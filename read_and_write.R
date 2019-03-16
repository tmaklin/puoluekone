WriteResults <- function(data, parties, self, input) {
    out.folder <- sprintf("%s_%s", as.integer(Sys.time()), digest::digest(data))
    system(paste("mkdir ", out.folder, sep=''))
    answer.aligns <- matrix(0, data$nqs, data$ncandidates)
    cluster.hits <- matrix(0, data$nqs, data$nparties)
    for (i in 1:data$nqs) {
        answer.aligns[i, ] <- FindNear(data$data[, i], self$answers[i])
        party.aligns <- unname(unlist(lapply(by(answer.aligns[i,], parties, table), "[", "1")))
        party.aligns[is.na(party.aligns)] <- 0
        cluster.hits[i, ] <- party.aligns
    }
    cluster.hits <- cluster.hits[, match(unique(parties), sort(unique(parties)))]
    sink(paste(out.folder, "pseudoalignments.ec", sep='/'))
    id.question <- 0
    for (i in 1:data$nqs) {
        candidate.aligns <- which(answer.aligns[i, ] == 1)
        if (length(candidate.aligns) > 0) {
            cat(id.question)
            cat('\t')
            cat(paste(candidate.aligns - 1, collapse=','))
            cat('\n')
            id.question <- id.question + 1
        }
    }
    sink()

    weights.question <- self$weights
    sink(paste(out.folder, "pseudoalignments.tsv", sep='/'))
    for (i in 0:(id.question - 1)) {
        cat(i)
        cat('\t')
        cat(weights.question[i + 1])
        cat('\n')
    }
    sink()

    sink(paste(out.folder, "run_info.json", sep='/'))
    cat("{")
    cat('\n')
    cat(paste("\"        n_targets\": ", data$ncandidates, sep=''))
    cat("}")
    sink()
    return(out.folder)
}
