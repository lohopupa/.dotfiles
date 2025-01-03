[[ -z "$CODE_EXTENSIONS_PATH" ]] && CODE_EXTENSIONS_PATH=~/.code_extensions

code-update-list-exts() {
    code --list-extensions >> "$CODE_EXTENSIONS_PATH"
}

code-install-exts() {
    while read line; do
        code --install-extension "$line"
    done < "$CODE_EXTENSIONS_PATH"
}