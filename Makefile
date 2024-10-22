.PHONY: init

YEET ?=
ENV ?= local
VMLINUX ?= /sys/kernel/btf/vmlinux
CFORMAT = .clang-format

init:
	./scripts/init.sh $(YEET)

format:
	@-$(MAKE) --no-print-directory check_format
	@find "yeets" -name "*.c" -exec clang-format -i -style=file:$(CFORMAT) {} + || exit 1; \
	echo "Formatted all files"

check_format:
	@find "yeets" -name "*.c" -exec clang-format -style=file:$(CFORMAT) --dry-run --Werror {} + || exit 1 ; \