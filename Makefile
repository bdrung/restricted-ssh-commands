PREFIX=/usr

VERSION = 0.1
DATE = 2015-10-02

all:

clean:
	rm -rf restricted-ssh-commands.1 test

test/restricted-ssh-commands: restricted-ssh-commands
	mkdir -p test
	sed 's@config_file="/etc@config_file="$${TEST_ROOT-}/etc@' $^ > $@
	chmod +x $@

check: test/restricted-ssh-commands
	./test-restricted-ssh-commands

%.1: %.pod
	pod2man --center=" " --release="restricted-ssh-commands" -d "$(DATE)" $^ $@

doc: restricted-ssh-commands.1

install: doc
	install -D -m 755 restricted-ssh-commands $(DESTDIR)$(PREFIX)/lib/restricted-ssh-commands
	install -D -m 644 restricted-ssh-commands.1 $(DESTDIR)$(PREFIX)/share/man/man1/restricted-ssh-commands.1

%.tar.xz: LICENSE Makefile restricted-ssh-commands restricted-ssh-commands.pod test-restricted-ssh-commands
	tar -cJf $@ --transform 's,^,restricted-ssh-commands-$(VERSION)/,' $^

dist: restricted-ssh-commands-$(VERSION).tar.xz

.PHONY: all clean check doc dist install
