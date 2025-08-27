cpv() {
    src=$1
    dst=$2

    total_files=$(find "$src" -type f | wc -l)
    copied_files=0

    (cp -rv "$src" "$dst" &>/tmp/cp_output &)

    while [ $copied_files -lt $total_files ]; do
        copied_files=$(find "$dst" -type f | wc -l)
        percent=$((copied_files * 100 / total_files))
        echo -ne "\rProgress: [$(printf '%0.s#' $(seq 1 $((percent / 2))))$(printf '%0.s ' $(seq 1 $((50 - percent / 2))))] $percent%"
        sleep 0.1
    done

    wait
    echo -e "\nCopy complete."
}
