#' Chinese Numerals Detection and Extraction
#'
#' Functions to detect and extract Chinese numerals in character object and
#' string.
#'
#' @param x the character object or string to be tested or to extract from.
#'
#' @param strict logcial: Should the Chinese numerals format be strictly
#'   enforced? A casual test only checks if \code{x} contains Chinese numerals
#'   characters. A strict test checks if \code{x} is valid Chinese numerals.
#'   (e.g. "\emph{yi bai yi}" will pass the casual test and fail the strcit
#'   test)
#'
#' @param ... optional arguments to be passed to \code{\link[base]{grepl}} (for
#'   \code{is_cnum} and \code{has_cnum}) or
#'   \code{\link[stringr]{str_extract_all}} (for \code{extract_cnum}).
#'   Disregarded when \code{strict = TRUE}.
#'
#' @inheritParams conversion
#'
#' @return \code{is_cnum} and \code{has_cnum} return a logical vector
#'   (is/contains Chinese numerals or not for each element of \code{x}).
#'
#'   \code{extract_cnum} returns a character vector.
#'
#' @inheritSection conversion Details
#'
#' @seealso \link[=conversion]{Functions for conversion}
#'
#' @name tools
#'
NULL

#' @describeIn tools Test if character object is Chinese numerals
#'
#' @examples
#' is_cnum("hello")
#'
#' @export
#'
is_cnum <- function(x, lang = "tc", mode = "casual", financial = FALSE,
                    literal = FALSE, strict = FALSE, ...) {
  if (strict) {
    if (length(x) > 1) {
      return(sapply(x, function(y)
        is_cnum(y, lang, mode, financial, literal, strict)))
    }
    tryCatch(
      error = function(cnd) {
        FALSE
      },
      if (c2num(x, lang, mode, financial, literal)) {
        TRUE
      })
  } else {
    grepl(return_regex(lang, mode, financial, TRUE), x, ...)
  }
}

#' @describeIn tools Test if string contains Chinese numerals
#'
#' @examples
#' has_cnum("hello")
#'
#' @export
#'
has_cnum <- function(x, lang = "tc", mode = "casual", financial = FALSE, ...) {
  if (length(x) > 1) {
    return(sapply(x, function(y) has_cnum(y, lang, mode, financial)))
  }
  grepl(return_regex(lang, mode, financial, FALSE), x, ...)
}

#' @describeIn tools Extract Chinese numerals from string
#'
#' @examples
#' extract_cnum("hello")
#'
#' @export
#'
extract_cnum <- function(x, lang = "tc", mode = "casual", financial = FALSE, ...) {
  stringr::str_extract_all(x, return_regex(lang, mode, financial, FALSE), ...)
}
