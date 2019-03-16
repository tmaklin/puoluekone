fluidPage(
    titlePanel("Bayesiläinen puoluekone"),
    h3("Lyhyesti"),
    includeHTML("html/lyhyesti.html"),
    mainPanel(
        uiOutput("datasets"),
        selectInput("vaalipiiri", "Vaalipiiri", selected = "Helsinki", choices = c("Helsinki")),
        uiOutput("questions"),
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
