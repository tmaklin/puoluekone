fluidPage(
    titlePanel("Bayesiläinen puoluekone"),
    h3("Lyhyesti"),
    includeHTML("html/lyhyesti.html"),
    mainPanel(
        uiOutput("questions"),
        checkboxGroupInput("datasets", "Kysymykset", c("HS" = "data/hs_eduskunta19.json"), selected = "data/hs_eduskunta19.json"),
        selectInput("vaalipiiri", "Vaalipiiri", selected = "Helsinki", choices = c("Helsinki")),
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
