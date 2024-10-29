.onAttach <- function(libname, pkgname) {

  if (!requireNamespace("cli", quietly = TRUE)) {
    suppressMessages(suppressWarnings(install.packages("cli", quietly = TRUE)))
  }
  suppressMessages(suppressWarnings(library(cli)))

  load_package <- function(pkg) {
    if (!suppressMessages(require(pkg, quietly = TRUE, character.only = TRUE))) {
      install.packages(pkg, quietly = TRUE)
      suppressMessages(library(pkg, character.only = TRUE))
    }
  }

  packages <- c("readxl", "dplyr", "tibble", "crayon", "emmeans", "multcomp", "multcompView", "agricolae", "ScottKnott")

  cli_progress_bar(
    format = "Memuat paket: {cli::pb_bar} {cli::pb_percent} | {cli::pb_current}/{cli::pb_total}",
    total = length(packages)
  )

  for (pkg in packages) {
    load_package(pkg)
    cli_progress_update()
  }

  cli_progress_done()

  vers <-  "v2.0.0"
  library(crayon)
  packageStartupMessage("")
  packageStartupMessage(bold(green("CropID")))
  packageStartupMessage("")
  packageStartupMessage("Paket R untuk Analisis terkait Pertanian")
  packageStartupMessage("Author   : Ozik Putra Jarwo")
  packageStartupMessage("Versi    : ", vers)
  packageStartupMessage("Github   : https://github.com/OzikPutraJarwo/cropidr")
  packageStartupMessage("Kontak   : https://www.kodejarwo.com")
  packageStartupMessage("")
}