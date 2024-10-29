#' Analisis Varians (ANOVA) dan Uji Lanjut (Post-hoc Test)
#'
#' @param file_jalur Jalur ke file data excel
#' @param file_kolom Tipe kolom data excel
#' @param lembar_nama Nama sheet yang akan digunakan
#' @param kolom_respon Nama kolom hasil dalam sheet yang digunakan
#' @param jenis_rancangan Tipe ANOVA ("RAK" atau "RAL")
#' @param kolom_perlakuan Nama kolom perlakuan
#' @param kolom_kelompok Nama kolom ulangan
#' @param jenis_ujilanjut Tipe uji lanjut ("BNT", "BNJ", "DMRT", atau "ScottKnott")
#' @return Hasil ANOVA dan Uji Lanjut
#' @export

avs <- function(file_jalur, file_kolom, lembar_nama, kolom_respon, jenis_rancangan, kolom_perlakuan, kolom_kelompok, jenis_ujilanjut) {

  if (jenis_rancangan == "RAK"){
    anova_form <- paste("~", kolom_kelompok, "+", kolom_perlakuan)
    excel_sk = read_excel(file_jalur, sheet = lembar_nama)
    formula_sk = paste(kolom_respon, "~", kolom_perlakuan, "+", kolom_kelompok)
    anova_sk <- aov(as.formula(formula_sk), data = excel_sk)
  } else if (jenis_rancangan == "RAL") {
    anova_form <- paste("~", kolom_perlakuan)
    excel_sk = read_excel(file_jalur, sheet = lembar_nama)
    formula_sk = paste(kolom_respon, "~", kolom_perlakuan)
    anova_sk <- aov(as.formula(formula_sk), data = excel_sk)
  }
  sheet <- lembar_nama
  col_name <- kolom_respon
  data <- read_excel(file_jalur, sheet = sheet, col_types = file_kolom)
  anova_formula <- as.formula(paste(col_name, anova_form))
  anova <- aov(anova_formula, data = data)
  anova_summary <- summary(anova)
  
  anova_df <- as.data.frame(anova_summary[[1]])
  anova_df <- rownames_to_column(anova_df, var = "Term")
  anova_df$Term <- gsub("Residuals", "Galat", anova_df$Term)
  colnames(anova_df)[colnames(anova_df) == "Df"] <- "db"
  colnames(anova_df)[colnames(anova_df) == "Sum Sq"] <- "JK"
  colnames(anova_df)[colnames(anova_df) == "Mean Sq"] <- "KT"
  colnames(anova_df)[colnames(anova_df) == "F value"] <- "F-hit"
  
  if (jenis_rancangan == "RAK"){
    f_table <- qf(0.95, anova_df$db[1:2], anova_df$db[3])
  } else if (jenis_rancangan == "RAL") {
    f_table <- qf(0.95, anova_df$db[1], anova_df$db[2])
  }
  anova_df$`F-tab` <- c(f_table, NA)
  
  colnames(anova_df)[colnames(anova_df) == "Pr(>F)"] <- "P-val"
  anova_df <- anova_df %>% relocate(`F-tab`, .before = `P-val`)
  anova_df <- column_to_rownames(anova_df, var = "Term")

  if (jenis_rancangan == "RAK"){
    db_Total <- (anova_df$db[1] + 1) * (anova_df$db[2] + 1) - 1
    db_JK <- sum(anova_df$JK[1:3])
  } else if (jenis_rancangan == "RAL") {
    db_Total <- sum(anova_df$db[1:2])
    db_JK <- sum(anova_df$JK[1:2])
  }

  total_row <- setNames(data.frame(
    db = db_Total,
    JK = db_JK,
    KT = NA,
    `F-hit` = NA,
    `F-tab` = NA,
    `P-val` = NA
  ), names(anova_df))
  
  anova_df <- rbind(anova_df, total_row)
  rownames(anova_df)[nrow(anova_df)] <- "Total"

  anova_df <- anova_df %>%
  mutate(across(c(db, JK, KT, `F-hit`, `F-tab`, `P-val`), ~ round(., 2)))

  if (jenis_rancangan == "RAK"){
    sigma_KTG <- anova_df$KT[3]
  } else if (jenis_rancangan == "RAL") {
    sigma_KTG <- anova_df$KT[2]
  }
  mu_KTG <- mean(data[[col_name]], na.rm = TRUE)
  cv <- round((sqrt(sigma_KTG) / mu_KTG * 100), 0)

  signif <- ifelse(
    anova_df$`P-val` <= 0.01, green("** (sn)"),
    ifelse(anova_df$`P-val` <= 0.05, yellow("* (n)"), red("tn"))
  )
  signif[is.na(anova_df$`P-val`)] <- NA

  df_error <- df.residual(anova)
  MSE <- sum(anova$residuals^2) / df_error
  n_groups <- length(unique(data[[kolom_perlakuan]]))
  r_groups <- length(unique(data[[kolom_kelompok]]))
  emmeans_result <- emmeans(anova, as.formula(paste("~", kolom_perlakuan)))

  add_indent <- function(groups) {
    unique_groups <- unique(groups)
    indented_groups <- character(length(groups))
    for (i in seq_along(groups)) {
      indent_level <- match(groups[i], unique_groups)
      indented_groups[i] <- paste0(strrep(" ", indent_level), groups[i])
    }
    return(indented_groups)
  }

  if (grepl("BNT", jenis_ujilanjut)){
    lsd_cld <- cld(emmeans_result, adjust = "none", Letters = letters, alpha = 0.05)
    LSD_value <- round(qt(1 - 0.05/2, df_error) * (sqrt(2 * MSE / r_groups)), 2)
  }

  if (grepl("BNJ", jenis_ujilanjut)){
    tukey_result <- multcomp::cld(emmeans_result, Letters = letters)
    ordered_results <- tukey_result[order(tukey_result$emmean), ]
    tukey_value <- round(qtukey(0.95, n_groups, df_error) * (sqrt(MSE / r_groups)), 2)
  }

  if (grepl("DMRT", jenis_ujilanjut))   {
    dmrt_result <- agricolae::duncan.test(anova, kolom_perlakuan, group = TRUE)
    dmrt_groups <- dmrt_result$groups
    colnames(dmrt_groups) <- c("Rerata", "Notasi")
    dmrt_groups$Notasi <- add_indent(dmrt_groups$Notasi)
    DMRT_value <- round(qt(1 - 0.05/2, df_error) * (sqrt(MSE / r_groups)), 2)
  }

  if (grepl("ScottKnott", jenis_ujilanjut))   {
    sk_result <- SK(anova_sk)
    sk_groups <- sk_result$out$Result
    num_groups <- ncol(sk_groups) - 1
    new_labels <- rev(letters[1:num_groups])
    for (i in seq_len(num_groups)) {
      current_col <- paste0("G", i)
      sk_groups[[current_col]][sk_groups[[current_col]] != ""] <- new_labels[i]
    }
    sk_groups$Means <- as.numeric(as.character(sk_groups$Means))
    sk_groups <- sk_groups[!is.na(sk_groups$Means), ]
    sk_groups <- sk_groups[order(sk_groups$Means), ]
    sk_groups$Gugus <- apply(sk_groups[, 2:(num_groups + 1)], 1, function(x) paste(x[x != ""], collapse = ""))
  }

  cat(bold(yellow("=============================================\n\n")))
  cat(bold(blue("Nama Sheet :", sheet)))
  cat("\n")
  cat(bold(blue("Kolom      :", col_name)))
  cat("\n\n")
  cat(bold("ANOVA", jenis_rancangan))
  cat("\n")
  print(anova_df)
  cat("\n")
  cat(bold("Koefisien Korelasi:"), paste0(cv, "%"))
  cat("\n\n")
  cat(bold("Signifikansi"))
  cat("\n")
  if (jenis_rancangan == "RAK"){
    cat("-", kolom_kelompok, ":", signif[1])
    cat("\n")
    cat("-", kolom_perlakuan, ":", signif[2])
  } else if (jenis_rancangan == "RAL") {
    cat("-", kolom_perlakuan, ":", signif[1])
  }
  cat("\n")
  if (grepl("BNT", jenis_ujilanjut)){
    cat("\n")
    cat(bold("BNT :"), LSD_value)
    cat("\n\n")
    cat(sprintf("%-10s %-10s %-10s\n",
                kolom_perlakuan, "Rerata", "Notasi"))
    for (i in 1:nrow(lsd_cld)) {
      cat(sprintf("%-10s %-10s %-10s\n",
                  lsd_cld[[kolom_perlakuan]][i],
                  round(lsd_cld$emmean[i], 2),
                  lsd_cld$.group[i]))
    }
  }
  if (grepl("BNJ", jenis_ujilanjut)){
    cat("\n")
    cat(bold("BNJ :"), tukey_value)
    cat("\n\n")
    cat(sprintf("%-10s %-10s %-10s\n",
                kolom_perlakuan, "Rerata", "Notasi"))
    for (i in 1:nrow(ordered_results)) {
      cat(sprintf("%-10s %-10s %-10s\n",
                  ordered_results[[kolom_perlakuan]][i],
                  round(ordered_results$emmean[i], 2),
                  ordered_results$.group[i]))
    }
  }
  if (grepl("DMRT", jenis_ujilanjut)) {
    cat("\n")
    cat(bold("DMRT :"), DMRT_value)
    cat("\n\n")
    cat(sprintf("%-10s %-10s %-10s\n", "Perlakuan", "Rerata", "Notasi"))  
    for (i in seq_len(nrow(dmrt_groups))) {
      cat(sprintf("%-10s %-10.2f %-10s\n", 
                  rownames(dmrt_groups)[i], 
                  dmrt_groups[i, "Rerata"], 
                  dmrt_groups[i, "Notasi"]))
    }
  }
  if (grepl("ScottKnott", jenis_ujilanjut)) {
    cat("\n")
    cat(bold("Scott Knott"))
    cat("\n\n")
    cat(sprintf("%-10s %-10s %-10s\n", "Perlakuan", "Rerata", "Gugus"))
    for (i in seq_len(nrow(sk_groups))) {
      cat(sprintf("%-10s %-10.2f %-10s\n", 
                  rownames(sk_groups)[i], 
                  sk_groups$Means[i], 
                  sk_groups$Gugus[i]))
    }
  }
  cat(bold(yellow("\n=============================================\n\n")))
}
