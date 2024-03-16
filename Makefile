include Makefile.inc

SUBDIRS := article database frontend java python tool

all: $(SUBDIRS)


$(SUBDIRS):
	$(ECHO) "Entering $@" && $(MAKE) -C $@

index:
	python3 genlink.py > readme.org

.PHONY: all $(SUBDIRS)
