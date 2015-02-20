

recode.response <- function(response){
  f <- as.factor(response)
  levels(f) <- c("Ilska", "Förakt", "Avsky", "Rädsla", "Glädje", "Sorg", "Förvåning")
  f
}

preprocess.frame <- function(df) {
  colnames(df) <- sapply(colnames(df), tolower)
  df$response <- recode.response(df$response)
  # Merge levels exactly!
  df$response <- factor(dt$response, levels=levels(dt$emotion))
  df
}

get.confusion.matrix <- function(df){
  olibrary(caret)
  tab <- table(df$response, df$emotion)
  confusionMatrix(tab)
}


