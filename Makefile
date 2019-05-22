##
# Amiberry
#
# @file Makefile
# @version 0.1
include config.mk

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

# includes and libs
CPPFLAGS 	:= -Os -pipe -std=gnu++14
ASFLAGS		:= $(CPPFLAGS) -falign-functions=16
LDFLAGS 	= -flto -Wl,-O1 -Wl,--hash-style=gnu -Wl,--as-needed -ldl -lpthread

# includes
CPPFLAGS	+= -Isrc -Isrc/osdep -Isrc/threaddep -Isrc/include -Isrc/archivers

# common Defines
CPPFLAGS += \
	-DVERSION=\"$(VERSION)\" \
	-DAMIBERRY

# common flags
CPPFLAGS += \
	-MD -MT $@ -MF $(@:%.o=%.d)

# pkg-config libraries flags
CPPFLAGS += \
	$(ZLIB) \
	$(XML2INC) \
	$(FLACINC) \
	$(MPG123INC) \
	$(MPEG2INC) \
	$(MPEG2CONVERTINC) \
	$(PNGINC) \

LDFLAGS += \
	$(ZLIB) \
	$(XML2LIB) \
	$(FLACLIB) \
	$(MPG123LIB) \
	$(MPEG2LIB) \
	$(MPEG2CONVERTLIB) \
	$(PNGLIB) \
	-lpthread \

export CFLAGS	+= -pipe
export CXXFLAGS += $(CFLAGS) -std=gnu++14 -fpermissive

#
# Common options
#

ifdef DEBUG
# Otherwise we'll get compilation errors, check https://tls.mbed.org/kb/development/arm-thumb-error-r7-cannot-be-used-in-asm-here
# quote: The assembly code in bn_mul.h is optimized for the ARM platform and uses some registers, including r7 to efficiently do an operation. GCC also uses r7 as the frame pointer under ARM Thumb assembly.
CFLAGS += -fomit-frame-pointer -g -rdynamic -funwind-tables -mapcs-frame -DDEBUG -Wl,--export-dynamic
else

CFLAGS += -Ofast -frename-registers -falign-functions=16
endif

ifdef GCC_PROFILE
CFLAGS += -pg
LDFLAGS += -pg
endif

ifdef GEN_PROFILE
CFLAGS += -fprofile-generate -fprofile-arcs -fvpt
LDFLAGS += -lgcov
endif

ifdef USE_PROFILE
CFLAGS += -fprofile-use -fprofile-correction -fbranch-probabilities -fvpt
LDFLAGS += -lgcov
endif

ifdef SANITIZE
LDFLAGS += -lasan
CFLAGS += -fsanitize=leak -fsanitize-recover=address
endif

ifdef GCC_WARN
WARNFLAGS	= -Wall -Wno-shift-overflow -Wno-narrowing
CFLAGS		+= $(WARNFLAGS)
CPPFLAGS	+= $(WARNFLAGS)
endif

# Dispmanx
# WARNING: raspian magic
ifeq ($(DISPMANX),1)
CFLAGS	+= -DUSE_DISPMANX -I/opt/vc/include -I/opt/vc/include/interface/vmcs_host/linux -I/opt/vc/include/interface/vcos/pthreads
LDFLAGS	+= -lbcm_host -lvchiq_arm -L/opt/vc/lib -Wl,-rpath=/opt/vc/lib
endif

# SDL2
ifeq ($(SDL),2)
SDL2INC := $(shell pkg-config --cflags sdl2)
SDL2LIB := $(shell pkg-config --libs sdl2)

CFLAGS		+= -DUSE_SDL2 $(SDL2INC)
CPPFLAGS	+= -DUSE_SDL2 $(SDL2INC)
LDFLAGS		+= $(SDL2LIB)
else

# SDL1
SDL1INC := $(shell pkg-config --cflags sdl)
SDL1LIB := $(shell pkg-config --libs sdl)

CFLAGS		+= -DUSE_SDL1 $(SDL1INC)
CPPFLAGS	+= -DUSE_SDL1 $(SDL1INC)
LDFLAGS		+= $(SDL1LIB)
endif

# RaspberryPi 3
ifeq ($(PLATFORM),rpi3)
# 32bits
ifeq (32,ARCH)
CFLAGS	+= -mfpu=neon-fp-armv8
endif

CFLAGS		+= \
	-march=armv8-a -mtune=cortex-a53
CPPFLAGS	+= \
	-DARMV6_ASSEMBLY \
	-D_FILE_OFFSET_BITS=64 \
	-DARMV6T2 \
	-DUSE_ARMNEON \
	-DARM_HAS_DIV
endif

