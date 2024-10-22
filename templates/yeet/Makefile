.PHONY: all debug pkg unpkg clean

PROJECT_ROOT=$(shell git rev-parse --show-toplevel)

BINDIR = bin
TARGET = __TARGET__
SRCDIR = src
BUILDDIR = build
VMLINUX ?= /sys/kernel/btf/vmlinux

CC = clang
CFLAGS = -g -O2 -target bpf -I include -I ../../include

SRCS := $(wildcard $(SRCDIR)/*.bpf.c)
OBJS = $(patsubst $(SRCDIR)/%.c,$(BUILDDIR)/%.o,$(SRCS))

all: $(BUILDDIR) $(BINDIR) $(BINDIR)/$(TARGET) pkg

debug: CFLAGS += -DBPF_DEBUG=1
debug: all

pkg:
	$(PROJECT_ROOT)/scripts/yeet_pkg.sh --target $(TARGET) --bin $(BINDIR)/$(TARGET)

unpkg:
	$(PROJECT_ROOT)/scripts/yeet_pkg.sh -u --target $(TARGET)

$(BINDIR)/$(TARGET): $(OBJS)
	bpftool gen object $@ $^
	chmod +x $@

$(BINDIR):
	mkdir -p $(BINDIR)

$(BUILDDIR):
	mkdir -p $(BUILDDIR)

$(BUILDDIR)/%.bpf.o: $(SRCDIR)/%.bpf.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -rf $(BUILDDIR)
	rm -rf $(BINDIR)
	rm -rf $(TARGET).yeet
	rm -rf $(TARGET)

vmlinux:
	bpftool btf dump file $(VMLINUX) format c > include/vmlinux.h

clean_vmlinux:
	rm include/vmlinux.h

format:
	@-$(MAKE) --no-print-directory check_format
	@find . -name "*.c" -exec clang-format -i -style=file:$(CFORMAT) {} + || exit 1; \
	echo "Formatted all files"

check_format:
	@find . -name "*.c" -exec clang-format -style=file:$(CFORMAT) --dry-run --Werror {} + || exit 1 ; \