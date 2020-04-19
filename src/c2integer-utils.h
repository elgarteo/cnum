#include <Rcpp.h>
#include <string>
#include <vector>

// Function to return whether y is an element of x
template <typename T>
bool contains(const Rcpp::CharacterVector x, const T y)
{
  return std::find(x.begin(), x.end(), y) != x.end();
}

// Function to return index of matching element in vector
int subset_chr(const Rcpp::CharacterVector x, const std::string y)
{
  int index = 0;
  for (int i = 0; i < x.size(); ++i) {
    if (x[i] == y) {
      index = i;
      break;
    }
  }
  return index;
}

// Function to return the corresponding chr of df$n given n of df$c
std::string subset_df(const Rcpp::DataFrame df, const std::string c)
{
  const Rcpp::NumericVector n_col = df["n"];
  const Rcpp::CharacterVector c_col = df["c"];
  if (!contains(c_col, c))
    return "";
  const int index = subset_chr(c_col, c);
  const int output = n_col[index];
  return std::to_string(output);
}
