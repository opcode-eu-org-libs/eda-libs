About this repository
=====================

This is set of my libraries and tools for libre EDA suites. This repository was separated from my [website](http://opcode.eu.org/) and contains:

* symbols library for gschem
* footprints library for pcb-rnd (most should works in mainline pcb)
* some useful tools (e.g. [sch2img.sh](sch2img.sh))

Files from this repo are often required by my other projects.

## Instalation

For install run:

```
make installLibs
sudo make installTools
```

For more details see `make help` and [Makefile](Makefile) file.

## Licensing

Primary license for this repo is MIT License (see [LICENSE](LICENSE)),
but some third-party elements are under GNU GPL (see [third-party/LICENSE](third-party/LICENSE)).

* Main symbols library ([symbols](symbols), [symbols.tragesym](symbols.tragesym) and [sources](sources)) and main footprints library ([footprints](footprints)) are distributed under dual licence MIT or GNU GPL with "unlimited use license".
* Third-party elements (in [third-party](third-party) directory) are under GNU GPL, including:
    * Modified version of tragesym ([third-party/tragesym](third-party/tragesym)) used to build some symbols for this library is distributed under GNU GPL.
    * Modified parametric footprints generator srcipts from pcb-rnd ([third-party/pcb-rnd_parametric](third-party/pcb-rnd_parametric)) are distributed under GNU GPL.
    * Modified footprints from gEDA/pcb package ([third-party/gEDA_footprints](third-party/gEDA_footprints)) are distributed under GNU GPL (with "unlimited use license").
    * Unmodified footprints from gedasymbols.org ([third-party/gedasymbols.org_footprints](third-party/gedasymbols.org_footprints)) are distributed under GNU GPL (with "unlimited use license")
    * Unmodified symbols from gEDA package ([third-party/gEDA_symbols](third-party/gEDA_symbols)) are distributed under GNU GPL (with "unlimited use license").
* Any other stuff are under MIT License.


About open/free/libre EDA suites
================================

## gEDA

[gEDA](http://www.geda-project.org/) is GNU GPL based [Electronic Design Automation](https://en.wikipedia.org/wiki/Electronic_design_automation) software suite.

### gschem
One of most important components of gEDA is [gschem](http://wiki.geda-project.org/geda:gaf) - schematic capture program. It is used to draw schematics of electronic circuits, it's operate on text files for component symbols and for whole schematic.

### pcb
Another important component is [PCB](http://pcb.geda-project.org/) - printed circuit board editor. It is used to design printed circuit board, it's operate on text files for footprints and for whole borad. For creating pcb based on gEDA schematic is used `gsch2pcb` tool.

### pcb-rnd
[pcb-rnd](http://repo.hu/projects/pcb-rnd/) is fork of pcb from gEDA suite with many improvements, such as:

* parametric elemnts as part of library created by AWK script (insted of m4)
* direct import from many schematic formats (including gschem)

pcb-rnd supports mainline pcb file formats for footprints and board, but native use other text based file formats.


## other libre EDA software

### lepton-eda
[lepton-eda](https://github.com/lepton-eda/lepton-eda) is fork of gEDA gschem and friends (gaf).
Use the same format for symbols and schematic as original gschem.

### coralEDA
[pcb-rnd](http://repo.hu/projects/coraleda/) is EDA suite build around pcb-rnd and [xschem](http://repo.hu/projects/xschem/).
Uses own file formats for symbols, footprints, schematics and boards, but support gEDA/pcb file formats for footprints and board.

### kicad
[kicad](http://kicad-pcb.org/) is other, independent EDA suite.
Uses own file formats for symbols, footprints, schematics and boards.
