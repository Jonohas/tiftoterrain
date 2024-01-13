import rasterio
from rasterio import Affine
from rasterio.merge import merge
from rasterio.warp import calculate_default_transform, reproject, Resampling
import numpy as np
import os
import sys


def flip_and_shift_geotiff(input_path, output_path):
    with rasterio.open(input_path) as src:
        # Read the data
        data = src.read()

        # Flip the image data vertically
        flipped_data = data[:, ::-1, :]

        # Update the affine transform
        # We flip (height) and then shift up (-2 * height)
        transform = src.transform * Affine.translation(0, src.height) * Affine.translation(0, -src.height)

        # Write the flipped and shifted image to a new file
        with rasterio.open(
            output_path, 'w',
            driver=src.driver,
            height=src.height,
            width=src.width,
            count=src.count,
            dtype=src.dtypes[0],
            crs=src.crs,
            transform=transform,
        ) as dst:
            dst.write(flipped_data)

if __name__ == "__main__":
    # get arguments from command line


    input_path = sys.argv[1]

    output_path = sys.argv[2]
    print("input_path: ", input_path)
    print("output_path: ", output_path)
    flip_and_shift_geotiff(input_path, output_path)
