set dp period

***Paper Validación***
net install oparallel.pkg, from (http://fmwww.bc.edu/RePEc/bocode/o/)
net install spost13_ado.pkg, from (http://www.indiana.edu/~jslsoc/stata/)
net install st0208.pkg, from (http://www.stata-journal.com/software/sj10-4/)
net install st0491.pkg, from (http://www.stata-journal.com/software/sj17-3/)
net install  st0099_1.pkg, from (http://www.stata-journal.com/software/sj10-2/)
net install gologit2.pkg, from (http://fmwww.bc.edu/RePEc/bocode/g/)
net install outreg2.pkg, from (http://fmwww.bc.edu/RePEc/bocode/o/)
ssc install estout, replace
ssc install alphawgt
ssc install cutpt
ssc install logout

*************************************************************************************
egen NAQ_R_AF_sum= rowtotal(NAQ8 NAQ9 NAQ22)
egen NAQ_R_AP_sum= rowtotal(NAQ2 NAQ4 NAQ5 NAQ6 NAQ7 NAQ10 NAQ11 NAQ12 NAQ13 NAQ15 NAQ17 NAQ20)
egen NAQ_R_RT_sum= rowtotal(NAQ1 NAQ3 NAQ14 NAQ16 NAQ18 NAQ19 NAQ21)

egen LID_DES_sum= rowtotal(LID_DES5 LID_DES7 LID_DES9 LID_DES1 LID_DES4 LID_DES8 LID_DES10)
gen prec_paper = prec1 + prec2 + prec3 + prec5 + prec6 + prec7 + prec8 + prec9
egen latdec_paper = rowtotal(A18_top_1 A18_top_2 A18_top_3  A18_top_4 A18_top_5)
egen democ_paper = rowtotal(A18_top_6 A18_top_7 A18_top_8 A18_top_9 A18_top_10 A19_top_1 A19_top_2 A19_top_3 A19_top_4)

summarize latdec_paper[aweight=weight], detail
summarize prec_paper[aweight=weight], detail
summarize satis[aweight=weight], detail
summarize latdec_paper [aweight=weight], detail
summarize democ_paper [aweight=weight], detail

egen LF2= rowtotal(LID_DES5 LID_DES7 LID_DES9)
egen LC2= rowtotal(LID_DES6 LID_DES11 LID_DES12 LID_DES14)

egen ACOSO_TEN_DIST= rowtotal(autonaq tenpsi k2_elevado)
recode ACOSO_TEN_DIST 0/1=0 2/max=1

gen LF_rec_logit= LF_rec
recode LF_rec_logit 0=0 1=1 2/max=2
tab LF_rec_logit
label var LF_rec_logit "OCM OLR Lid. Laissez-Faire"
gen LA_rec_logit=LA_rec
recode LA_rec_logit 0=0 1=1 2/max=2
tab LA_rec_logit
label var LA_rec_logit "OCM OLR Lid. Aut."
gen LC_rec_logit=LC_rec
recode LC_rec_logit 2/max=0 1=1 0=2
tab LC_rec_logit
label var LC_rec_logit "OCM OLR Lid. Cons.(rev)"

gen NAQ_Dic_logit = NAQ_Dic
recode NAQ_Dic_logit 0=0 1=1 2/max=2
tab NAQ_Dic_logit
label var NAQ_Dic_logit "OCM OLR NAQ-R"

*para generar variable dicotomizada sin tener que generar nuevas variables.
gen LID_DES_dic = 0
qui foreach v of var LID_DES5 LID_DES7 LID_DES9 LID_DES1 LID_DES4 LID_DES8 LID_DES10 {
    replace LID_DES_dic = LID_DES_dic + 1 if inlist(`v', 2, 3)
}
tab LID_DES_dic
recode LID_DES_dic (4/max= 4 "4 o más"), gen (LID_DES_Dic)
drop LID_DES_dic
label var LID_DES_Dic "OCM Dichotomized Des Leadership Sum"

gen LID_DES_Dic_logit = LID_DES_Dic
recode LID_DES_Dic_logit 0=0 1=1 2/max=2
tab LID_DES_Dic_logit
label var LID_DES_Dic_logit "OCM OLR LID_DES"

drop NAQ_sum_cuartil
recode NAQ_sum 0/0=0 1/4=1 5/10=2 11/max=3, gen(NAQ_sum_cuartil)
summarize NAQ_sum[aweight=weight], detail

recode LID_DES_sum 0=0 1/2=1 3/4=2 5/max=3, gen(LID_DES_sum_cuartil)
summarize LID_DES_sum[aweight=weight], detail

************************1******************************************
* Correlaciones
local mylist "NAQ_sum NAQ_R_AP_sum NAQ_R_RT_sum NAQ_R_AF_sum LC LA LF"
local mylist2 "NAQ_sum NAQ_R_AP_sum NAQ_R_RT_sum NAQ_R_AF_sum LA LC2 LF2 k6_2 latdec democ prec_paper satis"
correlate `mylist2' [weight=weight]
local mylist2 "NAQ_sum NAQ_R_AP_sum NAQ_R_RT_sum NAQ_R_AF_sum LA LC2 LF2 k6_2 latdec democ prec_paper satis"
logout, save("corr_25_03_descriptives_0") excel replace: pwcorr `mylist2' [w=weight], star(.05)
local mylist2 "NAQ_sum NAQ_R_AP_sum NAQ_R_RT_sum NAQ_R_AF_sum LA LC2 LF2 k6_2 latdec democ prec_paper satis"
logout, save("corr_14_03_descriptives25_3_1") excel replace: pwcorr `mylist2' [w=weight], star(.01)
local mylist2 "NAQ_sum NAQ_R_AP_sum NAQ_R_RT_sum NAQ_R_AF_sum LA LC2 LF2 k6_2 latdec democ prec_paper satis"
logout, save("corr_14_03_descriptives25_3_2") excel replace: pwcorr `mylist2' [w=weight], star(.001)

* Alpha, aunque no lo ocupo con pesos
alpha prec1 prec2 prec3 prec5 prec6 prec7 prec8 prec9, i
alpha A47_top_1 A47_top_2 A47_top_3 A47_top_4 A47_top_5 A47_top_6, i
alpha A18_top_6 A18_top_7 A18_top_8 A18_top_9 A18_top_10 A19_top_1 A19_top_2 A19_top_3 A19_top_4, i
alpha A18_top_1 A18_top_2 A18_top_3  A18_top_4 A18_top_5, i
alpha s1-s5, i

bysort mujer: alpha NAQ1-NAQ22,i
bysort mujer: alpha LID_DES1 LID_DES4 LID_DES8 LID_DES10 ///
					LID_DES5 LID_DES7 LID_DES9 ///
					LID_DES6 LID_DES11 LID_DES12 LID_DES14,i

alpha LID_DES1 LID_DES4 LID_DES8 LID_DES10, detail
alpha LID_DES3 LID_DES5 LID_DES7 LID_DES9, detail
alpha LID_DES5 LID_DES7 LID_DES9, detail
alpha LID_DES6 LID_DES11 LID_DES12 LID_DES14, detail

alphawgt LID_DES3 LID_DES5 LID_DES7 LID_DES9 [aweight=weight], detail

*Chi Cuadrado
 foreach s of varlist autonaq NAQ_Leyman NAQ_MyE NAQ_A {
  foreach v of varlist k2_elevado psicotrop depre ///
						LA_Leyman LF_Leyman LC_Leyman ///
						tenpsi satlab_rec climasex ///
						prec ///
						{
		estpost svy, subpop(mujer): tab `v' `s', count col format(%9,3g)
		esttab .  using "H:/chi2_validación_NAQ_M2.html", cell("count(fmt(%9,0fc)) col(fmt(%9,3fc))") ///
		scalars(F_Pear p_Pear) nostar unstack mtitle(`e(colvar)') ///
		addnotes(`predicho' " por " `v') sfmt(%15,3g) plain ///
		append
  } 
 } 
  foreach s of varlist autonaq NAQ_Leyman NAQ_MyE NAQ_A {
  foreach v of varlist k2_elevado psicotrop depre ///
						LA_Leyman LF_Leyman LC_Leyman ///
						tenpsi satlab_rec climasex ///
						prec ///
						{
		estpost svy, subpop(hombre): tab `v' `s', count col format(%9,3g)
		esttab .  using "H:/chi2_validación_NAQ_H2.html", cell("count(fmt(%9,0fc)) col(fmt(%9,3fc))") ///
		scalars(F_Pear p_Pear) nostar unstack mtitle(`e(colvar)') ///
		addnotes(`predicho' " por " `v') sfmt(%15,3g) plain ///
		append
  } 
 } 

 foreach s of varlist LA_Leyman LF_Leyman LC_Leyman {
  foreach v of varlist k2_elevado psicotrop depre ///
						tenpsi satlab_rec climasex prec ///
						{
		estpost svy, subpop(mujer): tab `v' `s', count col format(%9,3g)
		esttab .  using "H:/chi2_validación_DLS_M2.html", cell("count(fmt(%9,0fc)) col(fmt(%9,3fc))") ///
		scalars(F_Pear p_Pear) nostar unstack mtitle(`e(colvar)') ///
		addnotes(`predicho' " por " `v') sfmt(%15,3g) plain ///
		append
  } 
 } 
  foreach s of varlist LA_Leyman LF_Leyman LC_Leyman {
  foreach v of varlist k2_elevado psicotrop depre ///
						tenpsi satlab_rec climasex prec ///
						{
		estpost svy, subpop(hombre): tab `v' `s', count col format(%9,3g)
		esttab .  using "H:/chi2_validación_DLS_H2.html", cell("count(fmt(%9,0fc)) col(fmt(%9,3fc))") ///
		scalars(F_Pear p_Pear) nostar unstack mtitle(`e(colvar)') ///
		addnotes(`predicho' " por " `v') sfmt(%15,3g) plain ///
		append
  } 
 } 

  
 **************************************LINEAR REGRESSION*********************************
 *para ver el modelo y sus outputs
 ereturn list
  
 svy: regress NAQ_sum i.autonaq i.k2_elevado i. psicotrop i.tenpsi i.satlab_rec i.mujer i.climasex i.prec i.LF_Leyman ///
			i.LA_Leyman i.LC_Leyman					
		eststo modelnaq			
		
		esttab modelnaq  using "H:/reg_NAQ_linear_final.html", cells (b(star fmt(3)) se(par fmt(2)) ci_bc[ll] ci_bc[ul]) ///
		stats(F df_m p r2 N, fmt(2)) style(fixed) drop(0.*) ///
		append

**final
 svy: regress NAQ_sum i.autonaq i.k2_elevado i.tenpsi i.satlab_rec i.mujer ///
			i.climasex i.prec i.LF_Leyman i.LA_Leyman i.LC_Leyman 
		
		esttab . using "H:/reg_NAQ_linear_final_24_3.html", cells (b(star fmt(3)) se(par fmt(2)) ci_bc[ll] ci_bc[ul]) ///
		stats(F df_m p r2 N, fmt(2)) style(fixed) drop(0.*) ///
		append

 svy: regress LID_DES_sum i.autonaq i.k2_elevado i. psicotrop i.tenpsi i.satlab_rec i.mujer i.climasex i.prec i.NAQ_MyE
		eststo modeldls		
		
		esttab modeldls  using "H:/reg_LID_DES_linear_final.html", cells (b(star fmt(3)) se(par fmt(2)) ci_bc[ll] ci_bc[ul]) ///
		stats(F df_m p r2 N, fmt(2)) style(fixed) drop(0.*) ///
		append
		
**final
 svy: regress LID_DES_sum i.autonaq i.k2_elevado i.tenpsi i.satlab_rec ///
		i.mujer i.climasex i.prec i.NAQ_MyE
		eststo modeldls		
		
		esttab modeldls  using "H:/reg_LID_DES_linear_final.html", cells (b(star fmt(3)) se(par fmt(2)) ci_bc[ll] ci_bc[ul]) ///
		stats(F df_m p r2 N, fmt(2)) style(fixed) drop(0.*) ///
		append

  esttab, eform
  
  *The assumptions of homoskedasticity, normality, and independence ///
 *(e.g. no auto-correlation) are all assumptions needed for ordinary least squares. 
 *They are not needed for svy: regress, which bases its inference on the sample 
 *design (stratification and variation between primary sampling units) and is robust 
 *to violations of those assumptions
 
 *Collinearity has similar effects on survey estimators as in regular regression 
 *estat vif will produce VIFs after regress, but not after svy: regress. However 
 *the only part of the survey design that affects collinearity is the weights, 
 *so you can run regress with probability weights:
 regress NAQ_sum i.autonaq i.k2_elevado i. psicotrop i.tenpsi i.satlab_rec i.mujer i.climasex i.prec i.LF_Leyman ///
			i.LA_Leyman i.LC_Leyman	[pw = weight]
estat vif 

display "tolerance = " 1-e(r2) " VIF = " 1/(1-e(r2))

*NO CALZAN CON LOS ENTREGADOS EN R**** De todas formas reporto los 2. Unoc omo 
*la media y el otro son los in indicesdividuales
 
 * ver ajuste. que todos los parámetros sean 0 en test; en linktest.  the p-value for _hat is not important in judging the fit of the model.
linktest
test
 
**********************************1. ORDINAL LOGISTIC REG************************

*el paquete gologit2 se enmarca en modelos logicos ordinales generalizados.
*relaja el supuesto de paralelas, por eso se le llama "parcial" (Williams, 2005)
*s󬯠para sacar Wald test of parallel lines assumption for the final model
*An insignificant test statistic indicates that the final model
*does not violate the proportional odds/ parallel lines assumption.

*(si se quiere analizar efectos de alguna variable en cada nivel de la VD, ocupar la opci󮠧amma)

svyset [pw=weight]
		
foreach s of varlist LF_rec_logit LA_rec_logit LC_rec_logit NAQ_Dic_logit  {
		gsvy: gologit2 `s' i.k2_elevado, or autofit
		gsvy: gologit2 `s' i.tenpsi, or autofit
		gsvy: gologit2 `s' i.k2_elevado i.mujer i.climasex, or autofit
		gsvy: gologit2 `s' i.tenpsi i.mujer i.climasex, or autofit
		gsvy: gologit2 `s' i.k2_elevado i.mujer i.climasex i.prec, or autofit
		gsvy: gologit2 `s' i.tenpsi i.mujer i.climasex i.prec, or autofit
		  } 
		  
foreach s of varlist  LID_DES_Dic_logit NAQ_sum_cuartil LID_DES_sum_cuartil {
		gsvy: gologit2 `s' i.k2_elevado, or autofit
		gsvy: gologit2 `s' i.tenpsi, or autofit
		gsvy: gologit2 `s' i.k2_elevado i.mujer i.climasex, or autofit
		gsvy: gologit2 `s' i.tenpsi i.mujer i.climasex, or autofit
		gsvy: gologit2 `s' i.k2_elevado i.mujer i.climasex i.prec, or autofit
		gsvy: gologit2 `s' i.tenpsi i.mujer i.climasex i.prec, or autofit
		  } 
 **Se decide sacar los Dic Logit del NAQ y DLS porque en algunos casos no 
 **cumplían con la PL
		LF_rec_logit LA_rec_logit LC_rec_logit NAQ_sum_cuartil LID_DES_sum_cuartil
foreach s of varlist NAQ_Dic_logit{
		svy: ologit `s' i.k2_elevado, or
				esttab .  using "H:/svyolr_stata2.html", cells ("b(star fmt(3)) se(par fmt(2)) p(fmt(3)) ci") eform ///
				stats(F df_m p r2 N, fmt(3)) style(fixed) drop(0.*) ///
				addnotes("k2 por " `s' "; Exponentiated coefficients") sfmt(%15,3g) plain ///
				append
		svy: ologit `s' i.tenpsi, or
				esttab .  using "H:/svyolr_stata2.html", cells ("b(star fmt(3)) se(par fmt(2)) p(fmt(3)) ci") eform ///
				stats(F df_m p r2 N, fmt(2)) style(fixed) drop(0.*) ///
				addnotes("tenpsi por " `s'"; Exponentiated coefficients") sfmt(%15,3g) plain ///
				append
		svy: ologit `s' i.k2_elevado i.mujer i.climasex, or
				esttab .  using "H:/svyolr_stata2.html", cells ("b(star fmt(3)) se(par fmt(2)) p(fmt(3)) ci") eform ///
				stats(F df_m p r2 N, fmt(2)) style(fixed) drop(0.*) ///
				addnotes("k2_1 por 1" " por " `s'"; Exponentiated coefficients") sfmt(%15,3g) plain ///
				append
		svy: ologit `s' i.tenpsi i.mujer i.climasex, or
				esttab .  using "H:/svyolr_stata2.html", cells ("b(star fmt(3)) se(par fmt(2)) p(fmt(3)) ci") eform ///
				stats(F df_m p r2 N, fmt(2)) style(fixed) drop(0.*) ///
				addnotes("tenpsi_1 por " `s'"; Exponentiated coefficients") sfmt(%15,3g) plain ///
				append
		svy: ologit `s' i.k2_elevado i.mujer i.climasex i.prec, or
				esttab .  using "H:/svyolr_stata2.html", cells ("b(star fmt(3)) se(par fmt(2)) p(fmt(3)) ci") eform ///
				stats(F df_m p r2 N, fmt(2)) style(fixed) drop(0.*) ///
				addnotes("k2_2 por " `s'"; Exponentiated coefficients") sfmt(%15,3g) plain ///
				append
		svy: ologit `s' i.tenpsi i.mujer i.climasex i.prec, or
				esttab .  using "H:/svyolr_stata2.html", cells ("b(star fmt(3)) se(par fmt(2)) p(fmt(3)) ci") eform ///
				stats(F df_m p r2 N, fmt(2)) style(fixed) drop(0.*) ///
				addnotes("tenpsi_2 por" `s'"; Exponentiated coefficients") sfmt(%15,3g) plain ///
				append
		  }  

**********************************2. CALCULO COEF************************

*conste que el OR no se aplica para las SE. Tampoco tiene una medida de ajuste global adecuada
*el F del gologit2 no se parece al F de ologit(porque es una medida mⳠlaxa para el modelo generalizado)

*si se quiere mayor claridad de losvalores entregados
listcoef, help
*si se quiere predecir el recorrido de las probabilidades, manteniendo constantes otras
mtable, at (tenpsi = 1 ) rown(Tensi󮠐sica) dec(3)
*para predecir la v.d. en base a covariables
forvalues i = 0/2 {
margins, at(k2_elevado = 1 mujer = 1 climasex= 1) predict(outcome(`i'))}


*******************************************************************************
**************************************SVYGLM**************************************

label variable k2_elevado "Distres"
label variable tenpsi "Tension Psiquica"
label variable mujer "Mujer"
label variable climasex "Clima Sexista"
label variable prec "Precariedad"

*For example, if 80 out of 100 exposed subjects have a particular disease and 50 out of 100 non-exposed 
*subjects have the disease, then the odds ratio (OR) is (80/20)/(50/50) = 4. However, the prevalence 
*ratio (PR) is (80/100)/(50/100) = 1.6. The latter indicates that the exposed subjects are only 1.6 times 
*as likely to have the disease as the non-exposed subjects, and this is the number in which most people 
*would be interested.			

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

*The proportion with prevalent disease among those exposed is the probability of 
*prevalent disease among the exposed, and similarly for the unexposed. We are 
*making this point to distinguish a ratio based on probabilities from a ratio based on odds.

*value of the binomial denominator N, the number of trials.
*Specifying ^family(binomial 1)^ is the same as specifying ^family(binomial)^; both
*mean that y has the Bernoulli distribution with values 0 and 1 only.

*https://stats.idre.ucla.edu/stata/faq/how-can-i-estimate-relative-risk-using-glm-for-common-outcomes-in-cohort-studies/
 
	foreach vd of varlist k2_elevado tenpsi {
foreach vi of varlist LA_rec_logit LF_rec_logit LC_rec_logit NAQ_Dic_logit ///
						LID_DES_Dic_logit NAQ_sum_cuartil LID_DES_sum_cuartil {
	svy: glm `vd' b0.`vi' ,  family(poisson) link(log) eform
				esttab .  using "final.html", label cells ("b(star fmt(3)label(PR)) p(fmt(3)) ci(fmt(3)par label(CI95%))") eform keep(*`vi') ///
				addnotes("1" `vd'" por" `vi'"; Exponentiated coefficients") sfmt(%15,3g) plain ///
				append
	svy: glm `vd' b0.`vi' b0.mujer b0.climasex,  family(poisson) link(log) eform
				esttab .  using "final.html", label cells ("b(star fmt(3)label(PR)) p(fmt(3)) ci(fmt(3)par label(CI95%))") eform keep(*`vi') ///
				addnotes("2" `vd'" por" `vi'"; Exponentiated coefficients") sfmt(%15,3g) plain ///
				append
	svy: glm `vd' b0.`vi' b0.mujer b0.climasex b0.precr1,  family(poisson) link(log) eform
				esttab .  using "final.html", label cells ("b(star fmt(3)label(PR)) p(fmt(3)) ci(fmt(3)par label(CI95%))") eform keep(*`vi') ///
				addnotes("3" `vd'" por" `vi'"; Exponentiated coefficients") sfmt(%15,3g) plain ///
				append
		  } 
		 }

svy: glm tenpsi b0.NAQ_Dic_logit ,  family(binomial 1) link(log) eform				
svy: glm tenpsi b0.NAQ_Dic_logit b0.mujer b0.climasex,  family(binomial 1) link(log) eform				


*******************************************************************************
**************************************ROC**************************************
*******************************************************************************
*Instalo el programa para establecer puntos de corte empcamente 󰴩mos.
cutpt autonaq NAQ_sum
*debe ejecutarse el seed en conjunto con el bootsrap. Autocategorizaci󮠎AQ-R
set seed 2038947
bootstrap e(cutpoint), rep(250): cutpt autonaq NAQ_sum, youden
*debe ejecutarse el seed en conjunto con el bootsrap. Autocategorizaci󮠁raucaria y NAQ
set seed 2038947
bootstrap e(cutpoint), rep(250): cutpt ACOSO_AUTO_REC2 NAQ_sum, youden

set seed 2038947
bootstrap e(cutpoint), rep(250): cutpt ACOSO_TEN_DIST NAQ_sum, youden


roctab ACOSO_TEN_DIST NAQ_sum, graph msymbol(none) addplot(scatteri `e(sens)' `=1 - e(spec)')
        legend(label("Cutpoint"))

egen ACOSO_TEN_DIST= rowtotal(autonaq tenpsi k2_elevado)
recode ACOSO_TEN_DIST 0/1=0 2/max=1

egen ACOSO_DIST_= rowtotal(autonaq tenpsi k2_elevado)
recode ACOSO_TEN_DIST 0/1=0 2/max=1

recode ACOSO_AUTO_REC 1=0 2=1, gen (ACOSO_AUTO_REC2)

LF_rec_logit LA_rec_logit LC_rec_logit

svy, subpop(mujer): glm k2_elevado b0.LC_rec_logit,  family(binomial 1) link(log) eform

