use "G:\Mi unidad\6.TESIS 2018\_BASE DEF_FINAL\BASDEF_FINAL\12_10_18\BD_22_10_18_lab_cul_org.dta", clear
use "C:\Users\andre\Google Drive\DOCUMENTOS\6.TESIS 2018\_BASE DEF_FINAL\BASDEF_FINAL\12_10_18\BD_22_10_18_lab_cul_org.dta", clear
cd "G:\Mi unidad\6.TESIS 2018\_BASE DEF_FINAL\BASDEF_FINAL\01_02_19"
***************CREAR VARIABLES  Y DEFINIR DISEÑO**************************************************
*******************************************************************************
. net install http://www.stata.com/users/kcrow/tab2xl, replace
. net install http://www.stata.com/users/kcrow/tab2docx
ssc install estout
*http://repec.org/bocode/e/estout/estpost.html#estpost122

set dp comma
svyset [pw=weight]

*para sacar subpop hombre y mujer
gen hombre = mujer
recode hombre 0=1 1=0

*problema con variable AUTONAQ
drop autonaq
gen autonaq = A21
recode autonaq 99=.
tab autonaq

*creo la variable apra saber si trabaja en el sector privado del resto.
gen SECT_PRIV = A4
recode SECT_PRIV 2=1 88=. 99=. 1=0 3=0 4=0

*Existencia de Organización Sindical o Gremial (1=No)
recode A40 (1=0) (0=1) (88=.) (99=.), gen (org_sind) label(A40)

*DER
recode recompensa (min/17=1 "Baj recompensa") (18/max=0 "Alta recompensa"), gen(bajarecompensa)
recode esfuerzo(min/7=0 "Baj esfuerzo") (8/max=1 "Alto esfuerzo"), gen(altoesfuerzo)

*Variable seleccionada para medir GSE.
gen gse_ac3 = gse 
recode gse_ac3 1/3=1 4/5=2

**OCUPREV
recode A2 (99=.), gen(superv) label (A2)
recode ocuprev (5=5 "Vendedores"), gen (ocuprev_rec) label(ocuprev)
*la categoria 5 corresponde s vendedores igual que en Araucaria. Se equivocaton al etiquetar.

*Variable seleccionada para hacer categorización.
gen prev3 = ocuprev_rec
recode prev3 (6=1) (9=1) (4=2) (8=2) (5=2) (1=2) (2=2)(3=1) (7=1)

*ZOna. Importante-
zona

*ver la distribución de la variable no recodificacda
svy: tab A37_1, obs
tab A37_1 [iw=weight]
svy: tab A37_2, obs
tab A37_2 [iw=weight]
svy: tab A37_3, obs
tab A37_3 [iw=weight]

hist A37_1 
hist A37_2 
hist A37_3

*hago unas variables en las que sólo veo extremos
drop culorg1_ext culorg2_ext culorg3_ext
gen culorg1_ext=A37_1
recode culorg1_ext 1/2=0 3/4=. 5/6=1

svy: tab culorg1_ext, obs
tab culorg1_ext [iw=weight]

gen culorg2_ext=A37_2
recode culorg2_ext 1/2=0 3/4=. 5/6=1

svy: tab culorg2_ext, obs
tab culorg2_ext [iw=weight]

gen culorg3_ext=A37_3
recode culorg3_ext 1/2=0 3/4=. 5/6=1

svy: tab culorg3_ext, count
tab culorg3_ext [iw=weight]

**Marzo 2019- ACTUALIZACION

recode A37_1 1/2=0 3/4=1 5/6=0, gen(proc_res) label(Procesos Resultados Ext Int)

recode A37_2 1/2=0 3/4=1 5/6=0, gen (bienst_tarea) label(Bienestar Tarea Ext Int)

recode A37_3 1/2=0 3/4=1 5/6=0, gen (laxo_estr) label(Control Laxo Estricto Ext Int)

*DER
gen Desbalance_Esfuerzo_Recompensa = esfuerzo/ (recompensas * 0.4285)
recode Desbalance_Esfuerzo_Recompensa (min/1=0 "Balance Esf-Rec") (1/max=1 "DER"), gen(DER)

***********************************************************************
**sacado de do_andres 290918 usando paper profe
* no funciona hacerlo con ninguno,probaré haciendo una variable
tab esfqueb[iw=pesofin]
_pctile esfqueb [pweight=pesofin], p(25 50 75)
return list
gen esfqueb2=esfqueb
recode esfqueb2 min/13=1 14=2 15/16=3 17/max=4
drop esfqueb2

