## Mapa topogr�fico do estado de Rio de Janeiro com dados espaciais 

##antes de tudo precisamos intalar os pacotes abaixo:

install.packages("raster")
install.packages("rasterVis")
install.packages("colorspace")
install.packages("rgdal")
install.packages("fields")
install.packages("sf")
install.packages("sp")

##Agora vamos chamar os pacotes que acabamos de instalar conforme descrito abaixo:

library("raster") #Leitura de dados espaciais 
library("rasterVis")
library("colorspace")
library("rgdal")
library("fields")
library("sf")
library("sp")

##Agora voc� pode baixar os arquivos .tif que s�o do tipo Raster, bom eu peguei
##do site: http://srtm.csi.cgiar.org/srtmdata/

##Vamos definir onde vamos ler os aquivos .tif que baixamos e vamos salvar a
##nossa pasta na �rea de trabo, mas veja n�o salvei a parta em "dir" e sim at� 
##a �rea de trabalho. 

dir <- "C:/Users/marcu/OneDrive/�rea de Trabalho/"

##Baixei tr�s arquivos .tif no site mencionado acima, para abrangir as �reas 
##geogr�ficas de RJ e SP, vamos carregar um por vez e salvar nas pastas: r1,
##r2 e r3.

r1<- raster(paste0(dir,"dados/srtm_26_17.tif"))
r2<- raster(paste0(dir,"dados/srtm_27_17.tif"))
r3<- raster(paste0(dir,"dados/srtm_28_17.tif"))

##Agora vamos fazer uma a��o de juntar as tr�s informa��es, isso � bem comum
##e o nome dessa jun��o � Mosaico, precisaremos fazer uma fun��o para isso, 
##vamos abaixo:

se<- mosaic(r1,r2,r3,fun=mean)

##Aqui utilizamos a fun��o mosaic() e veja que utilizamos fun=men, essa �ltima
##fun��o foi para tratar a sobreposi��o de dados nas jun��es de cada mapa
##utilizamos men para ele tirar uma m�dia desses dados e gurdados na vari�vel se

plot(se)## para visualizar como ficou nossa jun��o

##bom agora n�s precisamos delimitar a �rea de cada estado, e para fazer isso
## vamos utilizar o pacote geobr, ele j� traz todas as informa��es que precisamos
##para delimitar a �rea geogr�fica de cada estado.

install.packages("geobr")
library(geobr)

##com a fun��o read_state presente no pacote geobr conseguimos ter acesso
##a toda �rea delimitada dos estados brasileiro, vamos pegar do Rio de janeiro
##veja que tamb�m conseguimos pegar o ano dos dados

rj<- read_state(code_state = "RJ", year = 2019)

##para conseguir pegar a �rea geogr�fica vamos utilizar a fun��o crop, e cortar
##a �rea certinha

rasterrj<- crop(se,rj)

##agora para selecionar apenas os dados cortados vamos aplicar uma fun��o chamada
##mask onde dentro dela informamos nossa vari�vel rasterrj e rj

topografiarj<- mask(rasterrj,rj)

plot(topografiarj)##use plot para visualizar sua imagem

##agora vamos utilizar mais um pacote o rasterVis, ele nos permite melhores 
##visualiza��es, margin � para tirar os gr�ficos que formam na parte superior e
##direita dando refer�ncia m�dia para cada grau de latitude e longitude, cuts
##� para incluir mais n�veis de topografia
##podemos utilizar a fun��o col.regions e tim.colors para colorir nosso mapa
##para isso voc� precisa executar mais um pacote o "fields"

levelplot(topografiarj,margin=FALSE,cuts=80, 
                col.regions=tim.colors(90))

##tamb�m � poss�vel que n�s fa�amos a nossa pr�pria paleta de cores, conforme
#padr�o que visualizamos em gr�ficos


col.relevo<- colorRampPalette(c("#bcd2a4","#89d2a4","#28a77e","#ddb747","#fecf5b"
                ,"#da9248","#b75554","#ad7562","#b8a29a","#9f9e98"))

##e depois s� substituir o tim.colors
levelplot(topografiarj,margin=FALSE,cuts=80, 
          col.regions=col.relevo(90))

##Podemos melhorar ainda mais o gr�fico, sobrepondo o mesmo a �rea que
##selecionamos no site com as informa��es srtm, vamos gurdar essa ultima imagem

plotrj<- levelplot(topografiarj,margin=FALSE,cuts=80, 
          col.regions=col.relevo(90))

##Vamos utilizar a fun��o layer do pacote latticeExtra, pois precisamos converter
##nosso arquivo "rj" que � sp para Spatial, com isso precisamos instalar o 
##pacote "sp", depois � s� unir com o plot anterior


plotrj + latticeExtra::layer(sp.lines(as(rj$geom,Class = "Spatial")))

##Fim









