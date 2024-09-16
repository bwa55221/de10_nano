from PIL import Image
import numpy as np

size = 1920, 1080
path = "/home/brandon/work/de10_nano/user_software/image_conversion/mcclaren.png"
# path = "/home/brandon/work/de10_nano/user_software/image_conversion/cb_1080.png"
image = Image.open(path)
image = image.resize(size)
# image = Image.open(path).convert('RGBA') # use this for cb_1080.png
image = image.convert('RGBA')
image = np.asarray(image)
np.asarray(image).tofile("/home/brandon/work/de10_nano/user_software/image_conversion/raw_image.raw", format="%u")
# image.np.ndarray.tofile("/home/brandon/work/de10_nano/user_software/image_conversion/raw_image.raw", format=np.uint8)
# image.astype(np.uint8).tofile("/home/brandon/work/de10_nano/user_software/image_conversion/raw_image.raw")
print(len(image))
print(np.size(image))
print(len(image[0][0]))
print(image[0][0])
# print(image[1074][:])

print(image[0][0:241])
print(len(image[0][0:240]))
# for i in range(len(image[0])):
#     print(image[0][i])