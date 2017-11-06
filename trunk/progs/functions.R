connect.dwh <- function() {
    require(RMySQL)
        con <- dbConnect(MySQL(),
            user = options()$CEA.DBUSER,
            password = options()$CEA.DBPASS,
            host = options()$CEA.DBHOST,
            port = options()$CEA.DBPORT,
            dbname='wkda')
        con
}


connect.dwh2 <- function() {
    require(RMySQL)
        con <- dbConnect(MySQL(),
            user = options()$CEA.DBUSER,
            password = options()$CEA.DBPASS,
            host = options()$CEA.DBHOST,
            port = options()$CEA.DBPORT,
            dbname='dwh_ds2')
        con
}


