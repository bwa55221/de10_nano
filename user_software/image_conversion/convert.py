from PIL import Image
import numpy as np

path = "/home/brandon/work/de10_nano/user_software/image_conversion/image.png"
image = Image.open(path)
# image = Image.open(path).convert('RGB')
image = np.asarray(image)

image.astype(np.uint8).tofile("/home/brandon/work/de10_nano/user_software/image_conversion/raw_image.raw")