{smcl}
{* *! version 1.0  3 Feb 2021}{...}
{vieweralsosee "Main hdps help" "hdps"}{...}
{viewerjumpto "Syntax" "hdps_setup##syntax"}{...}
{viewerjumpto "Description" "hdps_setup##description"}{...}
{viewerjumpto "Options" "hdps_setup##options"}{...}
{viewerjumpto "Output" "hdps_setup##output"}{...}
{viewerjumpto "Examples" "hdps_setup##examples"}{...}
{title:Title}

{phang}
{bf:hdps setup} {hline 2} Specifies data dimensions and key patient variables for the HDPS procedure

{marker syntax}{...}
{title:Syntax}
{p 8 17 2}
{cmdab:hdps setup}
{it: dimension(s)}
[{cmd:,}
{it:options}]

Dimensions are specified using the filename:

{p 8 17 2}
{cmdab:}
({it:filename}, {it:varname}
[{it:ever}]) 

{dlgtab:Dimension syntax}
{phang}
{bf: filename} specifices file name for data dimension {p_end}

{phang}
{bf: varname} specifies variable in the data dimension containing the codes. This option
is required and must be the first option specified {p_end}

{phang}
{bf: ever} optionally specifies that the recurrence assessment should incorporate
`Ever' information {p_end}

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Required}
{synopt:{opt save(string)}} Output directory {p_end}
{synopt:{opt study(string)}} Study name and output prefix {p_end}
{synopt:{opt patid(varname)}} Patient identifier variable {p_end}
{synopt:{opt exp:osure(varname)}} Exposure variable {p_end}
{synopt:{opt out:come(varname)}}  Outcome variable {p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}

{marker description}{...}
{title:Description}
{pstd} The hdps setup command declares the data dimensions and key variables used through-
out the HDPS procedure, further specifying the directory for outputted datasets. Set the
current directory to a folder containing all necessary data and load the cohort dataset
into memory before running this command.

{marker options}{...}
{title:Options}
{dlgtab:Main}
{phang}
{opt save(string)} specifies a study name that serves as a prefix on all output files. This option is required.  {p_end}

{phang}
{opt study(string)} specifies a directory where output files will be saved. This option is required.   {p_end}

{phang}
{opt patid(varname)} specifies variable containing the patient identifiers in cohort data set and data dimensions. This option is required   {p_end}

{phang}
{opt exp:osure(varname)} specifies the binary treatment or exposure variable. THis option is required.   {p_end}

{phang}
{opt out:come(varname)} specifies the binary outcome variable. This option is required.  {p_end}

{title:Output}{marker output}

{pstd} "study_cohort_info.dta" contains the patient identifier, treatment and outcome variables.

{marker examples}{...}
{title:Examples}

{pstd}Change current directory to folder containing cohort and data dimension datasets

{pstd}Load cohort dataset

{pin}. {bf: use "cohort.dta", replace }

{pstd}Specify two data dimensions (clinical and therapy) with Ever incorporated for clinical dimensions.

{pin}. {bf: hdps setup (clinical_dim, icd10 ever) (therapy_dim, bnf), patid(patid) exp(trt) out(outcome) study(example) save(../output/)}


{p}{helpb hdps: Return to main help page for hdps}



