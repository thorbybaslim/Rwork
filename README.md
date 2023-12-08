# Rwork
R scripts for reproducible analysis

Testing commit


## Environment setup

1. Step (1) Remember to edit ou append your .Rprofile with the following:

```R
	setrenv <- function()
        	source('../../trunk/analysis/000-setenv.R')
```

2. Step (2) Then clone this repo into a working dir inside a git-versioned repo:

```bash
	gh repo clone thorbybaslim/Rwork && rm -rf Rwork/.git 

```
```fish
	gh repo clone thorbybaslim/Rwork; and rm -rf Rwork/.git 
```


3. Step (3) Walk into Rwork,r-work, create a 001 (002, 003, 00n, whatever) folder cwd into R
	start R from it, and then 
```
	setrenv()
```

4. Step (4) PROFIT!


