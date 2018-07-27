#!/bin/bash

echo "Customizing board template for SiFive Freedom E-Series Chip"

BOARD_NAME=${PWD##*/}
BOARD_IDENTIFIER=$(echo $BOARD_NAME | sed -e 's/-/_/g' | tr '[:lower:]' '[:upper:]')

echo "Using the name of the containing folder for the board identifier: $BOARD_NAME"
echo "Using the upcase of that as an identifier: $BOARD_IDENTIFIER"

read -p "Do you want to boot from the default boot address 0x2040_0000? (Y/n): " DEFAULT_BASE_ADDR
case $DEFAULT_BASE_ADDR in
    [Nn]* ) read -p "Enter ROM boot address in hex (ex. 0x20000000, 0x20400000): " ROM_BASE_ADDR;;
    * ) ROM_BASE_ADDR="0x20400000";;
esac

RENAME_FILES=("board_name.dts" "board_name.yaml" "board_name_defconfig")
TEMPLATE_FILES=("Kconfig.board" "Kconfig.defconfig" "${RENAME_FILES[@]}")

for template_file in "${TEMPLATE_FILES[@]}"
do
    sed -i $template_file -e "s/<BOARD_IDENTIFIER>/$BOARD_IDENTIFIER/g" \
        -e "s/<BOARD_NAME>/$BOARD_NAME/g" -e "s/<ROM_BASE_ADDR>/$ROM_BASE_ADDR/"
done

for rename_file in "${RENAME_FILES[@]}"
do
    mv $rename_file $(echo $rename_file | sed -e "s/board_name/$BOARD_NAME/")
done

echo "Done customizing board files"
