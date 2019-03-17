fluidPage(
    titlePanel("Bayesiläinen puoluekone"),
    h3("Lyhyesti"),
    includeHTML("html/lyhyesti.html"),
    mainPanel(
        uiOutput("datasets"),
        ## This is horrible and should be dynamically generated!
        selectInput("vaalipiiri", "Vaalipiiri", selected = "Helsinki", choices = c("Uusimaa", "Helsinki", "Varsinais-Suomi", "Satakunta", "Ahvenanmaa", "Häme", "Pirkanmaa", "Kaakkois-Suomi", "Savo-Karjala", "Vaasa", "Keski-Suomi", "Oulu", "Lappi")),
        uiOutput("questions"),
        actionButton("estimate", "Hae ehdokaat ja puolueet"),
        h3("Sopivimmat ehdokkaat"),
        htmlOutput("candidates"),
        h3("Sopivimmat ehdokkaat"),
        htmlOutput("nearCandidates"),
        h3("Ihannepuolue"),
        htmlOutput("parties"),
        h3("Sijoitus ehdokkaisiin nähden"),
        plotOutput("plot1", width='100%'),
        includeHTML("html/selite.html")),
    width = 12
)
