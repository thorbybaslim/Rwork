# 001-demo.R
#---------------------------------------------------------------------
# R reproducible framework
#----------------------------------------------------------------------
# 
# 00x-xxxx
#	Brief description of what this file does       
#
#
# Start with this car -> 496790933
# stock_number: BB58894
# https://admin.wkda.de/car/detail/496790933
#
#

progs('functions.R')

if (wrap('setup')) {
		        #Do this part only if we run runAnal(1,setup)
		        con <- connect.dwh()
				con2 <- connect.dwh2()
}

if (wrap('prepare')) {
# select car_id from car_evaluations_auto_pricing where model_id = '0.0.3' AND model_name = 'kind' AND created_on > '2017-10-17' limit 2;
#   504306433
#	496790933
# INSERT INTO dwh_ds2.babyset SELECT car_id AS id from car_evaluations_auto_pricing where model_name = 'kind' AND created_on > '2017-10-17'
# CREATE TABLE dwh_ds2.babyset SELECT car_id AS id from wkda.car_evaluations_auto_pricing where model_name = 'kind' AND created_on > '2017-10-17'

		baby <- data.frame(id=as.integer(c(504306433,496790933)))
		baby <- data.frame(id=as.integer(c(435026563)))
		dbWriteTable(con2,'babyset2',baby,row.names=FALSE)

}

if (wrap('query')) {

STD <- dbGetQuery(con,' SELECT DISTINCT
					  cl.id,
					  ctdr.question_id
				FROM
					  dwh_ds2.babyset cl 
 		  			LEFT JOIN wkda.car_test_drives ctd ON ctd.car_id = cl.id
				    LEFT JOIN wkda.car_test_drives ctd1 ON ctd1.car_id = cl.id and ctd1.id > ctd.id
					LEFT JOIN wkda.car_test_drive_results ctdr ON ctdr.car_test_drive_id = ctd.id
				WHERE      
					1
				  ')
STD$id <- as.integer(STD$id)

}

if (wrap('predmp')) {

predmp <- dbGetQuery(con,' SELECT
					 	b.id,
						ceap.prediction,
						ceap.error_level,
						ccp.amount/100 AS manualprice
						FROM
							dwh_ds2.babyset AS b
						LEFT JOIN wkda.car_evaluations_auto_pricing AS ceap ON b.id = ceap.car_id
						LEFT JOIN wkda.car_current_prices AS ccp ON ccp.car_id = ceap.car_id AND ccp.type = "auto1_original_price" ')

predmp$id <- as.integer(predmp$id)
}
if (wrap('treatover')) {
	predmp$over <- predmp$prediction - predmp$manualprice
	op <- subset(predmp,prediction > manualprice)
	op$overm <- ifelse(op$overpct > 2 | op$over > 1000,1,0)

}

if (wrap('treatSTD')) {
	STD <- subset(STD,!is.na(question_id))

	# First filter for only those ids in op
	STD[STD$id %in% op$id,] -> STDm
	STDm$value <- 1
	STDv <- cast(STDm, id ~ question_id,sum)
	names(STDv)[2:113] <- paste('Q',names(STDv)[2:113],sep='')

	 STD$value <- 1
     fSTDv <- cast(STD, id ~ question_id,sum)
     names(fSTDv)[2:113] <- paste('Q',names(fSTDv)[2:113],sep='')

}

if (wrap('merge')) {
	m <- merge(STDv,op,by='id',all.x=TRUE,all.y=FALSE)

	table(m$overm , m$Q10)
	res.names <- NULL
	res.pvalues <- NULL
	res.odds <- NULL

	for(q in names(STDv)[2:113]) {
		qtab <- table(m$overm, m[,q])
		qpval <- fisher.test(qtab)$p.value
		odds <- fisher.test(qtab)$estimate
		res.names <- c(q,res.names)
		res.pvalues <- c(qpval,res.pvalues)
		res.odds <- c(odds,res.odds)
	}
	res <- data.frame(res.names,res.pvalues,res.odds)
    res$pval <- as.numeric(sprintf("%5.4f",res$res.pvalues) )

	m$combined <- ifelse(m$Q1090 + m$Q1020 + m$Q210 +  m$Q90 + m$Q170 + m$Q230 + m$Q730 + m$Q1110 + m$Q1030 + m$Q1070 + m$Q141 +  m$Q271 + m$Q120 + m$Q190 + m$Q1100 > 0,1,0)
	fisher.test(xtabs( ~ combined + overm, data = m))


	m2 <- merge(fSTDv,predmp,by='id',all.x=TRUE,all.y=FALSE)
    m2$combined <- ifelse(m2$Q1090 + m2$Q1020 + m2$Q210 +  m2$Q90 + m2$Q170 + m2$Q230 + m2$Q730 + m2$Q1110 + m2$Q1030 + m2$Q1070 + m2$Q141 +  m2$Q271 + m2$Q120 + m2$Q190 + m2$Q1100 > 0,1,0)

	

}
