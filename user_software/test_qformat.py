from qformatpy import qformat
import ctypes

# x = 3.141592653589793
x = 45 # degrees
# x = 0.7854  # radians
result = qformat(x, qi=10, qf=20, rnd_method='Trunc')
print(result)


bin_result = bin(ctypes.c_uint32.from_buffer(ctypes.c_float(result)).value)
print(bin_result)
print(len(bin_result)-2) # strip of 0b prefix in length calc


# shooting for this 32'b00010010111001000000010100011101; // 26.565 degrees -> atan(2^-1)
