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
# - odrodi-xu4
# - odoid-c1
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

GCC_WARN=1

# compiler
CC		?= gcc
CXX		?= g++
RM		?= rm -f
STRIP	?= strip

CFLAGS.cortex-a5 =\
	-march=armv7-a \
	-mcpu=cortex-a5 \
	-mtune=cortex-a5 \
	-mfpu=neon-vfpv4

CFLAGS.cortex-a53 =\
	-march=armv8-a \
	-mtune=cortex-a53 \
	-mfpu=neon-fp-armv8

CFLAGS.cortex-a7 =\
	-march=armv7-a \
	-mtune=cortex-a7 \
	-mfpu=neon-vfpv4

CPPFLAGS.neon =\
	-D_FILE_OFFSET_BITS=64 \
	-DARM_HAS_DIV \
	-DARMV6_ASSEMBLY \
	-DUSE_ARMNEON \
	-DARMV6T2 \
	-DNEON

CPPFLAGS.mali =\
	-DMALI_GPU \
	-DUSE_RENDER_THREAD \
	-DFASTERCYCLES

# libraries
ZLIB2INC := $(shell pkg-config --cflags zlib)
ZLIB2LIB := $(shell pkg-config --libs zlib)

XML2INC := $(shell pkg-config --cflags libxml-2.0)
XML2LIB := $(shell pkg-config --libs libxml-2.0)

FLACINC := $(shell pkg-config --cflags flac)
FLACLIB := $(shell pkg-config --libs flac)

MPG123INC := $(shell pkg-config --cflags libmpg123)
MPG123LIB := $(shell pkg-config --libs libmpg123)

MPEG2INC := $(shell pkg-config --cflags libmpeg2)
MPEG2LIB := $(shell pkg-config --libs libmpeg2)

MPEG2CONVERTINC := $(shell pkg-config --cflags libmpeg2convert)
MPEG2CONVERTLIB := $(shell pkg-config --libs libmpeg2convert)

PNGINC := $(shell pkg-config --cflags libpng)
PNGLIB := $(shell pkg-config --libs libpng)
