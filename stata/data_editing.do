*learning outcome: Read .csv data in in Stata.
import delimited raw_data.csv, clear

*learning outcome: Install a Stata package.
ssc install outreg

*learning outcome: Name files, functions and variables appropriately.
rename gdppercapitapppconstant2011inter gdp
rename populationtotalsppoptotl population
rename lifeexpectancyatbirthtotalyearss expect
rename time year

*learning outcome: Fix common data quality errors in Stata.
drop if countrycode==""
drop if expect==".."
drop if population==".."
drop if gdp==".."

destring gdp, gen (gdp_new)
destring population, gen (population_new)
destring expect, gen (expect_new)

*learning outcome:Prepare a sample for analysis by filtering observations and variables and creating transformations of variables.
gen gdp_k=gdp_new/1000
gen populationM = population_new/1000000

drop gdp
drop gdp_new
drop population_new
drop population
drop expect 
rename gdp_k gdp
rename populationM population
rename expect_new expect

*learning outcome: Aggregate, reshape, and combine data for analysis in Python or Stata. Demonstrate at least one of these data manipulations.
*collapse (mean) gdp_mean=gdp, by(countrycode)


lab var gdp "GDP per capita, PPP (constant 2011 international thousand $) [NY.GDP.PCAP.PP.KD]"
lab var population "Population, million [SP.POP.TOTL]"
lab var expect "Life expectancy at birth, total (years) [SP.DYN.LE00.IN]"

*learning outcome: Run ordinary least squares regression in Stata.
gen gdp_sq=gdp*gdp
regress expect gdp gdp_sq

*learning outcome: Create a graph (of any type) in Stata.
twoway (line gdp expect) 
 
*learning outcome: Save regression tables and graphs as files. Demonstrate both.
outreg using regression1.doc
graph export graph.pdf

*learning outcome: Automate repeating tasks using Stata "for" loops.
foreach i of num 1/10 {
	display `i'
	display "hi there"
}


*learning outcome: Save data in Stata
save clean_data