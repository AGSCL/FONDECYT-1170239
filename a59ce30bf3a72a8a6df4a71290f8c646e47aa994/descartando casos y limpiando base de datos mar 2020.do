*Tengo 2 base de datos con diferentes variables
use "C:\Users\CISS Fondecyt\OneDrive\Escritorio\do files\culorg 06-04- BD_05_02_19 (BD_22_10_18_lab_cul_org2)_post modelos_finales2.dta" 
desc,short
*Las ordeno por Nombre de sujeto
sort SbjNum
desc,short
tab edux
tab ocux
tab Edad
tab A1x1_Coded_1
tab ocux
codebook ocux tab(100)
codebook ocux, tab(100)
tab A11
codebook A1x1_Coded_1
tab expclass_naq_final_1
tab rec_expclass_CULORG_1
*Resulta que el cluster_rec es la versión no codificada de cluster_rec2.
tab cluster_rec
tab cluster_rec2
di 1995-1835
frame create nuevo
frames dir
frame rename nuevo viejo
frame change nuevo
frame create nuevo
frames dir
frame rename default viejo
frame drop viejo
frame rename default viejo
frames dir
frame change nuevo
use "C:\Users\CISS Fondecyt\OneDrive\Escritorio\do files\BD_29_06_19 (BD_22_10_18_lab_cul_org2).dta"
sort SbjNum
desc,hort
desc,short
frame change viejo
tab NAQ_sum_cuartil_01
tab NAQ_sum_cuartil
tab LID_DES_sum_cuartil
NAQ_sum_ROC2_01
tab NAQ_sum_ROC2_01
tab NAQ_sum_ROC2
drop NAQ_sum_ROC2
tab bajarecompensa_01
tab bajarecompensa
tab altoesfuerzo_01
tab altoesfuerzo
drop bajarecompensa_01 altoesfuerzo_01
tab jef_hogar
tab jef_hogar_01
drop jef_hogar_01-acos_sex_01
tab org_sind_01
tab org_sind
drop org_sind_01
tab prev3_01
tab prev3
drop prev3_01
drop _est_b1_01
tab gse_ac3_01
tab gse_ac3_01
drop superv_01-gse_ac3_01
drop cluster
drop NAQ1_clus-LID_DES14_clus
 tab proc_res
tab NAQ_sum_cuartil_01
tab NAQ_sum_cuartil
frames dir
frame create mas_nuevo
frame change mas_nuevo

*Borrar esamples
drop _est_culorg_ext_c7-_est_culorg_ext_c6_FINAL_est _est_culorg_c2-_est_culorg_c8
drop _est_culorg_ext_c1 _est_b1 _est_culorg_ext_c2-_est_culorg_ext_c6
drop _est_logit-_est_CIM

drop clus2_2clas
