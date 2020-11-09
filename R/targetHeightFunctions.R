data(parentValues)

#' Calculate target height
#'
#' @param sex One of 'male' and 'female'.
#' @param motherHeight Height of the mother in cm.
#' @param fatherHeight Height of the father in cm.
#' @param method The method to be used to calculate the target height.
#'   Possible values are 'Tanner', 'Molinari' and 'Hermanussen'. (defaults to 'Tanner')
#' @param reference The reference to be used to calculate SDS values. (defaults to 'Kromeyer-Hauschild')
#' @return The target height in cm.
#' @examples
#' targetHeight('female', 175, 180, 'Tanner')
targetHeight <- function(sex, motherHeight, fatherHeight, method = 'Tanner', reference = 'Kromeyer-Hauschild') {
  if (missing(sex))          stop("required argument 'sex' is missing")
  if (missing(motherHeight)) stop("required argument 'motherHeight' is missing")
  if (missing(fatherHeight)) stop("required argument 'fatherHeight' is missing")
  if (missing(method))       stop("required argument 'method' is missing")
  if (missing(reference))    stop("required argument 'reference' is missing")
  
  if (!sex %in% c('male', 'female'))
    stop("'sex' must be one of 'male' or 'female'")
  if (!method %in% c('Tanner', 'Molinari', 'Hermanussen'))
    stop("'method' must be one of 'Tanner', 'Molinari' or 'Hermanussen'")
  
  relevantValues <- filter(parentValues, reference == !!reference & measurement == 'height')
  
  if (method == 'Tanner') {
    targetHeight = (motherHeight + fatherHeight) / 2 + ifelse(sex == 'male', 6.5, -6.5)
  } else if (method == 'Molinari') {
    targetHeight = (motherHeight + fatherHeight) / 2 + ifelse(sex == 'male', 10.2, -2.6)
  } else {
    fatherHeightSds <- zscoreFromLms(fatherHeight, filter(relevantValues, sex == 'male'))
    motherHeightSds <- zscoreFromLms(motherHeight, filter(relevantValues, sex == 'female'))
    sds <- (fatherHeightSds + motherHeightSds) / 2 * 0.72
    return(list(height = yFromLms(sds, filter(relevantValues, sex == !!sex)), sds = sds))
  }
  
  return(list(
    height = targetHeight,
    sds    = zscoreFromLms(targetHeight, filter(relevantValues, sex == !!sex))
  ))
}