*probaré haciendo otra variable
tab esfuerzo [iweight=pesofin]
_pctile esfuerzo [pweight=pesofin], p(25 50 75)
return list
gen esfuerzo2=esfuerzo
recode esfuerzo2 min/7=1 8=2 9=3 10/max=4
 mlogit  esfuerzo2 k6dic[iw=pesofin], base(4) rrr
*tampoco me funciona, no se parece al paper de la profe
*file:///C:/Users/andre/Google%20Drive/DOCUMENTOS/6.TESIS%202018/389C2~1.ANT/ANSOLE~1.PDF

*pruebo haciendo recompensas.
tab recompensa[iweight=pesofin]
_pctile recompensa [pweight=pesofin], p(25 50 75)
return list
gen recompensa2=recompensa
recode recompensa2 min/15=1 16/17=2 18/19=3 20/max=4
 mlogit  recompensa2 k6dic[iw=pesofin], base(4) rrr
*esta medida me hace un poco más de sentido, pero no sé si es suficiente, 
* todavía no calza con la publicación de la profesora

********************************MATRIZ POLICÓRICA******************************
*******************************************************************************

**para ver la estructura de los ítems
polychoric A37_1 A37_2 A37_3 [pweight=weight]
display r(sum_w) 
matrix r = r(R)
factormat r, n(1995) factors(2) pcf
estat factors
estat kmo 
estat smc
*factormat produces a factor analysis, by default using the principal-factor 
*method, although optionally using the principle-component factor method

*Indeed, factormat ..., pcf entails the extraction 
*criterion of minimal eigenvalues of 1 by default under option pcf.
*principal-component factor method be used to analyze the correlation matrix.  
*The communalities are assumed to be 1.
**
*** No tiene ningún sentido hacer un análisis factorial. 
**Hay poca unicidad de los factores (20%), casos Heywood (>1).

**********************************************LCA*******************************
********************************************************************************

