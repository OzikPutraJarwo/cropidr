# CropID

**Indonesian Agricultural Research Related Functions and Data**

**CropID** merupakan sebuah package untuk bahasa pemrograman R untuk melakukan analisis data terkait penelitian pertanian (*agriculture research*).

## Fitur

- Analisis Varians (*ANOVA / Analysis of Variance*)
  - Rancangan Acak Lengkap / RAL (*Completely Randomized Design / CRD*)
  - Rancangan Acak Kelompok / RAK (*Randomized Complete Block Design / RCBD*)
- Uji Lanjut (*Post-Hoc Test*)
  - Uji Beda Nyata Terkecil / BNT (*Fisher's LSD*)
  - Uji Beda Nyata Jujur / BNJ (*Tukey's HSD*)
  - Uji Duncan / DMRT (*Duncan's Multiple Range Test*)
  - Uji Gugus / SK (*Scott Knott*)
- Path Analysis (*coming soon*)
- Dendrogram (*coming soon*)
- Biplot Genotype by Traits (*coming soon*)
- Boxplot (*coming soon*)

## Penggunaan

### 1. Analisis Varians & Uji Lanjut

Analisis varians dan uji lanjut dibungkus dalam satu fungsi yaitu `avs()`. Anda dapat menggunakannya dengan menggunakan parameter berikut:

|Parameter|Keterangan|Nilai|
|-|-|-|
|`file_jalur`|Jalur ke file data excel.|
|`file_kolom`|Tipe kolom data excel.|`"text"` `"numeric"`|
|`lembar_nama`|Nama sheet yang akan digunakan.|
|`kolom_respon`|Nama kolom hasil dalam sheet yang digunakan.|
|`jenis_rancangan`|Tipe ANOVA.|`"RAK"` `"RAL"`|
|`kolom_perlakuan`|Nama kolom perlakuan.|
|`kolom_kelompok`|Nama kolom kelompok / ulangan.|
|`jenis_ujilanjut`|Tipe uji lanjut (bisa lebih dari 1).|`"BNT"` `"BNJ"` `"DMRT"` `"ScottKnott"`|

Berikut contoh kode yang dapat digunakan:

```r
avs(
  file_jalur = "Nama File.xlsx",
  file_kolom = c("text", "numeric"),
  lembar_nama = "DB",
  kolom_respon = "MST13",
  jenis_rancangan = "RAK",
  kolom_perlakuan = "Perlakuan",
  kolom_kelompok = "Ulangan",
  jenis_ujilanjut = "BNT BNJ DMRT ScottKnott"
)
```

Output:
1. Tabel ANOVA
2. Koefisien korelasi
3. Signifikansi
4. Nilai uji lanjut
5. Notasi uji lanjut

## Instalasi

Hingga saat ini, package `CropID` belum dirilis di CRAN, sehingga user dapat melakukan instalasi dengan menggunakan cara-cara berikut:

### 1. Menggunakan `devtools`

Instal dan panggil package `devtools` apabila belum terinstal sebelumnya:

```r
install.packages("devtools")
library(devtools)
```

Setelah itu, instal dan panggil R package CropID dengan menggunakan:

```r
install_github("OzikPutraJarwo/cropidr")
library(cropid)
```

### 2. Menggunakan URL

Atau, instalasi juga dapat dilakukan dengan menggunakan URL sebagai berikut:

```r
install.packages("https://github.com/OzikPutraJarwo/cropidr/archive/refs/heads/main.zip", repos = NULL)
```

URL ini juga dapat diganti dengan path file yang telah didownload lokal.

## Kontributor
<a href="https://github.com/OzikPutraJarwo/cropidr/graphs/contributors" target="_blank">
  <img src="https://contrib.rocks/image?repo=OzikPutraJarwo/cropid.R"/>
</a>

## Pembaruan Selanjutnya

- Update DMRT
- Pemutakhiran v2

## Atribusi

Hak Cipta CropID oleh Ozik Putra Jarwo. Ucapan terima kasih diberikan kepada pengembang R packages berikut yang telah membantu dan menjadi dependensi CropID:
- `agricolae` - Alain Delahaye, Pierre Rouanet, dan lainnya
- `cli` - Gábor Csárdi
- `crayon` - Gábor Csárdi
- `dplyr` - Hadley Wickham, Romain François, Henry Wickham, dan Kirill Müller
- `emmeans` - Russell V. Lenth
- `multcomp` - Frank Bretz, Torsten Hothorn, dan Peter Westfall
- `multcompView` - Frank Bretz
- `readxl` - Hadley Wickham dan Bryan Jenny
- `ScottKnott` - Enio Jelihovschi, José Cláudio Faria, dan Ivan Bezerra Allaman
- `tibble` - Hadley Wickham, Kirill Müller, dan RStudio