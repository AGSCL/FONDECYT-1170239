*Tengo una base de datos con toda la información
use "G:\Mi unidad\DOCUMENTOS\6.TESIS 2018\_BASE DEF_FINAL\BASDEF_FINAL\01_02_19\BD_29_06_19 (BD_22_10_18_lab_cul_org2) (1).dta",clear

*La mezclo con esta otra, que resulta del proyecto de Estudio de Cultura
merge 1:1 SbjNum using "G:\Mi unidad\DOCUMENTOS\6.TESIS 2018\CULTURA\21-04-19 (BD_05_02_19) CULORG.dta"

drop _merge

*Borrar esamples, borrada a proposito (esample)
drop  _est_culorg_ext_c1 _est_culorg_ext_c3 _est_culorg_ext_c4 _est_culorg_ext_c2 ///
_est_b1 _est_culorg_ext_c5 _est_culorg_ext_c6 _est_culorg_ext_c7 _est_culorg_ext_c8 ///
_est_culorg_ext_c9 _est_culorg_ext_c10 _est_culorg_ext_c11 _est_culorg_ext_c12 ///
_est_culorg_ext_c13 _est_culorg_ext_c14 _est_culorg_ext_c15 _est_culorg_ext_c6_FINAL ///
_est_culorg_ext_c6_FINAL_est _est_culorg_c2 _est_culorg_c3 _est_culorg_c4 _est_culorg_c5 ///
_est_culorg_c6 _est_culorg_c7 _est_culorg_c8  _est_logit _est_melogit _est_CIM

*Combino las bases de datos que me quedan dudas. La segunda la utilicé en base al último archivo de cultura que hice en la carpeta para poder definir 
 * las variables de cultura, la última vez fue modificada el 20-04-2019. En este caso, yo hice una nueva versión hasta febrero 2020
 merge 1:1 SbjNum using "G:\Mi unidad\DOCUMENTOS\6.TESIS 2018\LCA NAQ\culorg 06-04- BD_05_02_19 (BD_22_10_18_lab_cul_org2)_post modelos_finales2.dta"
 
 drop _est_culorg_ext_c1 _est_b1 _est_culorg_ext_c2 _est_culorg_ext_c3 _est_culorg_ext_c4 _est_culorg_ext_c5 _est_culorg_ext_c6 _est_culorg_ext_c7 ///
 _est_culorg_ext_c8 _est_culorg_ext_c9 _est_culorg_ext_c10 _est_culorg_ext_c11 _est_culorg_ext_c12 _est_culorg_ext_c13 _est_culorg_ext_c14 _est_culorg_ext_c15 ///
 _est_culorg_ext_c6_FINAL _est_culorg_ext_c6_FINAL_est _est_culorg_c2 _est_culorg_c3 _est_culorg_c4 _est_culorg_c5 _est_culorg_c6 _est_culorg_c7 _est_culorg_c8 ///
 _est_logit _est_melogit _est_CIM

 drop _merge
 
save "G:\Mi unidad\DOCUMENTOS\6.TESIS 2018\Codebook_FONDECYT_1170239\BD_2020.dta",replace

*********************************************************************************
************************ AGREGAR VARIABLES QUE NO ESTÁN Y DESCARTAR *****************
******************************************OTRAS**********************************

use "G:\Mi unidad\DOCUMENTOS\6.TESIS 2018\Codebook_FONDECYT_1170239\BD_2020.dta",clear

*definir bases de datos de trabajo (sólo stata 16)
frame create principio_marzo
frames rename default finales_marzo
frames dir

***************************************************
******1***REQUIERO RECUPERAR ESTAS VARIABLES
*NAQ_sum_ROC2_01
*NAQ_sum_cuartil_01
*classpost1_01 classpost2_01  classpost3_01 classpost4_01 classpost5_01 classpost6_01
*NAQ_sum_ROC3
*LID_DES_MyE


*
frame change principio_marzo

use "G:\Mi unidad\DOCUMENTOS\6.TESIS 2018\Codebook_FONDECYT_1170239\BD_2020_compilacion_versiones.dta",clear

*Ver como se comportan y diferencias entre las variables con 01¨
*Hasta ahora, sólo naq sum cuartil es distinta de su par
tab NAQ_sum_ROC2 
tab NAQ_sum_ROC2_01 
tab NAQ_sum_cuartil_01
tab NAQ_sum_cuartil
tab classpost1_01
tab NAQ_sum_ROC3
tab LID_DES_MyE

