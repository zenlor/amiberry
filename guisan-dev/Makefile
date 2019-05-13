AR	= ar

TARGET	= lib/libguisan.a

SRC	:= $(wildcard **/*.cpp)
OBJS	:= $(SRC:%.cpp=%.o)
DEPS	:= $(SRC:%.cpp=%.d)


CPPFLAGS +=-I./include $(shell sdl2-config --cflags) -MD -MT $@ -MF $(@:%.o=%.d)

.PHONY : all clean

$(TARGET) : $(OBJS)
	$(AR) cr $(TARGET) $(OBJS)

all : $(TARGET)

.PHONY : clean
clean :
	rm -f $(OBJS) $(DEPS)
	rm -f $(TARGET)

-include $(DEPS)
