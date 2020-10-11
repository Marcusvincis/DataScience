## Mapa topográfico do estado de Rio de Janeiro com dados espaciais 

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

##Agora você pode baixar os arquivos .tif que são do tipo Raster, bom eu peguei
##do site: http://srtm.csi.cgiar.org/srtmdata/

##Vamos definir onde vamos ler os aquivos .tif que baixamos e vamos salvar a
##nossa pasta na área de trabo, mas veja não salvei a parta em "dir" e sim até 
##a área de trabalho. 

dir <- "C:/Users/marcu/OneDrive/Área de Trabalho/"

##Baixei três arquivos .tif no site mencionado acima, para abrangir as áreas 
##geográficas de RJ e SP, vamos carregar um por vez e salvar nas pastas: r1,
##r2 e r3.

r1<- raster(paste0(dir,"dados/srtm_26_17.tif"))
r2<- raster(paste0(dir,"dados/srtm_27_17.tif"))
r3<- raster(paste0(dir,"dados/srtm_28_17.tif"))

##Agora vamos fazer uma ação de juntar as três informações, isso é bem comum
##e o nome dessa junção é Mosaico, precisaremos fazer uma função para isso, 
##vamos abaixo:

se<- mosaic(r1,r2,r3,fun=mean)

##Aqui utilizamos a função mosaic() e veja que utilizamos fun=men, essa última
##função foi para tratar a sobreposição de dados nas junções de cada mapa
##utilizamos men para ele tirar uma média desses dados e gurdados na variável se

plot(se)## para visualizar como ficou nossa junção

##bom agora nós precisamos delimitar a área de cada estado, e para fazer isso
## vamos utilizar o pacote geobr, ele já traz todas as informações que precisamos
##para delimitar a área geográfica de cada estado.

install.packages("geobr")
library(geobr)

##com a função read_state presente no pacote geobr conseguimos ter acesso
##a toda área delimitada dos estados brasileiro, vamos pegar do Rio de janeiro
##veja que também conseguimos pegar o ano dos dados

rj<- read_state(code_state = "RJ", year = 2019)

##para conseguir pegar a área geográfica vamos utilizar a função crop, e cortar
##a área certinha

rasterrj<- crop(se,rj)

##agora para selecionar apenas os dados cortados vamos aplicar uma função chamada
##mask onde dentro dela informamos nossa variável rasterrj e rj

topografiarj<- mask(rasterrj,rj)

plot(topografiarj)##use plot para visualizar sua imagem

##agora vamos utilizar mais um pacote o rasterVis, ele nos permite melhores 
##visualizações, margin é para tirar os gráficos que formam na parte superior e
##direita dando referência média para cada grau de latitude e longitude, cuts
##é para incluir mais níveis de topografia
##podemos utilizar a função col.regions e tim.colors para colorir nosso mapa
##para isso você precisa executar mais um pacote o "fields"

levelplot(topografiarj,margin=FALSE,cuts=80, 
                col.regions=tim.colors(90))

##também é possível que nós façamos a nossa própria paleta de cores, conforme
#padrão que visualizamos em gráficos


col.relevo<- colorRampPalette(c("#bcd2a4","#89d2a4","#28a77e","#ddb747","#fecf5b"
                ,"#da9248","#b75554","#ad7562","#b8a29a","#9f9e98"))

##e depois só substituir o tim.colors
levelplot(topografiarj,margin=FALSE,cuts=80, 
          col.regions=col.relevo(90))

##Podemos melhorar ainda mais o gráfico, sobrepondo o mesmo a área que
##selecionamos no site com as informações srtm, vamos gurdar essa ultima imagem

plotrj<- levelplot(topografiarj,margin=FALSE,cuts=80, 
          col.regions=col.relevo(90))

##Vamos utilizar a função layer do pacote latticeExtra, pois precisamos converter
##nosso arquivo "rj" que é sp para Spatial, com isso precisamos instalar o 
##pacote "sp", depois é só unir com o plot anterior


plotrj + latticeExtra::layer(sp.lines(as(rj$geom,Class = "Spatial")))

##Fim









