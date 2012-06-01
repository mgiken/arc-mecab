prefix = ${shell arc --show-prefix}

libdir = $(DESTDIR)/$(prefix)/lib/arc/site

all:

install:
	mkdir -p $(libdir)
	cp mecab.arc $(libdir)/mecab.arc

uninstall:
	rm -rf $(libdir)/mecab.arc

test:
	prove -fe arc t
