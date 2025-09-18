PREFIX ?= /usr

main:
	curl -LJ "https://raw.githubusercontent.com/chimera-linux/cports/main/musl-bsd-headers/files/tree.h" -o tree.h
	curl -LJ "https://raw.githubusercontent.com/chimera-linux/cports/main/musl-bsd-headers/files/cdefs.h" -o cdefs.h
	curl -LJ "https://raw.githubusercontent.com/chimera-linux/cports/main/musl-bsd-headers/files/queue.h" -o queue.h
	curl -LJ "https://raw.githubusercontent.com/chimera-linux/cports/main/musl-bsd-headers/files/error.h" -o error.h

install:
	install -dm755 $(DESTDIR)$(PREFIX)/include/sys
	install -m644 *.h $(DESTDIR)$(PREFIX)/include/sys/
