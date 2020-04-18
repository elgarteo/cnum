#include <Rcpp.h>
#include <string>
#include <codecvt>
#include <locale>

// Function to convert string to wstring
std::wstring s2ws(const std::string& str)
{
  using convert_typeX = std::codecvt_utf8<wchar_t>;
  std::wstring_convert<convert_typeX, wchar_t> converterX;
  return converterX.from_bytes(str);
}

// Function to convert wstring to string
std::string ws2s(const std::wstring& wstr)
{
  using convert_typeX = std::codecvt_utf8<wchar_t>;
  std::wstring_convert<convert_typeX, wchar_t> converterX;
  return converterX.to_bytes(wstr);
}

// Function to return whether y is an element of x
bool contains(const Rcpp::CharacterVector x, const int y)
{
  return std::find(x.begin(), x.end(), y) != x.end();
}

// Function to return index of matching element in vector
int subset_num(const Rcpp::NumericVector x, const int y)
{
  int idx = 0;
  for (int i = 0; i < x.length(); i++) {
    if (x[i] == y + 1) {
      idx = i;
      break;
    }
  }
  return idx;
}

// Function to return the corresponding chr of df$c given n of df$n
std::wstring subset_df(const Rcpp::DataFrame df, const int n) {
  const Rcpp::NumericVector n_col = df["n"];
  const Rcpp::CharacterVector c_col = df["c"];
  const int index = subset_num(n_col, n);
  const std::string output = Rcpp::as<std::string>(c_col[index]);
  return s2ws(output);
}
