
*=============================================================================
* HDPS graphics
* 
* *! version 1.0.0 1djan2021 JT
* History 
*=============================================================================

capture program drop hdps_graphics
program define hdps_graphics, rclass
version 15 
syntax varlist(min = 2) [if] , type(string) [DIMension(varname) pr(numlist max=1)]  *

	
tempvar touse 
	mark `touse' `if' `in'
	
* Check if type option specified
if "`type'"=="" {
	di as error "Syntax: type not specified. Options are 'prevalence', 'bross' or 'strength'."
    exit 198
}     

if "`type'"!="prevalence" & "`pr'"!= "" {
di as error "Syntax: the pr option can only be specified when 'prevalence' type specified." 
    exit 198

}
if "`type'"!="bross" & "`type'"!="prevalence"  & "`type'"!="strength" {
	di as error "Syntax: invalid type specified. Options are 'prevalence', 'bross' or 'strength'."
    exit 198
}     
if "`type'"=="bross" & "`dimension'"!=""  {
	di as error "Syntax: dimension option can not be specified for 'bross' type"
    exit 198
}     

if "`type'"=="prevalence" & "`dimension'"==""  {
	di as error "Syntax: dimension option needs to be specified"
    exit 198
}    

if "`type'"=="strength" & "`dimension'"==""  {
	di as error "Syntax: dimension option needs to be specified"
    exit 198
}    
* sort graph options
_get_gropts , graphopts(`options') 
	local options `"`s(graphopts)'"'


* Manipulate variables 
	// identify the row and column vars individually
tokenize `varlist'
local yvar `1' 
local xvar `2'
	if "`yvar'" == "`xvar'" {
		di as err "Same variable specified twice"
		exit 198
	}


if "`type'"=="bross" {
qui count if `touse' 
local xtick = `r(N)' // can add tick for xaxis
#delimit ;
 twoway (line `yvar' `xvar' if `touse') ,
	ytitle("|log(bias)|" )  
	xtitle("Rank of empirically selected covariate" )
	xlabel(0(100)`xtick', labsize(medsmall) angle(horizontal)) 
	`options'
	
	;
#delimit cr
}

if "`type'" == "prevalence" {

	if "`pr'"== "" {
	local pr_plot  2
	}
	else {
	local pr_plot `pr'
	}



qui summ `yvar' if `touse' 

local y_fun_max = round(`r(max)', 0.2)
local y_round_max = round(`r(max)', 0.2)


qui summ `xvar' if `touse' 

local xmax = `r(max)'
local x_round_max = round(`r(max)', 0.2)
local x_fun_max = round(`r(max)',0.2)/`pr_plot'

qui levelsof `dimension' , local(dims) 

local i = 1
foreach d of local dims {

local graph`i' "(scatter `yvar' `xvar' if `dimension' == `d' & `touse', msize(small) mcolor(%50)) "

local ++i
}

forvalues j = 1/`i' {
local graph = "`graph'" + "`graph`j''"

}

#delimit ;
 twoway `graph' 
		   (function y= x/`pr_plot', lcol(black*0.8) clpat(dash) range(0 `y_fun_max'))  
		   (function y=`pr_plot'*x, lcol(black*0.8) clpat(dash)  range(0 `x_fun_max')) 
		  (function y=x, lcol(black*0.8) range(0 `y_fun_max'))
				  ,
	ylabel(,angle(horizontal))
	ylabel(0(0.2)`y_fun_max', labsize(medsmall) angle(horizontal))  
	xlabel(0(0.2)`xmax', labsize(medsmall) angle(horizontal)) 
	ytitle("Prevalence in `yvar'" )  
	xtitle("Prevalence in `xvar'" ) 
	yscale(range(0 `y_round_max'))
	xscale(range(0 `x_round_max'))
									
		   
	`options'
	;

#delimit cr
}


if "`type'"=="strength" {
qui summ `yvar' if `touse'
local ymax = round(`r(max)', 1.0)

qui summ `xvar' if `touse'
local xmax = round(`r(max)', 1.0)

qui levelsof `dimension' , local(dims) 
local i = 1
foreach d of local dims {

local graph`i' "(scatter `yvar' `xvar' if `dimension' == `d'  & `touse' , msize(small) mcolor(%50)) "
local ++i
}

forvalues j = 1/`i' {
local graph = "`graph'" + "`graph`j''"

}
 #delimit ;
 twoway `graph', 
		 
	ytitle("`yvar' association" )  
	ylabel(0(0.5)`ymax', labsize(medsmall) angle(horizontal))  
	xtitle("`xvar' association" ) 
	xlabel(0(0.5)`xmax', labsize(medsmall) angle(horizontal))  	 

	 
	 `options'
	;
#delimit cr
}

end
