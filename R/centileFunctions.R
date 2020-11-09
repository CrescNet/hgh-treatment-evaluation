zscoreFromLms <- function(y, lms) {
  req(y, lms)
  
  if (abs(lms$l) < 0.00001) {
    return(log(y / lms$m) / lms$s)
  } else {
    return(((y / lms$m) ^ lms$l - 1) / (lms$l * lms$s))
  }
}

yFromLms <- function(zscore, lms) {
  if (abs(lms$l) < 0.00001) {
    return(exp(zscore * lms$s) * lms$m)
  } else {
    return((zscore * lms$l * lms$s + 1) ^ (1 / lms$l) * lms$m)
  }
}
