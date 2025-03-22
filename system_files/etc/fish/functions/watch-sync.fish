function watch-sync
    watch "awk '\$3==\"kB\"{\$2=\$2/1024;\$3=\"MB\"} 1' /proc/meminfo | grep Dirty"
end