******************************Dicotomizado*************************************
set seed 4345
forvalues i = 2/15{
quietly gsem(culorg1 culorg2 culorg3 <-) , mlogit lclass(C `i') nocapslatent iterate(1000) ///
startvalues(randomid, draws(50) seed(4345)) emopts(iter(20))
estimates save culorg_c`i' 
estat lcgof
}

estimates stats culorg_c2 culorg_c3 culorg_c4 culorg_c5 culorg_c6 culorg_c7 ///
culorg_c8 culorg_c9 culorg_c10 culorg_c11 culorg_c12 culorg_c13 culorg_c14 ///
culorg_c15
ereturn list

*reports the probabilities of class membership.
estat lcprob
*reports the estimated mean for each item in each class.
estat lcmean
margins
marginsplot
**NO FUNCIONA!!!!!!!!!!***


*******************************Extremos****************************************
*este sí funciona (https://www.stata.com/manuals/semexample50g.pdf)
set seed 4345
forvalues i = 2/15{
quietly gsem(A37_1 A37_2 A37_3 <-) , mlogit lclass(C `i') nocapslatent iterate(1000) ///
startvalues(randomid, draws(1) seed(4345)) 
estimates save culorg_ext_c`i' 
estat lcgof
}

*likelihood-ratio statistic is also known as the G2 statistic.
*p > chi2: We fail to reject the null hypothesis that our model fits 
*as well as the saturated model.
estat lcgof
*If you don't get standard errors, that means the model has not converged 
*adequately - basically, you aren't sure (because Stata is not sure) 
*if you are at a global maximum of the likelihood function. 

*ahora COMPARAMOS CON LOS OTROS MODELOS, a ver qué pasa
estimates stats culorg_ext_c2 culorg_ext_c3 culorg_ext_c4 ///
	culorg_ext_c5 culorg_ext_c6 culorg_ext_c7 culorg_ext_c8 culorg_ext_c9 ///
	culorg_ext_c10 culorg_ext_c11 culorg_ext_c12 culorg_ext_c13 culorg_ext_c14 ///
	culorg_ext_c15
ereturn list

*Ahora comparo todos los modelos.
estimates dir
estimates stats _all

*NO SIRVE MUCHO, PORQUE ME ARROJA EL ÚLTIMO MODELO GENERADO.
*estimates replay culorg_ext_c6
*estimates restore
*estat lcgof
*set seed 4345
	
**solución estable.ESTE MODELO CALZA CASI IGUAL AL GENERADO POR R (POLCA).
set seed 4345
gsem(A37_1 A37_2 A37_3 <- ),  mlogit lclass(C 6) iterate(1000) ///
startvalues(randomid, draws(50) seed(4345)) emopts(iter(30))
estimates save culorg_ext_c6_FINAL_est
estat lcgof
set seed 4345
*¿qué significan los signos?, leer para saber draws y seed
*lcinvariant(none) o nonrtolerance
* https://www.statalist.org/forums/forum/general-stata-discussion/general/1422554-stable-solutions-gsem-lca-stata-15
*https://www.statalist.org/forums/forum/general-stata-discussion/general/1457868-replicating-masyn-s-latent-profile-models-stata-example-52g


* We recommend that you leave e(sample) set to 0.  But what if you really
*need to calculate that postestimation statistic? Well, you can get it, but
*you are going to take responsibility for setting e(sample) correctly.
*Here we just happen to know that all the foreign observariones were used, 
*so we can type

*Para rescatar las estimaciones realizadas.
*ESTE USE SÓLO SERVIRÁ EN LA BASE use "G:\Mi unidad\6.TESIS 2018\_BASE DEF_FINAL\
* BASDEF_FINAL\01_02_19\culorg 06-04- BD_05_02_19 (BD_22_10_18_lab_cul_org2).dta"
cd "G:\Mi unidad\6.TESIS 2018\CULTURA"
*defino donde será el entorno de trabajo.
estimates use "G:\Mi unidad\6.TESIS 2018\CULTURA\culorg_ext_c6_FINAL_est.ster"
*estimates describe "G:\Mi unidad\6.TESIS 2018\CULTURA\culorg_ext_c6_FINAL_est.ster"
estat lcgof

*The safe thing to do, however, is to look at the estimation command --
*estimates describe will show it to you -- and then type
estimates describe
 estimates describe using culorg_ext_c6_FINAL_est
estimates esample

*If all the observations had been used, we could simply type
estimates esample:
 
*the estimation of standard errors for marginal means and marginal probabilities can be timeconsuming
*with large models. If you are interested only in the means and probabilities, you can
*specify the nose option with estat lcmean and estat lcprob to speed up estimation. With this
*option, no standard errors, test statistics, or confidence intervals are reported.
*reports the probabilities of class membership.
estat lcprob, nose post
*reports the estimated mean for each item in each class.
*estimates esample: (note the colon) resets e(sample). Puede necesitarse una vez que se 
*cargan los archivos
estat lcmean
estat lcmean, nose post
margins
marginsplot

predict classprior*, classpr
predict classpost*, classposteriorpr
 *We can determine the expected class for each individual based 
 *on whether the posterior probability is greater than 0.5
 
 forvalues i = 1/6{
generate expclass_CULORG_final_`i' = (classpost`i'>0.5)
tab expclass_CULORG_final_`i'
}


*para sacar entropía. Funciona una vez haciendo el modelo.
*https://www.statalist.org/forums/forum/general-stata-discussion/general/1412686-calculating-entropy-for-lca-latent-class-analysis-in-stata-15/page3
quietly predict classpost* if e(sample) == 1, classposteriorpr
unab myvars : classpost*
local count : word count `myvars'
forvalues k = 1/`count' {       
 quietly gen sum_p_lnp_`k' = classposte`k'*ln(classpost`k') if e(sample) == 1
 }
quietly egen sum_p_lnp = rowtotal(sum_p_lnp_*) if e(sample) == 1
summ sum_p_lnp, meanonly
local sum = r(sum)
quietly count if !missing(sum_p_lnp) & e(sample) == 1
scalar Entropy = 1+`sum'/(r(N)*ln(`count'))
drop sum_p_lnp*
display Entropy 

*para sacar LMR 
*https://www.statalist.org/forums/forum/general-stata-discussion/general/1412686-calculating-entropy-for-lca-latent-class-analysis-in-stata-15/page3
program lmrtest, rclass
version 15.0
args estimates_null estimates_alternative
tempname n ll_null ll_alt parms_null parms_alt a classes_null classes_alt lr_test_stat modlr_test_stat p q
quietly {
estimates restore `1'
scalar `n' = e(N)
scalar `ll_null' = e(ll)
scalar `parms_null' = e(K)
matrix `a' = e(lclass_k_levels)
scalar `classes_null' = `a'[1,1]
estimates restore `2'
scalar `ll_alt' = e(ll)
scalar `parms_alt' = e(K)
matrix `a' = e(lclass_k_levels)
scalar `classes_alt' = `a'[1,1]
scalar `p' = (3 * `classes_alt' - 1)
scalar `q' = (3 * `classes_null' - 1)
scalar `lr_test_stat' = -2 * (`ll_null' - `ll_alt')
scalar `modlr_test_stat' = `lr_test_stat' / (1 + ((`p' - `q') * ln(`n')) ^ -1)
}
return scalar lmrt_p = chi2tail(`parms_alt' - `parms_null',`modlr_test_stat')
end

*program drop lmrtest
lmrtest culorg_ext_c6_FINAL_est


*********************************CLUSTER HECHOS*****************************************


**Parte descriptiva
forvalues i = 1/6{
tab1 A37_1 A37_2 A37_3 if expclass_CULORG_final_`i'== 1 [iweight=weight]
	}
	
forvalues i = 1/6{
tab1 culorg1 culorg2 culorg3 if expclass_CULORG_final_`i'== 1 [iweight=weight]
	}


forvalues i = 1/6{
tab1 proc_res bienst_tarea laxo_estr if expclass_CULORG_final_`i'== 1 [iweight=weight]
	}

*Ahora veo diferencias por sexo
forvalues i = 1/6{
  foreach v of varlist culorg1 culorg3 proc_res bienst_tarea laxo_estr {
	estpost svy: tab `v' mujer if expclass_CULORG_`i'== 1,count col format(%9,3g)
	esttab .  using "culorg_clus_sexo_final.html", cell("col(fmt(%9,3fc))") ///
	scalars(F_Pear p_Pear) nostar unstack mtitle(`e(colvar)') ///
	addnotes(`v' " por " `i') sfmt(%15,3g) plain ///
	append

 } 
 
 foreach i in 1 3 4 5 6{
  foreach v of varlist culorg2 {
	estpost svy: tab `v' mujer if expclass_CULORG_`i'== 1,count col format(%9,3g)
	esttab .  using "culorg_clus_sexo6.html", cell("count(fmt(%9,0fc)) col(fmt(%9,3fc))") ///
	scalars(F_Pear p_Pear) nostar unstack mtitle(`e(colvar)') ///
	addnotes(`v' " por " `i') sfmt(%15,3g) plain ///
	append
  } 
 } 
 **IMPORTANTE
 *Para hacer  una variable que agrupe a los cluster.
foreach culorg_clus of varlist expclass_CULORG_final_* {
	recode `culorg_clus' 0=., gen (rec_`culorg_clus')
	}
egen cluster_final = concat(rec_expclass_CULORG_final_*)
encode cluster_final, generate(cluster_rec_final)
recode cluster_rec (1=.) (2=6 "clus 6") (3=5 "clus 5") (4=4 "clus 4") (5=3 "clus 3") (6=2 "clus 2") (7=1 "clus 1"), gen (cluster_rec2_final)


*vEMOS LAS VARIABLES DE INTERÈS por las caviarbles de CUltura
  foreach s of varlist cluster_rec2{
  foreach v of varlist culorg1 culorg2 culorg3 proc_res bienst_tarea laxo_estr{
	estpost svy: tab `v' `s',col format(%9,3g)
	estadd sca Vsvy=(sqrt(e(cun_Pear)/(e(N)*min((e(r)-1),(e(c)-1)))))
	esttab .  using "chi2_clus_cultura.html", cell("col(fmt(%9,3fc))") ///
	scalars(F_Pear p_Pear Vsvy )  ///
	nostar unstack mtitle(`e(colvar)') ///
	addnotes(`v' " por " `s') sfmt(%15,3g) plain ///
	append
  } 
 }
*vEMOS LAS VARIABLES DE INTERÈS 15-04-19
  foreach sex of varlist mujer hombre{
  foreach s of varlist cluster_rec2{
  foreach v of varlist autonaq NAQ_Leyman NAQ_MyE NAQ_A k2_elevado ///
	depre psicotrop tenpsi iso desbalance_dic LF_Leyman LA_Leyman LC_Leyman vul ///
	prev3 gse_ac3 zona {
	estpost svy, subpop(`sex'): tab `v' `s',col format(%9,3g)
	estadd sca Vsvy=(sqrt(e(cun_Pear)/(e(N)*min((e(r)-1),(e(c)-1)))))
	esttab .  using "chi2_V_clus2.html", cell("col(fmt(%9,3fc))") ///
	scalars(F_Pear p_Pear Vsvy )  ///
	nostar unstack mtitle(`e(colvar)') ///
	addnotes(`v' " por " `s') sfmt(%15,3g) plain ///
	append
  } 
 }
}

proc_res  bienst_tarea laxo_estr

*************************************Chi- por Sexo****************************
******************************************************************************

*faltan las siguientes variables: precr1 DER 
*podrían añadarise las del GSE

  foreach sex of varlist mujer hombre{
  foreach s of varlist culorg1 culorg2 culorg3 culorg1_ext culorg2_ext culorg3_ext {
  foreach v of varlist autonaq NAQ_Leyman NAQ_MyE NAQ_A k2_elevado depre ///
		psicotrop democ_dic aposoc_tot latdec_dic tenpsi iso salgen climasex /// 
		org_sind prec1 politrab desempleo vul prec2 ///
		SECT_PRIV auditc estrechez atpub /// 
		LF_Leyman LA_Leyman LC_Leyman A22 {
	estpost svy, subpop(`sex'): tab `v' `s',count col format(%9,3g)
	esttab .  using "F:/chi22.html", cell("count(fmt(%9,0fc)) col(fmt(%9,3fc))") ///
	scalars(F_Pear p_Pear V )  ///
	nostar unstack mtitle(`e(colvar)') ///
	addnotes(`v' " por " `s') sfmt(%15,3g) plain ///
	append
  } 
 }
}


*Si se quiere añadir el Cramer's V
*https://books.google.cl/books?id=c39ZDwAAQBAJ&pg=PA121&lpg=PA121&dq=svy+tab+cramer+v&source=bl&ots=U_vU9grg3c&sig=ACfU3U0tdrCMd9nBBAIOg6hE0vYrV7TMYQ&hl=es-419&sa=X&ved=2ahUKEwi66PHm-ZXhAhUiIbkGHaDjDXEQ6AEwBXoECAkQAQ#v=onepage&q=svy%20tab%20cramer%20v&f=false
  foreach sex of varlist mujer hombre{
  foreach s of varlist culorg1 culorg2 culorg3 proc_res bienst_tarea laxo_estr{
  foreach v of varlist autonaq NAQ_Leyman NAQ_MyE NAQ_A k2_elevado depre ///
		psicotrop democ_dic aposoc_tot latdec_dic tenpsi iso salgen ///
		altoesfuerzo bajarecompensa desbalance_dic ///
		org_sind prec1 politrab desempleo vul prec2 ///
		SECT_PRIV auditc estrechez atpub /// 
		ocuprev_rec antiguedad politrab climasex ///
		jef_hogar zona Edad ///
		A22 agr_fisica acos_sex testigo ///
		LF_Leyman LA_Leyman LC_Leyman {
	estpost svy, subpop(`sex'): tab `v' `s',count col format(%9,3g)
	estadd sca Vsvy=(sqrt(e(cun_Pear)/(e(N)*min((e(r)-1),(e(c)-1)))))
	esttab .  using "chi2_V2.html", cell("count(fmt(%9,0fc)) col(fmt(%9,3fc))") ///
	scalars(F_Pear p_Pear Vsvy )  ///
	nostar unstack mtitle(`e(colvar)') ///
	addnotes(`v' " por " `s') sfmt(%15,3g) plain ///
	append
  } 
 }
}

  foreach sex of varlist mujer hombre{
  foreach s of varlist culorg1 culorg2 culorg3 proc_res bienst_tarea laxo_estr{
  foreach v of varlist prev3 gse_ac3 zona {
	estpost svy, subpop(`sex'): tab `v' `s',count col format(%9,3g)
	estadd sca Vsvy=(sqrt(e(cun_Pear)/(e(N)*min((e(r)-1),(e(c)-1)))))
	esttab .  using "chi2_V22.html", cell("count(fmt(%9,0fc)) col(fmt(%9,3fc))") ///
	scalars(F_Pear p_Pear Vsvy )  ///
	nostar unstack mtitle(`e(colvar)') ///
	addnotes(`v' " por " `s') sfmt(%15,3g) plain ///
	append
  } 
 }
}
 
*********************************************************************
*Genero la solicitud del profesor, cultura por sexo

  foreach v of varlist culorg1 culorg2 culorg3 proc_res bienst_tarea laxo_estr {
	estpost svy: tab `v' mujer,count col format(%9,3g)
	estadd sca Vsvy=(sqrt(e(cun_Pear)/(e(N)*min((e(r)-1),(e(c)-1)))))
	esttab .  using "chi2_V22.html", cell("count(fmt(%9,0fc)) col(fmt(%9,3fc))") ///
	scalars(F_Pear p_Pear Vsvy )  ///
	nostar unstack mtitle(`e(colvar)') ///
	addnotes(`v' " por " `s') sfmt(%15,3g) plain ///
	append
  } 

*********************************************************************
foreach sexo of varlist hombre mujer {
	svy, subpop(`sexo'): mlogit precr1 b0.NAQ_MyE b0.k2_elevado b0.depre b0.psicotrop b0.iso b0.DER ///
			, or
			esttab .  using "E:/svylogit_stata2.html", cells ("b(star fmt(3)) se(par fmt(2)) p(fmt(3)) ci_l ci_u") eform ///
			stats(F df_m p r2 N, fmt(2)) style(fixed) drop(0.*) ///
				addnotes("tenpsi_2 por" `sexo'"; Exponentiated coefficients") sfmt(%15,3g) plain ///
				append
		  } 

*********************************************************************

melogit NAQ_MyE || cluster_rec2:, [iw=weight]
svy: melogit NAQ_MyE || gse_ac3:

*survey final weights not allowed with multilevel models; a final weight ///
*variable was svyset using the [pw=exp] syntax, but multilevel models /// 
*require that each stage-level weight variable is svyset using the stage's 
*corresponding weight() option. an error occurred when svy executed melogit

**No se puedee ocupar con survey

*GSE puede ser una opción
xtmelogit NAQ_MyE || cluster_rec2:, var or
estat1 icc

*ocuprev_rec también
xtmelogit NAQ_MyE || ocuprev_rec:, var
estat icc

xtmelogit NAQ_MyE cluster_rec2|| zona:, var
estat icc

*El iCC es el porcentaje de la varianza total, proporción de la correlación 
*entre las escuelas.
*En general es bajo para NAQ-MyE y LA Leyman


estat ic

*también lo puedo comparar con otros modelos.
est store logit

est store melogit

 lrtest melogit logit, force
 hausman melogit logit
 
 *we reject the null hypothesis that the unobserved
*individual level effects are uncorrelated with the other covariates.  This
*implies that we should use the fixed-effects estimator instead of the
*random-effects estimator.
 
 
 
xtmelogit bieber gpa_cmc teacher_fan_c || classes:, var
display "FYI: The deviance of the CIM is:" -2*e(ll)
estimate save CIM
 
**********************************************************************
************************MODELO JERÀRQUICO*****************************
logit NAQ_MyE k2_elevado depre psicotrop tenpsi LF_Leyman LA_Leyman, or
est save logit

xtmelogit NAQ_MyE k2_elevado depre psicotrop tenpsi LF_Leyman LA_Leyman || cluster_rec2:, var iweight(weight) or
est save melogit

display "FYI: The deviance of the CIM is:" -2*e(ll)
estimate store CIM
estat icc

 lrtest melogit logit, force
 hausman melogit logit


**********************************************************************
*perturb is particularly useful for evaluating collinearity if interactions ///
*are present or nonlinear transformations of variables
perturb: mlogit cluster_rec2 NAQ_A k2_elevado depre psicotrop iso tenpsi [pweight = weight], poptions ( pvars(cluster_rec2) prange(0) pfactors(tenpsi) pcnttabs(96) )
bysort hombre: mlogit cluster_rec2 b0.autonaq b0.NAQ_MyE b0.k2_elevado /// 
b0.depre b0.desbalance_dic b0.vul b0.LA_Leyman b0.LF_Leyman [iw=weight], rrr base(2)

foreach sexo of varlist mujer hombre{
	svy, subpop(`sexo'): mlogit cluster_rec2 b0.autonaq b0.NAQ_MyE b0.k2_elevado b0.depre b0.desbalance_dic b0.vul ///
			b0.LA_Leyman b0.LF_Leyman, rrr base(2)
			esttab .  using "svymlogit_stata_svy6.html", cells ("b(star fmt(3)) se(par fmt(2)) p(fmt(3)) ci_l ci_u") eform ///
			stats(F df_m p r2 N, fmt(2)) style(fixed) drop(0.*) ///
				addnotes("cluster" `sexo'"; Exponentiated coefficients") sfmt(%15,3g) plain ///
				append
			listcoef 1.autonaq,  pvalue(.05) percent help
			listcoef 1.NAQ_MyE,  pvalue(.05)  percent  help
			listcoef 1.depre, pvalue(.05)  percent help
			listcoef 1.desbalance_dic, pvalue(.05)  percent help
			listcoef 1.LA_Leyman, pvalue(.05)  percent help  //* sólo en el caso de 
			listcoef 1.LF_Leyman, pvalue(.05)  percent help //*sólo en el caso de mujeres
			mlogtest, all
			mlogtest, wald set(1.autonaq 1.NAQ_MyE 1.k2_elevado 1.depre 1.vul 1.LA_Leyman 1.LF_Leyman)
			estimates store modelo1`sexo'
		  } 
		  
		   
*listcoef, con p value, muestra sólo las significativas. Sólo ver los Wald. Para 
*ver el efecto en cada variable, más allá de las restricciones propias de la comparación
*con el modelo base.

*Wald test, at least in theory, approximate the lr test

*mlogtest,wald Wald tests for independent variables 
* Si las variables independientes diferencian pares de categorías del outcome usando
*el test de Wald-.
* A partir de mlogtest, wald, concluimos que todas las variables, salvo DER no son
*estadísticamente significativas y podrían potencialmente ser botadas (aunque algunas
*se relacionen específicamente con algún grupo).  

* Wald tests for combining alternatives: las categorías factibles de ser combinadas
* Si hay p significativos, significa que las variables explicativas 
*diferencian entre categorías de la dependiente

suest modelo1hombre modelo1mujer}

*información
margins autonaq NAQ_MyE depre, predict(outcome(1))
margins autonaq NAQ_MyE depre, predict(outcome(2))
margins autonaq NAQ_MyE depre, predict(outcome(3))
margins autonaq autonaq depre, predict(outcome(4))
margins autonaq NAQ_MyE depre, predict(outcome(5))
margins autonaq NAQ_MyE depre, predict(outcome(6))

*, some substance use studies are starting to use
*regression models to obtain PR as estimators of the association between a dichotomous dependent variable and several
*independent variables. In this sense, in substance abuse research some studies 
*have calculated PR to estimate which factors could be associated to illicit drug consumption (

*The PR is defined as the prevalence in exposed population divided
*by the prevalence in non-exposed, while OR is the odds of
*disease or condition among exposed individuals divided by
*the odds of disease or condition among unexposed. In this
*sense, in cross-sectional designs, when the dependent variable is dichotomous, we usually obtain the prevalence in the
*descriptive analysis and therefore, PR is more intuitive and
*easy to understand than OR. 

svy, subpop(mujer): glm desbalance_dic b2.cluster_rec2 autonaq,  family(binomial 1) link(log) eform
svy, subpop(hombre): glm desbalance_dic b2.cluster_rec2,  family(binomial 1) link(log) eform

svy, subpop(mujer): glm autonaq b2.cluster_rec2, family(poisson) link(log) eform
svy, subpop(hombre): glm autonaq b2.cluster_rec2, family(poisson) link(log) eform

*The proportion with prevalent disease among those exposed is the probability of 
*prevalent disease among the exposed, and similarly for the unexposed. We are 
*making this point to distinguish a ratio based on probabilities from a ratio based on odds.

foreach sexo of varlist mujer hombre{
foreach v of varlist autonaq NAQ_MyE k2_elevado /// 
	depre desbalance_dic vul LA_Leyman LF_Leyman {
	svy, subpop(`sexo'): glm `v' b2.cluster_rec2,  family(poisson) link(log) eform
				esttab .  using "pr_lca3.html", label cells ("b(star fmt(3)label(PR)) p(fmt(3)) ci(fmt(3)par label(CI95%))") eform keep(*cluster_rec2*) ///
				addnotes("cluster" `sexo'" por" `v'"; Exponentiated coefficients") sfmt(%15,3g) plain ///
				append
		  } 
		 }

*PARA VER LA PROBABILIDAD CONTROLANDO POR LAS OTRAS VARIABLES.
		 *autonaq
foreach sexo of varlist mujer hombre{
foreach v of varlist autonaq {
	svy, subpop(`sexo'): glm `v' b2.cluster_rec2 NAQ_MyE k2_elevado ///
			depre desbalance_dic vul LA_Leyman LF_Leyman,  family(poisson) link(log) eform
				esttab .  using "pr_lca_contr.html", label cells ("b(star fmt(3)label(PR)) p(fmt(3)) ci(fmt(3)par label(CI95%))") eform keep(*cluster_rec2*) ///
				addnotes("cluster_cont1" `sexo'" por" `v'"; Exponentiated coefficients") sfmt(%15,3g) plain ///
				append
		  } 
		 }

		 *NAQ_MyE
foreach sexo of varlist mujer hombre{
foreach v of varlist NAQ_MyE {
	svy, subpop(`sexo'): glm `v' b2.cluster_rec2 autonaq k2_elevado ///
			depre desbalance_dic vul LA_Leyman LF_Leyman,  family(poisson) link(log) eform
				esttab .  using "pr_lca_contr.html", label cells ("b(star fmt(3)label(PR)) p(fmt(3)) ci(fmt(3)par label(CI95%))") eform keep(*cluster_rec2*) ///
				addnotes("cluster_cont2" `sexo'" por" `v'"; Exponentiated coefficients") sfmt(%15,3g) plain ///
				append
		  } 
		 }

		 *k2_elevado
foreach sexo of varlist mujer hombre{
foreach v of varlist k2_elevado {
	svy, subpop(`sexo'): glm `v' b2.cluster_rec2 autonaq NAQ_MyE ///
			depre desbalance_dic vul LA_Leyman LF_Leyman,  family(poisson) link(log) eform
				esttab .  using "pr_lca_contr.html", label cells ("b(star fmt(3)label(PR)) p(fmt(3)) ci(fmt(3)par label(CI95%))") eform keep(*cluster_rec2*) ///
				addnotes("cluster_cont3" `sexo'" por" `v'"; Exponentiated coefficients") sfmt(%15,3g) plain ///
				append
		  } 
		 }
		 
		 *depre
foreach sexo of varlist mujer hombre{
foreach v of varlist depre {
	svy, subpop(`sexo'): glm `v' b2.cluster_rec2 autonaq NAQ_MyE ///
			k2_elevado desbalance_dic vul LA_Leyman LF_Leyman,  family(poisson) link(log) eform
				esttab .  using "pr_lca_contr.html", label cells ("b(star fmt(3)label(PR)) p(fmt(3)) ci(fmt(3)par label(CI95%))") eform keep(*cluster_rec2*) ///
				addnotes("cluster_cont4" `sexo'" por" `v'"; Exponentiated coefficients") sfmt(%15,3g) plain ///
				append
		  } 
		 }	
		 
		 *desbalance_dic
foreach sexo of varlist mujer hombre{
foreach v of varlist desbalance_dic {
	svy, subpop(`sexo'): glm `v' b2.cluster_rec2 autonaq NAQ_MyE ///
			k2_elevado depre vul LA_Leyman LF_Leyman,  family(poisson) link(log) eform
				esttab .  using "pr_lca_contr.html", label cells ("b(star fmt(3)label(PR)) p(fmt(3)) ci(fmt(3)par label(CI95%))") eform keep(*cluster_rec2*) ///
				addnotes("cluster_cont5" `sexo'" por" `v'"; Exponentiated coefficients") sfmt(%15,3g) plain ///
				append
		  } 
		 }			
		 
		 *vul
foreach sexo of varlist mujer hombre{
foreach v of varlist vul {
	svy, subpop(`sexo'): glm `v' b2.cluster_rec2 autonaq NAQ_MyE ///
			k2_elevado depre desbalance_dic LA_Leyman LF_Leyman,  family(poisson) link(log) eform
				esttab .  using "pr_lca_contr.html", label cells ("b(star fmt(3)label(PR)) p(fmt(3)) ci(fmt(3)par label(CI95%))") eform keep(*cluster_rec2*) ///
				addnotes("cluster_cont6" `sexo'" por" `v'"; Exponentiated coefficients") sfmt(%15,3g) plain ///
				append
		  } 
		 }		
		 
		 *LA_Leyman
foreach sexo of varlist mujer hombre{
foreach v of varlist LA_Leyman {
	svy, subpop(`sexo'): glm `v' b2.cluster_rec2 autonaq NAQ_MyE ///
			k2_elevado depre desbalance_dic vul LF_Leyman,  family(poisson) link(log) eform
				esttab .  using "pr_lca_contr.html", label cells ("b(star fmt(3)label(PR)) p(fmt(3)) ci(fmt(3)par label(CI95%))") eform keep(*cluster_rec2*) ///
				addnotes("cluster_cont7" `sexo'" por" `v'"; Exponentiated coefficients") sfmt(%15,3g) plain ///
				append
		  } 
		 }		 
		 		 
		 *LF_Leyman
foreach sexo of varlist mujer hombre{
foreach v of varlist LF_Leyman {
	svy, subpop(`sexo'): glm `v' b2.cluster_rec2 autonaq NAQ_MyE ///
			k2_elevado depre desbalance_dic vul LA_Leyman,  family(poisson) link(log) eform
				esttab .  using "pr_lca_contr.html", label cells ("b(star fmt(3)label(PR)) p(fmt(3)) ci(fmt(3)par label(CI95%))") eform keep(*cluster_rec2*) ///
				addnotes("cluster_cont8" `sexo'" por" `v'"; Exponentiated coefficients") sfmt(%15,3g) plain ///
				append
		  } 
		 }		
		 
svy, subpop(mujer): glm desbalance_dic b2.cluster_rec2 autonaq,  family(poisson) link(log) eform
svy, subpop(hombre): glm desbalance_dic b2.cluster_rec2,  family(binomial 1) link(log) eform

*value of the binomial denominator N, the number of trials.
*Specifying ^family(binomial 1)^ is the same as specifying ^family(binomial)^; both
*mean that y has the Bernoulli distribution with values 0 and 1 only.
