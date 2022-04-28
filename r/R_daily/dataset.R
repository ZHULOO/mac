rm(list = ls())
url<-"http://people.stern.nyu.edu/wgreene/Text/Edition7/tablelist8new.htm"
web<-read_html(url,encoding = "utf-8")
nodes<-web%>%html_nodes(".WordSection1 a")
href<-nodes%>%html_attr("href")
href1<-href[-c(9,36,45,46)]
Name<-sub("http://www.stern.nyu.edu/~wgreene/Text/Edition7/","",href1) 
setwd("F:/DownLoad/格林计量8th/DataSet")
for(i in 32:length(href1))
  {
  download.file(href1[i],Name[i], mode = "a")
}





