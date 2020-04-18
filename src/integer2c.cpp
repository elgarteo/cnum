#include <Rcpp.h>
#include <string>
#include <regex>
#include "utils.h"

using namespace Rcpp;

// Function to convert integer to Chinese numeral
// [[Rcpp::export]]
std::string integer2c(const long number_r, const List conv_t)
{
  const std::wstring zero = s2ws(conv_t["zero"]);

  if (number_r == 0)
    return ws2s(zero);

  const DataFrame chr_t = as<DataFrame>(conv_t["chr_t"]);
  const DataFrame scale_t = as<DataFrame>(conv_t["scale_t"]);
  const std::wstring one = subset_df(chr_t, 0);
  const std::wstring ten = subset_df(scale_t, 1);

  const std::string number = std::to_string(number_r);
  const int n = number.size() - 1;
  std::wstring converted;
  int i = 0;
  int scale_n = n;
  int digit;
  NumericVector n_col;
  NumericVector lowers;
  int lower_scale;
  int scale_diff;
  std::string sub_number;
  int sub_number_n;
  std::wstring sub_converted;
  const std::regex zerohead("^0");

  while (i <= n) {
    if (contains(scale_t["n"], scale_n + 1)) {
      // non-recursive
      digit = number[i] - 48;
      if (digit == 0)
        converted += zero;
      else {
        converted += subset_df(chr_t, digit - 1); // respective Chinese numeral of the digit
        converted += subset_df(scale_t, scale_n); // respective Chinese numeral of the scale
      }
      i += 1;
      scale_n -= 1;
    } else {
      // recursive, e.g. process the bracketed digits (100)0000 to form 百萬
      n_col = scale_t["n"];
      lowers = n_col[scale_n > n_col]; // find all lower scales
      lower_scale = max(lowers); // the next lower scale
      scale_diff = scale_n - lower_scale; // difference of current and next lower scale
      sub_number = number.substr(i, scale_diff + 1); // sub-number for recursive_conversion
      sub_number_n = std::stoi(sub_number);
      if (sub_number_n > 0) {
        sub_converted = s2ws(integer2c(sub_number_n, conv_t)); // recursive_conversion
        if ((10 <= sub_number_n) && (sub_number_n <= 19))
          // add one when neccessary, e.g. 一兆零(一)十三億
          sub_converted = one + sub_converted;
        if (std::regex_search(sub_number, zerohead))
          // add zero for scales of digit zero, e.g. 一兆(零)三十三億
          sub_converted = zero + sub_converted;
        converted = (converted + sub_converted) + subset_df(scale_t, lower_scale);
      }
      i = i + scale_diff + 1;
      scale_n = scale_n - scale_diff - 1;
    }
  }
  // correct "一十一" to "十一"
  converted = std::regex_replace(converted, std::wregex((L"^" + one) + ten), ten);
  // remove redundant zeros
  converted = std::regex_replace(converted, std::wregex(zero + L"{2,}"), zero);
  converted = std::regex_replace(converted, std::wregex(zero + L"$"), L"");
  return ws2s(converted);
}

// Function to convert integer to Chinese numeral literally
// [[Rcpp::export]]
std::string integer2c_literal(const long number_r, const List conv_t)
{
  const DataFrame chr_t = as<DataFrame>(conv_t["chr_t"]);
  const std::wstring zero = s2ws(conv_t["zero"]);

  const std::string number = std::to_string(number_r);
  std::wstring converted;
  int digit;
  for (int i = 0; i < number.size(); i++) {
    digit = number[i] - 48;
    if (digit == 0)
      converted += zero;
    else
      converted += subset_df(chr_t, digit - 1); // respective Chinese numeral of the digit
  }
  return ws2s(converted);
}
