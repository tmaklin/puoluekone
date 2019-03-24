library("rjson")
source("read_and_write.R")
source("manipulate_data.R")
options(digits = 2)

function(input, output) {

    constituency <- reactive({
        req(input$datasets)
        n.datasets <- length(input$datasets)
        datasets <- vector(mode = "list", n.datasets)
        questions <- vector(mode = "list", n.datasets)
        for (i in 1:n.datasets) {
            dataset <- fromJSON(file = input$datasets[[i]])
            questions[[i]] <- ExtractJSONQuestions(dataset$questions, input$vaalipiiri)
            datasets[[i]] <- FormatJSONData(dataset$candidates, questions[[i]]$ids,
                                            input$vaalipiiri)
        }
        if (n.datasets > 1) {
            return(MergeDatasets(datasets, questions, n.datasets))
        }
        return(list("data" = datasets[[1]], "questions" = questions[[1]]$text))
    })

    output$datasets <- renderUI({
        files <- list.files("data/")
        dataset.names <- toupper(gsub("_[a-z0-9.]*", "", files))
        files <- paste("data", files, sep='/')
        names(files) <- dataset.names
        checkboxGroupInput("datasets", "Kysymykset", choices = files)
    })

    output$questions <- renderUI({
        question.text <- constituency()$questions
        choices = list("Täysin samaa mieltä" = 5, "Jokseenkin samaa mieltä" = 4,
                       "Jokseenkin eri mieltä" = 2, "Täysin eri mieltä" = 1, "En osaa sanoa" = 3)
        n.questions <- length(question.text)
        questions <- vector(mode = "list", length=2*n.questions)
        j <- 1
        for (i in 1:n.questions) {
            questions[[j]] <- radioButtons(paste("q", i, sep=''), label = question.text[i],
                                           choices = choices, selected = 3, width = '100%')
            questions[[j + 1]] <- sliderInput(paste("w", i, sep=''), label = "Paino",
                                              value = 50, min = 0, max = 100, step = 1)
            j <- j + 2
        }
        return(questions)
    })

    filled.values <- reactive({
        req(input$q1) ## check if the questionnaire exists
        n.questions <- sum(grepl("q", names(input)))
        self.answers <- character(n.questions)
        self.weights <- numeric(n.questions)
        for (i in 1:n.questions) {
            self.answers[i] <- input[[paste("q", i, sep='')]]
            self.weights[i] <- as.numeric(input[[paste("w", i, sep='')]])
        }
        return(list("answers" = as.numeric(self.answers), "weights" = self.weights))
    })

    candidateSuggestions <- eventReactive(input$estimate, {
        data <- constituency()$data
        n.suggestions <- 5
        self.answers <- filled.values()$answers
        suggested <- FindCandidates(data$data, self.answers, data$ncandidates, n.suggestions)
        candidates <- as.list(paste(data$candidates[suggested$id], " (",
                                    round(suggested$agree/data$nqs*100, 0),
                                    "%)", sep=''))
        nearCandidates <- as.list(paste(data$candidates[suggested$almost.id], " (",
                                        round(suggested$almost.agree/data$nqs*100, 0),
                                        "%)", sep=''))
        list("candidates" = candidates, "nearCandidates" = nearCandidates)
    })

    partySuggestions <- eventReactive(input$estimate, {
        data <- constituency()$data
        survey.results <- WriteResults(data, data$parties, filled.values(), input, write.to.disk = TRUE)
        system(paste("./mSWEEP -f ", survey.results, " -i indis.txt",
                     " -o ",survey.results, "/test", sep=''))
        results <- read.table(paste(survey.results, "test_abundances.txt", sep='/'), sep='\t')
        results <- results[order(results[, 2], decreasing=TRUE), ]
        system(paste("rm -rf", survey.results, sep=' '))

        results
    })

    plot1 <- eventReactive(input$estimate, {
        party.colors <- c("plum2", # Eläinoikeuspuolue
                          "hotpink", # Feministinen puolue
                          "slategray4", # Itsenäisyyspuolue
                          "blue", # Kansallinen Kokoomus
                          "darkred", # KTP
                          "darkorange1", # Liberaalipuolue
                          "maroon4", # Liike Nyt
                          "blue4", # Perussuomalaiset
                          "black", # Piraattipuolue
                          "darkslategray", # Tähtiliike
                          "dodgerblue", # Sininen tulevaisuus
                          "darkgray", # Suomen kansa ensin
                          "greenyellow", # Suomen Keskusta
                          "brown", # SKP
                          "purple4", # KD
                          "red", # SDP
                          "yellow", # RKP
                          "red4", # Vasemmistoliitto
                          "green4") # Vihreät
        data <- constituency()$data
        parties <- sort(unique(data$parties))
        self <- filled.values()$answers
        pca <- prcomp(data$data)

        newcoords <- scale(t(as.matrix(self)), pca$center, pca$scale) %*% pca$rotation
        orderin_piiri <- match(data$parties, parties)
        cols <- party.colors[orderin_piiri]

        par(mar=c(3, 3, 3, 14), xpd=TRUE)
        plot(pca$x[, 1:2], pch=19, col=cols)
        points(x=newcoords[1], y=newcoords[2], pch=8, cex=4, col="black")
        legend("topright", legend=parties, fill=party.colors, bty='n', inset=c(-0.90, 0))
        legend("topleft", legend=c("Sinä", "Ehdokkaat"), pch=c(8, 19), bty='n')
    })

    output$candidates <- renderUI({
        HTML(paste(candidateSuggestions()$candidates, collapse='<br/>'))
    })

    output$nearCandidates <- renderUI({
        HTML(paste(candidateSuggestions()$nearCandidates, collapse='<br/>'))
    })

    output$parties <- renderUI({
        vals <- partySuggestions()
        vals <- vals[order(vals[, 2], decreasing=TRUE), ]
        HTML(paste(paste(round(vals[, 2]*100, 2), "% ", vals[, 1], sep=''), collapse='<br/>'))
    })

}
