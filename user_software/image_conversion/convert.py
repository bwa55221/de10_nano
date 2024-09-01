from PIL import Image
import numpy as np

path = "/home/brandon/work/de10_nano/user_software/image_conversion/image.png"
image = Image.open(path)
# image = Image.open(path).convert('RGB')
image = np.asarray(image)
np.asarray(image).tofile("/home/brandon/work/de10_nano/user_software/image_conversion/raw_image.raw", format="%u")
# image.np.ndarray.tofile("/home/brandon/work/de10_nano/user_software/image_conversion/raw_image.raw", format=np.uint8)
# image.astype(np.uint8).tofile("/home/brandon/work/de10_nano/user_software/image_conversion/raw_image.raw")
print(image[0][0])