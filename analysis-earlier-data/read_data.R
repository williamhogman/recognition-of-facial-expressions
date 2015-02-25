library(foreign)

read.spss.mgame <- function(fname) {
  read.spss(fname,
            use.value.labels=T,
            to.data.frame=T,
            trim.factor.names=T,
            use.missings=T
            )
}

read.spss.psycho <- function(fname) {
  library(memisc)
  spss.system.file(fname, count.cases=T, to.lower=T)
}


convert <- function(infile, outfile){
  write.csv(read.spss.mgame(infile), outfile)
}

combine.multi <- function(pattern) {
  library()
  df <- do.call(rbind.data.frame, lapply(Sys.glob(pattern), function(name){
    
    data <- as.data.set(read.spss.psycho(name))
    if("ud" %in% colnames(data)) {
      data$fname <- data$ud
    } else {
      data$fname <- gsub(".sav", "", gsub("./psychotherapist/Micro", "", name))
    }
    data$v2 <- as.character(data$v2)
    as.data.frame(data[,c("v1", "v2", "v3", "v4", "v5", "fname")])
  }))

  colnames(df) <- c("image", "response", "emotion", "correct", "rt", "subj")

  # Fix the response factor
  df$correct[df$correct == "Rätt"] <- 1
  df$correct[is.na(df$correct)] <- 0
  df$correct <- as.logical(as.numeric(as.character(df$correct)))
  # Fix the resposnes

  df$response[df$response == "Ilska"] <- 1
  df$response[df$response == "Förakt"] <- 2
  df$response[df$response == "Äckel"] <- 3
  df$response[df$response == "Rädsla"] <- 4  
  df$response[df$response == "Glädje"] <- 5
  df$response[df$response == "Sorg"] <- 6
  df$response[df$response == "Förvåning"] <-  7
  df$trial <- as.numeric(with(foo, ave(foo$subj, foo$subj, FUN = seq)))

  df
}

convert.multi <- function(pattern, outfile) {
  write.csv(combine.multi(pattern), outfile)
}


main <- function(){
  convert("Annasdata.sav", "annasdata.csv")
  convert("Psykoterpeuter_vsKontroll2.sav", "Psykoterpeuter_vsKontroll2.csv")
  convert.multi("./psychotherapist/Micro*.*.sav", "psychotherapists.csv")
}
