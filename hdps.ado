*=============================================================================
* HDPS
* 
* *! version 1.0.0 1feb2021 JT
* History 
*=============================================================================
cap prog drop hdps
prog def hdps
syntax [anything] [if] [in], [which *]

// hdps subcommands

* all known subcommands
local subcmds setup prevalence recurrence prioritize graphics

// Subcommands with data requirements
local subcomds0 setup prevalence recurrence prioritize graphics
 

// check a subcommand is given
if mi("`anything'") {
	di as error "Syntax: hdps <subcommand>"
	exit 198
}

// "which" option
if "`anything'"=="which" {
	which hdps
	foreach subcmd of local subcmds {
		which hdps_`subcmd'
	}
	exit
}

// Parse current subcommand
gettoken subcmd rest : anything


// Check it's a valid subcommand
cap which hdps_`subcmd'
if _rc {
    di as error "`subcmd' is not a valid hdps subcommand"
    exit 198
}

    
if mi(`"`options'"') hdps_`subcmd' `rest' `if' `in'
else                 hdps_`subcmd' `rest' `if' `in', `options'
end
