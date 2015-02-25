
proper.emotion.names <- c("Disgust", "Contempt", "Surprise", "Happiness", "Anger", "Fear", "Sadness")


recode.response <- function(response){
  f <- as.factor(response)
  levels(f) <- c("Ilska", "Förakt", "Avsky", "Rädsla", "Glädje", "Sorg", "Förvåning")
  f
}

preprocess.frame <- function(dt) {
  colnames(dt) <- sapply(colnames(dt), tolower)
  dt$response <- recode.response(dt$response)
  # Merge levels exactly!
  dt$response <- factor(dt$response, levels=levels(dt$emotion))

  # Use English labels
  levels(dt$response) <-  proper.emotion.names
  levels(dt$emotion) <- proper.emotion.names
  
  dt
}

get.confusion.matrix <- function(df){
  library(caret)
  tab <- table(df$response, df$emotion)
  confusionMatrix(tab)
}

mtx.for.file <- function(fn) {
  get.confusion.matrix(preprocess.frame(read.csv(fn)))
}


study.one.data <- function() {
  library(ascii)
  options(asciiType="org")
  source("analyze.R")
  mtx <- mtx.for.file("annasdata.csv") 
  print(ascii(as.data.frame(mtx$byClass)))
  print(ascii(mtx$table))
  mtx
}


latex.study1.confusion.matrix <- function(cm) {
  library(xtable)
  caps = c("Confusion matrix of responses in study 1, rows represent participant responses and columns represent the stimulus.", "Confusion matrix of responses in study 1")
  xt <- xtable(cm$table, caption=caps, label="study1confusion")
  print.xtable(xt, caption.placement="top", booktabs=T, tabular.environment="tabularx", width="\\textwidth")
}

latex.study1.outcomes <- function(cm) {
  library(xtable)
  caps = "Summary table of confusion for each class"
  xt <- xtable(cm$byClass, caption=caps, label="study1classtable", align="lXXXXXXXX")
  print.xtable(xt,
               caption.placement="top",
               booktabs=T,
               tabular.environment="tabularx",
               width="\\textwidth",
               sanitize.rownames.function=function(x){
                 gsub("Class: ", "", x)
               },
               sanitize.colnames.function=function(x){
                 paste("\\rotatebox{-60}{", x, "}")
               },
               rotate.colnames=T
               )
}


preprocess.study2 <- function(df) {

  cols <- c(
            "Age_years", "Gender", "Grupp", "contempt_perc",
            "disgust_perc", "fear_perc", "joy_perc", "surprise_perc",
            "TOTALTRÄFF", "PANASPOSITIV", "PANASNEGATIV", "joy_perc",
            "POSIGENKÄNNING"
            )
  
  new.df <- df[,cols]
  
}

psycho.tab <- function(dt) {
  tab <- table(dt$trial, dt$correct)
  rows <- row.names(tab[,0])
  data.frame(row.names=rows, trial=rows, incorrect=tab[,1], correct=tab[,2])
}


