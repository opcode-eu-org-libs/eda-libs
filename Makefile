# Copyright (c) 2019 Robert Ryszard Paciorek <rrp@opcode.eu.org>
# 
# MIT License
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

GEDADIR=$(HOME)/.gEDA
PCBDIR=$(HOME)/.pcb-rnd/lib
ifeq ($(wildcard $(PCBLIBDIR)),) 
    PCBLIBDIR=$(HOME)/.pcb/lib
endif
ifeq ($(wildcard $(PCBLIBDIR)),) 
    PCBLIBDIR=$(HOME)/.pcblib
endif
ifeq ($(wildcard $(PCBLIBDIR)),) 
    PCBLIBDIR=$(HOME)/pcblib
endif
BINDIR=/usr/local/bin

SYMLIBSDIR=$(GEDADIR)/Components.EDA-libs
SYMGEDADIR=$(GEDADIR)/Components.gEDA
SRCLIBSDIR=$(GEDADIR)/Sources.EDA-libs

.PHONY: help installTools installLibs cleanAndInstallSymbols cleanSymbols installSymbols installConnectors installTragesym installFootprints installConfig

help:
	@ echo "USAGE: make installLibs"
	@ echo "USAGE: sudo make installTools"
	@ echo ""
	@ echo "Install dir for schematic libs is: $(GEDADIR)."
	@ echo "  You can change it via GEDADIR make variable."
	@ echo "  See results of: make help GEDADIR=/tmp"
	@ echo ""
	@ echo "Install dir for pcb libs is: $(PCBLIBDIR)."
	@ echo "  You can change it via PCBLIBDIR make variable."
	@ echo "  See results of: make help PCBLIBDIR=/tmp"

installLibs: cleanAndInstallSymbols installGEDASyblols installFootprints installConfig

#
# install component symbols library
#

cleanAndInstallSymbols:
	$(MAKE) cleanSymbols
	$(MAKE) installSymbols

cleanSymbols:
	@ echo "Clean $(SYMLIBSDIR) and $(SRCLIBSDIR)"
	rm -fr $(SYMLIBSDIR)/* $(SRCLIBSDIR)/*

installSymbols: installConnectors installTragesym
	@ echo "Installing *.sym file from repository to $(SYMLIBSDIR)"
	@ for inDir in symbols/*; do \
		echo "  install -m 644 -Dt $(SYMLIBSDIR)/`basename $$inDir` $$inDir/*" ; \
		install -m 644 -Dt $(SYMLIBSDIR)/`basename $$inDir` $$inDir/* ; \
	done
	@ echo "Installing *.src file from repository to $(SRCLIBSDIR)"
	install -m 644 -Dt $(SRCLIBSDIR) sources/*

installConnectors:
	@ echo "Generate and install 1x?? connectors symbols"
	@ TRAGESYM=third-party/tragesym/tragesym ./tools/createConnectorsSymbols.sh $(SYMLIBSDIR)/connectors/ 1
	@ echo "Generate and install 2x?? connectors symbols"
	@ TRAGESYM=third-party/tragesym/tragesym ./tools/createConnectorsSymbols.sh $(SYMLIBSDIR)/connectors/ 2

installTragesym:
	@ for inDir in symbols.tragesym/*; do \
		echo "Generate and install symbols from $$inDir" ; \
		outDir="$(SYMLIBSDIR)/`basename $$inDir`" ; \
		mkdir -p $$outDir ;\
		for inFile in $$inDir/*; do \
			outFile=`basename "$$inFile"` ; outFile="$${outFile%.src}.sym" ; \
			echo "  - $$inFile -> $$outFile" ; \
			./third-party/tragesym/tragesym "$$inFile" "$$outDir/$$outFile" ; \
		done ;\
	done


#
# install selected component symbols from original gEDA library
#

SYMFILE_BASIC = capacitor-1.sym capacitor-2.sym capacitor-4.sym capacitor-variable-1.sym capacitor-variable-2.sym \
 coil-1.sym coil-2.sym crystal-1.sym fuse-1.sym fuse-2.sym varistor-1.sym \
 resistor-1.sym resistor-2.sym resistor-variable-1.sym resistor-variable-2.sym \
 battery-1.sym battery-2.sym battery-3.sym voltage-1.sym current-1.sym nmos-1.sym pmos-1.sym \
 transformer-1.sym transformer-2.sym transformer-3.sym transformer-4.sym transformer-5.sym

installGEDASyblols:
	$(eval GEDASYSDIR := $(shell gschemx -c '(display geda-data-path)(gschem-exit)'))
	$(eval GEDASYMDIR := $(if $(GEDASYSDIR), "$(GEDASYSDIR)/sym", "third-party/gEDA_symbols"))
	@ echo "Install some symbols from gEDA symbols library ..."
	@ install -d $(SYMGEDADIR)
	@ for f in $(SYMFILE_BASIC); do \
		echo "  analog/$$f -> basic/$$f" ;\
		install -m 644 -Dt $(SYMGEDADIR)/basic/ $(GEDASYMDIR)/analog/$$f || exit 1;\
	done
	@ for f in and* nand* nor* or* xnor* xor* buf* not*; do \
		echo "  verilog/$$f -> logic/$$f" ;\
		install -m 644 -Dt $(SYMGEDADIR)/logic/ $(GEDASYMDIR)/verilog/$$f || exit 1;\
	done
	@ for f in title-bordered-A2.sym title-bordered-A3.sym title-bordered-A4.sym ; do \
		echo "  titleblock/$$f -> titleblock/$$f" ;\
		install -m 644 -Dt $(SYMGEDADIR)/titleblock/ $(GEDASYMDIR)/titleblock/$$f || exit 1;\
	done


#
# install pcb / pcb-rnd footprints
#

installFootprints:
	$(eval PCB_RND_SHARE := $(shell pcb-rnd --show-paths | awk -F '[ \t]*=[ \t]' '$$1 == "rc/path/share" {print $$2}'))
	install -m 644 -Dt $(PCBLIBDIR)/EDA-libs.Parametric third-party/pcb-rnd_parametric/*
	ln -fs $(PCB_RND_SHARE)/pcblib/parametric/common.awk $(PCBLIBDIR)/EDA-libs.Parametric
	install -m 644 -Dt $(PCBLIBDIR)/EDA-libs third-party/gEDA_footprints/*.fp
	install -m 644 -Dt $(PCBLIBDIR)/EDA-libs third-party/gedasymbols.org_footprints/*/*.fp
	install -m 644 -Dt $(PCBLIBDIR)/EDA-libs footprints/*.fp


#
# install gschem and friend (gaf) config files
#

installConfig:
	@ echo "Installing config files"
	install -m 644 -C --backup=numbered configs/gafrc $(GEDADIR)/gafrc
	install -m 644 -Dt $(GEDADIR)/gafrc.d configs/libs.01.scm
	install -d $(GEDADIR)/Components
	install -d $(GEDADIR)/Sources


#
# install executable tools/utils files
#

installTools:
	install -Dt $(BINDIR) tools/sch2img.sh
	ln -fs $(BINDIR)/sch2img.sh $(BINDIR)/sch2pdf
	ln -fs $(BINDIR)/sch2img.sh $(BINDIR)/sch2svg
	ln -fs $(BINDIR)/sch2img.sh $(BINDIR)/sch2png
