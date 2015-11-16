

ifeq ($(PLATFORM), gcw0)
	CC		:= /opt/gcw0-toolchain/usr/bin/mipsel-linux-gcc
	STRIP		:= /opt/gcw0-toolchain/usr/bin/mipsel-linux-strip
	SYSROOT		:= $(shell $(CC) --print-sysroot)
	CFLAGS		:= $(shell $(SYSROOT)/usr/bin/sdl2-config --cflags)
	CFLAGS		+= -DNO_FRAMELIMIT
	LDFLAGS		:= $(shell $(SYSROOT)/usr/bin/sdl2-config --libs)
	RELEASE	:= release
endif

CC		?= cc
STRIP		?= strip
CFLAGS		?= $(shell sdl2-config --cflags)
LDFLAGS		?= $(shell sdl2-config --libs)

TARGET		?= gcw_zero_emu
SRCDIR		:= src
OBJDIR		:= obj
SRC		:= $(wildcard $(SRCDIR)/*.c)
OBJ		:= $(SRC:$(SRCDIR)/%.c=$(OBJDIR)/%.o)

ifdef DEBUG
	CFLAGS	+= -Wall -ggdb -DDEBUG
else
	CFLAGS	+= -O2
endif

.PHONY: all opk clean

all: $(TARGET)

$(TARGET): $(OBJ)
	$(CC) $(CFLAGS) $^ $(LDFLAGS) -o $@
ifndef DEBUG
	$(STRIP) $@
endif

$(OBJ): $(OBJDIR)/%.o: $(SRCDIR)/%.c | $(OBJDIR)
	$(CC) -c $(CFLAGS) $< -o $@

$(OBJDIR):
	mkdir -p $@

opk: $(TARGET)
ifeq ($(PLATFORM), gcw0)
	mkdir -p		$(RELEASE)
	cp $(TARGET)		$(RELEASE)
	cp -R data		$(RELEASE)
	cp default.gcw0.desktop	$(RELEASE)
	cp icon.png		$(RELEASE)
	mksquashfs		$(RELEASE) gcw_zero_emu.opk -all-root -noappend -no-exports -no-xattrs
endif

clean:
	rm -Rf $(TARGET) $(OBJDIR) $(RELEASE)

