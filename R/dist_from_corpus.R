#'
#' Calculate the distance of each topic from the overall corpus token distribution
#'
#' The Hellinger distance between the token probabilities or betas for each topic and
#' the overall probability for the word in the corpus is calculated.
#'
#' @param topic_model a fitted topic model object from one of the following:
#' \code{\link[topicmodels]{tm-class}}
#' @param dtm_data a document-term matrix of token counts coercible to \code{simple_triplet_matrix}
#'
#' @return A vector of distances with length equal to the number of topics in the fitted model
#'
#' @references {
#'   Jordan Boyd-Graber, David Mimno, and David Newman, 2014.
#'   \emph{Care and Feeding of Topic Models: Problems, Diagnostics, and Improvements.}
#'   CRC Handbooks ofModern Statistical Methods. CRC Press, Boca Raton, Florida.
#' }
#'
#' @importFrom topicmodels distHellinger
#' @importFrom slam col_sums as.simple_triplet_matrix
#'
#' @export
#'
#' @examples
#'
#' # Using the example from the LDA function
#' library(topicmodels)
#' data("AssociatedPress", package = "topicmodels")
#' lda <- LDA(AssociatedPress[1:20,], control = list(alpha = 0.1), k = 2)
#' dist_from_corpus(lda, AssociatedPress[1:20,])

dist_from_corpus <- function(topic_model, dtm_data){
  # Check that the model and dtm contain the same number of documents
  if (!contain_equal_docs(topic_model, dtm_data)) {
    stop("The topic model object and document-term matrix contain an unequal number of documents.")
  }

  UseMethod("dist_from_corpus")
}
#' @export
dist_from_corpus.TopicModel <- function(topic_model, dtm_data){
  # Obtain the beta matrix from the topicmodel object
  beta_mat <- exp(topic_model@beta)

  # Coerce dtm to slam format
  dtm_data <- as.simple_triplet_matrix(dtm_data)

  # Calculate token frequency across all documents
  global_tf_counts <- col_sums(dtm_data, na.rm = TRUE)

  # Get corpus-level probability of each token's occurence
  corpus_dist <- global_tf_counts/sum(global_tf_counts)

  # Using the Hellinger distance, calculate the distance
  # of each topic's token distribution from the corpus distribution
  distHellinger(beta_mat, matrix(corpus_dist, nrow = 1))[,1]
}
