## Function to convert a Chinese numeral to integer
c2integer <- function(number, conv_t) {
  chr_t <- conv_t[["chr_t"]]
  scale_t <- conv_t[["scale_t"]]
  zero <- conv_t[["zero"]]

  normal_stack <- 0 # hold values before summing at the end
  scale_stack <- 0 # hold values of premature summing for recursive scaling
  scale_n <- integer() # the scale no. of the char, 0 if not scale
  tmp <- 0 # to hole value of number to be manipulated by scale digit
  for (i in seq_along(number)) {
    digit <- number[i]
    if (digit == zero) {
      # if numeral is zero
      scale_n[i] <- 0
      next
    }
    if (digit %in% chr_t$c) {
      # if numeral is a digit
      digit <- chr_t$n[chr_t$c == digit]
      scale_n[i] <- 0
      tmp <- digit
      next
    }
    if (digit %in% scale_t$c) {
      # if numeral is a scale char
      scale_n[i] <- scale_t$n[scale_t$c == digit]
      digit <- 10^(scale_n[i] - 1)
      if (i == 1) {
        # e.g. 十二
        normal_stack <- c(normal_stack, digit)
        next
      }
      if (scale_n[i - 1]) {
        # if previous numeral is also a scale char, e.g. 一百萬
        scale_stack <- c(scale_stack, sum(normal_stack) * digit)
        normal_stack <- 0
        next
      }
      if (!(scale_n[i] - 1) %in% scale_t$n) {
        # if current scale is a large scale which requires recursive scaling,
        # e.g. 一億 and 一兆
        scale_stack <- c(scale_stack, sum(normal_stack) * digit + tmp * digit)
        normal_stack <- 0
        tmp <- 0
        next
      }
      if (i > 2) {
        j <- max(which(scale_n[-i] != 0)) # index of previous scale
        if (scale_n[max(j)] < scale_n[i]) {
          # if previous scale is smaller than current scale, e.g. 一百二十三萬
          scale_stack <- c(scale_stack, sum(normal_stack) * digit + tmp * digit)
          normal_stack <- 0
          tmp <- 0
          next
        }
      }
      # e.g. 一百二十三
      normal_stack <- c(normal_stack, tmp * digit)
      tmp <- 0
      next
    }
  }
  sum(scale_stack, normal_stack, tmp)
}

## Function to convert a Chinese numeral literally
c2integer_literal <- function(number, conv_t) {
  chr_t <- conv_t[["chr_t"]]
  zero <- conv_t[["zero"]]

  converted <- ""
  for (i in seq_along(number)) {
    digit <- ifelse(number[i] == zero, 0, chr_t$n[chr_t$c == number[i]])
    converted <- paste0(converted, digit)
  }
  converted
}

## Function to convert a Chinese numeral to decimal scale
c2decimal <- function(number, conv_t) {
  dot <- conv_t[["dot"]]

  number <- number[-grep(dot, number)]
  paste0(".", c2integer_literal(number, conv_t))
}

## Function to split up Chinese numerals
split_numeral <- function(number, conv_t, mode) {
  chr_t <- conv_t[["chr_t"]]
  scale_t <- conv_t[["scale_t"]]
  zero <- conv_t[["zero"]]
  neg <- conv_t[["neg"]]
  dot <- conv_t[["dot"]]

  number_split <- unlist(strsplit(number, ""), use.names = FALSE)
  # if multichar scale char exsists, check and re-merge, e.g. 万亿
  is_mchr <- nchar(scale_t$c) > 1
  if (any(is_mchr)) {
    mchr <- scale_t$c[is_mchr]
    for (x in mchr) {
      index <- integer()
      # search through numerals for multichar
      i <- nchar(x) # starting index as length of multichar
      j <- i # hold value
      while (i <= length(number_split)) {
        # merge current and previous char
        merged <- paste0(number_split[(i - j + 1):i], collapse = "")
        if (merged == x) {
          # if found multichar, save starting and ending index numbers
          index <- c(index, i - j + 1, i)
        }
        i <- i + 1
      }
      if (!length(index)) {
        # if mulichar scale char not found
        next
      }
      i <- 1
      tmp <- character()
      while (i <= length(number_split)) {
        # merge multichar scale char while retaining order
        if (i %in% index) {
          # when i == starting index
          j <- index[grep(i, index) + 1] # ending index
          tmp <- c(tmp, paste0(number_split[i:j], collapse = "")) # merge
          i <- j + 1 # skip to element after ending index
        } else {
          tmp <- c(tmp, number_split[i])
          i <- i + 1
        }
      }
      number_split <- tmp
    }
  }
  if (!all(number_split %in% c(chr_t$c, scale_t$c, zero, dot, neg))) {
    msg <- paste0("* `", number_split[!number_split %in% c(chr_t$c, scale_t$c, zero, dot, neg)],
                  "` is not a valid Chinese numeral character\n")
    stop("`x` contains non-Chinese numerals in mode `", mode, "`:\n", msg, call. = FALSE)
  }
  number_split
}
