## This file is part of Puoluekone.
##
## Puoluekone is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## Puoluekone is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with Puoluekone.  If not, see <https://www.gnu.org/licenses/>.

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
