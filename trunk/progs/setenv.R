# setenv.R
#---------------------------------------------------------------------
# R reproducible framework
#----------------------------------------------------------------------
# 
# setenv
#	Functions to adjust the environment and helper functions
#
#


sandbox <- function(x=NULL) {
    if (!is.null(x)) 
        paste(.SANDBOX,'/',x,sep='')
    else
        paste(.SANDBOX,'/',sep='')
}

trunk <- function(x=NULL) {
    if (!is.null(x)) 
            paste(.TRUNK,'/',x,sep='')
    else 
        paste(.TRUNK,'/',sep='')

}  

progs <- function(x=NULL) {
     #FIXME add a pattern matching 
    if (!is.null(x)) {
        if (file.exists(trunk(paste('progs/',x,sep=''))) == FALSE)
            stop("File ",x," not found in trunk/progs")

        cat("\tLoading functions file: ",x,"\n",sep='')
        source(trunk(paste('progs/',x,sep=''))) 
    }
    else
        paste(.TRUNK,'/progs/',sep='')
}


wrap <- function(sub) {
	if ((options()$CEA.subs == sub) | options()$CEA.subs == 'all')
		TRUE
	else
		FALSE

}

#
#   runAnal
#
#	This function run analysis files from their numbers
#
#	Usage:
#		runAnal(1):	loads analysis files that start with 001-
#		runAnal(1:12)	loads analysis from 001 to 012-
#		runAnal(4:3)	loads 003- and 004-, sorting
#		runAnal(4:3,sort= FALSE) 	loads 004 then 003-
#	
#	stop decides if the process is terminated if a specified analysis is
#	not found
#       


runAnal <- function(sources=NULL,sub=NULL,sort=TRUE,stop=TRUE,echo=FALSE) {

    options(CEA.subs=NULL)
	
    if (length(sources) == 0) 
        stop("No analysis file specified")

    if (length(sources) > 1 & missing(sub)) {
	stop("sub does only make sense when running a single file.")
    }

    if (!missing(sub)) {
	sub2run <- deparse(substitute(sub))	
        options(CEA.subs=sub2run)
    }
    else {
	options(CEA.subs='all')

    }



    x <- as.numeric(sources)
   
    if (sort == TRUE)
        x <- sort(x)
    
    x.char <- ifelse(x < 10,paste("00",x,sep=''),ifelse(x < 100,paste("0",x,sep=''),as.character(x)))
    x.char <- paste(x.char,"-",sep='')

    for (i in seq(along=x)) {
        lista <- list.files(trunk('analysis/'),pattern=paste('^',x.char[i],'.*.R$',sep=''))

        if (length(lista) == 0) {
                if (stop == TRUE) 
                    stop("Analsys files not found: ",x.char[i],"\n")
                else 
                    cat("Analysis file not found: ",x.char[i],"\n",sep='')
        }
        else if (length(lista) > 1) {
                if (stop == TRUE) 
                    stop("More than one analysis starting with: ",x.char[i],"\n")
                else
                    cat("More than one analysis file found starting with:",x.char[i],"\n",sep='')

        }
        else {
            cat("\tLoading analysis file",lista)
	    if (!missing(sub)) {
		cat("\t running sub-part ",sub2run," (if existant...)\n")
	    }
	    cat("\n")
            source(trunk(paste('analysis/',lista,sep='')),echo=echo)
        }
    }
}

