{smcl}
{* *! version 1.0 1feb2021}{...}
{viewerjumpto "Syntax" "hdpsk##syntax"}{...}
{viewerjumpto "Description" "hdps##description"}{...}
{viewerjumpto "Data formats" "hdps##formats"}{...}
{viewerjumpto "Examples" "hdps##examples"}{...}
{viewerjumpto "Methodological considerations" "hdps##methods"}{...}
{viewerjumpto "Limitations" "hdps##limitations"}{...}
{viewerjumpto "References" "hdps##refs"}{...}
{viewerjumpto "Author" "hdps##updates"}{...}

{title:Title}

{phang}
{bf:hdps} Suite of commands for 1) performing data manipulation and variable selection steps of the high-dimensional propensity score (HDPS) algorithm, 2) graphically assess the properties of selected covariates. 

{title:Syntax}{marker syntax}

{col 7}{bf:{help hdps_setup:hdps setup}}{...}
{col 30}Identify data dimensions and key patient variables

{col 7}{bf:{help hdps_prevalence:hdps prevalence}}{...}
{col 30}Applies a prevalence filter to features within each dimension 

{col 7}{bf:{help hdps_recurrence:hdps recurrence}}{...}
{col 30}Creates binary covariates based on feature recording frequency

{col 7}{bf:{help hdps_prioritize:hdps prioritize}}{...}
{col 30}Prioritizes covariates and selects a subset(s) for analysis

{col 7}{bf:{help hdps_graphics:hdps graphics}}{...}
{col 30}Standalone command for investigating the properties of selected covariates 

{marker description}{...}
{title:Description}

{pstd}
The HDPS algorithm is a multi-step procedure for confounder generation and selection in large healthcare databases. 

{col 4} Step 1: Declare data dimensions and key variables ({bf:hdps setup})
{col 4}
{col 4} Step 2: Apply a feature prevalence filter within each dimension ({bf:hdps prevalence})
{col 4}
{col 4} Step 3: Assess the recurrence of features based on data driven cut-offs (creating a large pool of binary HDPS covariates) 
{col 4} ({bf:hdps recurrence})
{col 4}
{col 4} Steps 4 & 5: Prioritize the set of binary HDPS covariates and select a subset to incorporate into a propensity score 
{col 4} analysis ({bf:hdps prioritize})
 {col 4}
{col 4} Step 6: Graphically investigate the properties of selected covariates ({bf:hdps graphics})
{col 4}
{col 4} Step 7: Apply a traditional propensity score analysis

{pstd}
The {bf:hdps} suite of programs conducts steps 1 - 6 of the high-dimensional propensity (HDPS) algorithm. 

{marker formats}{...}
{title:Data formats}

{pstd}There are two data formats to be discussed, both of which are needed to run {bf:{help hdps_setup:hdps setup}} and the subsequent commands.  

{pstd}The first relates to the study dataset. This is expected to be a cohort, formatted to 1 observation per patient. Additionally, it must contain a patient identifier and binary exposure and outcome variables. 

{p 8 8 8}
Cohort format

        {c TLC}{hline 25}{c TRC}
        {c |} {it: patid}  {it:exposure outcome}{c |}   
        {c |}{hline 25}{c |}          
        {c |} 1001A       1      0    {c |}   
        {c |} 1002A       0      0    {c |} 
        {c |} 1003A       1      1    {c |}                
        {c |} 1004A       0      1    {c |}                
        {c BLC}{hline 25}{c BRC}

{pstd}The second relates to the data dimensions. This is expected to be a {it: long} format dataset with many observations per patient and feature (e.g. code). To incorporate 'ever' data, separate dimensions should be specified containing these data.

{p 8 8}
Dimension format (using International Classification of Disease Edition 10 (ICD-10) codes as an example)

        {c TLC}{hline 17}{c TRC}
        {c |} {it: patid}     {it:icd10}{c |}   
        {c |}{hline 17}{c |}          
        {c |} 1001A       W22 {c |}   
        {c |} 1001A       W22 {c |} 
        {c |} 1001A       X52 {c |}             
        {c |} 1003A       V97 {c |}                
        {c |} 1004A       W61 {c |}   
        {c |} 1004A       Y92 {c |}    
        {c BLC}{hline 17}{c BRC}

{marker examples}{...}
{title:Examples}

{pstd}Code and data for the examples below are available at {browse "https://github.com/johntaz/HDPS-Stata-Demo"}.

{pstd}Change the current directory to the folder with HDPS data dimensions and load the cohort data

{pin}. {bf: use "cohort.dta", clear}

{pstd}Declare data dimensions, output folder and key patient variables

