{smcl}
{* *! version 1.0 1feb2021}{...}
{vieweralsosee "Main hdps help page" "hdps"}{...}
{viewerjumpto "Syntax" "hdps_recurrence##syntax"}{...}
{viewerjumpto "Description" "hdps_recurrence##description"}{...}
{viewerjumpto "Output" "hdps_recurrence##output"}{...}
{title:Title}

{phang}
{bf:hdps recurrence} {hline 2} Creates a pool of HDPS covariates and assesses the frequency of recording (Step 3)

{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmdab:hdps recurrence} 
{cmd:}

{p 4 6 2}
You must run {cmd:hdps setup} and {cmd:hdps prevalence} before using {cmd:hdps recurrence}.{p_end}

{title:Description}{marker description}
{pstd} Using information about the distributions of features across the data dimensions, {cmd:hdps recurrence} generates HDPS covariates. For each of the features, up to three binary covariates are generated: '{it:code}_once', '{it:code}_spor' and '{it:code}_freq' as described by Schneeweiss et al (2009). 

{pstd} If during {cmd:hdps setup}  the 'ever' option is specified for a particular data dimension, the bottom cut-off generated will be '{it:code}_ever'. For more details, see Tazare et al (2020).

{pstd} Based on the frequency a feature is recorded during an individual's pre-exposure period, {cmd:hdps recurrence} then assigns either 1 or 0 for each HDPS covariate generated. 

{title:Output}{marker output}

{pstd} The total number of binary HDPS covariates generated is return in the Results Window. 

{pstd} "study_hdps_covariates.dta" is returned in the specified output folder.

{p}{helpb hdps: Return to main help page for hdps}


