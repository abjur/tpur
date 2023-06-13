#' Links de todas as TPUs
#'
#' Uma base de dados com todos os links de todas as TPUs, extraídos diretamente 
#' do site do Conselho Nacional de Justiça (CNJ) do Sistema de Gestão Processual (SGT).
#'
#' @format Data frame:
#' \describe{
#'  \item{id}{Código de identificação único da TPU}
#'  \item{atual}{Variável lógica se a TPU é atual ou não}
#'  \item{tipo}{Tipo de conteúdo da TPU (Assuntos, Classes ou Movimentos)}
#'  \item{tipo_abbr}{Abreviação do tipo de conteúdo da TPU (A, C ou M)}
#'  \item{data_versa}{Data da versão da TPU}
#'  \item{justica}{Justiça a que se refere a TPU}
#'  \item{tabela}{Ramificação da Justiça}
#'  \item{link}{Link da TPU}
#'  }
"sgt"

#' Links do releases para as TPUs de assuntos
#'
#' Uma base de resumo para os links do releases
#' 
#' @format Data frame:
#' \describe{
#'  \item{file}{Nome do arquivo que está no releases}
#'  \item{dt_inic}{Data de início do período de validade para a TPU}
#'  \item{dt_fim}{Data de fim do período de validade para a TPU}
#'  \item{release}{Link para a base .csv no releases}
#'  }
"assuntos"

#' Links do releases para as TPUs de classes
#'
#' Uma base de resumo para os links do releases
#' 
#' @format Data frame:
#' \describe{
#'  \item{file}{Nome do arquivo que está no releases}
#'  \item{dt_inic}{Data de início do período de validade para a TPU}
#'  \item{dt_fim}{Data de fim do período de validade para a TPU}
#'  \item{release}{Link para a base .csv no releases}
#'  }
"classes"