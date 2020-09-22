(display "load libs.01.scm\n")

;; use ONLY own component symbols library
(reset-component-library)
(component-library-search (build-path (getenv "HOME") ".gEDA/Components.EDA-libs/"))
(component-library-search (build-path (getenv "HOME") ".gEDA/Components.gEDA/"))
;(component-library        (build-path (getenv "HOME") ".gEDA/Components/") "user libs")
(component-library-search (build-path (getenv "HOME") ".gEDA/Components/"))

;; use ALSO own schematic source library
(source-library           (build-path (getenv "HOME") ".gEDA/Sources/"))
(source-library-search    (build-path (getenv "HOME") ".gEDA/Sources/"))
(source-library           (build-path (getenv "HOME") ".gEDA/Sources.EDA-libs/"))
(source-library-search    (build-path (getenv "HOME") ".gEDA/Sources.EDA-libs/"))

;; search for symbols and souyrces in current working directory
(component-library ".")
(source-library  ".")
