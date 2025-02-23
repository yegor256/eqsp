# SPDX-FileCopyrightText: Copyright (c) 2022 Yegor Bugayenko
# SPDX-License-Identifier: MIT

SHELL := /bin/bash

.SHELLFLAGS = -e -o pipefail -c
.ONESHELL:

DIRS := $(wildcard [0-9][0-9]-*/.) syllabus

all: latexmk package

latexmk:
	for d in $(DIRS); do
		cd $${d} && latexmk -pdf && cd ..
	done

lacheck:
	for d in $(DIRS); do
		cd $${d} && lacheck *.tex && cd ..
	done

package: latexmk
	mkdir -p package
	for d in $(DIRS); do
		cp $${d}/*.pdf package
	done
	cd package
	rm -rf index.html
	for f in $$(ls *.pdf); do
		echo "<p><a href='$${f}'>$${f}</a></p>" >> index.html
	done

copy:
	for d in $(DIRS); do
		cp .latexmkrc $${d}
		cp .texsc $${d}
		cp .texqc $${d}
	done

clean:
	for d in $(DIRS); do
		cd $${d}
		latexmk -C
		rm -rf _minted*
		cd ..
	done