frame change finales_marzo

tab NAQ_sum_ROC2 /*igual a la bd de prin marzo*/
tab NAQ_sum_cuartil /*NAQ_sum_cuartil de prin marzo al parecer respondería a la categorización errónea. La que existe está ok*/
*tab classpost1_01 /*no existe y tiene datos distintos para todos*/
*tab NAQ_sum_ROC3 /* no existe por ahora, tab NAQ_sum_ROC, 1579 y 416, igual*/
*tab LID_DES_MyE /* no existe por ahora*/

**Los LA_Leyman y LC_leyman se corresponden con la última base segpun lo entiendo

frame change finales_marzo

***************************************************
*******2*** Paper Validación

egen NAQ_R_AF_sum= rowtotal(NAQ8 NAQ9 NAQ22)
egen NAQ_R_AP_sum= rowtotal(NAQ2 NAQ4 NAQ5 NAQ6 NAQ7 NAQ10 NAQ11 NAQ12 NAQ13 NAQ15 NAQ17 NAQ20)
egen NAQ_R_RT_sum= rowtotal(NAQ1 NAQ3 NAQ14 NAQ16 NAQ18 NAQ19 NAQ21)

*Ojo, es distinto a democ, ver sus consecuencias y cómo sale en el paper
*Se diferencia en el rowtotal.
egen democ_paper = rowtotal(A18_top_6 A18_top_7 A18_top_8 A18_top_9 A18_top_10 A19_top_1 A19_top_2 A19_top_3 A19_top_4)

* Importante, LC2 y LC son distintos. lo mismo LF2 y LF, probablemente porque no incluyen las mismas variables
egen LF2= rowtotal(LID_DES5 LID_DES7 LID_DES9)
egen LC2= rowtotal(LID_DES6 LID_DES11 LID_DES12 LID_DES14)

**prec_paper es lo mismo que precr1. No vale la pena hacerla de nuevo

*para generar variable dicotomizada sin tener que generar nuevas variables.
cap drop LID_DES_Dic
cap drop LID_DES_Dic_logit
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

*ACOSO_AUTO_REC2 es redundante.

save "G:\Mi unidad\DOCUMENTOS\6.TESIS 2018\Codebook_FONDECYT_1170239\BD_2020.dta",replace

***************************************************
*******3*** Paper Vulnerabilidad

*PARA SABER SI HAY QUE INCORPORAR UNA NUEVA VARIABLE
*gen prec_sum_original = vul + prec1 + prec2 + prec3 + prec5 + prec6 + prec7 + prec8
*recode prec_sum_original (3/max= 1 "Prec") (0/2=0 "Ausencia Prec"), gen (precr1)


***************************************************
*******4*** Paper Cultura
use "G:\Mi unidad\DOCUMENTOS\6.TESIS 2018\Codebook_FONDECYT_1170239\BD_2020.dta",replace

*está redundante

*DER
cap drop bajarecompensa altoesfuerzo
recode recompensas (min/17=1 "Baj recompensa") (18/max=0 "Alta recompensa"), gen(bajarecompensa)
recode esfuerzo(min/7=0 "Baj esfuerzo") (8/max=1 "Alto esfuerzo"), gen(altoesfuerzo)

cap drop desbalance desbalance_dic
gen desbalance = esfuerzo/ (recompensa * 0.4285)
recode desbalance (min/1=0 "Balance Esf-Rec") (1/max=1 "DER"), gen(desbalance_dic)


**Genero cultura, sólo valores extremos dicotomizados
drop culorg1_ext culorg2_ext culorg3_ext
gen culorg1_ext=A37_1
recode culorg1_ext 1/2=1 3/4=0 5/6=1

svy: tab culorg1_ext, obs
tab culorg1_ext [iw=weight]

gen culorg2_ext=A37_2
recode culorg2_ext 1/2=1 3/4=0 5/6=1

svy: tab culorg2_ext, obs
tab culorg2_ext [iw=weight]

gen culorg3_ext=A37_3
recode culorg3_ext 1/2=1 3/4=0 5/6=1

svy: tab culorg3_ext, count
tab culorg3_ext [iw=weight]

