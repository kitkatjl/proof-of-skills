clear
set seed 987654321

use "RD-data.dta", clear

reg y D z 


scatter y z if D==0 || scatter y z if D==1,  ///
	xline(50, lstyle(foreground)) || lfit y z if D ==0, color(red) || ///
	lfit y z if D ==1, color(red) 

	
* measurement error

gen e =  runiform(1, 2)

* running variable with measurement error

gen z1=z+e


gen D1 = 1
replace D1 = 0 if z1 > 50

reg y D1 z1



	