# raspberry2
ifeq ($(PLATFORM),rpi2)
CFLAGS		+= -march=armv7-a -mtune=cortex-a7 -mfpu=neon-vfpv4
CPPFLAGS	+= -DARMV6_ASSEMBLY -D_FILE_OFFSET_BITS=64 -DARMV6T2 -DUSE_ARMNEON -DARM_HAS_DIV -DUSE_SDL1

HAVE_NEON = 1

# Neon
CFLAGS += -DNEON
endif

# raspberry1
ifeq ($(PLATFORM),rpi1)
CFLAGS		+= -march=armv6zk -mtune=arm1176jzf-s -mfpu=vfp
CFLAGS		+= -DNEON
CPPFLAGS	+= -DARMV6_ASSEMBLY -D_FILE_OFFSET_BITS=64 -DARMV6T2
endif

# Android
ifeq ($(PLATFORM),android)
CFLAGS		+= -mfpu=neon -mfloat-abi=soft
CPPFLAGS	+= -DARMV6_ASSEMBLY -D_FILE_OFFSET_BITS=64 -DANDROIDSDL -DARMV6T2 -DUSE_ARMNEON -DARM_HAS_DIV -DUSE_SDL1
ANDROID		= 1
HAVE_NEON	= 1
HAVE_SDL_DISPLAY = 1
endif

# OrangePI
ifeq ($(PLATFORM),orangepi-pc)
CFLAGS		+= \
	-march=armv7-a -mtune=cortex-a7 -mfpu=neon-vfpv4
CPPFLAGS	+= \
	-DARMV6_ASSEMBLY -D_FILE_OFFSET_BITS=64 -DARMV6T2 \
	-DUSE_ARMNEON -DARM_HAS_DIV -DMALI_GPU -DUSE_RENDER_THREAD

HAVE_NEON = 1
endif

ifeq ($(PLATFORM),xu4)
CFLAGS		+= \
	-mcpu=cortex-a15.cortex-a7 -mtune=cortex-a15.cortex-a7 -mfpu=neon-vfpv4
CPPFLAGS	+= \
	-DARMV6_ASSEMBLY -D_FILE_OFFSET_BITS=64 -DARMV6T2 -DUSE_ARMNEON \
	-DARM_HAS_DIV -DUSE_SDL2 -DMALI_GPU -DUSE_RENDER_THREAD -DFASTERCYCLES

HAVE_NEON = 1
endif

ifeq ($(PLATFORM),c1)
CFLAGS		+= \
	-march=armv7-a -mcpu=cortex-a5 -mtune=cortex-a5 -mfpu=neon-vfpv4
CPPFLAGS	+= \
	-DARMV6_ASSEMBLY -D_FILE_OFFSET_BITS=64 -DARMV6T2 -DUSE_ARMNEON \
	-DARM_HAS_DIV -DUSE_SDL2 -DMALI_GPU -DUSE_RENDER_THREAD -DFASTERCYCLES
endif

ifeq ($(PLATFORM),n1)
AARCH64 = 1
#CFLAGS		+=\
#	-march=armv8-a -mtune=cortex-a53 -mfpu=neon-fp-armv8
CPPFLAGS	+= \
	-D_FILE_OFFSET_BITS=64 -DUSE_SDL2 -DMALI_GPU -DUSE_RENDER_THREAD -DFASTERCYCLES
endif

ifeq ($(PLATFORM),vero4k)
CFLAGS		+=\
	-march=armv8-a -mtune=cortex-a53 -mfpu=neon-fp-armv8
CPPFLAGS	+=\
	-I/opt/vero3/include \
	-DARMV6_ASSEMBLY -D_FILE_OFFSET_BITS=64 -DARMV6T2 -DUSE_ARMNEON \
	-DARM_HAS_DIV -DMALI_GPU -DUSE_RENDER_THREAD -DFASTERCYCLES
LDFLAGS		+= -L/opt/vero3/lib
HAVE_NEON = 1
endif

ifeq ($(PLATFORM),tinker)
CFLAGS		+= \
	-march=armv7-a -mtune=cortex-a17 -mfpu=neon-vfpv4
CPPFLAGS	+= \
	-DARMV6_ASSEMBLY -D_FILE_OFFSET_BITS=64 -DARMV6T2 -DUSE_ARMNEON \
	-DARM_HAS_DIV -DUSE_SDL2 -DFASTERCYCLES -DUSE_RENDER_THREAD -DMALI_GPU
HAVE_NEON = 1
endif

ifeq ($(PLATFORM),rockpro64)
CFLAGS		+= \
	-march=armv8-a -mtune=cortex-a53 -mfpu=neon-fp-armv8
