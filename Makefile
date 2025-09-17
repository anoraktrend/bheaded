main:
	curl -LJ "https://git.alpinelinux.org/aports/plain/main/bsd-compat-headers/tree.h"  -o  tree.h
	curl -LJ "https://git.alpinelinux.org/aports/plain/main/bsd-compat-headers/cdefs.h" -o cdefs.h
	curl -LJ "https://git.alpinelinux.org/aports/plain/main/bsd-compat-headers/queue.h" -o queue.h
install:
	install -Dm644 -t $(DESTDIR)/$(PREFIX)/sys cdefs.h queue.h tree.h
