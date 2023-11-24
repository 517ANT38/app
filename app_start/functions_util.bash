error_exit(){
    echo "error: $1">&2
    exit 1
}

export -f error_exit