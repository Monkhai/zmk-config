#!/bin/bash

echo "========================================="
echo "ADV360 Pro Serial Flasher (SentinelOne Bypass)"
echo "========================================="
echo ""

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo "Converting LEFT firmware..."
python3 uf2conv.py -c -o left.bin adv360pro_left-zmk.uf2
adafruit-nrfutil dfu genpkg --dev-type 0x0052 --application left.bin left_dfu.zip

echo ""
echo "Put LEFT keyboard half in bootloader mode (double-tap reset)"
read -p "Press Enter when ready..."

echo "Flashing LEFT side via serial..."
adafruit-nrfutil dfu serial --package left_dfu.zip -p /dev/cu.usbmodem101 -b 115200

echo ""
echo "✓ LEFT side flashed!"
echo ""
echo "Converting RIGHT firmware..."
python3 uf2conv.py -c -o right.bin adv360pro_right-zmk.uf2
adafruit-nrfutil dfu genpkg --dev-type 0x0052 --application right.bin right_dfu.zip

echo ""
echo "Put RIGHT keyboard half in bootloader mode (double-tap reset)"
read -p "Press Enter when ready..."

echo "Flashing RIGHT side via serial..."
adafruit-nrfutil dfu serial --package right_dfu.zip -p /dev/cu.usbmodem101 -b 115200

echo ""
echo "========================================="
echo "✓ Both sides flashed successfully!"
echo "========================================="
echo "Your keyboard is updated with your custom keymap."
echo ""
echo "Cleaning up temporary files..."
rm -f left.bin right.bin left_dfu.zip right_dfu.zip flash.bin

echo "Done!"