**Genero Aquellos que se encuentran balanceados
cap drop proc_res bienst_tarea laxo_estr
recode A37_1 1/2=0 3/4=1 5/6=0, gen(proc_res) label(Procesos Resultados Ext Int)

recode A37_2 1/2=0 3/4=1 5/6=0, gen (bienst_tarea) label(Bienestar Tarea Ext Int)

recode A37_3 1/2=0 3/4=1 5/6=0, gen (laxo_estr) label(Control Laxo Estricto Ext Int)

**Noviembre 2019- ACTUALIZACION
recode LID_DES_Dic 0=0 1=0 2/max=1, gen(LID_DES_MyE)

recode cluster_rec2_final 3/6=0 1=0 2=1, gen(cluster_rec2_binary)

*cluster_rec, cluster_rec2, cluster_final, cluster_rec_final, cluster_rec2_final

**Por lo visto no estoy rescatando el verdadero classpost de la variable

save "G:\Mi unidad\DOCUMENTOS\6.TESIS 2018\Codebook_FONDECYT_1170239\BD_2020.dta",replace

***********************
*Obtener classpost sin errores
use "G:\Mi unidad\DOCUMENTOS\6.TESIS 2018\Codebook_FONDECYT_1170239\BD_2020.dta",clear
*frame change finales_marzo
*frame drop naq_lca_cultura


