# amiberry version
VERSION = 0.0.1

# Configuration flags
#
# Platforms:
# - rpi3 (*)
# - rpi2
# - rpi1
# - android
# - orangepi-pc
# - xu4
# - c1
# - n1
# - vero4k
# - tinker
# - rockpro64
PLATFORM ?= rpi3

# SDL version
# - 1
# - 2 (*)
SDL ?= 2

# Compilation options
#DEBUG=1
#GCC_PROFILE=1
#GEN_PROFILE=1
#USE_PROFILE=1
#SANITIZE=1

# compiler
CC		?= gcc
CXX		?= g++
RM		?= rm -f
STRIP	?= strip
