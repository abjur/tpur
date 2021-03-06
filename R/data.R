#' List of available tables and its links.
#'
#' Dataset containing a list of the available tables, its links and
#' columns describing administrative boundaries.
#'
#' @format A data frame with 75 rows and 8 variables
#' \describe{
#'   \item{link}{URL for table download.}
#'   \item{table_type}{Type of table. Available values are "Assuntos","Classes","Movimentos"}
#'   \item{court}{Table's jurisdiction.}
#'   \item{level}{Table's jurisdiction level.}
#'   \item{status}{Status code of a GET requisition.}
#' }
#' @source \url{https://www.cnj.jus.br/sgt/versoes.php}
"control_table"

#' List of UPT's 
#'
#' Dataset containing every downloaded and pre-processed UPT
#' nested in a data_frame column.
#'
#' @format A data frame with 48 rows and 10 variables:
#' \describe{
#'   \item{tpu}{Nested data_frames representing every download UPT.}
#'   \item{file_name}{Mnemonical identifier of the (table_type, court, level) triple.}
#' }
#' @source \url{https://www.cnj.jus.br/sgt/versoes.php}
"table_tpu"