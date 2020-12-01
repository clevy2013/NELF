#One-Off to break out DF and CF --------
setwd("C:/Users/Charlotte.Levy/Dropbox/_UMass/Projects/NELF")
temp<-read_csv(file="SampledByMonth_2020.11.3.csv", 
                          col_types=cols(WKT=col_character(), fid=col_skip(), id=col_skip(), Albedo_1=col_integer(), layer=col_character(), path=col_skip()))

temp$DF_TF<-grepl("DF", temp[["layer"]])
temp$CF_TF<-grepl("CF", temp[["layer"]])
temp_DF<-subset(temp, DF_TF==TRUE)
temp_DF<-temp_DF %>% select(-one_of('DF_TF'))
temp_CF<-subset(temp, CF_TF==TRUE)
temp_CF<-temp_CF %>% select(-one_of('CF_TF'))

write.csv(x=temp_DF, "SampledByMonth_DF_2020.11.17.csv")
write.csv(x=temp_CF, "SampledByMonth_CF_2020.11.17.csv")

setwd("D:/NELF_Project/5_OutputData")
temp<-read.csv("SampledByMonth_DF_2020.11.17.csv")


#Attempt two to break out DF and CF
temp<-read_csv("C:/Users/Charlotte.Levy/Dropbox/_UMass/Projects/NELF/SampledData_2020.11.3_Bworkable.csv")
temp_DF<-subset(temp, Type=="DF")
temp_DF<-temp_DF %>% select(-one_of('X1'))
temp_CF<-subset(temp, Type=="CF")
temp_CF<-temp_CF %>% select(-one_of('X1'))
write.csv(x=temp_DF, "SampledByMonth_DF_2020.11.17.csv", row.names=FALSE)
write.csv(x=temp_CF, "SampledByMonth_CF_2020.11.17.csv", row.names=FALSE)
 