{smcl}
{* *! version 1.0 1feb2021}{...}
{vieweralsosee "Main hdps help page" "hdps"}{...}
{viewerjumpto "Syntax" "hdps_graphics##syntax"}{...}
{viewerjumpto "Description" "hdps_graphics##description"}{...}
{viewerjumpto "Options" "hdps_graphics##options"}{...}
{viewerjumpto "Variables" "hdps_graphics##variables"}{...}
{viewerjumpto "Examples" "hdps_graphics##examples"}{...}
{title:Title}

{phang}
{bf:hdps graphics} {hline 2} Graphically investigates the properties of selected covariates (Step 6)

{marker syntax}{...}
{title:Syntax}
{p 8 17 2}
{cmdab:hdps graphics}
varlist(min
=
2)
[{help if}]
[{cmd:,}
{it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Required }
{synopt:{opt type(string)}}  Plot type (bross, prevalence or strength) {p_end}
{synopt:{opt dim:ension(varname)}}  Dimension identifier (only required for prevalence or strength types) {p_end} 

{syntab:Optional}
{synopt:{opt pr(#)}} Plot prevalence ratios ('prevalence' plots only) {p_end}
{synopt:{opt graph_options}} Twoway graph options {helpb twoway_options} {p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}

{marker description}{...}
{title:Description}
{pstd} The hdps graphics command is a standalone command for graphically assessing the
properties of covariates generated and selected by the HDPS procedure. There are three
graphical diagnostic tools available: 

{pstd} {bf: Bross:} inspects the distribution of ranked Bross values.

{pstd} {bf: Prevalence:} compares the prevalence of selected codes in the two treatment groups.

{pstd} {bf: Strength:} compares the relationship between the covariate-exposure and covarite-outcome association strengths.

{marker options}{...}
{title:Options}
{dlgtab:Main}

{phang}
{opt type(string)} specifies one of three plot types: 'bross', 'prevalence' or 'strength'. Only one type can be specified at a time. This option is required.   {p_end}

{phang}
{opt dim:ension(varname)} specifies a numeric variable identifying the dimension a covariate is derived from. Note this option is only required for 'prevalence' and 'strength' plot types.  {p_end}

{phang}
{opt pr(#)} optionally specifies prevalence ratios. The prevalence ratio and its reciprocal will be plotted as dashed lines. The default is prevalence ratios of 2 and 0.5 Note pr() is option an option for the `prevalence' plot type.

{phang}
{opt graph_options} are any of the options in {helpb twoway_options}.

{marker variables}{...}
{title:Variables}

{pstd} {bf: hdps prioritize} returns a data set called "study_bias_info.dta" that stores variables which can be
used to generate these visualizations. The following variables are available: 

{phang}
{bf: abs_log_bias} stores the Bross bias values used to rank HDPS covariates.  {p_end}

{phang}
{bf: rank} stores the rank of each HDPS covariate.  {p_end}

{phang}
{bf: pc1/pc0} stores the prevalence of codes in the exposure and unexposred groups.  {p_end}

{phang}
{bf: ce_strength/cd_strength} stores the strength of association between HDPS covariate and a) exposure (ce), 
b) outcome (cd).  {p_end}

{marker examples}{...}
{title:Examples}
{pstd} 

{pstd}Load bias information dataset and generate a dimension identifier

{pin}. {bf: use "../output/example_bias_info.dta", clear}

{pin}. {bf: gen dimension=substr(code,1,2)}

{pin}. {bf: encode dimension, gen(dim)}

{pstd}Inspect Bross values for top 100 selected covariates

{pin}. {bf: hdps graphics abs_log_bias rank if rank<=100, type(bross)}

{pstd}Compare prevalence in treated and untreated groups

{pin}. {bf: hdps graphics pc1 pc0, type(prevalence) dim(dim)}

{pin}. {bf: hdps graphics pc1 pc0 if rank<=100, type(prevalence) dim(dim)}

{pstd}Compare covariate-exposure and covariate-outcome association strengths

{pin}. {bf: hdps graphics ce_strength cd_strength, type(strength) dim(dim)}

{pin}. {bf: hdps graphics ce_strength cd_strength if rank<=100, type(strength) dim(dim)}

{p}{helpb hdps: Return to main help page for hdps}




