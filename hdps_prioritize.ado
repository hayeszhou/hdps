*=============================================================================
*HDPS prioritize
* 
* *! version 1.0.0 1feb2021 JT
* History 
*=============================================================================
capture program drop hdps_prioritize 

program define hdps_prioritize , eclass
version 15 
syntax , method(string) top(numlist >0 integer) [zerocell] 

if "`e(hdpsSetup_____)'"  != "1" {
di as error "Data dimensions have not been declared using {stata hdps setup}"
    exit 498
}

if "`e(hdpsPrev_____)'"  != "1" {
di as error "Feature prevalence has not been assesed using {stata hdps prevalence}"
    exit 498

}

if "`e(hdpsRecc_____)'"  != "1" {
di as error "HDPS covariates have not been generated using {stata hdps recurrence}"
    exit 498

}

* Check if exposure option specified
if "`method'"=="" {
	di as error "Syntax: method not specified. Options are 'bross' or 'exposure'."
    exit 198
}     

if "`method'"!="bross" & "`method'"!="exposure" {
	di as error "Syntax: Invalid prioritization method. Options are 'bross' or 'exposure'."
    exit 198
}     

* Covariates to be selected
if "`top'"=="" {
di as error "Syntax: Specify number(s) of covariates to be selected."
    exit 498
}   

noi di as text ""
noi di as text "Ranking HDPS covariates:"

if "`method'"=="bross" {
noi di as result "Prioritizing using the Bross formula:"
}     

if "`method'"=="exposure" {
noi di as result "Prioritizing using exposure-based approach"
}   

* Load data
qui use "`e(save__)'/`e(study__)'_hdps_covariates", replace

quietly {

local patid `e(patid__)'
local exposure `e(exp__)'
local outcome `e(out__)'

qui ds `patid' `exposure' `outcome', not

tempname bias_1 
postfile `bias_1' str30(code) e1 e0 c1 c0 e1c1 e0c1 e1c0 e0c0 d1c1 d1c0 d0c1 d0c0 using "`e(save__)'/`e(study__)'_bias_info.dta", replace

* Loop through features to generate hd-PS covariates

local a = 1
local last_perc = 0
noi di as result "Progress: " _cont

qui local count_values: word count `r(varlist)'

foreach v of varlist `r(varlist)' {
   
   count if `v'==1
   local c1=`r(N)'
   
   count if `v'==0
   local c0=`r(N)'
   
   count if `exposure'==1
   local e1=`r(N)' 
   
   count if `exposure'==0
   local e0=`r(N)' 
   
   count if `exposure'==1 & `v'==1
   local e1c1=`r(N)'
   
   count if `exposure'==0 & `v'==1
   local e0c1=`r(N)'
   
    count if `exposure'==1 & `v'==0
   local e1c0=`r(N)'
   
   count if `exposure'==0 & `v'==0
   local e0c0=`r(N)'

   count if `outcome'==1 & `v'==1
   local d1c1=`r(N)'

   count if `outcome'==1 & `v'==0
   local d1c0=`r(N)'
   
   count if `outcome'==0 & `v'==1
   local d0c1=`r(N)'

   count if `outcome'==0 & `v'==0
   local d0c0=`r(N)'
   
	post `bias_1' ("`v'") (`e1') (`e0') (`c1') (`c0')  (`e1c1') (`e0c1') (`e1c0') (`e0c0') (`d1c1') (`d1c0') (`d0c1') (`d0c0')
		
* Counting loop

local percent_comp = round(100*`a'/`count_values',1.0)
if `a' == 1 {
noi di as result "0%" _cont
}
if `percent_comp' >= 20 & `last_perc' <20 {
noi di as result "...20%" _cont
}

if `percent_comp' >= 40 & `last_perc' <40 {
noi di as result "...40%" _cont
}

if `percent_comp' >= 60 & `last_perc' <60 {
noi di as result "...60%" _cont
}

if `percent_comp' >= 80 & `last_perc' <80 {
noi di as result "...80%" _cont
}

if `percent_comp' == 100 & `last_perc' !=100  {
noi di as result "...Completed" _cont
}

local last_perc = `percent_comp'
local ++a
}		
	}

postclose `bias_1'                
use "`e(save__)'/`e(study__)'_bias_info.dta", replace

* Zero cell corrections
if "`zerocell'"!="" {
qui replace d1c1 = d1c1 + 0.1 if d1c1 ==0
qui replace d1c0 = d1c0 + 0.1 if d1c0 ==0
qui replace d0c1 = d0c1 + 0.1 if d0c1 ==0
qui replace d0c0 = d0c0 + 0.1 if d0c0 ==0

qui replace e1c1 = e1c1 + 0.1 if e1c1 ==0
qui replace e1c0 = e1c0 + 0.1 if e1c0 ==0
qui replace e0c1 = e0c1 + 0.1 if e0c1 ==0
qui replace e0c0 = e0c0 + 0.1 if e0c0 ==0
}

* calculate measures
gen pc1=e1c1/e1
gen pc0=e0c1/e0
gen rr_ce=pc1/pc0
qui replace rr_ce=. if rr_ce==0
gen rr_cd=(d1c1/c1)/(d1c0/c0)

gen bias=(pc1*(rr_cd-1)+1)/(pc0*(rr_cd-1)+1)
gen abs_log_bias=abs(log(bias))

* Rank by Bross Formula or Exposure-Confounder association
if "`method'"=="exposure" {
gsort- rr_ce
}
else {
gsort- abs_log_bias
} 

gen rank=_n
gen ce_strength=abs(rr_ce-1)
gen cd_strength=abs(rr_cd-1)

label data "`e(study__)' study bias information"
qui save "`e(save__)'/`e(study__)'_bias_info.dta", replace

* Select covariates based on top numlist
noi di as text _new ""
noi di as text "Forming hd-PS cohort(s) based on top ranked covariates:"
noi di as result "Selecting: " _cont
qui local num_vars: word count `top'
local b = 0 
local d = 1
foreach v of local top {
	preserve
	if `d' != `num_vars' {
	noi di as result "`v', " _cont
	}
	if `d' == `num_vars' & `d' == 1 {
	noi di as result "`v' " _cont
	}
	if `d' == `num_vars' {
	noi di as result "and `v'." _cont
	}
	qui keep if rank <= `v'
	qui levelsof code, local(final_selection)

	qui use "`e(save__)'/`e(study__)'_hdps_covariates", replace

	foreach i of local final_selection {
		rename `i' __fs`i'
	}
	keep `patid' `exposure' `outcome' __fs* 
	
	foreach i of local final_selection {
		rename __fs`i' `i' 
	}	

	qui save "`e(save__)'/`e(study__)'_hdps_covariates_top_`v'", replace
	restore
	local ++b
	local ++d
	local num_`b' = `v'
}


* Output
noi di as text _new ""
noi di as text "Output files:"
noi di as result "(1) `e(study__)'_bias_info.dta"

local a = 1
foreach v of local top {
local c = `a' + 1
local num = `num_`a''
noi di as result "(`c') `e(study__)'_hdps_covariates_top_`num'.dta"

local ++a 
}

* Create Tag that hdps_prevalence has run
ereturn local hdpsBias_____  = 1

end
