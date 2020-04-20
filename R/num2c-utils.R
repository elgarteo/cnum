## Function to convert decimal scales to Chinese numeral
decimal2c <- function(number, conv_t) {
  dot <- conv_t[["dot"]]

  number <- format(number, scientific = FALSE)
  number <- gsub(".*\\.", "", number)
  paste0(dot, integer2c_literal(as.numeric(number), conv_t))
}

## Function to convert integer to Chinese numeral with single scale character
integer2c_single <- function(number, conv_t) {
  scale_t <- conv_t[["scale_t"]]

  number <- format(number, scientific = FALSE)
  if (grepl("\\.", number)) {
    int_value <- gsub("\\..*", "", number)
    nearest_scale <- scale_t$n[max(which(scale_t$n <= nchar(int_value)))]
  } else
    nearest_scale <- scale_t$n[max(which(scale_t$n <= nchar(number)))]

  new_number <- as.numeric(number) / 10^(nearest_scale - 1)
  if (new_number %% 1 == 0)
    return(paste0(integer2c(new_number, conv_t), scale_t$c[scale_t$n == nearest_scale]))
  paste0(integer2c(floor(new_number), conv_t),
         decimal2c(new_number %% 1, conv_t),
         scale_t$c[scale_t$n == nearest_scale])
}
