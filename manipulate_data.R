FormatJSONData <- function(data, district) {
    selected.district <- data$candidates[unlist(lapply(data$candidates, "[", "district")) == district]
    n.candidates <- length(selected.district)
    n.questions <- length(selected.district[[1]]$answers)
    answers <- lapply(selected.district, "[", "answers")
    answers <- matrix(unlist(answers), n.candidates, n.questions, byrow=TRUE)
    first.names <- unlist(lapply(selected.district, "[", "firstName"))
    last.names <- unlist(lapply(selected.district, "[", "lastName"))
    parties <- unname(unlist(lapply(selected.district, "[", "party")))
    n.parties <- length(unique(parties))

    candidates <- paste(first.names, ' ', last.names, ", ", parties, sep='')

    return(list("data" = answers,
                "parties" = parties,
                "candidates" = candidates,
                "nparties" = n.parties,
                "nqs" = n.questions,
                "ncandidates" = n.candidates))
}

ExtractAnswers <- function(data, n.questions) {
    self.answers <- character(n.questions)
    for (i in 1:n.questions) {
        self.answers[i] <- data[[paste("q", i, sep='')]]
    }
    return(as.numeric(self.answers))
}

ExtractWeights <- function(data, n.questions) {
    vec <- numeric(n.questions)
    for (i in 1:n.questions) {
        vec[i] <- as.numeric(data[[paste("w", i, sep='')]])
    }
    return(vec)
}

FindNear <- function(self, candidate) {
    agree <- (self %in% c(4, 5)) & (candidate %in% c(4, 5))
    disagree <- ((self %in% c(1, 2)) & (candidate %in% c(1, 2)))
    dontknow <- ((self == 3) & (candidate == 3))
    return(agree | disagree | dontknow)
}

FindCandidates <- function(data, vec, n.candidates, nout=1) {
    agrees.exact <- numeric(n.candidates)
    agrees.almost <- numeric(n.candidates)
    for (i in 1:n.candidates) {
        agrees.exact[i] <- sum(vec == data[i, ])
        agrees.almost[i] <- sum(FindNear(vec, data[i, ]))
    }
    return(list("id" = order(agrees.exact, decreasing=TRUE)[1:nout],
                "agree" = sort(agrees.exact, decreasing=TRUE)[1:nout],
                "almost.id" = order(agrees.almost, decreasing=TRUE)[1:nout],
                "almost.agree" = sort(agrees.almost, decreasing=TRUE)[1:nout]))
}
