findrules <- function(age,gender,occupation,sup,con) {
  gappscopy=gapps %>% filter(Your.Age.group.==age,Gender==gender,Occupation==occupation)
  gappscopy[gappscopy == ""] = NA
  gapps2 = gappscopy %>% mutate(title =paste(social.networking.apps.you.use ,
                                             Messaging.apps,online.shopping.Apps,Fashion.Apps, 
                                             payment , Music.and.Radio ,  Video.and.Entertainment
                                             , Food.and.Drinks,
                                             Education,sep=";"))
  #gapps2$title[4]
  
  #gappstrans=as(gapps2$title, "transactions")
  my_gapps_data = paste(gapps2$title, sep="\n");
  
  write(my_gapps_data, file = "gappsbasket");
  
  gappstrans = read.transactions("gappsbasket", format = "basket", sep=";")
  
  #gappstrans[4]
  gappsrules <- apriori(gappstrans, parameter = list(support =
                                                       sup
                                                     , confidence = con, minlen = 2))
  #inspect(gappsrules)
  
  inspect(gappsrules[!is.redundant(gappsrules)])  
 # return gappsrules
}
findrules("17-25","female","Student",0.7,0.25)