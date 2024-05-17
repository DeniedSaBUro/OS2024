#!/bin/bash

if [ -z "$1" ]; then
    echo "Error"
    exit 1
fi
string="$1"
output="output.txt"
expansion=".txt"
find . -name "*${expansion}" -type f -print0 | xargs -0 grep -l "${string}" >> "${output}"
echo "Готово"
