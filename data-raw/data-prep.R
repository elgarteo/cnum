### Variables naming format
### * [numeral characters]: chr_<lang>
### * [scale characters]: scale_<mode>_<lang>
### * [mode scale intervals]: interval_<mode>
### * add suffix _f for financial numerals characters
###
## Chinese numerals characters
# Normal
chr_tc <- c("一", "二", "三", "四", "五", "六", "七", "八", "九")
chr_sc <- chr_tc
# Financial
chr_tc_f <- c("壹", "貳", "參", "肆", "伍", "陸", "柒", "捌", "玖")
chr_sc_f <- c("壹", "贰", "叁", "肆", "伍", "陆", "柒", "捌", "玖")

## Chinese numerals scale characters
# Casual
scale_casual_tc <- c("", "十", "百", "千", "萬", "億", "兆", "京")
scale_casual_sc <- c("", "十", "百", "千", "万", "亿", "兆", "京")
# Casual Financial
scale_casual_tc_f <- c("", "拾", "佰", "仟", "萬", "億", "兆", "京")
scale_casual_sc_f <- scale_casual_tc_f

# CasualPRC
scale_casualPRC_tc <- c("", "十", "百", "千", "萬", "億", "萬億", "京")
scale_casualPRC_sc <- c("", "十", "百", "千", "万", "亿", "万亿", "京")
# CasualPRCFinancial
scale_casualPRC_tc_f <- c("", "拾", "佰", "仟", "萬", "億", "萬億", "京")
scale_casualPRC_sc_f <- scale_casualPRC_tc_f

# SIprefix
scale_SIprefix_tc <- c("", "十", "百", "千", "百萬", "吉", "兆", "拍")
scale_SIprefix_sc <- c("", "十", "百", "千", "百万", "吉", "兆", "拍")
# SIprefix Financial
scale_SIprefix_tc_f <- scale_SIprefix_tc
scale_SIprefix_sc_f <- scale_SIprefix_sc

# SIprefixPRC
scale_SIprefixPRC_tc <- c("", "十", "百", "千", "兆", "吉", "太", "拍")
scale_SIprefixPRC_sc <- scale_SIprefixPRC_tc
# SIprefixPRC Financial
scale_SIprefixPRC_tc_f <- scale_SIprefixPRC_tc
scale_SIprefixPRC_sc_f <- scale_SIprefixPRC_sc

# SIprefixPRClong
scale_SIprefixPRClong_tc <- c("", "十", "百", "千", "兆", "吉咖", "太拉", "拍它")
scale_SIprefixPRClong_sc <- scale_SIprefixPRClong_tc
# SIprefixPRClong Financial
scale_SIprefixPRClong_tc_f <- scale_SIprefixPRClong_tc
scale_SIprefixPRClong_sc_f <- scale_SIprefixPRClong_sc

## Mode scale intervals
# Casual
interval_casual <- c(1:5, 9, 13, 17)
# CasualPRC
interval_casualPRC <- interval_casual
# SIprefix
interval_SIprefix <- c(1:4, 7, 10, 13, 16)
# SIprefixPRC
interval_SIprefixPRC <- interval_SIprefix
# SIprefixPRC
interval_SIprefixPRClong <- interval_SIprefixPRC

## Special numerals characters
# Decimal seperator
dot_tc <- "點"
dot_sc <- "点"
# Zero
zero_tc <- "零"
zero_sc <- zero_tc
# Negative
neg_tc <- "負"
neg_sc <- "负"

usethis::use_data(chr_tc, chr_sc, chr_tc_f, chr_sc_f,
                  scale_casual_tc, scale_casual_sc,
                  scale_casual_tc_f, scale_casual_sc_f,
                  scale_casualPRC_tc, scale_casualPRC_sc,
                  scale_casualPRC_tc_f, scale_casualPRC_sc_f,
                  scale_SIprefix_tc, scale_SIprefix_sc,
                  scale_SIprefix_tc_f, scale_SIprefix_sc_f,
                  scale_SIprefixPRC_tc, scale_SIprefixPRC_sc,
                  scale_SIprefixPRC_tc_f, scale_SIprefixPRC_sc_f,
                  scale_SIprefixPRClong_tc, scale_SIprefixPRClong_sc,
                  scale_SIprefixPRClong_tc_f, scale_SIprefixPRClong_sc_f,
                  interval_casual, interval_casualPRC, interval_SIprefix,
                  interval_SIprefixPRC, interval_SIprefixPRClong,
                  dot_tc, dot_sc, zero_tc, zero_sc, neg_tc, neg_sc,
                  internal = TRUE, overwrite = TRUE)
