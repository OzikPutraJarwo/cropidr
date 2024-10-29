install_github("OzikPutraJarwo/cropidr")
library(cropid)

avs(
  file_jalur        = "./tests/data.xlsx",
  file_kolom        = c("text", "text", 
                        "numeric", "numeric", "numeric", 
                        "numeric", "numeric", "numeric"
                      ),
  lembar_nama       = "DB",
  kolom_respon      = "MST13",
  jenis_rancangan   = "RAK",
  kolom_perlakuan   = "Perlakuan",
  kolom_kelompok    = "Ulangan",
  jenis_ujilanjut   = "BNT BNJ DMRT ScottKnott"
)