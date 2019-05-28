AR	= ar

TARGET	= lib/libguisan.a

SRC	:= $(wildcard src/*.cpp) $(wildcard src/*/*.cpp)
OBJS	:= $(SRC:%.cpp=%.o)
DEPS	:= $(SRC:%.cpp=%.d)
SDLINC = $(shell pkg-config --cflags sdl2)
SDLLIB = $(shell pkg-config --libs sdl2)


#CPPFLAGS +=-std=gnu++14 -I./include $(SDLINC) -MD -MT $@ -MF $(@:%.o=%.d)
CPPFLAGS +=-I./include

.PHONY : all clean

$(TARGET) : $(OBJS)
	$(AR) crs $(TARGET) $(OBJS)

all : $(TARGET)

.PHONY : clean
clean :
	rm -f $(OBJS) $(DEPS)
	rm -f $(TARGET)

-include $(DEPS)
