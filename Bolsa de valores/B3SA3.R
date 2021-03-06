#Vamos precisar instalar o pacote "quantmod" e inicia-lo em nossa biblioteca
install.packages("quantmod")
library(quantmod)

#Agora vamos utilizar o comando "getSymbol" para extrair dados da a��o
#que n�s queremo, no "src" � o local onde o Rstudio vai extrair esses dados
#no from temos o periodo que queremos

getSymbols("B3SA3.SA", src = "yahoo", from= '2017-01-01', to='2020-10-17')

#logo apos o comando a a��o j� fica armazenada em nosso environment
#voce pode usar o comando "periodicity" para saber se a a��o � atualizada
#diariamente

plot.xts(B3SA3.SA$B3SA3.SA.Close,major.format="%b/%d/%Y",
main="B3SA3.SA.",ylab="Close price.",xlab="Time")

#logo ap�s n�s plotamos a a��o no gr�fico e aqui eu escolhi o gr�fico
#a partir do pre�o de fechamento no periodo de 02/01/2017 at� dia 16/10/2020
#muito f�cil utilizando apenas 4 comandos em nosso script.
