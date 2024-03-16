include Makefile.inc

SUBDIRS := article database frontend java python tool

all: $(SUBDIRS)


$(SUBDIRS):
	$(ECHO) "Entering $@" && $(MAKE) -C $@

.PHONY: all $(SUBDIRS)
