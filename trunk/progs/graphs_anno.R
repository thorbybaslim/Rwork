# graphs_anno.R
#---------------------------------------------------------------------
# R reproducible framework
#----------------------------------------------------------------------
# 
# graphs_anno
#	Graphical annotation support functions
#
#


# gera.etiqueta
#   recebe o nome de uma variavel na tabela de legendas
#   e uma matriz de descricao do banco de dados, 
#   retornando uma etiqueta para ela

gera.etiqueta <- function(x,mat.desc) {
    if (any(row.names(mat.desc) == x) == FALSE) {
        stop(paste('variavel de nome',x,'nao encontrada na matriz de descricoes'))
    }

    if (mat.desc[x,2] == "") {
        cap <- mat.desc[x,1]
    }
    else {
        cap <- eval(parse(text=paste("expression(paste(\"",mat.desc[x,1],"\",' (',",mat.desc[x,2],",')'))",sep='')))
    }
    return(cap)
}