**Por lo visto, la última versión de LCA NAQ tendría los classpost correctos para
**predecir la clase esperada de pertenencia de cluster_rec2_final ni en binary
	cap frame create naq_lca_cultura
	frame dir
	frame change naq_lca_cultura
	use "G:\Mi unidad\DOCUMENTOS\6.TESIS 2018\LCA NAQ\culorg 06-04- BD_05_02_19 (BD_22_10_18_lab_cul_org2)_post modelos_finales.dta", clear

	 forvalues i = 1/6{
	gen classpost_culorg_alt`i' = classpost`i'
	drop classpost`i'
	 }
*veo en qué medida se condicen con los de la última base, pero no me los traigo
	forvalues i = 1/6{
	generate expclass_culorg_alt`i' = (classpost_culorg_alt`i'>0.5)
	tab expclass_culorg_alt`i'
	}

*Todas estas variables vendrían de esta fuente
		tab cluster
		tab cluster_rec
		tab cluster_rec2
*	tab cluster_rec2_final /*no existe*/

*me quedo con lo importante y guardo la base
	keep SbjNum  classpost_culorg_alt*
	save "G:\Mi unidad\DOCUMENTOS\6.TESIS 2018\Codebook_FONDECYT_1170239\NAQ_LCA_classpost_CULORG.dta",replace

*vuelvo a finales_marzo
	frames dir
frames change finales_marzo

	merge 1:1 SbjNum using "G:\Mi unidad\DOCUMENTOS\6.TESIS 2018\Codebook_FONDECYT_1170239\NAQ_LCA_classpost_CULORG.dta"

*cluster_rec_final es de 21-04-19, desde ahí que hago cluster_rec2_final	
	drop cluster_rec2_final
	rename cluster_rec_final cluster_rec_alt

*formateando los nombres de las variables	
	rename 		expclass_CULORG_final_1 expclass_CULORG_alt_1 
	rename 		expclass_CULORG_final_2 expclass_CULORG_alt_2 
	rename		expclass_CULORG_final_3 expclass_CULORG_alt_3 
	rename		expclass_CULORG_final_4 expclass_CULORG_alt_4 
	rename		expclass_CULORG_final_5 expclass_CULORG_alt_5 
	rename		expclass_CULORG_final_6 expclass_CULORG_alt_6 
	rename		rec_expclass_CULORG_final_1 rec_expclass_CULORG_alt_1 
	rename		rec_expclass_CULORG_final_2 rec_expclass_CULORG_alt_2 
	rename		rec_expclass_CULORG_final_3 rec_expclass_CULORG_alt_3 
	rename		rec_expclass_CULORG_final_4 rec_expclass_CULORG_alt_4 
	rename		rec_expclass_CULORG_final_5 rec_expclass_CULORG_alt_5 
	rename		rec_expclass_CULORG_final_6 rec_expclass_CULORG_alt_6
	
	recode cluster_rec_alt (1=.) (2=2 "clus 2") (4=4 "clus 4") (3=6 "clus 6") (5=5 "clus 5") (6=3 "clus 3") (7=1 "clus 1"), gen (cluster_rec2_alt)
	
	*me deshago de los classpost mal especificados. Se puede notar que el classpost 1 y 2 están en otro orden, porque tal vez pertenecen a otras variables.
	drop classpost3 classpost4 classpost5 classpost6 classpost1 classpost2
	
/*son 167 casos fuera vs. 160. Todavía no sé por qué los PR me funcionan igual con la dicotomizada en clase 2*/

frame drop naq_lca_cultura

 save "G:\Mi unidad\DOCUMENTOS\6.TESIS 2018\Codebook_FONDECYT_1170239\BD_2020.dta",replace

*************************************************
******5*** Ximena y Amalia

use "G:\Mi unidad\DOCUMENTOS\6.TESIS 2018\Codebook_FONDECYT_1170239\BD_2020.dta",clear
frames dir

*Existe
tab acos_sex 
tab A22
tab agr_fisica
tab ARAUCARIA_ACOSO
tab ACOSO_AUTO
tab ACOSO_AUTO_REC

*CAMINO PARA LLEGAR A ARAUCARIA ACOSO.
*egen ARAUCARIA_ACOSO= rowtotal(acos_sex A22 agr_fisica)
*recode ARAUCARIA_ACOSO 0/1=0 2/max=1
recode ARAUCARIA_ACOSO 3=1 /* para normalizarlo*/

gen ACOSO_AUTO_2 = acos_sex +A22 +agr_fisica +autonaq
*egen ACOSO_AUTO_2 = rowtotal(acos_sex A22 agr_fisica autonaq)
recode ACOSO_AUTO_2 0=0 1/max=1, gen(ACOSO_AUTO_REC_2)
*Son lo mismo
tab1 ACOSO_AUTO ACOSO_AUTO_2
*Comparar. Por lo visto, también son iguales
tab1 ACOSO_AUTO_REC ACOSO_AUTO_REC_2

bootstrap e(cutpoint), rep(250): cutpt ACOSO_AUTO_REC_2 NAQ_sum, youden
*resulta en 7,5 el punto de corte. Ojo. Los puntos de corte definidos por Amalia y Ximena¨
*se basaron en la tesis de AGS, por lo que se determinó con software R

*Pueden descartarse
drop ACOSO_AUTO_2 ACOSO_AUTO_REC_2

  *recodificar la variable NAQ_sum en punto de corte
cap drop NAQ_sum_ROC3
recode NAQ_sum 0/8=0 9/max=1, gen(NAQ_sum_ROC3)
label var NAQ_sum_ROC3 "Suma ptjes brutos NAQ-R ROC (crit. inclusivo)"
label define NAQ_sum_ROC3  1 "Presencia VL", replace
label define NAQ_sum_ROC3 0 "Ausencia VL", replace 

*Resultan ser lo mismo
tab1 NAQ_sum_ROC3 NAQ_sum_ROC2

*Se descarta NAQ_sum_ROC2 porque no está siendo ocupado
drop NAQ_sum_ROC2

 **definir variables
 recode A54 99=.  1/3=1 4/6=2 7/8=3 9/10=4, gen (Educacion277) label("Educación Amalia y Ximena")
 recode ocuprev 1=1 2/3=2 4/5=3 6/8=4 9=5, gen(ocuprev_xi_am277) label("Ocupación Amalia y Ximena")
  *corregido por indicaciones 27-07-19
 recode A62 99=. 88=.	1/3=1 4=2 5/6=3, gen (ing_hog_xi_am277) label("Ingreso Hogar Amalia y Ximena")

 *Hacer etiquetas 27-7-19
label variable Educacion277 "Educación Amalia y Ximena"
label define Educacion277 1 "Sin Educacion o Basica", replace
label define Educacion277 2 "Media o Tecnica Incomp", replace
label define Educacion277 3 "Tecnica Comp o Univ Incomp", replace
label define Educacion277 4 "Universitaria Comp o Postgr", replace
label variable ocuprev_xi_am277 "Ocupación Amalia y Ximena"
label define ocuprev_xi_am277 1 "Jef Intermedias", replace
label define ocuprev_xi_am277 2 "Prof y Tecnicos", replace
label define ocuprev_xi_am277 3 "Empleados Oficina y Vendedores", replace
label define ocuprev_xi_am277 4 "Operarios, conductores y calif", replace
label define ocuprev_xi_am277 5 "No calificados", replace
label variable ing_hog_xi_am277 "Ingreso Hogar Amalia y Ximena"
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

label variable NAQ_Dic "Suma ptjes. dicotomizados NAQ-R"
label variable NAQ_Leyman "NAQ OCM- Criterio Leymann"
label variable NAQ_MyE "NAQ OCM- Criterio Mikkelsen & Einarsen"
label variable NAQ_A "NAQ OCM- Criterio Agervold"
 
*Se condice con lo que menciona en el artículo de AM y XI
svy:tab NAQ_sum_ROC mujer, count obs col
svy:tab NAQ_sum_ROC3 mujer, count obs col

*Expuestos a violencia “varias veces a la semana” o “a diario” : mujeres: 23,5%; hombres: 14,6%.
 svy: tab frec_acos21_1 mujer, col

*Para ver diferencias sólo entre vulnerables por sexo. 
gen vul_hm= vul
replace vul_hm=.
replace vul_hm = 1 if vul==1 & mujer==1
replace vul_hm = 2 if vul==1 & mujer==0
label variable vul_hm "Sólo con hombres y mujeres expuestos a vulnerabilidad"

tab vul_hm
svy: tab vul_hm NAQ_sum_ROC3, row label

*Sólo hombres y mujeres expuestos a liderazgos LF, autoritarios y constructivos
gen LF_Leyman_hm= LF_Leyman
replace LF_Leyman_hm=.
replace LF_Leyman_hm = 1 if LF_Leyman==1 & mujer==1
replace LF_Leyman_hm = 2 if LF_Leyman==1 & mujer==0
label variable LF_Leyman_hm "Sólo con hombres y mujeres expuestos a lid laissez-faire"

tab LF_Leyman_hm
svy: tab LF_Leyman_hm NAQ_sum_ROC3, row label

gen LA_Leyman_hm= LA_Leyman
replace LA_Leyman_hm=.
label variable LA_Leyman_hm "Sólo con hombres y mujeres expuestos a lid autoritario"
replace LA_Leyman_hm = 1 if LA_Leyman==1 & mujer==1
replace LA_Leyman_hm = 2 if LA_Leyman==1 & mujer==0

tab LA_Leyman_hm
svy: tab LA_Leyman_hm NAQ_sum_ROC3, row label count

gen LC_Leyman_hm= LC_Leyman
replace LC_Leyman_hm=.
replace LC_Leyman_hm = 1 if LC_Leyman==1 & mujer==1
replace LC_Leyman_hm = 2 if LC_Leyman==1 & mujer==0
label variable LA_Leyman_hm "Sólo con hombres y mujeres expuestos a lid constructivo"

tab LC_Leyman_hm
svy: tab LC_Leyman_hm NAQ_sum_ROC3, row label


*Sólo hombres y mujeres expuestos a variables de Salud Mental
 gen depre_hm=.
replace depre_hm = 1 if depre==1 & mujer==1
replace depre_hm = 2 if depre==1 & mujer==0
label variable depre_hm "Sólo con hombres y mujeres expuestos a Depresión"
tab depre_hm 
svy: tab depre_hm, col

 gen psicotrop_hm=.
replace psicotrop_hm = 1 if psicotrop==1 & mujer==1
replace psicotrop_hm = 2 if psicotrop==1 & mujer==0
label variable psicotrop_hm "Sólo con hombres y mujeres expuestos a Cons Psicotrópicos"
tab psicotrop_hm 
svy: tab psicotrop_hm, obs  

gen k2_elevado_hm=.
replace k2_elevado_hm = 1 if k2_elevado==1 & mujer==1
replace k2_elevado_hm = 2 if k2_elevado==1 & mujer==0
label variable psicotrop_hm "Sólo con hombres y mujeres expuestos a Distrés"
tab k2_elevado_hm 
svy: tab k2_elevado_hm, obs  

*Sólo hombres y mujeres que perciben Clima Sexista
gen climasex_hm= climasex
replace climasex_hm=.
replace climasex_hm = 1 if climasex==1 & mujer==1
replace climasex_hm = 2 if climasex==1 & mujer==0
label variable climasex_hm "Sólo con hombres y mujeres expuestos a Clima Sexista"
tab climasex_hm
svy: tab climasex_hm NAQ_sum_ROC3, row label

*Para chequear la jerarquía del acoso
codebook A29_01, tab(100)
codebook A29_02, tab(100)
*tienen las mismas etiquetas
recode A29_01 99=., gen(jerarquia_acoso)
recode A29_02 99=., gen(jerarquia_acoso2)
*para ver las frecuencias por sexo
tabm jerarquia_acoso* [iweight=weight] if mujer==0, oneway
tabm jerarquia_acoso* [iweight=weight] if mujer==1, oneway

*Otra forma de generar LID_DES.
egen LID_DES_Leyman = rowtotal( LF_Leyman LA_Leyman)
label variable LID_DES_Leyman "Lid Destructivos (criterio Leymann)"
recode LID_DES_Leyman 0=0 1/2=1
*comparación
tab1 LID_DES_Dic LID_DES_Leyman

* Acoso Psicológico SEeguido y Muy seguido
recode A23 1=0 2/3=1, gen(acos_psico_freq) label("Frecuencia Acoso Psicológico seguido y muy seguido")
label variable acos_psico_freq "Frecuencia Acoso Psicológico seguido y muy seguido"

 save "G:\Mi unidad\DOCUMENTOS\6.TESIS 2018\Codebook_FONDECYT_1170239\BD_2020.dta",replace


*************************************************
******6*** Seminario y Variables Artículo Magdalena

 use "G:\Mi unidad\DOCUMENTOS\6.TESIS 2018\Codebook_FONDECYT_1170239\BD_2020.dta",clear

	 recode A16 99=., gen (carga_dom) label("Carga doméstica") //coincide con magda
	 recode A54 99=. 1/4=1 5/10=0, gen (Educacion_media) label("Educación Ens Media") //231 172 403, coincide con magda

	 recode A6 99=. 88=. 1=0 2/10=1, gen (cont_def) label("Contrato Definido") //ya definida

	recode ocuprev_rec (6 9 3 7 = 1) (8 5 4 2 1=0) , gen(ocuprev_nocalif) label("Ocupación No Calif") // NO COINCIDE

	recode zona 1=1 2/3=0, gen(santiago)
	recode zona 2=1 1=0 3=0, gen(valpo)
	recode zona 3=1 1=0 2=0, gen(concep)

	*etiquetar las variables.
	label variable ocuprev_nocalif "Ocupación"
	label define ocuprev_nocalif 1 "No Calif.", replace
	label define ocuprev_nocalif 0 "Calif", replace
	label variable carga_dom "Carga Doméstica"
	label define carga_dom 1 "Con Carga Doméstica", replace
	label define carga_dom 0 "Sin Carga Doméstica", replace
	label variable cont_def "Contrato"
	label define cont_def 1 "Definido", replace
	label define cont_def 0 "Indefinido", replace
	label variable Educacion_media "Educación"
	label define estrechez 1 "Menos que Ens Media", replace
	label define estrechez 0 "Mayor a Ens Media", replace
	label variable estrechez "Estrechez Económica"
	label define estrechez 1 "Sí", replace
	label define estrechez 0 "No", replace
	label variable vul "Vulnerabilidad"
	label define vul 1 "Sí", replace
	label define vul 0 "No", replace

 save "G:\Mi unidad\DOCUMENTOS\6.TESIS 2018\Codebook_FONDECYT_1170239\BD_2020.dta",replace

***************************************************
*******7*** Paper ROC y LCA NAQ

****VER CLASES NAQ****
*frames change finales_marzo
*frame drop naq_lca_naq
	cap frame create naq_lca_naq
	frame dir
	frame change naq_lca_naq
	use "G:\Mi unidad\DOCUMENTOS\6.TESIS 2018\LCA NAQ\culorg 06-04- BD_05_02_19 (BD_22_10_18_lab_cul_org2)_post modelos_finales.dta", clear

	estimates use "G:\Mi unidad\DOCUMENTOS\6.TESIS 2018\LCA NAQ\NAQ_ext_c6_FINAL_est2.ster"
	*estimates describe using NAQ_ext_c6_FINAL_est
	*genero otros classpost para ver si los expclass_naq_final son correctos o no.
	estimates esample:
	predict classpost_naq_def_*, classposteriorpr

	forvalues i = 1/6{
	generate expclass_naq`i' = (classpost`i'>0.6)
	tab expclass_naq`i'
	}
	*tienen un 263 en la última clase

	 forvalues i = 1/6{
	generate expclass_naq_alt_`i' = (classpost_naq_def_`i'>0.6)
	tab expclass_naq_alt_`i'
	}
	*tienen un 906 en la última clase
	
	*me quedo con los valores obtenidos directamente.
	keep SbjNum expclass_naq_alt_* classpost_naq_def_*

	save "G:\Mi unidad\DOCUMENTOS\6.TESIS 2018\Codebook_FONDECYT_1170239\NAQ_LCA_classpost_NAQ.dta",replace

frame change finales_marzo
	
	drop _merge
	merge 1:1 SbjNum using "G:\Mi unidad\DOCUMENTOS\6.TESIS 2018\Codebook_FONDECYT_1170239\NAQ_LCA_classpost_NAQ.dta"

	* Son distintos. Me quedo con el último.
	tab1 expclass_naq_final_* expclass_naq_alt_*

	*borrar la probabilidad posterior del naq que me traje. Estba hecho con las variables classpost, erróneas
	drop classpost_naq_1 classpost_naq_2 classpost_naq_3 classpost_naq_4 classpost_naq_5 classpost_naq_6
	drop expclass_naq_final_*
	
	 **IMPORTANTE
	 *Para hacer  una variable que agrupe las clases.
	foreach naq_clus of varlist expclass_naq_alt_* {
		recode `naq_clus' 0=., gen (rec_`naq_clus')
		}
	egen cluster_naq_alt = concat(rec_expclass_naq_alt_*)
	encode cluster_naq_alt, gen(cluster_naq_alt_rec)
	tab cluster_naq_alt_rec, sort nolab
	codebook cluster_naq_alt_rec
	recode cluster_naq_alt_rec (2=1 "class 1") (3=2 "class 2") (6=3 "class 3") (7=4 "class 4") (1=.) (4=5 "class 5") (5=6 "class 6") (8=.), gen (cluster_rec2_naq_alt)
	tab cluster_rec2_naq_alt
	*195 perdidos
	frame drop naq_lca_naq 

