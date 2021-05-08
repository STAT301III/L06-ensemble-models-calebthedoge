# Load package(s) ----
library(tidymodels)
library(tidyverse)
library(stacks)

# Handle common conflicts
tidymodels_prefer()

# Load candidate model info ----
load("model_info/knn_res.rda")
load("model_info/svm_res.rda")
load("model_info/lin_reg_res.rda")

# Load split data object & get testing data
load("data/wildfires_split.rda")

wildfires_test <- wildfires_split %>% testing()

# Create data stack ----
wildfires_data_stack <- stacks() %>%
  add_candidates(knn_res)  %>%
  add_candidates(svm_res)  %>%
  add_candidates(lin_reg_res)

#take a  peak
#as_tibble(wildfires_data_stack)

# Fit the stack ----
# penalty values for blending (set penalty argument when blending)
blend_penalty <- c(10^(-6:-1), 0.5, 1, 1.5, 2)

# Blend predictions using penalty defined above (tuning step, set seed)
set.seed(9876)
wildfires_blend <- wildfires_data_stack %>%
  blend_predictions(penalty = blend_penalty)

# Save blended model stack for reproducibility & easy reference (Rmd report)
save(wildfires_blend, file = "model_info/wildfires_blend.rda")

# Explore the blended model stack
wildfires_blend

autoplot(wildfires_blend, type = "weights") +
  theme_minimal( )

# fit to ensemble to entire training set ----


# Save trained ensemble model for reproducibility & easy reference (Rmd report)


# Explore and assess trained ensemble model
