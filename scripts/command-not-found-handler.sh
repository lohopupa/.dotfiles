command_not_found_handler() {
    local cmd=$1
    local args="${(@)argv[2,-1]}"  # Capture arguments passed to the command
    echo -e "\033[31mCommand '$cmd' not found.\033[0m"  # Red text for "not found"

    # Search for the package using pkgfile
    local suggestions=($(pkgfile "${cmd}"))
    
    if (( ${#suggestions[@]} == 1 )); then
        # Only one package found
        echo -e "\033[33mThe command '$cmd' is provided by the package '${suggestions[1]}'.\033[0m"  # Yellow text for suggestion
        echo -en "\033[36mDo you want to install it? [Y/n] \033[0m"  # Cyan prompt
        read -r answer
        answer="${answer:-y}"  # Default to 'y' if no input

        if [[ $answer == "y" || $answer == "Y" ]]; then
            yay -S "${suggestions[1]}"
            eval "$cmd $args"
        else
            echo -e "\033[31mPackage not installed.\033[0m"  # Red text for "not installed"
        fi
    elif (( ${#suggestions[@]} > 1 )); then
        # Multiple packages found
        echo -e "\033[33mThe command '$cmd' is provided by multiple packages:\033[0m"
        for i in ${(k)suggestions}; do
            echo -e "\033[34m[$i]\033[0m ${suggestions[$i]}"  # Blue text for package index
        done
        echo -en "\033[36mEnter the number of the package you want to install: \033[0m"
        read -r choice

        if [[ $choice -gt 0 && $choice -le ${#suggestions[@]} ]]; then
            yay -S "${suggestions[$choice]}"
            eval "$cmd $args"
        else
            echo -e "\033[31mInvalid selection. Package not installed.\033[0m"
        fi
    else
        # No packages found; search for closest match among installed commands
        echo -e "\033[31mNo package provides the command '$cmd'.\033[0m"

        local all_commands=($(compgen -c))
        local suggestion=$(printf "%s\n" "${all_commands[@]}" | python3 -c "
import sys
from difflib import get_close_matches

cmd = '${cmd}'
commands = [line.strip() for line in sys.stdin]
matches = get_close_matches(cmd, commands, n=1, cutoff=0.5)  # Closest match with a cutoff of 0.5
print(matches[0] if matches else '', end='')
")

        if [[ -n $suggestion ]]; then
            # Ask the user if they meant the suggestion, with a default answer of 'y'
            echo -en "\033[36mDid you mean '$suggestion'? [Y/n] \033[0m"
            read -r answer
            answer="${answer:-y}"  # Default to 'y' if no input

            if [[ $answer == "y" || $answer == "Y" ]]; then
                # Execute the suggestion with the arguments
                eval "$suggestion $args"
            else
                echo -e "\033[31mCommand not executed.\033[0m"
            fi
        else
            echo -e "\033[31mNo similar commands found.\033[0m"
        fi
    fi
}
