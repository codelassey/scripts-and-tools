#!/bin/bash

echo ""
if [ -n "$1" ]; then
    target="$1"
else
    read -p "Enter URL (http:// or https://) for Web Server Detection :" target
fi

mkdir -p results/$(echo $target | tr '/' '_')/

echo ""

echo "Starting Web Server Detection on $target ..."

whatweb "$target" > "results/$(echo $target | tr '/' '_')/detect-web.html" > /dev/null 2>&1

echo "==================================================================================================="

echo "Web Server Detection Complete. Check 'results' folder for scan results saved in 'detect-web.html'"

echo "==================================================================================================="
