## This file is part of Puoluekone (https://github.com/tmaklin/puoluekone)
## Copyright (C) 2020  Tommi Mäklin (tommi@maklin.fi)
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU Affero General Public License as published
## by the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU Affero General Public License for more details.
##
## You should have received a copy of the GNU Affero General Public License
## along with this program.  If not, see <https://www.gnu.org/licenses/>.

addResourcePath(prefix = 'www', directoryPath = 'www')

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
        includeHTML("html/selite.html"),
        tags$a(href = "www/javascript.html", rel = "jslicense", "JavaScript-lisenssit")),
    width = 12
)
