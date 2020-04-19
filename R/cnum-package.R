#' cnum: Working with Chinese Numerals
#'
#' This R package provides useful functions to work with Chinese numerals in R,
#' such as conversion between Chinese numerals and Arabic numerals as well as
#' detection and extraction of Chinese numerals in character objects and string.
#'
#' @section Warnings: The precision of converting large numbers and long
#'   decimals is limited in base R. You might be able to improve the accuracy by
#'   running \code{options(digits = 22)}.
#'
#' @note Due to technical limitation, R package documentation cannot contain
#'   Chinese characters. Therefore, the Chinese characters are represented in
#'   romanized Chinese \emph{pinyin} in the documentation and substituted with
#'   \emph{"hello"} in some of the example code. Visit the GitHub page for
#'   clearer examples with Chinese characters.
#'
#' @author Elgar Teo (\email{elgarteo@@connect.hku.hk})
#'
#' @seealso GitHub page: \url{https://github.com/elgarteo/cnum}
#'
#' @docType package
#' @keywords internal
#' @importFrom stringr str_detect str_extract_all
#' @importFrom Rcpp sourceCpp
#' @useDynLib cnum, .registration = TRUE
#'
"_PACKAGE"
