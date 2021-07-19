{smcl}
{* *! version 1.0  3 Feb 2021}{...}
{vieweralsosee "Main hdps help page" "hdps"}{...}
{viewerjumpto "Syntax" "hdps_prevalence##syntax"}{...}
{viewerjumpto "Description" "hdps_prevalence##description"}{...}
{viewerjumpto "Options" "hdps_prevalence##options"}{...}
{viewerjumpto "Output" "hdps_prevalence##output"}{...}
{viewerjumpto "Examples" "hdps_prevalence##examples"}{...}
{title:Title}

{phang}
{bf:hdps prevalence} {hline 2} Applies a code prevalence filter within each dimension (Step 2)

{marker syntax}{...}
{title:Syntax}
{p 8 17 2}
{cmdab:hdps prevalence}
[{cmd:,}
{it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Optional - one of the following must be specified}
{synopt:{opt top(integer)}} Number of codes to be selected from each dimension {p_end}
{synopt:{opt nofilter}} No filter applied (all codes assessed) {p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}

You must run {cmd:hdps setup} before using {cmd:hdps prevalence}.

{marker description}{...}
{title:Description}
{pstd} {cmd: hdps prevalence} performs Step 2 of the HDPS procedure, identifying the most prevalent codes 
within each dimension and calculating distribution cut-offs used to assess code recurrence. The command also, 
for each patient, assesses the total frequency of each of the selected codes.

{marker options}{...}
{title:Options}
{dlgtab:Main}
{phang}
{opt top(integer)} specifies the number of codes to be selected from each dimension.     {p_end}

{phang}
{opt nofilter} calculates distribution cut-offs and patient frequencies for all available codes.    {p_end}

{title:Output}{marker output}

{pstd} The number of codes successfully selected from each dimension is reported in the Results Window.

{pstd} "study_feature_prevalence.dta" contains a summary of the codes selected. 

{pstd} "study_patient_totals.dta" reports the per patient code totals for each of the codes selected. 

{marker examples}{...}
{title:Examples}

{pstd}Select top 100 most prevalent codes from each dimension

{pin}. {bf: hdps prevalence, top(100)}

{pstd}Select all codes from each dimension

{pin}. {bf: hdps prevalence, nofilter}

{p}{helpb hdps: Return to main help page for hdps}



