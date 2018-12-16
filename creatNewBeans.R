homefolder <- "M:/Thesis/R/Rcode"
resultfolder <- "M:/Thesis/R/Rcode/Data"
setwd(homefolder)


newbeans <- read.csv("Data/newbeans.csv")
newbeans <- data.frame(newbeans)
best <- newbeans[7]
worst <- newbeans[8]
a_name <- newbeans[3]
b_name <- newbeans[4]
c_name <- newbeans[5]
best1 <- newbeans$best1
worst1 <- newbeans$worst1
middle1 <- newbeans$middle1


## change best ABC to names
for (i in (1:888)){
  if (as.character(best[i,1]) == "A"){
    chara = as.character(a_name[i,1])
    newbeans$best1[i] = chara
  }
  else if (as.character(best[i,1]) == "B"){
    chara_b = as.character(b_name[i,1])
    newbeans$best1[i] = chara_b
  }
  else {
    chara_c = as.character(c_name[i,1])
    newbeans$best1[i] = chara_c
  }
}
## change worst ABC to names
for (i in (1:888)){
  if (as.character(worst[i,1]) == "A"){
    chara = as.character(a_name[i,1])
    newbeans$worst1[i] = chara
  }
  else if (as.character(worst[i,1]) == "B"){
    chara_b = as.character(b_name[i,1])
    newbeans$worst1[i] = chara_b
  }
  else {
    chara_c = as.character(c_name[i,1])
    newbeans$worst1[i] = chara_c
  }
}
a = cbind(as.character(newbeans$best),as.character(newbeans$worst))
b = cbind(rep("A",888),rep("B",888),rep("C",888))

a = cbind(as.character(newbeans$best),as.character(newbeans$worst))