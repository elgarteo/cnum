## Function to convert integer to Chinese numeral
integer2c <- function(number, conv_t) {
  chr_t <- conv_t[["chr_t"]]
  scale_t <- conv_t[["scale_t"]]
  zero <- conv_t[["zero"]]
  one <- chr_t$c[chr_t$n == 1]
  ten <- scale_t$c[scale_t$n == 2]

  if (number == 0) return(zero)

  number <- format(number, scientific = FALSE)
  n <- nchar(number)
  converted <- ""
  i <- 1
  scale_n <- n
  while (i <= n) {
    if (scale_n %in% scale_t$n) {
      # non-recursive
      digit <- as.numeric(substr(number, i, i))
      if (digit == "0") {
        converted <- paste0(converted, zero)
      } else {
        chr <- chr_t$c[chr_t$n == digit] # respective Chinese numeral of the digit
        converted <- paste0(converted, chr, scale_t$c[scale_t$n == scale_n])
      }
      i <- i + 1
      scale_n <- scale_n - 1
    } else {
      # recursive, e.g. process the bracketed digits (100)0000 to form 百萬
      lower_scale <- scale_t$n[max(which(scale_n > scale_t$n))] # locate the next lower scale
      scale_diff <- scale_n - lower_scale # scale difference of current and next lower scale
      sub_number <- substr((number), i, (i + scale_diff)) # sub-number for recursive conversion
      if (as.numeric(sub_number)) {
        sub_converted <- integer2c(as.numeric(sub_number), conv_t) # converted sub-number
        if (as.numeric(sub_number) %in% 10:19) {
          # add one when neccessary, e.g. 一兆零(一)十三億
          sub_converted <- paste0(one, sub_converted)
        }
        if (grepl("^0", sub_number)) {
          # add zero for scales of digit zero, e.g. 一兆(零)三十三億
          sub_converted <- paste0(zero, sub_converted)
        }
        converted <- paste0(converted, sub_converted, scale_t$c[scale_t$n == lower_scale])
      }
      i <- i + scale_diff + 1
      scale_n <- scale_n - scale_diff - 1
    }
  }
  # correct "一十一" to "十一"
  converted <- gsub(paste0("^", one, ten), ten, converted)
  # remove redundant zeros
  converted <- gsub(paste0(zero, "{2,}"), zero, converted)
  converted <- gsub(paste0(zero, "$"), "", converted)
  converted
}

## Function to convert integer to Chinese numeral literally
integer2c_literal <- function(number, conv_t) {
  chr_t <- conv_t[["chr_t"]]
  zero <- conv_t[["zero"]]

  converted <- ""
  for (i in 1:nchar(number)) {
    digit <- as.numeric(substr(number, i, i))
    chr <- ifelse(digit == "0", zero, chr_t$c[chr_t$n == digit])
    converted <- paste0(converted, chr)
  }
  converted
}

## Function to convert decimal scales to Chinese numeral
decimal2c <- function(number, conv_t) {
  dot <- conv_t[["dot"]]

  number <- format(number, scientific = FALSE)
  number <- gsub(".*\\.", "", number)
  paste0(dot, integer2c_literal(number, conv_t))
}

## Function to convert integer to Chinese numeral with single scale character
integer2c_single <- function(number, conv_t) {
  scale_t <- conv_t[["scale_t"]]

  number <- format(number, scientific = FALSE)
  if (grepl("\\.", number)) {
    int_value <- gsub("\\..*", "", number)
    nearest_scale <- scale_t$n[max(which(scale_t$n <= nchar(int_value)))]
  } else {
    nearest_scale <- scale_t$n[max(which(scale_t$n <= nchar(number)))]
  }
  new_number <- as.numeric(number) / 10^(nearest_scale - 1)
  if (new_number %% 1 == 0) {
    paste0(integer2c(new_number, conv_t),
           scale_t$c[scale_t$n == nearest_scale])
  } else {
    paste0(integer2c(floor(new_number), conv_t),
           decimal2c(new_number %% 1, conv_t),
           scale_t$c[scale_t$n == nearest_scale])
  }
}
