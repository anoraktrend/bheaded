# Configuration
PREFIX ?= /usr
CURL := curl -LJf --retry 3 --retry-delay 2 --connect-timeout 30 --max-time 120
FILES = tree.h cdefs.h queue.h error.h
BASE_URL = https://raw.githubusercontent.com/chimera-linux/cports/main/musl-bsd-headers/files

.PHONY: all fetch clean install uninstall check

all: fetch

# Download all header files
fetch: $(FILES)

# Pattern rule to download each header file
%.h:
	@echo "Downloading $@..."
	@if ! $(CURL) "$(BASE_URL)/$@" -o "$@.tmp"; then \
		echo "Failed to download $@"; \
		rm -f "$@.tmp"; \
		exit 1; \
	fi
	@mv "$@.tmp" "$@"

# Check if required tools are available
check:
	@command -v curl >/dev/null 2>&1 || { echo "Error: curl is required but not installed."; exit 1; }
	@command -v install >/dev/null 2>&1 || { echo "Error: install (coreutils) is required but not installed."; exit 1; }

# Install headers to system
install: check
	install -d $(DESTDIR)$(PREFIX)/include/sys
	for file in $(FILES); do \
		echo "Installing $$file..."; \
		install -m 644 $$file $(DESTDIR)$(PREFIX)/include/sys/$$file; \
done

# Remove downloaded files
clean:
	rm -f $(FILES) *.tmp

# Uninstall headers from system
uninstall:
	rm -f $(addprefix $(DESTDIR)$(PREFIX)/include/sys/,$(FILES))
	@if [ -d "$(DESTDIR)$(PREFIX)/include/sys" ]; then \
		rmdir "$(DESTDIR)$(PREFIX)/include/sys" 2>/dev/null || true; \
	fi
