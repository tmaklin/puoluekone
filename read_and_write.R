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

WriteToDisk <- function(parties, out.ecs, out.weights, out.info) {
    ## Create a hash to use as the folder name if writing to disk
    out.folder <- sprintf("%s_%s", as.integer(Sys.time()), digest::digest(data))
    system(paste("mkdir ", out.folder, sep=''))

    sink(paste(out.folder, "pseudoalignments.ec", sep='/'))
    cat(out.ecs)
    sink()

    sink(paste(out.folder, "pseudoalignments.tsv", sep='/'))
    cat(out.weights)
    sink()

    sink(paste(out.folder, "run_info.json", sep='/'))
    cat(out.info)
    sink()

    write.table(parties, file=paste(out.folder, "indis.txt", sep='/'),
                sep='\n', quote=FALSE, row.names=FALSE, col.names=FALSE)

    return(out.folder)
}

WriteResults <- function(data, parties, self, input, write.to.disk = TRUE) {
    answer.aligns <- matrix(0, data$nqs, data$ncandidates)
    cluster.hits <- matrix(0, data$nqs, data$nparties)
    for (i in 1:data$nqs) {
        answer.aligns[i, ] <- FindNear(data$data[, i], self$answers[i])
        party.aligns <- unname(unlist(lapply(by(answer.aligns[i,], parties, table), "[", "1")))
        party.aligns[is.na(party.aligns)] <- 0
        cluster.hits[i, ] <- party.aligns
    }
    cluster.hits <- cluster.hits[, match(unique(parties), sort(unique(parties)))]

    out.ecs <- ''
    id.question <- 0
    for (i in 1:data$nqs) {
        candidate.aligns <- which(answer.aligns[i, ] == 1)
        if (length(candidate.aligns) > 0) {
            out.ecs <- paste(out.ecs, id.question, '\t', sep='')
            out.ecs <- paste(out.ecs, paste(candidate.aligns - 1, collapse=','))
            out.ecs <- paste(out.ecs, '\n', sep='')
            id.question <- id.question + 1
        }
    }

    out.weights <- ''
    weights.question <- self$weights
    for (i in 0:(id.question - 1)) {
        out.weights <- paste(out.weights, i, '\t', weights.question[i + 1], '\n', sep='')
    }

    out.info <- paste("{", '\n', "        \"n_targets\" : ", data$ncandidates, ",",
                      #"\n        \"created_from_R\" : 1\n}",
                      sep='')

    if (write.to.disk) {
        return(WriteToDisk(parties, out.ecs, out.weights, out.info))
    }
    return(paste(paste(parties, collapse='\n'), "\nRUN_INFO\n",out.info,
                 out.weights,"PSEUDOALIGNMENT_ECS\n", out.ecs, sep=''))
}
