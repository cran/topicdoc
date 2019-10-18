## ---- include = FALSE----------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----example_setup-------------------------------------------------------
library(topicdoc)
library(topicmodels)

data("AssociatedPress")

lda_ap4 <- LDA(AssociatedPress,
               control = list(seed = 33), k = 4)

# See the top 10 terms associated with each of the topics
terms(lda_ap4, 10)

## ----all_at_once---------------------------------------------------------
topic_diagnostics(lda_ap4, AssociatedPress)

## ----one_at_a_time-------------------------------------------------------
topic_size(lda_ap4)
mean_token_length(lda_ap4)

