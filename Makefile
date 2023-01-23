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

GEDADIR=$(HOME)/.config/lepton-eda
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

PRIMARYTARGETS=help installDependencies installTools installLibs
LIBSTARGETS=cleanAndInstallSymbols installGEDASymblols installFootprints installConfig
SYMSTARGETS=cleanSymbols installSymbols installConnectors installTragesym
.PHONY: $(PRIMARYTARGETS) $(LIBSTARGETS) $(SYMSTARGETS)

help:
	@ echo "USAGE:      make installLibs"
	@ echo "USAGE: sudo make installTools"
	@ echo "   or:      make installTools BINDIR=~/mybin"
	@ echo "USAGE: sudo make installDependencies"
	@ echo ""
	@ echo "Install dir for:"
	@ echo " - schematic libs: GEDADIR=$(GEDADIR)"
	@ echo " - pcb libs: PCBLIBDIR=$(PCBLIBDIR)"
	@ echo " - executables: BINDIR=$(BINDIR)"
	@ echo "You can change them via make variables, as BINDIR above."
	@ echo ""
	@ echo "installDependencies target is dedicated for:"
	@ echo "  Debian 11 (Bullseye)"
	@ echo ""
	@ echo "make subtargets:\n  $(LIBSTARGETS)\n  $(SYMSTARGETS)"


#
# main targets
#

# insall symbols, footprints and configs
installLibs: $(LIBSTARGETS)

# install executable tools/utils files
installTools:
	install -Dt $(BINDIR) tools/sch2img.sh
	ln -fs $(BINDIR)/sch2img.sh $(BINDIR)/sch2pdf
	ln -fs $(BINDIR)/sch2img.sh $(BINDIR)/sch2svg
	ln -fs $(BINDIR)/sch2img.sh $(BINDIR)/sch2png

# install dependencies (mostly for sch2img.sh)
#EDA_PKGS=geda-gschem pcb-rnd geda-gnetlist
EDA_PKGS=lepton-eda pcb-rnd
TO_PDF_DEP_PKGS=bash ps2eps ghostscript texlive-font-utils pdf2svg inkscape poppler-utils netpbm
installDependencies:
	apt install $(EDA_PKGS) $(TO_PDF_DEP_PKGS)


#
# install component symbols library
#

$(GEDADIR):
	[ -d $(HOME)/.gEDA ] && [ ! -d $(GEDADIR) ] && mv $(HOME)/.gEDA/ $(GEDADIR)
	mkdir -p $(GEDADIR)
	[ ! -d $(HOME)/.gEDA ] && ln -fs $(HOME)/.config/lepton-eda $(HOME)/.gEDA

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

installConnectors: $(GEDADIR)
	@ echo "Generate and install 1x?? connectors symbols"
	@ TRAGESYM=third-party/tragesym/tragesym ./tools/createConnectorsSymbols.sh $(SYMLIBSDIR)/connectors/ 1
	@ echo "Generate and install 2x?? connectors symbols"
	@ TRAGESYM=third-party/tragesym/tragesym ./tools/createConnectorsSymbols.sh $(SYMLIBSDIR)/connectors/ 2

installTragesym: $(GEDADIR)
	@ echo "Generate and install symbols:"
	@ find symbols.tragesym -type d | while read inDir; do \
		mkdir -p "$(SYMLIBSDIR)/$${inDir#symbols.tragesym/}" ; \
	done
	@ find symbols.tragesym -type f | while read inFile; do \
		outFile="$${inFile#symbols.tragesym/}"; outFile="$${outFile%.src}.sym" ; \
		echo "  - $$inFile -> $$outFile" ; \
		./third-party/tragesym/tragesym "$$inFile" "$(SYMLIBSDIR)/$$outFile" ; \
	done


#
# install selected component symbols from original gEDA library
#

SYMFILE_BASIC = capacitor-1.sym capacitor-2.sym capacitor-4.sym capacitor-variable-1.sym capacitor-variable-2.sym \
 coil-1.sym coil-2.sym crystal-1.sym fuse-1.sym fuse-2.sym varistor-1.sym \
 resistor-1.sym resistor-2.sym resistor-variable-1.sym resistor-variable-2.sym \
 battery-1.sym battery-2.sym battery-3.sym voltage-1.sym current-1.sym nmos-1.sym pmos-1.sym \
 transformer-1.sym transformer-2.sym transformer-3.sym transformer-4.sym transformer-5.sym

installGEDASymblols: $(GEDADIR)
	$(eval GEDASYSDIR := $(shell gschem -c '(display geda-data-path)(gschem-exit)' | tail -n1))
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
	install -m 755 -Dt $(PCBLIBDIR)/EDA-libs.Parametric third-party/pcb-rnd_parametric/*
	ln -fs $(PCB_RND_SHARE)/footprint/parametric/common.awk $(PCBLIBDIR)/EDA-libs.Parametric
	ln -fs $(PCB_RND_SHARE)/footprint/parametric/common_subc.awk $(PCBLIBDIR)/EDA-libs.Parametric
	install -m 644 -Dt $(PCBLIBDIR)/EDA-libs third-party/gEDA_footprints/*.fp
	install -m 644 -Dt $(PCBLIBDIR)/EDA-libs third-party/gedasymbols.org_footprints/*/*.fp
	install -m 644 -Dt $(PCBLIBDIR)/EDA-libs footprints/*.fp


#
# install gschem and friend (gaf) config files
#

installConfig: $(GEDADIR)
	@ echo "Installing config files"
	install -m 644 -C --backup=numbered configs/gafrc $(GEDADIR)/gafrc
	install -m 644 -Dt $(GEDADIR)/gafrc.d configs/libs.01.scm
	install -d $(GEDADIR)/Components/UserLib
	@ echo "DON'T put symbols directly into this directory - USE subdirs (e.g UserLib)" > $(GEDADIR)/Components/INFO.txt
	install -d $(GEDADIR)/Sources
	install -m 644 sources/net_connector.sch $(GEDADIR)/Sources/.placeholder.sch # lepton crash on empty Sources dir, so put some placeholder
