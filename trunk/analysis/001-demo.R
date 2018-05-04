# 001-demo.R
#---------------------------------------------------------------------
# R reproducible framework
#----------------------------------------------------------------------
# 
# 00x-xxxx
#	Brief description of what this file does       
#
#

require(knitr)
require(crayon)
require(colorout)
cat("\t",cyan("***"),yellow("Loading Headers"),cyan("***"),"\n",sep='')
progs('dbsetup.R')
cat("\t",cyan("***"),yellow("Headers Loaded"),cyan("***"),"\n",sep='')

if (wrap('setup')) {
        con <- connect.dwh()
}


print("Header.. always runs")

if (wrap('A')) {
	#Do this part only if we run runAnal(1,A)
	print("part A ran.")



}

if (wrap('B')) {
	#Etc...
	print("part B ran.")

}

print("end")