CPPFLAGS	+= \
	-DARMV6_ASSEMBLY -D_FILE_OFFSET_BITS=64 -DARMV6T2 -DUSE_ARMNEON \
	-DARM_HAS_DIV -DUSE_SDL2 -DMALI_GPU -DUSE_RENDER_THREAD -DFASTERCYCLES
HAVE_NEON = 1
endif


# Program
PROG	= amiberry-$(PLATFORM)

#
# SDL1 options
#
ifeq ($(SDL),1)
all: $(PROG)

export CPPFLAGS += $(SDL_CFLAGS)
LDFLAGS		+= $(SDL_LDFLAGS) -lSDL_image -lSDL_ttf -lguichan_sdl -lguichan
endif

#
# SDL2 options
#
ifeq ($(SDL),2)
all: guisan $(PROG)

CPPFLAGS	+= -Iguisan-dev/include
LDFLAGS		+= -lSDL2_image -lSDL2_ttf -Lguisan-dev/lib -lguisan
endif


C_OBJS	= \
	src/archivers/7z/BraIA64.o \
	src/archivers/7z/Delta.o \
	src/archivers/7z/Sha256.o \
	src/archivers/7z/XzCrc64.o \
	src/archivers/7z/XzDec.o

OBJS 	= \
	src/akiko.o \
	src/ar.o \
	src/aros.rom.o \
	src/audio.o \
	src/autoconf.o \
	src/blitfunc.o \
	src/blittable.o \
	src/blitter.o \
	src/blkdev.o \
	src/blkdev_cdimage.o \
	src/bsdsocket.o \
	src/calc.o \
	src/cd32_fmv.o \
	src/cd32_fmv_genlock.o \
	src/cdrom.o \
	src/cfgfile.o \
	src/cia.o \
	src/crc32.o \
	src/custom.o \
	src/def_icons.o \
	src/devices.o \
	src/disk.o \
	src/diskutil.o \
	src/dlopen.o \
	src/drawing.o \
	src/events.o \
	src/expansion.o \
	src/fdi2raw.o \
	src/filesys.o \
	src/flashrom.o \
	src/fpp.o \
	src/fsdb.o \
	src/fsdb_unix.o \
	src/fsusage.o \
	src/gayle.o \
	src/gfxboard.o \
	src/gfxutil.o \
	src/hardfile.o \
	src/hrtmon.rom.o \
	src/ide.o \
	src/inputdevice.o \
	src/keybuf.o \
	src/main.o \
	src/memory.o \
	src/native2amiga.o \
	src/rommgr.o \
	src/rtc.o \
	src/savestate.o \
	src/scsi.o \
	src/statusline.o \
	src/traps.o \
	src/uaelib.o \
	src/uaeresource.o \
	src/zfile.o \
	src/zfile_archive.o \
	src/archivers/7z/7zAlloc.o \
	src/archivers/7z/7zBuf.o \
	src/archivers/7z/7zCrc.o \
	src/archivers/7z/7zCrcOpt.o \
	src/archivers/7z/7zDec.o \
	src/archivers/7z/7zIn.o \
	src/archivers/7z/7zStream.o \
	src/archivers/7z/Bcj2.o \
	src/archivers/7z/Bra.o \
	src/archivers/7z/Bra86.o \
	src/archivers/7z/LzmaDec.o \
	src/archivers/7z/Lzma2Dec.o \
	src/archivers/7z/Xz.o \
	src/archivers/dms/crc_csum.o \
	src/archivers/dms/getbits.o \
	src/archivers/dms/maketbl.o \
	src/archivers/dms/pfile.o \
	src/archivers/dms/tables.o \
	src/archivers/dms/u_deep.o \
	src/archivers/dms/u_heavy.o \
	src/archivers/dms/u_init.o \
	src/archivers/dms/u_medium.o \
	src/archivers/dms/u_quick.o \
	src/archivers/dms/u_rle.o \
	src/archivers/lha/crcio.o \
	src/archivers/lha/dhuf.o \
	src/archivers/lha/header.o \
	src/archivers/lha/huf.o \
	src/archivers/lha/larc.o \
	src/archivers/lha/lhamaketbl.o \
	src/archivers/lha/lharc.o \
	src/archivers/lha/shuf.o \
	src/archivers/lha/slide.o \
	src/archivers/lha/uae_lha.o \
	src/archivers/lha/util.o \
	src/archivers/lzx/unlzx.o \
	src/archivers/mp2/kjmp2.o \
	src/archivers/wrp/warp.o \
	src/archivers/zip/unzip.o \
	src/caps/caps_win32.o \
	src/machdep/support.o \
	src/osdep/bsdsocket_host.o \
	src/osdep/cda_play.o \
	src/osdep/charset.o \
	src/osdep/fsdb_host.o \
	src/osdep/amiberry_hardfile.o \
	src/osdep/keyboard.o \
	src/osdep/mp3decoder.o \
	src/osdep/picasso96.o \
	src/osdep/writelog.o \
	src/osdep/amiberry.o \
	src/osdep/amiberry_filesys.o \
	src/osdep/amiberry_input.o \
	src/osdep/amiberry_gfx.o \
	src/osdep/amiberry_gui.o \
	src/osdep/amiberry_rp9.o \
	src/osdep/amiberry_mem.o \
	src/osdep/amiberry_whdbooter.o \
	src/osdep/sigsegv_handler.o \
	src/sounddep/sound.o \
	src/osdep/gui/UaeRadioButton.o \
	src/osdep/gui/UaeDropDown.o \
	src/osdep/gui/UaeCheckBox.o \
	src/osdep/gui/UaeListBox.o \
	src/osdep/gui/InGameMessage.o \
	src/osdep/gui/SelectorEntry.o \
	src/osdep/gui/ShowHelp.o \
	src/osdep/gui/ShowMessage.o \
	src/osdep/gui/SelectFolder.o \
	src/osdep/gui/SelectFile.o \
	src/osdep/gui/CreateFilesysHardfile.o \
	src/osdep/gui/EditFilesysVirtual.o \
	src/osdep/gui/EditFilesysHardfile.o \
	src/osdep/gui/PanelAbout.o \
	src/osdep/gui/PanelPaths.o \
	src/osdep/gui/PanelQuickstart.o \
	src/osdep/gui/PanelConfig.o \
	src/osdep/gui/PanelCPU.o \
	src/osdep/gui/PanelChipset.o \
	src/osdep/gui/PanelCustom.o \
	src/osdep/gui/PanelROM.o \
	src/osdep/gui/PanelRAM.o \
	src/osdep/gui/PanelFloppy.o \
	src/osdep/gui/PanelHD.o \
	src/osdep/gui/PanelInput.o \
	src/osdep/gui/PanelDisplay.o \
	src/osdep/gui/PanelSound.o \
	src/osdep/gui/PanelMisc.o \
	src/osdep/gui/PanelSavestate.o \
	src/osdep/gui/main_window.o \
	src/osdep/gui/Navigation.o

