 
 *Base de datos obtenida en la carpeta del 01-02-19 , ult mod 29-06-2019
 use "G:\My Drive\DOCUMENTOS\6.TESIS 2018\_BASE DEF_FINAL\BASDEF_FINAL\01_02_19\BD_29_06_19 (BD_22_10_18_lab_cul_org2).dta", clear
 *Combino las bases de datos que me quedan dudas. La segunda la utilicé en base al último archivo de cultura que hice en la carpeta para poder definir 
 * las variables de cultura, la última vez fue modificada el 20-04-2019. En este caso, yo hice una nueva versión hasta febrero 2020
 merge 1:1 SbjNum using "C:\Users\LENOVO\Desktop\culorg 06-04- BD_05_02_19 (BD_22_10_18_lab_cul_org2)_post modelos_finales2.dta"
 *en la mimsma carpeta, también está disponible 21-04-19 (BD_05_02_19) CULORG, el que también fue modificada el 20-04-2019
 