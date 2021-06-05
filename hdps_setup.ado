*=============================================================================
* HDPS setup
* 
* *! version 1.0.0 1feb2021 JT
* History 
*=============================================================================
cap prog drop hdps_setup
prog define hdps_setup , eclass
version 15
syntax anything, [save(string) study(string) patid(varname) EXPosure(varname) OUTcome(varname)]

tokenize "`anything'", parse(")")
local i 0
local j 1
	while "``i'+1'" != "" {

		if "``i'+1'" != ")" {

		local subcmd`i' = ustrright("``i'+1'",length("``i'+1'")-1)
		local subcmd`i' `subcmd`i''
		local j = `j' + 1 
        }
	
	local i = `i' + 1
	}

* Clear previous results
ereturn clear

* Check if study option specified
if "`study'"!="" {
	ereturn local study__ `study' 
}

else {
	di as error "Syntax: No study prefix provided"
    exit 198
}   

* Check if save option specified
if "`save'"!="" {
	ereturn local save__ `save'
}
else {
	di as error "Syntax: No folder path for output provided"
    exit 198
}     

* Check if study option specified
if "`patid'"!="" {
	ereturn local patid__ `patid'
}
else {
	di as error "Syntax: No patient identifier provided"
    exit 198
}      

* Check if exposure option specified
if "`exposure'"!="" {
	ereturn local exp__ `exposure'
}
else {
	di as error "Syntax: No exposure variable provided"
    exit 198
}     

* Check if study option specified
if "`outcome'"!="" {
	ereturn local out__ `outcome'
}
else {
	di as error "Syntax: No outcome variable provided"
    exit 198
}     

* Number of tokens - 1
local w = `i'-1 


forvalues k = 1(2)`w' {
	tokenize "`subcmd`k''", parse(",")
	local dim`k' `1'

	tokenize "`3'", parse(" ")
	local token1 "`1'" 
	local token2 "`2'" 
	
	if "`3'"!= "" {
		di as error "Syntax: Too many options specified `dim`k''"
        exit 198
	}

	if "`token1'" == "ever" {
		local ever`k' = "yes"
		local code`k' "`token2'"
	}

	if "`token2'" == "ever" {
		local ever`k' = "yes"
		local code`k' "`token1'"
	}

	if "`token2'" == "" {
		local code`k' "`token1'"
	}
}

* Number of dimensions 
local k = `j' - 2
global numDims____ = `k'

* Correct subcommand names
local ever_list 

forvalues a = 1/`k' {
	local b = 2*`a' - 1
	ereturn local dim`a' `dim`b''
	ereturn local code`a' `code`b''
	
	if "`ever`b''" == "yes" {
		local ever_list "`ever_list' `a'"
		ereturn local dim`a'_ever = "`e(dim`a')'" + "_ever"
		ereturn local code`a'_ever `e(code`a')'
	}
}

* Check at least one dimension specified 
if `k'==0 {
	noi di as error "No data dimensions specified" 
	exit 498
}

* Check dimension names and contents
forvalues a = 1/`k' {
		local b = 2*`a' - 1	
         quietly describe `e(code`a')' using "`e(dim`a')'"
         
		 if "`ever`b''" == "yes"  {
			quietly describe `e(code`a')' using "`e(dim`a'_ever)'"
         }
}
					
* Output 
di as text ""
di as text "Data dimensions identified (code variable):"

forvalues l = 1/`k' {
    di as text  %~20s  `col1' "Dimension `l': " `col2' as result  "`e(dim`l')' (`e(code`l')')"
}

if "`ever_list'"!="" {
	numlist "`ever_list'"
	local everDims  `r(numlist)'
	ereturn local ever_dim_nums `r(numlist)'
	di as result _new "Note: 'ever' option specified at least once"
	di as text "Ever dimensions:"

		foreach l of local everDims  {
			di as text  %~20s  `col1' "Dimension `l': " `col2' as result  "`e(dim`l'_ever)' (`e(code`l'_ever)')"
		}
}
	
di as text _new "Output folder:"
di as result "`save'"

* keep dataset with just patient identifiers for recurrence step 

qui keep `patid' `exposure' `outcome'
label data "`e(study__)' study patient key information"
qui save "`e(save__)'/`e(study__)'_cohort_info", replace


* Create Tag that hdps_setup has run
ereturn local hdpsSetup_____  = 1

	
end 
