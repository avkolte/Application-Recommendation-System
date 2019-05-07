library(shiny)
library(arules)
library(tidyverse)
#library(reshape2)
#library(Matrix)
library(dplyr)
#library(dbplyr)
setwd("C:/Users/HP NOTEBOOK/Desktop/test/")
#library(stringr)
#library(ggplot2)


shinyServer(function(input,output)
{
  
  gapps = read.csv("Application Analysis.csv")
  
  recommend <- eventReactive(input$btn1,{
    
   
    my <-sym(input$genre)
    #Genre=gapps$my
    gappscopy=gapps %>% filter(Age==as.character(input$age),Gender==as.character(input$gender),
                               Occupation==as.character(input$occupation))
    gappscopy[gappscopy == ""] = NA
    #gapps2 = gappscopy %>% mutate(title =paste(Genre,sep=";"))
    #gapps2$title[4]
    
    gapps2 = gappscopy %>% mutate(title =!! my,sep=";")
    my_gapps_data = paste(gapps2$title,sep="\n");
    
   
    
    write(my_gapps_data, file = "gappsbasket");
    
    gappstrans = read.transactions("gappsbasket", format = "basket", sep=";")
    
    #gappstrans[4]
    gappsrules <- apriori(gappstrans, parameter = list(support = as.numeric(input$sup)
                                                       , confidence = as.numeric(input$con), minlen = 2))
    #inspect(gappsrules)
    
    assoc_rules =gappsrules[!is.redundant(gappsrules)]  
    
    assoc_rules = sort((subset(assoc_rules, lift>1.00)),by="lift",decreasing = TRUE)
    
    
    #gappsrules=gappsrules[!is.redundant(assoc_rules)]
    
    
    assoc_rules = as(assoc_rules,"data.frame")
    
    rules = sapply(assoc_rules$rules,function(x){
      x = gsub("[\\{\\}]", "", regmatches(x, gregexpr("\\{.*\\}", x))[[1]])
      x = gsub("=>",",",x)
      x = str_replace_all(x," ","")
      return( x )
    })
    
    rules = as.character(rules)
    rules = str_split(rules,",")
    
    assoc_rules$lhs_apps = sapply( rules, "[[", 1)
    assoc_rules$rhs_apps = sapply( rules , "[[", 2)
    
    assoc_rules$rules = NULL
    rm(rules)
    gc()
    
    #head(assoc_rules)
    final_data = assoc_rules %>% select(lhs_apps,rhs_apps)
    #final_data
    # return gappsrules
    write.csv(final_data,file="rules.csv",row.names = FALSE)
    
    data = read.csv("rules.csv",header = FALSE)
    result = vector()
    data = as.matrix(data)
    #colnames(data) = NULL
    data = data[-1,]
    names(data) <- NULL
    #glimpse(data)
    search <- function(search_key)
    {
      result = which(data[,1]==search_key)
      print(paste('Number of Apps Found :',length(result)))
      i=1
      while (i<=length(result))
      {     print(data[result[i],2])
        i=i+1
      }
    }
    
    print('------------------------------------------------------------------------------------')
    print('**************************Recommended Apps******************************************')
    search(as.character(input$key))
    
    
  })
  
  # inspectRule <- eventReactive(input$btn2,{
  #   inspect(assoc_rules)
  # })
  # observe({
  #   #data1 = gapps %>% filter(colnames(gapps)== !! my) %>% select(names(!! my))
  #   updateSelectInput(session,'key','Select App',choices=unique(gapps$my))
  #   
  # })
  
  output$app <- renderPrint({
    recommend()
   
  })
  
  # output$rules <- renderPrint({
  #   inspectRule()
  # })
  # 
})
