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
- Path Analysis (*coming soon*)
- Dendrogram (*coming soon*)
- Biplot Genotype by Traits (*coming soon*)
- Boxplot (*coming soon*)

## Penggunaan

### 1. Analisis Varians & Uji Lanjut

Analisis varians dan uji lanjut dibungkus dalam satu fungsi yaitu `avs()`. Anda dapat menggunakannya dengan menggunakan parameter berikut:

|Parameter|Keterangan|Nilai|
|-|-|-|
|`excel_j`|Jalur ke file data excel.|
|`excel_k`|Tipe kolom data excel.|`"text"` `"numeric"`|
|`sheet_n`|Nama sheet yang akan digunakan.|
|`sheet_k`|Nama kolom hasil dalam sheet yang digunakan.|
|`anova_r`|Tipe ANOVA.|`"RAK"` `"RAL"`|
|`anova_p`|Nama kolom perlakuan.|
|`anova_u`|Nama kolom ulangan.|
|`posthoc`|Tipe uji lanjut (bisa lebih dari 1).|`"BNT"` `"BNJ"` `"DMRT"`|

Berikut contoh kode yang dapat digunakan:

```r
avs(
  excel_j = "Nama File.xlsx",
  excel_k = c("text", "numeric"),
  sheet_n = "DB",
  sheet_k = "MST13",
  anova_r = "RAK",
  anova_p = "Perlakuan",
  anova_u = "Ulangan",
  posthoc = "BNT BNJ DMRT"
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

Setelah itu, instal dan panggil package CropID dengan menggunakan:

```r
install_github("OzikPutraJarwo/cropid")
library(cropid)
```

### 2. Menggunakan URL

Atau, instalasi juga dapat dilakukan dengan menggunakan URL sebagai berikut:

```r
install.packages("https://github.com/OzikPutraJarwo/cropid/archive/refs/heads/main.zip", repos = NULL)
```

URL ini juga dapat diganti dengan path file yang telah didownload lokal.

## Kontributor
<a href="https://github.com/OzikPutraJarwo/cropid.R/graphs/contributors" target="_blank">
  <img src="https://contrib.rocks/image?repo=OzikPutraJarwo/cropid.R"/>
</a>

## Pembaruan Selanjutnya

- ScottKnott
- Update DMRT

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
- `tibble` - Hadley Wickham, Kirill Müller, dan RStudio
