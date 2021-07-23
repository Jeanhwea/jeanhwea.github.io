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
	$(PANDOC) $(CFLAG) $< -o $(subst .pdf,-$(TAG).pdf,$@)

%.docx: %.org
	$(PANDOC) $< -o $(subst .docx,-$(TAG).docx,$@)

clean:
	-$(RM) -f *.pdf *.docx

.SUFFIXES: .docx .pdf .org

.PHONY:
	all clean docs
