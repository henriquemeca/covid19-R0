rm(list=ls())
cat("\014")

library(EpiEstim)
#data(Flu2009)

dados = read.table(file = "clipboard", sep = "\t", header=TRUE)
#dados = readClipboard()

dados$dates = as.Date(dados$dates)
colunas = colnames(dados)

colnames(dados)[1] = "dates"
colnames(dados)[2] = "I"

analyse = dados[,1:2]

config = make_config(list(mean_si = 4.8, std_mean_si = 1,
                          min_mean_si = 3.8, max_mean_si = 6.1,
                          std_si = 2.3, std_std_si = 0.5,
                          min_std_si = 1.6, max_std_si = 3.5))

res_uncertain_si = estimate_R(analyse,
                              method = "uncertain_si",
                              config = config)
#plot(res_uncertain_si, legend = FALSE)

output = res_uncertain_si$R$`Mean(R)`

for (i in c(3:length(colunas))) {
  analyse = data.frame(dados$dates,dados[,i])
  colnames(analyse)[2] = "I"
  
  r = estimate_R(analyse,method = "uncertain_si", config = config)
  
  output = data.frame(output,r$R$`Mean(R)`)
  colnames(output)[i-1] = colunas[i]
}

colnames(output)[1] = colunas[2]
write.csv2(output, file = "COVID19-STM.csv")