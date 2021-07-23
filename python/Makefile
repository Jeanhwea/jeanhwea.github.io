include ../Makefile.inc

ORGS := $(wildcard *.org)
PDFS := $(ORGS:%.org=%.pdf)
DOCS := $(ORGS:%.org=%.docx)

all: pdfs

pdfs: $(PDFS)
	$(ECHO) "Finish: [$(PDFS)]"

docs: $(DOCS)
	$(ECHO) "Finish: [$(DOCS)]"

%.pdf: %.org
	-$(PANDOC) $(CFLAG) $< -o $@

%.docx: %.org
	-$(PANDOC) $< -o $@

clean:
	-$(RM) -f *.pdf *.docx

.SUFFIXES: .docx .pdf .org

.PHONY:
	all clean docs
