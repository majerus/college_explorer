library(shiny)
library(leaflet)

# Choices for drop-downs
vars <- c(
  "Selectivity (adjustable)" = "superzip",
  "Tuition and Fees" = "centile",
  "Selectivity" = "college",
  "Applicants" = "income",
  "Enrollment" = "adultpop", 
  "log(Enrollment)" = "l_enorllment"
)





shinyUI(navbarPage("Four-Year Not-for-Profit Colleges", id="nav", 

  tabPanel("Interactive map",
    div(class="outer",
      
      tags$head(
        # Include our custom CSS
        includeCSS("styles.css"),
        includeScript("gomap.js")
      ),
      
      leafletMap("map", width="100%", height="100%",
        initialTileLayer = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
        initialTileLayerAttribution = HTML('Maps by <a href="http://www.mapbox.com/">Mapbox</a>'),
        options=list(
          center = c(37.45, -93.85),
          zoom = 5,
          maxBounds = list(list(15.961329,-129.92981), list(52.908902,-56.80481)) # Show US only
        )
      ),
      
      absolutePanel(
       id = "controls", 
       #class = "modal-body", 
        fixed = TRUE, draggable = TRUE,
        top = 60, left = "auto", right = 20, bottom = "auto",
        width = 330, height = "auto",
        
        h2("College Explorer"),
        
        selectInput("color", "Color", vars),
        selectInput("size", "Size", vars, selected = "adultpop"),
        conditionalPanel("input.color == 'superzip' || input.size == 'superzip'",
          # Only prompt for threshold when coloring or sizing by superzip
          numericInput("threshold", "Selectivity threshold (admit rate less than)", 10)
        ),
        
        plotOutput("histCentile", height = 200),
        plotOutput("scatterCollegeIncome", height = 250), 
       #img(src="TCA_Logo_K (2).png", width = 150))
       div(style = "margin: 0 auto;text-align: center;", 
          HTML("</br> 
              <a href=http://www.thirdcoastanalytics.com target=_blank>
              <img style='width: 150px;' src='http://i.imgur.com/ZZkas87.png'/> </a>"))
#        http://imgur.com/kBhR1Q8
#        http://i.imgur.com/TfGZPss.png
#[Imgur](http://i.imgur.com/ZZkas87.png)
       #tags$a(href="www.rstudio.com", "Click here!")
      ),
      
      tags$div(id="cite",
        HTML('Contact <a href="http://www.richmajerus.com/" target="_blank" >Rich Majerus </a> (rich.majerus@gmail.com) with questions, comments or concerns.  This application was built from code developed by the <a href="https://github.com/rstudio/shiny-examples/tree/master/063-superzip-example" target="_blank" >RStudio Team</a>. Data Source: National Center for Education Statistics, Integrated Postsecondary Education Data System (IPEDS) 2012-2013.  Due to these data being self-reported by each institution, the quality of the data in this visualization is only as high as the quality of institutional reporting. This visualization presents IPEDS data “as is." '
      ))
    )
  ),


  tabPanel("Data explorer",
    fluidRow(
      column(3,
        selectInput("states", "States", c("All states"="", structure(state.abb, names=state.name), "Washington, DC"="DC"), multiple=TRUE)
      ),
      column(3,
        conditionalPanel("input.states",
          selectInput("cities", "Cities", c("All cities"=""), multiple=TRUE)
        )
      ),
      column(3,
        conditionalPanel("input.states",
          selectInput("zipcodes", "Zipcodes", c("All zipcodes"=""), multiple=TRUE)
        )
      )
    ),
    #fluidRow(
    #  column(5,
    #    numericInput("minScore", "Min Tuition", min=0, max=50000, value=0)
    #  ),
    #  column(5,
    #    numericInput("maxScore", "Max Tuition", min=0, max=50000, value=50000)
    #  )
    #),
    hr(),
    dataTableOutput("ziptable")
  ),
  
  conditionalPanel("false", icon("crosshair"))

 # HTML("<i class=fa fa-crosshairs></i>")

))