ifeq ($(SDL),1)
OBJS	+= src/osdep/gui/sdltruetypefont.o
endif

ifeq ($(ANDROID), 1)
OBJS	+= \
	src/osdep/gui/androidsdl_event.o \
	src/osdep/gui/PanelOnScreen.o
endif

# disable NEON helpers for AARCH64
ifndef AARCH64
ifdef HAVE_NEON
OBJS += src/osdep/neon_helper.o
src/osdep/neon_helper.o: src/osdep/neon_helper.s
	$(CXX) $(CFLAGS) -o src/osdep/neon_helper.o -c src/osdep/neon_helper.s
else

OBJS += src/osdep/arm_helper.o
src/osdep/arm_helper.o: src/osdep/arm_helper.s
	$(CXX) $(CFLAGS) -o src/osdep/arm_helper.o -c src/osdep/arm_helper.s
endif
endif

OBJS	+= \
	src/newcpu.o \
	src/newcpu_common.o \
	src/readcpu.o \
	src/cpudefs.o \
	src/cpustbl.o \
	src/cpuemu_0.o \
	src/cpuemu_4.o \
	src/cpuemu_11.o \
	src/cpuemu_40.o \
	src/cpuemu_44.o \
	src/jit/compemu.o \
	src/jit/compstbl.o \
	src/jit/compemu_fpp.o \
	src/jit/compemu_support.o

DEPS = $(OBJS:%.o=%.d) $(C_OBJS:%.o=%.d)

$(PROG) : $(OBJS) $(C_OBJS)
	$(CXX) $(OBJS) $(C_OBJS) $(LDFLAGS) -o $(PROG)
ifndef DEBUG
# want to keep a copy of the binary before stripping? Then enable the below line
#	cp $(PROG) $(PROG)-debug
	$(STRIP) $(PROG)
endif

clean:
	$(RM) $(PROG) $(PROG)-debug $(C_OBJS) $(OBJS) $(ASMS) $(DEPS)
	$(MAKE) -C guisan-dev clean

cleanprofile:
	$(RM) $(OBJS:%.o=%.gcda)

bootrom:
	od -v -t xC -w8 src/filesys |tail -n +5 | sed -e "s,^.......,," -e "s,[0123456789abcdefABCDEF][0123456789abcdefABCDEF],db(0x&);,g" > src/filesys_bootrom.cpp
	touch src/filesys.cpp

guisan:
	$(MAKE) -C guisan-dev

-include $(DEPS)
# end