{pin}. {bf: hdps setup (clinical_dim, icd10 ever) (therapy_dim, bnf), patid(patid) exp(trt) out(outcome) study(example) save(../output/) }

{pstd}Apply the prevalence filter, selecting the top 100 most prevalent codes from each dimension

{pin}. {bf: hdps prevalence, top(100)}

{pstd}Assess recurrence of the selected codes for each patient in the pre-exposure covariate window

{pin}. {bf: hdps recurrence}

{pstd}Prioritize covariates using the Bross formula and select the top 100 covariates

{pin}. {bf: hdps prioritize, method(bross) top(100)}

{marker methods}{...}
{title:Methodological considerations}

{pstd}The HDPS was developed in claims data by Schneeweiss et al (2009). Whilst typically the Bross formula is used to prioritize covariates in the HDPS algorithm, ranking covariates by the strength of covariate-exposure relationship has been suggested in small samples with rare outcomes (Rassen et al, 2011). 

{pstd} Developments to the cut-offs described by Schneeweiss et al (applied in {bf:{help hdps_recurrence:hdps recurrence}}), incorporating pre-exposure information recorded across a patient's entire medical history (so-called 'ever' information) have been proposed by Tazare et al (2020) and are implemented in this suite of commands. 

{pstd}{bf:{help hdps_prevalence:hdps prevalence}} applies a prevalence filter restricting further steps of the HDPS to only the most prevalent features within each dimension. There is ongoing debate in the literature surrounding the use of a prevalence filter (Schuster et al, 2015) and users of {bf:hdps} have the option to consider all features throughout the procedure. However, it should be noted that selecting all features will, in some cases, substantially add to the computational burden. 

{pstd}{bf:{help hdps_prioritize:hdps prioritize}} allows the user to select a number of covariates based on covariate prioritization. Whilst convention often leads to the selection of 200 and 500 covariates, it is unclear what the optimal number is for a given setting (Patorno et al, 2014). We recommend assessing the sensitivity of results to the number of covariates selected. 

{title:Limitations}{marker limitations}

{pstd} With large dimension files and numbers of patients, you may run into memory problems. Where possible, ensure you have reduced the size of data dimensions prior to running the {bf:hdps} commands.

{pstd} If your version of Stata allows you to do so, you may need to increase {help matsize} in order to fit propensity score models containing a large number of covariates. 

{pstd} Please report any other problems to john.tazare1@lshtm.ac.uk or submit an issue to the GitHub page for this project {browse "http://www.http://github.com/johntaz/hdps"}.

{title:References}{marker refs}

{phang}Schneeweiss S, Rassen JA, Glynn RJ, Avorn J, Mogun H, Brookhart MA. High-dimensional propensity score adjustment in studies of treatment effects using health care claims data [published correction appears in Epidemiology. 2018 Nov;29(6):e63-e64]. {browse "http://doi.org/10.1097/EDE.0b013e3181a663cc" :Epidemiology, 20(4):512–522, 2009}
	
{phang}Rassen JA, Glynn RJ, Brookhart MA, Schneeweiss S. Covariate selection in high-dimensional propensity score analyses of treatment effects in small samples. {browse "https://doi.org/10.1093/aje/kwr001":Am J Epidemiol, 173(12):1404–1413, 2011}

{phang}Tazare J, Smeeth L, Evans SJW, Williamson EJ, Douglas IJ. Implementing high‐dimensional propensity score principles to improve confounder adjustment in UK electronic health records. {browse "https://doi.org/10.1002/pds.5121":Pharmacoepidemiol Drug Saf 29:1373–1381, 2020}

{phang}Schuster T, Pang M, Platt RW. On the role of marginal confounder prevalence - implications for the high-dimensional propensity score algorithm. {browse "https://doi.org/10.1002/pds.3773":Pharmacoepidemiol Drug Saf 24(9):1004-1007, 2015}

{phang}Patorno E, Glynn RJ, Hernández-Díaz S, Liu J, Schneeweiss S. Studies with many covariates and few outcomes: selecting covariates and implementing propensity-score-based confounding adjustments. {browse "https://doi.org/10.1097/EDE.0000000000000069":Epidemiology 25(2):268-78,  2014}

{title:Authors}{marker updates}

{p}John Tazare, Liam Smeeth, Stephen JW Evans, Ian J Douglas and Elizabeth J Williamson; London School of Hygiene & Tropical Medicine, UK.

Contact Email: {browse "mailto:john.tazare1@lshtm.ac.uk":john.tazare1@lshtm.ac.uk}.

{p}You can see the latest updates and discussions surrounding the {bf:hdps} suite on {browse "https://github.com/johntaz":GitHub} and {browse "https://www.twitter.com/JohnTStats":Twitter}

