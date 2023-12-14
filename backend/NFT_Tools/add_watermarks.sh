#!/bin/bash

# Path to the watermark image
watermark="watermark.png"

# Create a white version of the watermark
convert "$watermark" -background white -alpha background -channel RGB +level-colors white,white watermark_white.png

# Directory containing the images to be watermarked
image_dir=""

# Directory to save the watermarked images
output_dir="output/"

# Transparency level for the watermark on light and dark images
light_transparency=30
dark_transparency=30

# Brightness threshold to differentiate between light and dark images
brightness_threshold=0.5

# Ensure the output directory exists
mkdir -p "$output_dir"

for img in "$image_dir"*.png; do
    # Extract the filename
    filename=$(basename "$img")

    # Calculate the average brightness of the image
    brightness=$(convert "$img" -colorspace gray -format "%[fx:mean]" info:)

    # Determine the watermark and transparency based on the brightness
    if (( $(echo "$brightness < $brightness_threshold" | bc -l) )); then
        watermark_to_use="watermark_white.png"
        transparency=$dark_transparency
    else
        watermark_to_use=$watermark
        transparency=$light_transparency
    fi

    # Apply the watermark with dissolve blending
    composite -dissolve $transparency -gravity center "$watermark_to_use" "$img" "$output_dir$filename"
done
