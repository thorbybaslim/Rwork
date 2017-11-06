# 001-demo.R
#---------------------------------------------------------------------
# R reproducible framework
#----------------------------------------------------------------------
# 
# 00x-xxxx
#	Brief description of what this file does       
#
#

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
