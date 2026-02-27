# turf

TURF (Total Unduplicated Reach and Frequency) analysis for R.

## Installation

```r
# install.packages("devtools")
devtools::install_github("resondex/turf")
```

## Example

```r
library(turf)

# Run TURF analysis
turf_results <- turf_best_combo(
  df        = example_data_ice_cream,
  vars      = example_data_ice_cream_dictionary$variable,
  n         = 1:5,
  subgroups = c("Total", "Gen_Z", "Millennials", "Gen_X"),
  labels    = example_data_ice_cream_dictionary,
  weight    = "weight"
)

# Write results to Excel workbook
turf_write(
  best_combo_results = turf_results,
  raw                = example_data_ice_cream,
  vars               = example_data_ice_cream_dictionary$variable,
  subgroups          = c("Total", "Gen_Z", "Millennials", "Gen_X"),
  weight             = "weight",
  labels             = example_data_ice_cream_dictionary,
  top                = 1000,
  file_name          = "example_ice_cream_turf",
  project_name       = "Ice Cream Study (#1234567)"
)
```
