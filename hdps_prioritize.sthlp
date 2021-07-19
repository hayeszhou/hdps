{smcl}
{* *! version 1.0 1feb2021}{...}
{vieweralsosee "Main hdps help page" "hdps"}{...}
{viewerjumpto "Syntax" "hdps_prioritize##syntax"}{...}
{viewerjumpto "Description" "hdps_prioritize##description"}{...}
{viewerjumpto "Options" "hdps_prioritize##options"}{...}
{viewerjumpto "Output" "hdps_prioritize##output"}{...}
{viewerjumpto "Examples" "hdps_prioritize##examples"}{...}
{title:Title}

{phang}
{bf:hdps prioritize} {hline 2} Prioritizes covariates and selects a subset(s) for analysis (Steps 4 & 5)

{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmdab:hdps prioritize}
[{cmd:,}
{it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Required}
{synopt:{opt method(string)}} Covariate prioritization method {p_end}
{synopt:{opt top(numlist)}} Number of covariates to select {p_end}

{syntab:Optional}
{synopt:{opt zerocell}} Applies zero cell correction in calculation of Bross formula {p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}


{marker description}{...}
{title:Description}
{pstd} {cmd: hdps prioritize} prioritizes and performs variable selection on the set of covariates created by the {bf: hdps recurrence command}.

{marker options}{...}
{title:Options}
{dlgtab:Main}
{phang}
{opt method(string)} specifies the method of covariate prioritization. Available methods are 'bross' or 
'exposure'.  {p_end}

{phang}
{opt top(numlist)} specifies the number of covariates to be selected. To obtain multiple datasets varying the 
number of covariates selected, a list of integers can be provided, e.g. top(200 500).  {p_end}
 
{phang}
{opt zerocell} applies a correction of 0.1 to cells used in the calculation of the Bross formula. This is 
useful in settings with few outcomes, where computation of these values can be challenging.  {p_end}

{title:Output}{marker output}

{pstd} The hdps prioritize command outputs a dataset containing the data used to calculate the ranking information for each of the HDPS covariates ("study_bias_info.dta"). 

{pstd} "study_hdps_covariates_top_k.dta" is return in the specified output folder containing the selected number of covariates (k) for each scenario specified.

{marker examples}{...}
{title:Examples}
{pstd}

{pstd}Prioritize covariates using the Bross formula and select the top 100 covariates

{pin}. {bf: hdps prioritize, method(bross) top(100)}

{pstd}Prioritize covariates using the strength of exposure association and select the top 100 covariates

{pin}. {bf: hdps prioritize, method(exposure) top(100)}

{pstd}Select sets including the top 50 and 100 covariates

{pin}. {bf: hdps prioritize, method(bross) top(50 100)}

{p}{helpb hdps: Return to main help page for hdps}

