library(foreign)

read.spss.mgame <- function(fname) {
  read.spss(fname,
            use.value.labels=T,
            to.data.frame=T,
            trim.factor.names=T,
            use.missings=T
            )
}


convert <- function(infile, outfile){
  write.csv(read.spss.mgame(infile), outfile)
}


convert("Annasdata.sav", "annasdata.csv")
convert("Psykoterpeuter_vsKontroll2.sav", "Psykoterpeuter_vsKontroll2.csv")

