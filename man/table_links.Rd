\name{table_links}
\alias{table_links}
\docType{data}
\title{
%%   ~~ data name/kind ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of the dataset. ~~
}
\usage{data("table_links")}
\format{
  A data frame with 75 observations on the following 5 variables.
  \describe{
    \item{\code{table_type}}{a character vector}
    \item{\code{court}}{a factor with levels \code{Justica_do_Trabalho} \code{Justica_Federal} \code{Justica_Estadual} \code{Juizados_Especiais_Fazenda_Publica} \code{Turma_Estadual_Uniformizacao} \code{Justica_Militar_Uniao} \code{Justica_Militar_Estadual} \code{Justica_Eleitoral} \code{STF} \code{STJ} \code{CJF} \code{CNJ}}
    \item{\code{level}}{a factor with levels \code{_1_Grau} \code{_2_Grau} \code{_Juizado_Especial} \code{_Turmas_Recursais} \code{_1grau} \code{_stm} \code{_tjm} \code{_ZE} \code{_TRE} \code{_TSE} \code{}}
    \item{\code{link}}{a character vector}
    \item{\code{status}}{a numeric vector}
  }
}
\details{
%%  ~~ If necessary, more details than the __description__ above ~~
}
\source{
%%  ~~ reference to a publication or URL from which the data were obtained ~~
}
\references{
%%  ~~ possibly secondary sources and usages ~~
}
\examples{
data(table_links)
## maybe str(table_links) ; plot(table_links) ...
}
\keyword{datasets}
