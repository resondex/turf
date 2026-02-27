# Internal utility functions (replacements for work:: dependencies)


#' Convert a named character vector to a dictionary data frame
#' @param x A named character vector where names are variable names and values
#'   are labels.
#' @return A tibble with columns \code{variable} and \code{label}.
#' @keywords internal
.turf_dictionary_from_named <- function(x) {
  if (is.null(x)) return(NULL)

  if (is.data.frame(x) || tibble::is_tibble(x)) {
    return(x)
  }

  if (is.list(x) && !tibble::is_tibble(x)) {
    x <- purrr::map_chr(x, c)
  }

  if (is.character(x)) {
    if (is.null(names(x))) {
      names(x) <- x
    }
    return(tibble::tibble(variable = names(x), label = unname(x)))
  }

  x
}


#' Set a parallel future plan with automatic worker handling
#' @param strategy Character; one of "multisession", "multicore", "sequential".
#' @param workers Optional integer; number of workers.
#' @keywords internal
.turf_future_plan <- function(
    strategy = c("multisession", "multicore", "sequential"),
    workers = NULL
) {
  if (!requireNamespace("future", quietly = TRUE)) {
    stop("Package 'future' is required for parallel TURF. Install it with install.packages('future').")
  }
  if (!requireNamespace("furrr", quietly = TRUE)) {
    stop("Package 'furrr' is required for parallel TURF. Install it with install.packages('furrr').")
  }

  strategy <- match.arg(strategy)

  if (strategy == "multicore" && !future::supportsMulticore()) {
    strategy <- "multisession"
  }

  strategy_fun <- switch(
    strategy,
    sequential   = future::sequential,
    multisession = future::multisession,
    multicore    = future::multicore
  )

  if (is.null(workers)) {
    workers <- future::availableCores(omit = 1)
  }

  workers <- min(workers, future::availableCores(omit = 1))

  if (strategy == "sequential") {
    invisible(future::plan(strategy_fun))
  } else {
    invisible(future::plan(strategy_fun, workers = workers))
  }
}
