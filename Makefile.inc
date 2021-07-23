################################################################################
# Global
################################################################################
TAG   := $(shell git describe --tags --always --dirty="-dev")
TODAY := $(shell date +'%Y-%m-%d')


################################################################################
# Common tool
################################################################################
PANDOC := pandoc
ECHO   := @echo
RM     := rm

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
