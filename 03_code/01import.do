* ------------------------------------------------------------------------------
* AUTHOR: Valentina Andrade
* CREATION: July-2023
* ACTION: Load data from https://www.spensiones.cl/apps/bdp/index.php
* ------------------------------------------------------------------------------

set more off 
clear all

ssc install filelist

* ------------------------------------------------------------------------------
**# SET PATH AND LOCALS
* ------------------------------------------------------------------------------

*remote
if c(username)=="vandrade" global dropbox "/home/vandrade/quantile-wage-gap_shared/"
if c(username)=="vandrade" global src 	"$dropbox/02_data/src"
if c(username)=="vandrade" global tmp 	"$dropbox/02_data/tmp"
if c(username)=="vandrade" global github "/home/vandrade/quantile-wage-gap/"

*local
if c(username)=="valentinaandrade" global dropbox"/Users/valentinaandrade/Dropbox/Research/quantile-wage-gap_shared/"
if c(username)=="valentinaandrade" global src 	"$dropbox/02_data/src"
if c(username)=="valentinaandrade" global tmp 	"$dropbox/02_data/tmp"
if c(username)=="valentinaandrade" global github "/Users/valentinaandrade/Documents/GitHub/quantile-wage-gap/"


* ------------------------------------------------------------------------------
**# use data
* ------------------------------------------------------------------------------

* Sample ----------------------------------------------------------------

*Path
filelist, directory("$src") pattern("*1_afiliados.csv")
gen path = dirname + "/" + filename 
levelsof path, local(tofile)

*Loop
foreach x in `tofile' {
    import delimited using "`x'", clear
	
	* Rename vars
	ren v1 id
	ren v2 sexo
	ren v3 fecha_nac
	ren v4 nivel_ed
	ren v5 cursos
	ren v6 est_civil
	ren v7 comuna_domi
	ren v8 inst_prev
	ren v9 nacionalidad

	* Recode vars

	** Education in levels

	** Age
	*gen age = . 

	
    local tosave = subinstr("`x'", ".csv", "", .)
    save "`tosave'", replace 
}

use "$src/muestraasc12%/1_afiliados.dta",clear
append using "$src/muestraasc5%/1_afiliados" "$src/muestraasc3%/1_afiliados"
save "$tmp/1_afiliados", replace



* Wages ----------------------------------------------------------------
filelist, directory("$src") pattern("*5_rentas_imponibles.csv")
gen path = dirname + "/" + filename 
levelsof path, local(tofile)

*Loop
foreach x in `tofile' {
    import delimited using "`x'", clear
	
	* Rename vars
	ren v1 id
	ren v2 mes_dev
	ren v3 contrato
	ren v4 sil
	ren v5 act_eco
	ren v6 comuna_emp
	ren v7 renta
	ren v8 numb_trab
	ren v9 renta_prom_emp
	ren v10 sd_prom_emp
	ren v11 renta_0
	ren v12 tope_imp
	ren v13 ing_min
	ren v14 id_emp
	

	*reshape wide , i(id)
	
    local tosave = subinstr("`x'", ".csv", "", .)
    save "`tosave'", replace 
}

use "$src/muestraasc12%/5_rentas_imponibles.dta",clear
append using "$src/muestraasc5%/5_rentas_imponibles" "$src/muestraasc3%/5_rentas_imponibles"

save "$tmp/5_rentas_imponibles", replace


* Merge 
merge m:1 id using "$tmp/1_afiliados.dta"
keep if _merge ==3
drop _merge
save "$tmp/double_connected.dta"


