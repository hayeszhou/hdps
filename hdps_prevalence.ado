*=============================================================================
* HDPS prevalence
*
* *! version 1.0.0 1feb2021 JT
* History 
*=============================================================================
* Identify how many patients

cap prog drop hdps_prevalence
prog define hdps_prevalence , eclass
version 15
syntax , [top(numlist max=1 integer) nofilter]   // do not apply prevalence filter

if "`e(hdpsSetup_____)'"  != "1" {
di as error "Data dimensions have not been declared using {stata hdps setup}"
    exit 498
}


* Check if nofilter option specified
* If nofilter is specified then replace top to 0
if "`filter'" == "" & "`top'" == "" {
di as error "Syntax: One option must be specified"
    exit 198
}

if "`filter'" != "" & "`top'" != "" {
di as error "Syntax: Only specify one option"
    exit 198
}

qui count
local tot_patients__ `r(N)'


noi di as text ""
di as text "Identifying most prevalent features:"
if "`filter'" == "" {
di as result "Selecting top `top' from each dimension"
}

if "`filter'" != "" {
di as result "Selecting all features from each dimension"
}

forvalues d = 1/$numDims____ {
	* load dimensions
	qui {
	
	use "`e(dim`d')'" , replace 
	local patid `e(patid__)'
	rename `e(code`d')' code
	* encode the dimension in the code labels
	qui replace code = "d`d'_" + code
	
	bysort `patid' code : gen flag = _n
	bysort `patid' code : egen tot = max(flag)
	keep if flag == 1
    * add dimension identifier
	gen dimension = "`d'"
	
	* Tempfile of patient totals
	tempfile pt_totals_`d'    
	qui save "`pt_totals_`d''", replace
	
	drop dimension

	* Collapse counts to summarise each code
	collapse (count) r=flag (p50) q2=tot (p75) q3=tot, by(code)

	* Round the distributions 
	replace q2=floor(q2)
	replace q3=floor(q3)
	
	* add dimension identifier
	gen dimension = "`d'"

	* Rename variables
	gen prev = r / `tot_patients__'

	* Apply the prevalence filter
	gsort - prev
	gen rank = _n
	if "`filter'" == "" {
	keep if rank <= `top'
	}
	drop rank
	tempfile code_prev_`d'
	save "`code_prev_`d''"
	
	}
	qui count 
	di as text  %~20s  `col1' "Dimension `d': " `col2' as result  "Completed: selected `r(N)' features"
	


}

* Append information for all dimensions 
* 1. Code prevalence 
qui {
forvalues t = 1/$numDims____ {
	if `t' == 1 {
	use "`code_prev_`t''", clear
	save "`e(save__)'/`e(study__)'_feature_prevalence", replace
	}
	else {
	append using `code_prev_`t''
	save "`e(save__)'/`e(study__)'_feature_prevalence", replace
	label data "`e(study__)' study feature prevalence data"
	}
}

* Add markers for whether to create spor/freq variables
gen no_spor = cond(q2 == 1, 1, 0)
gen no_freq= cond(q3 == 1 | q3==q2, 1, 0)

* Reorder dataset
order dimension code r prev q2 q3 no_spor no_freq

save "`e(save__)'/`e(study__)'_feature_prevalence", replace

* Identify codes in the prevalence file
qui levelsof code, local(vars)	

* 2. Patient totals
forvalues t = 1/$numDims____ {
	if `t' == 1 {
	use "`pt_totals_`t''", clear
	save "`e(save__)'/`e(study__)'_patient_totals", replace
	}
	else {
	append using `pt_totals_`t''
	save "`e(save__)'/`e(study__)'_patient_totals", replace
	label data "`e(study__)' study patient feature summary data"
	}
}

 local a = 1 
* Add in ever patient information
forvalues t = 1/$numDims____ {
	if "`e(dim`t'_ever)'" != "" {
	
		if `a' == 1 {
		noi di as result ""
		noi di as text "Incorporating 'ever' information:"
		local ++a
		}
	
	di as result ""
	use  `e(dim`t'_ever)', replace
	rename `e(code`t'_ever)' code
	local i = 1
	
	* encode the dimension in the code labels
	qui replace code = "d`t'_" + code
	
	* Remove codes which are not in prevalence file
	foreach v of local vars {
		if `i' == 1 {
			gen flag = 1 if code == "`v'"
		}
		else {
			replace flag = 1 if code == "`v'"
		}
		local ++i
	}
	keep if flag == 1 
	drop flag
	
	local patid `e(patid__)'
	
	* Ensure there is only 1 record per patient/code in this file
	bysort `patid' code : gen flag = 1 
	keep if flag == 1
	drop flag 
	gen tot = 1
	* add dimension identifier
	gen dimension = "`t'"
	tempfile pt_ever_totals_`t'   
	save "`pt_ever_totals_`t''"
	
	noi di as text  %~20s  `col1' "Dimension `t': " `col2' as result  "Completed"
	}
}

use "`e(save__)'/`e(study__)'_patient_totals", replace
drop flag
save "`e(save__)'/`e(study__)'_patient_totals", replace

forvalues t = 1/$numDims____ { 
   if "`e(dim`t'_ever)'" != "" {
	append using `pt_ever_totals_`t''
	bysort patid code: gen flag = _n 
	bysort patid code: egen tot_flag = max(flag)
	* Drop the 'ever' information if patient already has a record
	drop if tot_flag > 1 & tot == 1 
	drop flag tot_flag
	save "`e(save__)'/`e(study__)'_patient_totals", replace
   }
}

}
* 3. Clean so that only relevant codes i.e. in top X remain

if "`filter'" == "" {
	qui {
	use "`e(save__)'/`e(study__)'_feature_prevalence", replace
	levelsof code, local(vars)	
	use "`e(save__)'/`e(study__)'_patient_totals", replace
	local i = 1 
	foreach v of local vars {
		if `i' == 1 {
			gen flag = 1 if code == "`v'"
		}
		else {
			replace flag = 1 if code == "`v'"
		}
		local ++i
	}
	keep if flag == 1 
	drop flag
	save "`e(save__)'/`e(study__)'_patient_totals", replace
	}
}
* Reorder patient totals
order patid dimension code tot 
qui save "`e(save__)'/`e(study__)'_patient_totals", replace

* Output
di as text _new "Output files:"
di as result "(1) `e(study__)'_feature_prevalence.dta"
di as result "(2) `e(study__)'_patient_totals.dta"

* Return code prevalences
qui use "`e(save__)'/`e(study__)'_feature_prevalence", replace


* Create Tag that hdps_prevalence has run
ereturn local hdpsPrev_____  = 1

end
