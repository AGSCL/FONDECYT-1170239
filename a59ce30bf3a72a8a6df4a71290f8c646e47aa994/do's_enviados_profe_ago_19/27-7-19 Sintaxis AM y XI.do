*use "G:\Mi unidad\6.TESIS 2018\CULTURA\culorg 06-04- BD_05_02_19 (BD_22_10_18_lab_cul_org2).dta"

  labelbook ocuprev A62 A54 

  *recodificar la variable NAQ_sum en punto de corte
drop NAQ_sum_ROC3
recode NAQ_sum 0/8=0 9/max=1, gen(NAQ_sum_ROC3)
label var NAQ_sum_ROC3 "Suma ptjes brutos NAQ-R ROC (crit. inclusivo)"
label define NAQ_sum_ROC3  1 "Presencia VL", replace
label define NAQ_sum_ROC3 0 "Ausencia VL", replace 
  
 **definir variables
 recode A54 99=. 		1/3=1 4/6=2 7/8=3 9/10=4, gen (Educacion277) label(Educación Amalia y Ximena)
 recode ocuprev 1=1 2/3=2 4/5=3 6/8=4 9=5, gen(ocuprev_xi_am277) label(Ocupación Amalia y Ximena)
  *corregido por indicaciones 27-07-19
 recode A62 99=. 88=.	1/3=1 4=2 5/6=3, gen (ing_hog_xi_am277) label(Ingreso Hogar Amalia y Ximena)

