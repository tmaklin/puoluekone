FormatJSONData <- function(data, question.ids, district) {
    selected.district <- data[unlist(lapply(data, "[", "district")) == district]
    n.candidates <- length(selected.district)
    n.questions <- length(selected.district[[1]]$answers)
    answers <- lapply(selected.district, "[", "answers")
    answers <- matrix(unlist(answers), n.candidates, n.questions, byrow=TRUE)
    answers <- answers[, question.ids]
    n.questions <- length(question.ids)
    first.names <- unlist(lapply(selected.district, "[", "firstName"))
    last.names <- unlist(lapply(selected.district, "[", "lastName"))
    ## .r.p. is in all party names
    parties <- gsub(" r.p.", "", unname(unlist(lapply(selected.district, "[", "party"))))
    n.parties <- length(unique(parties))

    candidates <- paste(first.names, ' ', last.names, ", ", parties, sep='')
    return(list("data" = answers,
                "parties" = parties,
                "candidates" = candidates,
                "nparties" = n.parties,
                "nqs" = n.questions,
                "ncandidates" = n.candidates))
}

ExtractJSONQuestions <- function(questions, district) {
    districts <- unlist(lapply(questions, function(x) is.null(x$district)))
    districts[!districts] <- unlist(lapply(questions, function(x) x$district == district))
    question.ids <- unlist(lapply(questions, "[", "id"))[districts]
    question.texts <- unname(unlist(lapply(questions, "[", "text"))[districts])
    return(list("ids" = question.ids, "text" = question.texts))
}

MergeDatasets <- function(datasets, questions, n.datasets) {
    question.texts <- unlist(lapply(questions, "[", "text"))

    candidates <- Reduce(intersect, lapply(datasets, function(x) unlist(x$candidates)))
    all.candidates <- unlist(lapply(datasets, "[", "candidates"))
    parties <- unlist(lapply(datasets, "[", "parties"))
    parties <- parties[match(candidates, all.candidates)]
    n.candidates <- length(candidates)
    n.questions <- sum(unlist(lapply(datasets, function(x) ncol(x$data))))
    n.parties <- length(unique(parties))
    answers <- matrix(3, n.candidates, n.questions) ## 3 is empty/no answer
    start <- 1
    for (i in 1:n.datasets) {
        order.in.data <- match(candidates, datasets[[i]]$candidates)
        answers[, start:(start - 1 + datasets[[i]]$nqs)] <- datasets[[i]]$data[order.in.data, ]
        start <- start + datasets[[i]]$nqs
    }
    return(list("data" = list("data" = answers, "parties" = parties,
                              "candidates" = candidates, "nparties" = n.parties,
                              "nqs" = n.questions, "ncandidates" = n.candidates),
                "questions" = question.texts))
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