****************************************************
*******8*** Observaciones y Variables No utilizadas

*La variable turnos se encontraría mal recodificada, de acuerdo a la definición ¨
*disponible en DO 7.08.18, tampoco está documentada en tratamiento de variables fondecyt
*DO 7.08.18= sistema de trabajo (turnos y nocturno)
tab turnos
cap drop turnos
* Se reemplaza con una variable que indique lo que se requiere
recode A10 2/max=1 1=0, gen(turnos)

*La variable no es de utilidad, se codificó la suma de puntajes brutos de satisfacción en terciles.
drop satis_terc
* La variable no es de utilidad, no se ocupa
drop clus2_2clas

*Resulta redundante, se repite en cluster_rec. Eliminar
drop cluster

*Quedó una variable expclass, será eliminada
drop expclass1

*Elimino el producto de la combinación de base de datos
drop _merge

*Borrar las variables que terminan en _clus porque son una recodificación que soloi
*sirve al software de análisis de clases latentes de R
drop NAQ1_clus NAQ2_clus NAQ3_clus NAQ4_clus NAQ5_clus NAQ6_clus NAQ7_clus NAQ8_clus ///
NAQ9_clus NAQ10_clus NAQ11_clus NAQ12_clus NAQ13_clus NAQ14_clus NAQ15_clus NAQ16_clus ///
NAQ17_clus NAQ18_clus NAQ19_clus  NAQ20_clus NAQ21_clus NAQ22_clus LID_DES1_clus ///
LID_DES2_clus LID_DES3_clus LID_DES4_clus LID_DES5_clus LID_DES6_clus LID_DES7_clus ///
LID_DES8_clus LID_DES9_clus LID_DES10_clus  LID_DES11_clus LID_DES12_clus LID_DES13_clus ///
LID_DES14_clus

*rename classter_rec2_alt = cluster_rec2_naq_alt

sort SbjNum

save "G:\Mi unidad\DOCUMENTOS\6.TESIS 2018\Codebook_FONDECYT_1170239\BD_2020.dta",replace
export delimited using "BD_2020_input", delimiter(";") replace
