#!/bin/bash

# Define the output files prefix
output_prefix="corrected_"

# Define the EPSG code
epsg_code="EPSG:25832"

# List of input files
declare -a files=("4637 Aufloesung 025m.tif"
                  "4638 Aufloesung 025m.tif"
                  "4639 Aufloesung 025m.tif"
                  "4737 Aufloesung 025m.tif"
                  "4738 Aufloesung 025m.tif"
                  "4739 Aufloesung 025m.tif"
                  "4837 Aufloesung 025m.tif"
                  "4838 Aufloesung 025m.tif"
                  "4839 Aufloesung 025m.tif")
                  #"4937 Aufloesung 025m.tif")

# Process each file
for file in "${files[@]}"
do
   # Generate output file name
   output_file="${output_prefix}${file}"


   # Apply gdalwarp to correct the orientation (flip vertically), assign EPSG:25832, and ensure north-up orientation
   gdalwarp -t_srs $epsg_code -of GTiff -co "COMPRESS=DEFLATE" -tr 0.25 -0.25 -tap "$file" "$output_file"

   python3 flip.py "$output_file" "flipped_$output_file"
#    gdalwarp -of GTiff -co "COMPRESS=DEFLATE" -gcp 0 0 old_x1 old_y1 -gcp 0 height old_x2 old_y2 -gcp width 0 old_x3 old_y3 ... "$file" "$output_file"

done

# Create a VRT from the corrected files
gdalbuildvrt output.vrt flipped_${output_prefix}*.tif

# Convert VRT to a physical TIFF file
gdal_translate output.vrt final_output.tif
