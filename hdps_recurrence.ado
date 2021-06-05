*=============================================================================
* HDPS recurrence
* 
* *! version 1.0.0 1feb2021 JT
* History 
*=============================================================================

cap prog drop hdps_recurrence
prog define hdps_recurrence, eclass
version 15
syntax , 

if "`e(hdpsSetup_____)'"  != "1" {
di as error "Data dimensions have not been declared using {stata hdps setup}"
    exit 498
}

if "`e(hdpsPrev_____)'"  != "1" {
di as error "Feature prevalence has not been assesed using {stata hdps prevalence}"
    exit 498

}

local patid `e(patid__)'

noi di as text ""
noi di as text "Loading data:"
		
qui use "`e(save__)'/`e(study__)'_cohort_info", replace

tempfile cohort_patid
qui save `cohort_patid'
*=============================================================================
* 1. Create dataset with possible hd_ps vars for codes (once/ever, spor, freq)
*=============================================================================
* 
qui use "`e(save__)'/`e(study__)'_feature_prevalence", replace 

keep dimension code q2 q3 no_spor no_freq
qui tempfile code_info
qui save `code_info'

qui use "`e(save__)'/`e(study__)'_patient_totals", replace 
qui merge m:1 dimension code using `code_info', nogen keep(3)

* Identify dimensions using ever information
qui gen ever = . 

forvalues t = 1/$numDims____ {
	if "`e(dim`t'_ever)'" != "" {
	 qui  replace ever = 1 if dimension == "`t'"
	  }
}
qui replace ever = 0 if ever ==.

noi di as result  "Completed"

* Count number of features available
qui levelsof code, local(vars)
qui local count_values: word count `vars'

noi di as text ""
noi di as text "Generating HDPS covariates and assessing feature recurrence:"
* Loop through features to generate HDPS covariates

local a = 1
noi di as result "Progress: " _cont
local last_perc = 0
foreach v of local vars {

preserve
qui keep if code == "`v'"

qui count 
if `r(N)' > 1 {
	local code = code[1]
	local ever = ever[1]
	local no_spor = no_spor[1]
	local no_freq = no_freq[1]

	if `ever' == 1 {
	qui	gen `code'_ever = 1
	}

	if  `ever' == 0 {
	qui	gen `code'_once = 1 
	}

	if  `no_spor' == 0 {
	qui	gen `code'_spor = cond(tot >= q2 , 1, 0) 
	}

	if `no_freq' == 0 {
	qui	gen `code'_freq = cond(tot >= q3 , 1, 0) 
	}

* Only keep relevant covariates
keep `patid' `code'*	

qui tempfile pt_code_info 
qui save `pt_code_info'

if `a' == 1 {
	qui use `cohort_patid', replace
}
else {
	qui use `hdps_cohort' , replace
}
qui merge 1:1 `patid' using `pt_code_info', nogen 
qui tempfile hdps_cohort
qui save `hdps_cohort' 
}

restore 

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

qui use `hdps_cohort' , replace
qui describe
local num_hdps = `r(k)' - 3 
noi di as text ""
noi di as text ""
di as text "Number of binary HDPS covariates created:"
di as result "`num_hdps'"

qui ds, not(type string)
foreach x of varlist `r(varlist)' {
qui replace `x' = 0 if `x' ==.
}
label data "`e(study__)' study generated HDPS covariates"
qui save "`e(save__)'/`e(study__)'_hdps_covariates", replace

* Output
noi di as text ""
di as text "Output file:"
di as result "(1) `e(study__)'_hdps_covariates.dta"

ereturn local hdpsRecc_____  = 1



end
