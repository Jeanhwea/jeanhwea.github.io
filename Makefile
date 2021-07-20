################################################################################
# Global
################################################################################
TAG   := $(shell git describe --tags --always --dirty="-dev")
TODAY := $(shell date +'%Y-%m-%d')
ORGS  := $(wildcard *.org)
DOCS  := $(patsubst %.org,%.pdf,$(ORGS))

################################################################################
# Setup PDF Flags
################################################################################
CFLAG  = --pdf-engine=xelatex
CFLAG += --toc
CFLAG += -V date="$(TODAY)"
CFLAG += -V author="$(TAG)"
# CFLAG += --toc-depth=3
CFLAG += --number-sections
# CFLAG += -V mainfont="Heiti SC Light"
CFLAG += -V mainfont="SimSun"
CFLAG += -V documentclass=ctexart
CFLAG += -V geometry:margin='.8in'

################################################################################
#  ____                                        _
# |  _ \  ___   ___ _   _ _ __ ___   ___ _ __ | |_
# | | | |/ _ \ / __| | | | '_ ` _ \ / _ \ '_ \| __|
# | |_| | (_) | (__| |_| | | | | | |  __/ | | | |_
# |____/ \___/ \___|\__,_|_| |_| |_|\___|_| |_|\__|
#
################################################################################
all: $(DOCS)
	echo $(DOCS)

.org:.pdf:
	echo pandoc $(CFLAG) $< -o $@

list-fonts:
	@fc-list :lang=zh

clean:
	@rm *.pdf


.SUFFIXES:.pdf .org

# codetta: start
# sed '/^[-0-9A-Za-z]*:/!d;s/:.*$//' Makefile | sort | tr '\n' ' ' | xargs -I {} printf ".PHONY:\n\t{}\n"
# codetta: output
.PHONY:
	abbr
# codetta: end
