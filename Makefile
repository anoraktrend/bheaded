# Configuration
PREFIX ?= /usr
FILES = tree.h cdefs.h queue.h error.h
REPO_URL = https://github.com/chimera-linux/cports.git
REPO_DIR = cports
FILES_PATH = main/musl-bsd-headers/files

.PHONY: all fetch clean install uninstall check

all: fetch

# Download all header files using git sparse-checkout
fetch: $(FILES)

# Clone the repository and set up sparse checkout if it doesn't exist
$(REPO_DIR)/.git:
	@echo "Cloning repository..."
	@git clone --no-checkout --depth 1 --filter=blob:none $(REPO_URL) $(REPO_DIR)
	@cd $(REPO_DIR) && git sparse-checkout init --cone
	@cd $(REPO_DIR) && git sparse-checkout set '$(FILES_PATH)'

# Pattern rule to get each header file
%.h: $(REPO_DIR)/.git
	@echo "Checking out $@..."
	@cd $(REPO_DIR) && git checkout HEAD -- '$(FILES_PATH)/$@'
	@cp $(REPO_DIR)/$(FILES_PATH)/$@ .

# Check if required tools are available
check:
	@command -v git >/dev/null 2>&1 || { echo "Error: git is required but not installed."; exit 1; }
	@command -v install >/dev/null 2>&1 || { echo "Error: install (coreutils) is required but not installed."; exit 1; }

# Install headers to system
install: check
	install -d $(DESTDIR)$(PREFIX)/include/sys
	for file in $(FILES); do \
		echo "Installing $$file..."; \
		install -m 644 $$file $(DESTDIR)$(PREFIX)/include/sys/$$file; \
done

# Clean up downloaded files and repository
clean:
	rm -f $(FILES)
	rm -rf $(REPO_DIR)

# Uninstall headers from system
uninstall:
	for file in $(FILES); do \
		echo "Removing $$file..."; \
		rm -f $(DESTDIR)$(PREFIX)/include/sys/$$file; \
	done
	rmdir -p $(DESTDIR)$(PREFIX)/include/sys 2>/dev/null || true
