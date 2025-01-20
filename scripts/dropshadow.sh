#!/usr/bin/env bash

# https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
set -o pipefail # If set, the return value of a pipeline is the value of the last (rightmost) command to exit with a non-zero status, or zero if all commands in the pipeline exit successfully. This option is disabled by default.
set -o errexit  # set -e # Exit immediately if a pipeline, which may consist of a single simple command, a list, or a compound command returns a non-zero status.
set -o nounset  # set -u # Treat unset variables and parameters other than the special parameters ‘@’ or ‘*’, or array variables subscripted with ‘@’ or ‘*’, as an error when performing parameter expansion. An error message will be written to the standard error, and a non-interactive shell will exit.
# set -o xtrace  # set -x # Print a trace of simple commands, for commands, case commands, select commands, and arithmetic for commands and their arguments or associated word lists after they are expanded and before they are executed. The value of the PS4 variable is expanded and the resultant value is printed before the command and its expanded arguments.

# https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html
# shopt -s inherit_errexit # If set, command substitution inherits the value of the errexit option, instead of unsetting it in the subshell environment. This option is enabled when POSIX mode is enabled.

if [ -d ".git" ] || git rev-parse --git-dir > /dev/null 2>&1; then
  GIT_ROOT_DIRECTORY=$(git rev-parse --show-toplevel)
  echo "\${GIT_ROOT_DIRECTORY}: ${GIT_ROOT_DIRECTORY}"
fi

SCRIPT_DIRECTORY="$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null 2>&1 && pwd)"
echo "\${SCRIPT_DIRECTORY}: ${SCRIPT_DIRECTORY}"

# ----------------------------------------------------------------------

# https://stackoverflow.com/a/31397073
# mktemp --directory "${TMPDIR:-/tmp}/zombie.XXXXXXXXX"
TEMPORARY_DIRECTORY="$(mktemp --directory --tmpdir="${PWD}")"
echo "\${TEMPORARY_DIRECTORY}: ${TEMPORARY_DIRECTORY}"

function cleanUp {
  rm \
    -r \
    -v \
    "${TEMPORARY_DIRECTORY}"
}
trap cleanUp EXIT

# ----------------------------------------------------------------------

pushd "${SCRIPT_DIRECTORY}"
date --universal +"%Y%m%dT%H%M%SZ"

# Check if the input image name is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <input_image>"
  exit 1
fi

# Input and output file names
input_image="$1"
output_image="${input_image%.*}-transparent-gradient-border.png"

# https://stackoverflow.com/questions/60680252/create-macos-style-screenshots-with-dropshadow-using-imagemagick/76144202#76144202
# https://stackoverflow.com/a/76144202
magick \
  $input_image \
  \( +clone -background black -shadow 40x50+0+36 \) \
  +swap -background transparent -layers merge +repage \
  $output_image

# 2. \( +clone -background black -shadow 50x15+9+15 \)
# 	•	\( and \): Used to group operations on a cloned copy of the input image.
# 	•	+clone: Creates a duplicate of the input image to work on.
# 	•	-background black: Sets the background color for the shadow to black.
# 	•	-shadow 50x15+9+15:
# 	•	50: The opacity of the shadow (50%).
# 	•	15: The amount of blur applied to the shadow. Larger values make the shadow softer.
# 	•	+9+15: Offsets the shadow horizontally by 9 pixels and vertically by 15 pixels.
# This creates the shadow effect for the image.

# +swap
# 	•	Swaps the positions of the original image and the shadow clone. This ensures the shadow is applied behind the original image.

# -bordercolor none -border 40
# 	•	-bordercolor none: Specifies that the border added should be transparent.
# 	•	-border 40: Adds a 40-pixel-wide transparent border around the image. This helps ensure the shadow doesn’t get cropped.

# -background none -mosaic
# 	•	-background none: Ensures the final output retains a transparent background.
# 	•	-mosaic: Combines the shadow and the original image into a single composite, aligning them correctly.

# +repage
# 	•	Removes any virtual canvas metadata (offsets or sizes) from the image. This ensures the image dimensions are trimmed to fit the visible content.

# https://stackoverflow.com/a/7699638

# Get the dimensions of the input image
# dimensions=$(magick identify -format "%wx%h" "$input_image")
# width=$(echo $dimensions | cut -d'x' -f1)
# height=$(echo $dimensions | cut -d'x' -f2)

# # Calculate the extent size (e.g., adding 64 pixels to both width and height)
# extent_width=$((width + 64))
# extent_height=$((height + 64))

# Apply the shadow and center the image
# magick -verbose ${input_image} \
#   \( +clone -background black -shadow 50x32+0+0 \) \
#   +swap \
#   -bordercolor none \
#   -border 32 \
#   -background none \
#   -gravity center \
#   -extent ${extent_width}x${extent_height} \
#   -mosaic \
#   +repage \
#   "${output_image}"

# magick $input_image \
#   -bordercolor none -border 50x50 \
#   \( +clone -alpha extract \
#   -background black -fill none \
#   -gravity center -annotate 0 " " \
#   -blur 0x25 -level 0,50% \
#   \) \
#   -compose DstOver -composite \
#   $output_image

# # Get the dimensions of the input image
# dimensions=$(magick identify -format "%wx%h" "$input_image")
# width=$(echo $dimensions | cut -d'x' -f1)
# height=$(echo $dimensions | cut -d'x' -f2)

# # Get dimensions of input image
# read width height <<< $(identify -format "%w %h" "$input_image")

# # Calculate proportional values
# border_size=$((width < height ? width : height))
# border_size=$((border_size / 20)) # 5% of smaller dimension
# blur_radius=$border_size          # Blur matches border size

# # Apply gradient border with strict size control
# convert "$input_image" \
#   \( +clone -background black -shadow 50x${blur_radius}+0+0 \) \
#   +swap -bordercolor none -border ${border_size} -background none \
#   -mosaic -trim +repage \
#   -gravity center -extent %[fx:w+${border_size}*2]x%[fx:h+${border_size}*2] \
#   "$output_image"

# echo "Gradient border added to $output_image"

# Apply gradient border
# convert "$input_image" \
#   \( +clone -background black -shadow 50x${blur_radius}+0+0 \) \
#   +swap -bordercolor none -border ${border_size} -background none \
#   -mosaic +repage "$output_image"

# magick "$input_image" \
#   \( +clone -background black -shadow 50x${blur_radius}+0+0 \) \
#   +swap -bordercolor none -border ${border_size} -background none \
#   -mosaic +repage -trim "$output_image"

# echo "Gradient border added to $output_image"

# convert ${input_image} -bordercolor none -border 20 \
#   \( +clone -alpha extract -virtual-pixel black -spread 10 -blur 0x10 -level 0,50% \) \
#   -compose DstOver -composite ${output_image}

# ( +clone -background black -shadow 50x15+9+15 ):
# 	•	+clone: Creates a copy of the input image in memory.
# 	•	-background black: Sets the background color for the shadow to black.
# 	•	-shadow 50x15+9+15: Creates a shadow effect using the following parameters:
# 	•	50: Shadow opacity as a percentage (50% in this case).
# 	•	15: Blur radius, controlling how soft the shadow edges appear.
# 	•	+9+15: Offset for the shadow, where +9 shifts the shadow 9 pixels right, and +15 shifts it 15 pixels down.

# convert ${input_image} \
#   ( +clone -background black -shadow 50x15+9+15 ) \
#   +swap -bordercolor none -border 40 -background none \
#   -mosaic +repage ${output_image}

popd || exit
