# 000-setenv.R
#---------------------------------------------------------------------
# R reproducible framework
#----------------------------------------------------------------------
# 
# 000-setenv
#       Functions to adjust the environment and helper functions
#
#


#   init.setrenv
#	This function is automatically loaded at the end of 000.
#	If force=TRUE it resets all the environment, being mandatory
#	that options()CEA.MACHINE be defined (if figureout=FALSE).
#	If figureout=TRUE, it tries to guess if we are in the right
#	place and do the sensible approach.
#	With force=FALSE it only verifies if .TRUNK and .SANDBOX
#	are defined and represent directories that exist in the
#	file system.
#

init.setrenv <- function(force=TRUE,figureout=TRUE) {

    if (file.exists('../../.rwork_env')) { 
	# this is tricky! if we transverse symbolic links we might get bitten in the arse...
	getwd() -> curr.dir
	setwd('../../')
	proj.path <- getwd()
	setwd(curr.dir)

    	base.paths <- list(default=proj.path)
    	trunk.paths <- list(machineNAME='/caminhao')
 	sandbox.paths <- list(machineNAME='/caixa-de-areia')

    }

    if (force == FALSE) {
        if (any(!exists('.TRUNK'),!exists('.SANDBOX')))
            stop(".TRUNK or .SANDBOX do not exist. Use force=TRUE")                
        if (exists('.TRUNK')) 
            if (file.exists(.TRUNK) == FALSE)
                stop(".TRUNK (",.TRUNK,") points to a non-valid path. Use force=TRUE")
        
        if (exists('.SANDBOX')) 
            if (file.exists(.SANDBOX) == FALSE) 
                stop(".SANBOX (",.SANDBOX,") points to a non-valid path. Use force=TRUE")
        return()
    }
    
   if (figureout == FALSE) {
    if (is.null(options()$CEA.MACHINE))
	stop("options()$CEA.MACHINE not set. Use\n options(CEA.MACHINE = 'string') to set it.")
   }
   else {
	options(CEA.MACHINE = 'default')
   }

    base.caminho <- base.paths[[options()$CEA.MACHINE]]
    if (is.null(base.caminho))
	stop("options()$CEA.MACHINE (",options()$CEA.MACHINE,") doesn't yield a valid path")

    trunk.match <- trunk.paths[[options()$CEA.MACHINE]]
    if (is.null(trunk.match)) 
	trunk.caminho <- paste(base.caminho,'/trunk',sep='')
    else
        trunk.caminho <- paste(base.caminho,trunk.match,sep='')

    if (file.exists(trunk.caminho) == FALSE)
        stop("Trunk path  ",trunk.caminho," does not exist.")

    assign('.TRUNK', trunk.caminho,pos=.GlobalEnv)

    sandbox.match <- sandbox.paths[[options()$CEA.MACHINE]]
    if (is.null(sandbox.match)) 
	sandbox.caminho <- paste(base.caminho,'/sandbox',sep='')
    else
        sandbox.caminho <- paste(base.caminho,sandbox.match,sep='')

    if (file.exists(sandbox.caminho) == FALSE)
        stop("Sandbox path ",sandbox.caminho," does not exist.")

    assign('.SANDBOX', sandbox.caminho,pos=.GlobalEnv)

}

cat("Setting up Rwork environemnt\n")

init.setrenv(options()$CEA.FORCE,options()$CEA.FIGUREOUT)

local({
	ajusta.ambiente.src <- paste(.TRUNK,'/progs/','setenv.R',sep='')
	if (file.exists(ajusta.ambiente.src))
		source(ajusta.ambiente.src)
	else
		stop("\nFile ",ajusta.ambiente.src,"\n\t does not exist")
})


