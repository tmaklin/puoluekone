echo "mychoices <- list(\"Täysin samaa mieltä\" = 5, \"Jokseenkin samaa mieltä\" = 4, \"Jokseenkin eri mieltä\" = 2, \"Täysin eri mieltä\" = 1, \"En osaa sanoa\" = 3)
mychoices2 <- c(\"Kyllä\", \"Ei\", \"En osaa sanoa\")
fluidPage(
    titlePanel(\"Bayesiläinen puoluekone\")," > ui.R
echo "h3(\"Lyhyesti\")," >> ui.R
echo "includeHTML(\"html/lyhyesti.html\")," >> ui.R
echo "mainPanel(" >> ui.R
##echo "selectInput(\"vaalipiiri\", \"Vaalipiiri\", selected = \"01 Helsingin vaalipiiri\", choices = c(\"01 Helsingin vaalipiiri\",\"02 Uudenmaan vaalipiiri\",\"03 Varsinais-Suomen vaalipiiri\",\"04 Satakunnan vaalipiiri\",\"05 Ahvenanmaan maakunnan vaalipiiri\",\"06 Hämeen vaalipiiri\",\"07 Pirkanmaan vaalipiiri\",\"08 Kaakkois-Suomen vaalipiiri\",\"09 Savo-Karjalan vaalipiiri\",\"10 Vaasan vaalipiiri\",\"11 Keski-Suomen vaalipiiri\",\"12 Oulun vaalipiiri\",\"13 Lapin vaalipiiri\"))," >> ui.R
echo "checkboxGroupInput(\"datasets\", \"Kysymykset\", c(\"HS\" = \"data/hs_eduskunta19.csv\"), selected = \"data/hs_eduskunta19.csv\")," >> ui.R
echo "selectInput(\"vaalipiiri\", \"Vaalipiiri\", selected = \"Helsinki\", choices = c(\"Helsinki\"))," >> ui.R

i=1
while read -r line; do
    echo "radioButtons(\"q$i\", label = h3(\"$line\"),
                 choices = mychoices,
                 selected = 3,
		 width = '100%'),
    sliderInput(\"w$i\", label=\"Paino\", value=50, min = 0, max = 100, step = 1)," >> ui.R
    let "i++"
done < $1
# while read -r line; do
#     echo "radioButtons(\"q$i\", label = h3(\"$line\"),
#                  choices = mychoices2,
#                  selected = \"En osaa sanoa\",
# 		 width = '100%'),
#     sliderInput(\"w$i\", label=\"Paino\", value=50, min = 0, max = 100, step = 1)," >> ui.R
#     let "i++"
# done < $2
echo "h3(\"Sopivimmat ehdokkaat\")," >> ui.R
echo "htmlOutput(\"candidates\")," >> ui.R
echo "h3(\"Sopivimmat ehdokkaat\")," >> ui.R
echo "htmlOutput(\"nearCandidates\")," >> ui.R
echo "h3(\"Ihannepuolue\")," >> ui.R
echo "htmlOutput(\"parties\")," >> ui.R
echo "h3(\"Sijoitus ehdokkaisiin nähden\")," >> ui.R
echo "plotOutput(\"plot1\", width='100%')," >> ui.R
echo "includeHTML(\"html/selite.html\"))," >> ui.R
##echo "plotOutput(\"plot2\"), width = 6)" >> ui.R
echo "width = 12)" >> ui.R
