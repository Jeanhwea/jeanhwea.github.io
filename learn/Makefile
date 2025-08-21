DIRTY   := $(shell date +"-draft-%Y%m%d-%H%M%S")
VERSION := $(shell git describe --tags --always --dirty="$(DIRTY)")
OUTDIR  := dist
PANDOC  := pandoc
P_FLAGS := --pdf-engine=xelatex
P_FLAGS += --number-sections
# P_FLAGS += --top-level-division=chapter
LATEX   := xelatex
L_FLAGS := -halt-on-error
BIBER   := biber
ORGS    := $(wildcard *.org)
PDFS    := $(ORGS:%.org=$(OUTDIR)/%.pdf)

all: dist-dir $(PDFS)

$(OUTDIR)/%.pdf: %.org
	$(PANDOC) $(P_FLAGS) -o $@ $<

dist-dir:
	@mkdir -p $(OUTDIR)

.PHONY: clean
clean:
	$(RM) -rf dist readme.tex
