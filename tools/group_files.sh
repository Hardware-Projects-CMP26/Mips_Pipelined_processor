#!/bin/bash




### group files in temp dir  ###
## Author: Sarah Soliman


if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <dir> <file_name> <temp_dir>"
    exit 1
fi


FILE_NAME=$2
SOURCE_DIR=$1
TEMP_DIR=$3
#check if temp doen't exsist
if  [ ! -d "$TEMP_DIR" ]; then
    mkdir $TEMP_DIR
else
    echo "destination already exsists"
    exit 1
fi



group_files(){
    local file="$1"
    if [[ "$file" == *"$FILE_NAME"* ]]; then
        cp "$file" "$TEMP_DIR/$(basename "$file")"
        echo "Moved $file to $TEMP_DIR"
    fi
}
find "$SOURCE_DIR" -type f | while IFS= read -r file; do
    group_files "$file"
done

echo "Files grouped in temporary directory: $TEMP_DIR"