*Hacer etiquetas 27-7-19
label variable Educacion277 "Educacion"
label define Educacion277 1 "Sin Educacion o Basica", replace
label define Educacion277 2 "Media o Tecnica Incomp", replace
label define Educacion277 3 "Tecnica Comp o Univ Incomp", replace
label define Educacion277 4 "Universitaria Comp o Postgr", replace
label variable ocuprev_xi_am277 "Ocupacion"
label define ocuprev_xi_am277 1 "Jef Intermedias", replace
label define ocuprev_xi_am277 2 "Prof y Tecnicos", replace
label define ocuprev_xi_am277 3 "Empleados Oficina y Vendedores", replace
label define ocuprev_xi_am277 4 "Operarios, conductores y calif", replace
label define ocuprev_xi_am277 5 "No calificados", replace
label variable ing_hog_xi_am277 "Educacion"
label define ing_hog_xi_am277 1 "Hasta 540.000 pesos", replace
label define ing_hog_xi_am277 2 "Desde 540.001 hasta 913.000 pesos", replace
label define ing_hog_xi_am277 3 "Desde 913.001 o mas", replace
label variable estrechez "Estrechez Económica"
label define estrechez 1 "Sí", replace
label define estrechez 0 "No", replace
label variable vul "Vulnerabilidad"
label define vul 1 "Sí", replace
label define vul 0 "No", replace
label variable climasex "Clima Sexista"
label define climasex 1 "Sí", replace
label define climasex 0 "No", replace
label variable LF_Leyman "Lid. Laissez-Faire"
label define LF_Leyman 1 "Sí", replace
label define LF_Leyman 0 "No", replace
label variable LA_Leyman "Lid. Autoritario"
label define LA_Leyman 1 "Sí", replace
label define LA_Leyman 0 "No", replace
label variable LC_Leyman "Lid. Constructivo"
label define LC_Leyman 1 "Sí", replace
label define LC_Leyman 0 "No", replace

 
*Por sexo en separado	
foreach sexo of varlist mujer hombre { 
  foreach vd of varlist Educacion277 ocuprev_xi_am277 ing_hog_xi_am277 ///
		estrechez vul climasex ///
		LF_Leyman LA_Leyman LC_Leyman {
  foreach vi of varlist NAQ_sum_ROC2 {
		estpost svy, subpop(`sexo'): tab `vd' `vi', count row format(%9,3g)
		estadd sca Vsvy=(sqrt(e(cun_Pear)/(e(N)*min((e(r)-1),(e(c)-1)))))
		esttab . using "chi2__ROC_seg_sexo_27_7_19.html", label cell("count(fmt(%9,0fc)) row(fmt(%9,3fc))") ///
		scalars(F_Pear p_Pear Vsvy) nostar unstack mtitle(`e(colvar)') ///
		addnotes(`vd' "por" `vi' " y " `sexo') sfmt(%15,3g) plain ///
		append
	} 
   }
 }
    

*cruces por sexo 
  foreach s of varlist Educacion277 ocuprev_xi_am277 ing_hog_xi_am277 /// 
  	LF_Leyman LA_Leyman LC_Leyman ///
	 estrechez vul climasex NAQ_sum_ROC2 {
  foreach v of varlist mujer {
		estpost svy: tab `s' `v', elabels count row format(%9,3g)
		estadd sca Vsvy=(sqrt(e(cun_Pear)/(e(N)*min((e(r)-1),(e(c)-1)))))
		esttab .  using "chi2__ROC_sexo_27_7_197.html", cell("count(fmt(%9,0fc)) row(fmt(%9,3fc))") ///
		legend label scalars(F_Pear p_Pear Vsvy) nostar unstack mtitle(`e(colvar)') ///
		addnotes(`s' "por" `v' " y " `sexo') sfmt(%15,3g) plain ///
		append
  } 
 }
	
 *hay más mujeres más calificadas
 svy: tab A54 mujer, col

  *hay más mujeres más calificadas
 svy: tab ocuprev_xi_am277 mujer, col
 
 
 *****************************************************************************
 *******************************16-08_19*************************************
 
   **Página 10 - Violencia/ocupaciones: chi2 entre hombres y mujeres
*Empleados de oficina expuestos a violencia:  
*Trabajadores no calificados exp. a violencia: 
svy, subpop(mujer): tab ocuprev_xi_am277 NAQ_sum_ROC3, row
svy, subpop(hombre): tab ocuprev_xi_am277 NAQ_sum_ROC3, row

svy, subpop(mujeres): tab vul NAQ_sum_ROC3, row label
svy, subpop(hombre): tab vul NAQ_sum_ROC3, row label


*entre mujeres y hombres vulnerables expuestos a violencia
gen vul_hm= vul
replace vul_hm=.

replace vul_hm = 1 if vul==1 & mujer==1
replace vul_hm = 2 if vul==1 & mujer==0
tab vul_hm

svy: tab vul_hm NAQ_sum_ROC3, row label


*Mujeres expuestas a liderazgos Laissez Faire: 47% expuestas a violencia
*Mujeres no expuestas a lid. Laissez Faire: 27,9% expuestas a violencia
svy, subpop(mujer): tab LF_Leyman NAQ_sum_ROC3, row label
*Hombres expuestos a liderazgos Laissez Faire: 37,3% expuestos a violencia
*Hombres no expuestos a liderazgos L.F.: 25,2 % expuestos a violencia
svy, subpop(hombre): tab LF_Leyman NAQ_sum_ROC3, row label
*Mujeres expuestas a liderazgos  Autoritarios: 68,5% expuestas a violencia
*Mujeres no expuestas a líder. Autoritarios: 25,4% expuestas a violencia
svy, subpop(mujer): tab LA_Leyman NAQ_sum_ROC3, row label
*Hombres expuestos a líderazgos Autoritarios: 58% expuestos a violencia
*Hombres no expuestos a líder. Autoritarios: 23,1% expuestos a violencia
svy, subpop(hombre): tab LA_Leyman NAQ_sum_ROC3, row label
*Mujeres expuestas a liderazgos constructivos: 29,4% expuestas a violencia
*Mujeres no expuestas a líder. constructivos: 41,4%  expuestas a violencia
svy, subpop(mujer): tab LC_Leyman NAQ_sum_ROC3, row label
*Hombres expuestos a liderazgos constructivos: 24,8% expuestos a violencia
*Hombres no expuestos a liderazgos constructivos: 39%  expuestos a violencia
svy, subpop(hombre): tab LC_Leyman NAQ_sum_ROC3, row label

*8.	Entre hombres y mujeres expuestos a liderazgos LF, autoritarios y constructivos expuestos a violencia
gen LF_Leyman_hm= LF_Leyman
replace LF_Leyman_hm=.

replace LF_Leyman_hm = 1 if LF_Leyman==1 & mujer==1
replace LF_Leyman_hm = 2 if LF_Leyman==1 & mujer==0
tab LF_Leyman_hm

svy: tab LF_Leyman_hm NAQ_sum_ROC3, row label

gen LA_Leyman_hm= LA_Leyman
replace LA_Leyman_hm=.

replace LA_Leyman_hm = 1 if LA_Leyman==1 & mujer==1
replace LA_Leyman_hm = 2 if LA_Leyman==1 & mujer==0
tab LA_Leyman_hm

svy: tab LA_Leyman_hm NAQ_sum_ROC3, row label count

gen LC_Leyman_hm= LC_Leyman
replace LC_Leyman_hm=.

replace LC_Leyman_hm = 1 if LC_Leyman==1 & mujer==1
replace LC_Leyman_hm = 2 if LC_Leyman==1 & mujer==0
tab LC_Leyman_hm

svy: tab LC_Leyman_hm NAQ_sum_ROC3, row label



*Mujeres perciben clima sexista: 69% expuestas a violencia 
*Hombres perciben clima sexista: 51% expuestos a violencia
svy, subpop(mujer): tab climasex NAQ_sum_ROC3, row label
svy, subpop(hombre): tab climasex NAQ_sum_ROC3, row label

*Mujeres que perciben clima sexista y hombres que perciben clima sexista y están expuestos a violencia.

gen climasex_hm= climasex
replace climasex_hm=.

replace climasex_hm = 1 if climasex==1 & mujer==1
replace climasex_hm = 2 if climasex==1 & mujer==0
tab climasex_hm

svy: tab climasex_hm NAQ_sum_ROC3, row label

  foreach s of varlist vul_hm LF_Leyman_hm LA_Leyman_hm LC_Leyman_hm climasex_hm  {
  foreach v of varlist NAQ_sum_ROC3 {
		estpost svy: tab `s' `v', elabels count row format(%9,3g)
		estadd sca Vsvy=(sqrt(e(cun_Pear)/(e(N)*min((e(r)-1),(e(c)-1)))))
		esttab .  using "chi2__ROC_sexo_15_8_19.html", cell("count(fmt(%9,0fc)) row(fmt(%9,3fc))") ///
		legend label scalars(F_Pear p_Pear Vsvy) nostar unstack mtitle(`e(colvar)') ///
		addnotes(`s' "por" `v') sfmt(%15,3g) plain ///
		append
  } 
 }
