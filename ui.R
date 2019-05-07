library(shiny)
library(shinythemes)
ui <- fluidPage(
  theme= shinytheme('readable'),
  #themeSelector(),
  
  navbarPage(
    
    id='nav',
    title = h3("Mobile Application Recommendation System"),
    
    tabPanel(
      
      'Data',value = 'Data',
      
      sidebarLayout(
        
        
        sidebarPanel(
          
          selectInput("age","Select Age",choices = c('17-25')),
          selectInput("gender","Select Gender",choices = c('male','female')),
          selectInput("occupation","Select Occupation",choices=c('Student')),
          selectInput('sup','Select support',choices = c(0.2,0.3,0.4,0.5,0.6,0.7,0.8)),
          selectInput('con','Select Confidence',choices = c(0.2,0.3,0.5,0.7,0.8,0.9,1.0)),
          selectInput('genre','Select Genre', choices = c('Social.Networking','Messaging.apps',
                                                          'online.shopping.apps','payment','Fashion.Apps',
                                                          'Video.and.Entertainment','Food.and.Drinks',
                                                          'Education')),
          selectInput('key','Select App',choices = c('facebook','instagram','twitter',
                                                     'Snapchat','WhatsApp','facebook messenger',
                                                     'Amazon','Flipkart','Myntra','Paytm','Google Pay',
                                                     'Youtube','hotstar','Netflix','zomato','Swiggy',
                                                     'Google Classroom')),
          #selectInput('key','Select App',choices = NULL),
          
          actionButton('btn1','Recommendations')
         # actionButton('btn2',"Show Association Rules")
          
        ),
        
        
        mainPanel(
          tabsetPanel(
            tabPanel(h3("Recommendations")),
            tabPanel(verbatimTextOutput("app"))
           # tabPanel(verbatimTextOutput("rules"))
          )
        ))
      )
    )
  )
