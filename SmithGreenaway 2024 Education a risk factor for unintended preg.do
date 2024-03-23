
clear all
set maxvar 20000

*** List of 50 countries and filenames 

*** We need both IR and HR files; HR files are used to generate contextual variables
/* List of IR files: save them into one folder
AFIR71FL.DTA, AOIR71FL.DTA, BDIR7RFL.DTA, BFIR62FL.DTA, BJIR71FL.DTA, BUIR71FL.DTA, 
CDIR61FL.DTA, CGIR61FL.DTA, CIIR62FL.DTA, CMIR71FL.DTA, COIR72FL.DTA, DRIR6AFL.DTA, 
EGIR61FL.DTA, GAIR61FL.DTA, GHIR72FL.DTA, GMIR81FL.DTA, GNIR71FL.DTA, GUIR71FL.DTA, 
HTIR71FL.DTA, IAIR74FL.DTA, IDIR71FL.DTA, KEIR72FL.DTA, KHIR73FL.DTA, KMIR61FL.DTA, 
KYIR61FL.DTA, LBIR7AFL.DTA, LSIR71FL.DTA, MLIR7AFL.DTA, MMIR71FL.DTA, MVIR71FL.DTA, 
MWIR7AFL.DTA, NGIR7AFL.DTA, NIIR61FL.DTA, NPIR7HFL.DTA, PEIR6IFL.DTA, PGIR71FL.DTA, 
PHIR71FL.DTA, PKIR71FL.DTA, RWIR70FL.DTA, SLIR7AFL.DTA, SNIR8BFL.DTA, TDIR71FL.DTA, 
TGIR61FL.DTA, TJIR71FL.DTA, TLIR71FL.DTA, TZIR7BFL.DTA, UGIR7BFL.DTA, ZAIR71FL.DTA, 
ZMIR71FL.DTA, ZWIR72FL.DTA*/
*** For each IR files, we trim down the file to include the following variables
global irvar_str caseid v000 
global irvar_num v001 v005 v022 v007 v012 v024 v025 v119 v133 v149 v190 v201 //
v213 v225 v312 v313 v501 v505 
local files : dir "HERE INPUT PATH FOR IR FILES" files "*.DTA"
cd "HERE INPUT PATH FOR IR FILES"
foreach file in `files' {
	use "`file'", clear
	rename *, lower
	local save_filename = substr("`file'", -12, .)
	gen filename="`save_filename'"
	foreach var_str of global irvar_str {
	    capture confirm variable `var_str'
		if _rc {
		    *string var
		    gen `var_str'=""
			}
	}
	foreach var_num of global irvar_num {
	    capture confirm variable `var_num'
		if _rc {
		    *numeric var
		    gen `var_num'=.
			}
    }
	preserve
	keep $irvar_str $irvar_num filename 
	order $irvar_str $irvar_num
	save `save_filename', replace
	restore
}
*** After triming down individual IR files, we append them all together 
! dir *.dta /a-d /b >d:\filelist.txt
file open myfile using d:\filelist.txt, read
file read myfile line
use `line', clear
save master_trim_IR, replace
file read myfile line
while r(eof)==0 { /* while you're not at the end of the file */
	append using `line'
	file read myfile line
}
file close myfile
*** Get unique group_id acorss all countries; this is also used to merge with HR files
gen region =string(v024,"%04.0f")
sort v000 region
egen regionid=concat(v000 region)
egen group_id=group(regionid) 
tab group_id
order filename-group_id
save master_trim_IR, replace

/* List of HR files: save them into one folder
AFHR71FL.DTA, AOHR71FL.DTA, BDHR7RFL.DTA, BFHR62FL.DTA, BJHR71FL.DTA, BUHR71FL.DTA, 
CDHR61FL.DTA, CGHR61FL.DTA, CIHR62FL.DTA, CMHR71FL.DTA, COHR72FL.DTA, DRHR6AFL.DTA, 
EGHR61FL.DTA, GAHR61FL.DTA, GHHR72FL.DTA, GMHR81FL.DTA, GNHR71FL.DTA, GUHR71FL.DTA, 
HTHR71FL.DTA, IAHR74FL.DTA, IDHR71FL.DTA, KEHR72FL.DTA, KHHR73FL.DTA, KMHR61FL.DTA, 
KYHR61FL.DTA, LBHR7AFL.DTA, LSHR71FL.DTA, MLHR7AFL.DTA, MMHR71FL.DTA, MVHR71FL.DTA, 
MWHR7AFL.DTA, NGHR7AFL.DTA, NIHR61FL.DTA, NPHR7HFL.DTA, PEHR6IFL.DTA, PGHR71FL.DTA, 
PHHR71FL.DTA, PKHR71FL.DTA, RWHR70FL.DTA, SLHR7AFL.DTA, SNHR8BFL.DTA, TDHR71FL.DTA, 
TGHR61FL.DTA, TJHR71FL.DTA, TLHR71FL.DTA, TZHR7BFL.DTA, UGHR7BFL.DTA, ZAHR71FL.DTA, 
ZMHR71FL.DTA, ZWHR72FL.DTA*/
global  hrvar_str hv000 
global hrvar_num  hv007 hv024 hv206 hv270 hv025 hv221 hv243a 
local files : dir "HERE INPUT PATH FOR HR FILES" files "*.DTA"
cd "HERE INPUT PATH FOR HR FILES"
foreach file in `files' {
	use "`file'", clear
	rename *, lower
	local save_filename = substr("`file'", -12, .)
	gen filename="`save_filename'"
	foreach var_str of global hrvar_str {
	    capture confirm variable `var_str'
		if _rc {
		    *string var
		    gen `var_str'=""
			}
	}
	foreach var_num of global hrvar_num {
	    capture confirm variable `var_num'
		if _rc {
		    *numeric var
		    gen `var_num'=.
			}
    }
	preserve
	keep $hrvar_str $hrvar_num filename 
	order $hrvar_str $hrvar_num
	save `save_filename', replace
	restore
}
*** After triming down individual IR files, we append them all together 
! dir *.dta /a-d /b >d:\filelist.txt
file open myfile using d:\filelist.txt, read
file read myfile line
use `line', clear
save master_trim_HR, replace
file read myfile line
while r(eof)==0 { /* while you're not at the end of the file */
	append using `line'
	file read myfile line
}
file close myfile
*** Get unique group_id acorss all countries; this is also used to merge with IR files
gen region =string(hv024,"%04.0f")
sort hv000 region
egen regionid=concat(hv000 region)
egen group_id=group(regionid) 
tab group_id
order filename-group_id
save master_trim_HR, replace

*cd "C:\Users\bpgre\Dropbox\shared folders\intentions-structure paper\Temp data"
*cd "C:\Users\esmithgr\Dropbox\shared folders\intentions-structure paper\Temp data"
cd "/Users/yingyilin/Library/CloudStorage/Dropbox/intentions-structure paper/Temp data"

***generate contextual variables from HR files, then merger w. IR files 
use master_trim_HR, clear 
*% electrified households
gen elec=hv206 
recode elec 9=. 
*% urban households 
gen urban=hv025 
recode urban 2=0 
*% rich households 
gen rich=hv270 
recode rich 1/3=0 4/5=1 
*% households with a phone
*create a single household phone--regardless if mobile or landline
gen landphone=hv221
recode landphone 9=. 
gen mphone=hv243a
recode mphone 9=. 
gen phone=0 
replace phone=1 if landphone==1
replace phone=1 if mphone==1 
tab phone 
*** create contextual covariates 
sort group_id 
by group_id: egen perelec=mean(elec)
by group_id: egen perurban=mean(urban)
by group_id: egen perrich=mean(rich)
by group_id: egen perphone=mean(phone)
duplicates drop group_id, force 
keep filename regionid group_id per* 
merge 1:m group_id using master_trim_IR 
drop _merge 

*** Cleaning IR files 
* code world regions 
gen world=6
replace world=1 if inlist(v000, "KY6","TJ7")
replace world=2 if inlist(v000, "CO7", "DR6", "GU6", "HT7", "PE6")
replace world=3 if inlist(v000, "EG6")
replace world=4 if inlist(v000, "PG7")
replace world=5 if inlist(v000, "AF7", "BD7", "KH6", "IA6", "ID7", "MV7")
replace world=5 if inlist(v000, "MM7", "NP7", "PK7", "PH7", "TL7")
* country names 
gen countrycode=substr(v000, 1, 2)
gen countryname="Afghanistan" if countrycode=="AF"
replace countryname="Angola" if countrycode=="AO"
replace countryname="Bangladesh" if countrycode=="BD"
replace countryname="Burkina Faso" if countrycode=="BF"
replace countryname="Benin" if countrycode=="BJ"
replace countryname="Burundi" if countrycode=="BU"
replace countryname="Congo Democratic Republic" if countrycode=="CD"
replace countryname="Congo" if countrycode=="CG"
replace countryname="Cote d'Ivoire" if countrycode=="CI"
replace countryname="Cameroon" if countrycode=="CM"
replace countryname="Colombia" if countrycode=="CO"
replace countryname="Dominican Republic" if countrycode=="DR"
replace countryname="Egypt" if countrycode=="EG"
replace countryname="Gabon" if countrycode=="GA"
replace countryname="Ghana" if countrycode=="GH"
replace countryname="Gambia" if countrycode=="GM"
replace countryname="Guinea" if countrycode=="GN"
replace countryname="Guatemala" if countrycode=="GU"
replace countryname="Haiti" if countrycode=="HT"
replace countryname="India" if countrycode=="IA"
replace countryname="Indonesia" if countrycode=="ID"
replace countryname="Kenya" if countrycode=="KE"
replace countryname="Cambodia" if countrycode=="KH"
replace countryname="Comoros" if countrycode=="KM"
replace countryname="Kyrgyz Republic" if countrycode=="KY"
replace countryname="Liberia" if countrycode=="LB"
replace countryname="Lesotho" if countrycode=="LS"
replace countryname="Mali" if countrycode=="ML"
replace countryname="Myanmar" if countrycode=="MM"
replace countryname="Maldives" if countrycode=="MV"
replace countryname="Malawi" if countrycode=="MW"
replace countryname="Nigeria" if countrycode=="NG"
replace countryname="Niger" if countrycode=="NI"
replace countryname="Nepal" if countrycode=="NP"
replace countryname="Peru" if countrycode=="PE"
replace countryname="Papua New Guinea" if countrycode=="PG"
replace countryname="Philippines" if countrycode=="PH"
replace countryname="Pakistan" if countrycode=="PK"
replace countryname="Rwanda" if countrycode=="RW"
replace countryname="Sierra Leone" if countrycode=="SL"
replace countryname="Senegal" if countrycode=="SN"
replace countryname="Chad" if countrycode=="TD"
replace countryname="Togo" if countrycode=="TG"
replace countryname="Tajikistan" if countrycode=="TJ"
replace countryname="Timor-Leste" if countrycode=="TL"
replace countryname="Tanzania" if countrycode=="TZ"
replace countryname="Uganda" if countrycode=="UG"
replace countryname="South Africa" if countrycode=="ZA"
replace countryname="Zambia" if countrycode=="ZM"
replace countryname="Zimbabwe" if countrycode=="ZW"

*** drop women that are out of the 15-49 age range 
drop if v012<15
drop if v012>=50 
* N= 1,486,871
*first column for Appendix Table A1
tab countryname if world==1 
tab countryname if world==2
tab countryname if world==3 
tab countryname if world==4 
tab countryname if world==5 
tab countryname if world==6

*unintended preg: among current preg women 
gen unwanted=v225 
recode unwanted 1=0 2/3=1
recode unwanted 9=. 
tab unwanted
*unwanted, versus those who remain NOT preg
gen unwantedcf=unwanted
replace unwantedcf=2 if unwanted==. 
recode unwantedcf 0=. 2=0
tab unwantedcf

*education
gen educ=v133
tab educ
recode educ 98/99=.

*INDIVIDUAL LEVEL CONTROLS 
*age
gen age=v012
tab age 
*marital status 
tab v505
gen poly = v505
recode poly 95/99=.
replace poly=1 if v505>=1 & v505<=19 
tab poly
tab v501
gen marstatus = v501
recode marstatus 9=. 
recode marstatus 3/5=4 /*windowed/divorced/separated*/
recode marstatus 2=3 /*cohab*/
replace marstatus=2 if poly==1
tab marstatus
label define marstatus 0 "never in union" 1 "Monogamous marriage" 2 "Polygynous marriage" ///
3 "cohabitation" 4 "windowed/divorced/separated" 
label values marstatus marstatus
tab marstatus
*rural/urban 
tab v025
gen urban = v025 
recode urban 2=0 
*wealth 
tab v190	
gen wealth_index = v190

*CONTEXTUAL LEVEL CONTROLS 
*fertility context
gen completef=v201 
replace completef=. if v012<=44 
replace completef=. if v012>=50
*contraceptive context 
gen use=v313
recode use 0/2=0 3=1 
tab use
tab filename if v313==.
*OPTION 1: EXTERNAL contraceptive
*0=not using (=0)/other traditional (=10)/withdrawal (=9)/lactational amenorrhea (=13)/periodic abstinence (=8), standard other days method (=18), basal body temperature (=21)
gen use1=0
*1=pill, IUD, injections, sterilization, condoms, implant/noroplant, pill, IUD, injections, sterilization, condoms, implant/noroplant, pill, IUD, injections, sterilization, condoms, implant/noroplant, foam jelly. patch
replace use1=1 if v312==1 /*pill*/
replace use1=1 if v312==2  /*IUD*/
replace use1=1 if v312==3  /*injections, monthly injections, 3 month injections*/
replace use1=1 if v312==4  /*diaphragm/foam/jelly*/
replace use1=1 if v312==5  /*condoms, male condoms*/
replace use1=1 if v312==6  /*female sterilization*/
replace use1=1 if v312==7  /*male sterilization*/
replace use1=1 if v312==11  /*implants/norplant*/
replace use1=1 if v312==14  /*female condom*/
replace use1=1 if v312==15  /*foam or jelly*/
replace use1=1 if v312==16  /*emergency contraception*/
replace use1=1 if v312==17  /*other modern method, COIR72FL.DTA=patch*/
replace use1=1 if v312==19 
/*
filename	varname	value	label
COIR72FL.DTA	v312	19	injections every three months
EGIR61FL.DTA	v312	19	injection (monthly)
GUIR71FL.DTA	v312	19	foam/jelly/tablets/ovule/diaphragm
IDIR71FL.DTA	v312	19	injection 1 months
TLIR71FL.DTA	v312	19	billings method
ZAIR71FL.DTA	v312	19	injections 2 month
*/
replace use1=1 if v312==20
/*
filename	varname	value	label
COIR72FL.DTA	v312	20	vaginal ring
EGIR61FL.DTA	v312	20	prolonged breastfeeding
PHIR71FL.DTA	v312	20	mucus/billing/ovulation
*/ 
tab use1
*OPTION 2: ONLY EXTERNAL FOR WOMEN 
*1=TAKE OUT male condom/COMDOM/steralization (female controlled external method)
gen use2=use1
replace use2=0 if v312==5  /*condoms, male condoms*/
replace use2=0 if v312==7  /*male sterilization*/
tab use2
*OPTION 3: only external for women + periodic methods
*1=pullin another varibale, + "peridoic abstinence" + SDM, (based on OPTION 2)
gen use3=use2
replace use3=1 if v312==8 /*periodic abstinence*/
replace use3=1 if v312==18 & use1==0 /*SDM, but exclude the 3 countries which label 18 as some modern methods: EGIR61FL.DTA, KHIR73FL.DTA, NMIR61FL.DTA*/
tab use3
*generate contextual indicators, using women weight 
*education
egen num1 = total(educ * v005), by(group_id) 
egen den1 = total(v005) if educ!=., by(group_id) 
gen pereduc = num1/den1
sort group_id
by group_id: egen pereduc_=mean(educ)
replace pereduc=pereduc_ if pereduc==. /*for Pakistan, some women do not have v005*/
sum pereduc
*fertility 
egen num2 = total(completef * v005), by(group_id) 
egen den2 = total(v005) if completef!=., by(group_id) 
gen regioncf = num2/den2
sort group_id
by group_id: egen regioncf_=mean(completef)
replace regioncf=regioncf_ if regioncf==. /*for Pakistan, some women do not have v005*/
sum regioncf
*contraceptives 
egen num3 = total(use1 * v005), by(group_id) 
egen den3 = total(v005) if use1!=., by(group_id) 
gen perexuse = num3/den3
sort group_id
by group_id: egen perexuse_=mean(use1)
replace perexuse=perexuse_ if perexuse==. /*for Pakistan, some women do not have v005*/
sum perexuse

global women age i.marstatus i.urban i.wealth_index
global region  perelec perphone perurban perrich  pereduc regioncf 

********************SETTING SAMPLE!!!!
xtset group_id 
*keep if age >17 
egen country=group(countryname)
sum country
*second column in Appendix Table A1
tab v000 if world==1 
tab v000 if world==2
tab v000 if world==3 
tab v000 if world==4 
tab v000 if world==5 
tab v000 if world==6

reg unwanted c.educ  c.perexuse  $women  $region   i.country
*current pregnancy sample
gen psample=1 if e(sample)==1
gen psample_unwanted=1 if psample==1 & unwanted==1
tab countryname if psample==1
tab psample 

reg unwantedcf c.educ  c.perexuse  $women  $region  i.country 
gen cfsample=1 if e(sample)==1
tab cfsample

gen totalsample=0
replace totalsample=1 if psample==1
replace totalsample=1 if cfsample==1
tab totalsample

keep if totalsample==1  /****KEEP ONLY the TOTAL SAMPLE FOR THE FOLLOWING ANALYSIS***/
*third column in Appendix Table A1
tab countryname if world==1 
tab countryname if world==2
tab countryname if world==3 
tab countryname if world==4 
tab countryname if world==5 
tab countryname if world==6

***************
*** TABLE 1 ***
***************
gen svyweight = v005/1000000
gen strata = v022
svyset [pweight=svyweight], psu(v001) strata(strata) singleunit(certainty)

*cfsample (sample 1)
svy: tab unwantedcf if cfsample==1 
svy: mean  educ v201 age  if cfsample==1
estat sd
svy: tab marstatus if cfsample==1
svy: tab urban if cfsample==1
svy: tab wealth_index if cfsample==1
*region:
bysort group_id cfsample: gen id=_n if cfsample==1
sum perexuse  perelec perphone perurban perrich  pereduc regioncf if cfsample==1 & id==1
drop id

**psample (sample 2)
svy: tab unwanted if psample==1 
svy: mean  educ v201 age if psample==1
estat sd
svy: tab marstatus if psample==1
svy: tab urban if psample==1
svy: tab wealth_index if psample==1
*region:
bysort group_id psample: gen id=_n if psample==1
sum perexuse  perelec perphone perurban perrich  pereduc regioncf if psample==1 & id==1
drop id 


***************
*** TABLE 2 ***
***************
*COMPARISON 1: UNINTENDED TO NOT PREGNANT: N=
xtlogit unwantedcf c.educ##c.perexuse  $region $women v201  i.country if cfsample==1, re or

*COMPARISON 2: UNINTENDED TO INTENDED: N=
xtlogit unwanted c.educ##c.perexuse    $region $women  v201 i.country if psample==1, re or

*************************
*** APPENDIX TABLE A3 ***
*************************
* Create a new binary variable for (1) unintended preg (0) no preg/intended preg combined. 
gen unwanted_=unwanted 
replace unwanted_=0 if unwantedcf==0 
tab unwanted_
* Comaprison 3 - 2 models (Uninteded vs. not preg/intend)
xtlogit unwanted_ c.educ##c.perexuse  $region $women   v201  i.country ,  or

*************************
*** APPENDIX TABLE A4 ***
*************************
* Comaprison 4 - 2 models (Uninteded vs. not preg/intend): among childless women 
xtlogit unwanted_ c.educ##c.perexuse  $region $women    i.country if v201==0 & age>=17,  or

** supplementary analysis 1: excluding one country at a time 
forvalues i = 1(1)50 {
	tab countryname if country==`i'
	xtlogit unwantedcf c.educ##c.perexuse $region $women i.country if country!=`i', re or
	xtlogit unwanted c.educ##c.perexuse   $region $women i.country if country!=`i', re or
}

log using socius20241118, text replace 
xtlogit unwantedcf c.educ   $region $women  v201  i.country if perexuse<=.1 & cfsample==1,  re or
margins, at(educ=(0(1)20)) asobserved post saving(compare1_lowcontra1, replace)
xtlogit unwantedcf c.educ   $region $women  v201  i.country if perexuse<=.2  & cfsample==1,  re or
margins, at(educ=(0(1)20)) asobserved post saving(compare1_lowcontra2, replace)
xtlogit unwantedcf  c.educ   $region $women  v201  i.country if perexuse>=.5  & cfsample==1,  re or
margins, at(educ=(0(1)20)) asobserved post saving(compare1_highcontra5, replace)
xtlogit unwantedcf  c.educ   $region $women  v201  i.country if perexuse>=.4  & cfsample==1,  re or
margins, at(educ=(0(1)20)) asobserved post saving(compare1_highcontra4, replace)
log close


log using socius20230114_2, text replace 
** supplementary analysis 3: women's relative education 
gen edu=0 if educ <= pereduc 
replace edu=1 if educ > pereduc 
tab edu
xtlogit unwantedcf i.edu##c.perexuse $region $women i.country , re or
xtlogit unwanted i.edu##c.perexuse   $region $women i.country , re or

*margins 
xtlogit unwantedcf c.educ  $region $women i.country if perexuse<=.2 & cfsample==1
margins, at(educ=(0(1)20)) post saving(compare1_lowcontra, replace)
xtlogit unwantedcf c.educ  $region $women i.country if perexuse>=.4 & perexuse!=. & cfsample==1
margins, at(educ=(0(1)20)) post saving(compare1_highcontra, replace)

*margins 
xtlogit unwanted c.educ  $region $women i.country if perexuse<=.2 & psample==1
margins, at(educ=(0(1)20)) post saving(compare2_lowcontra, replace)
xtlogit unwanted c.educ  $region $women i.country if perexuse>=.4 & perexuse!=. & psample==1
margins, at(educ=(0(1)20)) post saving(compare2_highcontra, replace)

*margins 
xtlogit unwanted_ c.educ  $region $women i.country if perexuse<=.2
margins, at(educ=(0(1)20)) post saving(compare3_lowcontra, replace)
xtlogit unwanted_ c.educ  $region $women i.country if perexuse>=.4 & perexuse!=.
margins, at(educ=(0(1)20)) post saving(compare3_highcontra, replace)

*margins 
xtlogit unwanted_ c.educ  $region $women i.country if perexuse<=.2 & v201==0
margins, at(educ=(0(1)20)) post saving(compare4_lowcontra, replace)
xtlogit unwanted_ c.educ  $region $women i.country if perexuse>=.4 & perexuse!=. & v201==0
margins, at(educ=(0(1)20)) post saving(compare4_highcontra, replace)

*****************
**** FIGURE 1 *** REGIONAL ANALYSIS: N=596 regions
*****************
*ssc install grstyle
grstyle init
grstyle set horizontal
grstyle set plain
*ssc install labutil
duplicates drop group_id, force
sum perexuse
egen perexuse_mean=mean(perexuse), by(countryname)
sort  perexuse_mean countryname 
by perexuse_mean countryname: gen rank=1 if _n==1
replace rank = sum(rank)
replace rank = . if missing(countryname)
tab rank
label variable rank "Country"
labmask rank, values(countryname)
replace perexuse=perexuse*100
scatter  rank perexuse,   msymbol(circle_hollow) mcolor(black) msize(vsmall) ///
yla(1/50, valuelabel noticks ang(h)) ///
xtitle("Regional prevalence of contraceptive use (%)", size(small)) ///
xlabel(0(10)70, labsize(vsmall)) xscale(titlegap(3)) ytitle("") ///
ylabel(, valuelabel ang(0) labsize(vsmall)) graphregion(color(white)) 
graph display, ysize(3) xsize(2)



*************************
*** APPENDIX TABLE A2 *** REGIONAL ANALYSIS: N=596 regions 
*************************

** comparing different contracpting contexts
sum perelec if perexuse <=10
sum perphone if perexuse <=10
sum perurban if perexuse <=10
sum perrich if perexuse <=10
sum pereduc if perexuse <=10
sum regioncf if perexuse <=10

sum perelec if perexuse >=40
sum perphone if perexuse >=40
sum perurban if perexuse >=40
sum perrich if perexuse >=40
sum pereduc if perexuse >=40
sum regioncf if perexuse >=40

*correlations 
pwcorr perelec perexuse, sig
pwcorr perphone perexuse, sig
pwcorr perurban perexuse, sig
pwcorr perrich perexuse, sig
pwcorr pereduc perexuse, sig
pwcorr regioncf perexuse, sig

****************
*** FIGURE 2 ***
****************
use compare1_lowcontra, clear
gen context="low"
append using compare1_highcontra
replace context="high" if context==""
sum _margin _ci_lb _ci_ub 
twoway connected _margin _at1 if context=="low" , msize(small) lcolor(red) mcolor(red) ///
|| rcap _ci_lb _ci_ub _at1 if context=="low" ,  color(gray) ///
|| connected _margin _at1 if context=="high" , msize(small) lcolor(black) mcolor(black) ///
|| rcap _ci_lb _ci_ub _at1 if context=="high" ,  color(gray) ///
, ylabel(0(0.01)0.03, labsize(small) angle(0)) ytitle("") xtitle("")  ///
xlabel(0(1)20,  labsize(vsmall))  legend(order( 1 "Low contraceptive prevalence" ///
3 "High contraceptive prevalence" )) ///
legend(size(small) cols(1) ring(0) pos(1) symxsize(6) symysize(2) forcesize rowgap(.4)) ///
legend(region(lwidth(none))) xtitle("Women's education in years", size(small)) xscale(titlegap(2)) ///
graphregion(margin(2 2 0 2)) plotregion(margin(2 2 0 2)) 

use compare2_lowcontra, clear
gen context="low"
append using compare2_highcontra
replace context="high" if context==""
sum _margin _ci_lb _ci_ub 
twoway connected _margin _at1 if context=="low" , msize(small) lcolor(red) mcolor(red) ///
|| rcap _ci_lb _ci_ub _at1 if context=="low" ,  color(gray) ///
|| connected _margin _at1 if context=="high" , msize(small) lcolor(black) mcolor(black) ///
|| rcap _ci_lb _ci_ub _at1 if context=="high" ,  color(gray) ///
, ylabel(0(0.05)0.30, labsize(small) angle(0)) ytitle("") xtitle("")  ///
xlabel(0(1)20,  labsize(vsmall))  legend(order( 1 "Low contraceptive prevalence" ///
3 "High contraceptive prevalence" )) ///
legend(size(small) cols(1) ring(0) pos(1) symxsize(6) symysize(2) forcesize rowgap(.4)) ///
legend(region(lwidth(none))) xtitle("Women's education in years", size(small)) xscale(titlegap(2)) ///
graphregion(margin(2 2 0 2)) plotregion(margin(2 2 0 2)) 

**************************
*** APPENDIX FIGURE A1 ***
**************************
use compare3_lowcontra, clear
gen context="low"
append using compare3_highcontra
replace context="high" if context==""
sum _margin _ci_lb _ci_ub 
twoway connected _margin _at1 if context=="low" , msize(small) lcolor(red) mcolor(red) ///
|| rcap _ci_lb _ci_ub _at1 if context=="low" ,  color(gray) ///
|| connected _margin _at1 if context=="high" , msize(small) lcolor(black) mcolor(black) ///
|| rcap _ci_lb _ci_ub _at1 if context=="high" ,  color(gray) ///
, ylabel(0(0.01)0.03, labsize(small) angle(0)) ytitle("") xtitle("")  ///
xlabel(0(1)20,  labsize(vsmall))  legend(order( 1 "Low contraceptive prevalence" ///
3 "High contraceptive prevalence" )) ///
legend(size(small) cols(1) ring(0) pos(1) symxsize(6) symysize(2) forcesize rowgap(.4)) ///
legend(region(lwidth(none))) xtitle("Women's education in years", size(small)) xscale(titlegap(2)) ///
graphregion(margin(2 2 0 2)) plotregion(margin(2 2 0 2)) 

**************************
*** APPENDIX FIGURE A2 ***
**************************
use compare4_lowcontra, clear
gen context="low"
append using compare4_highcontra
replace context="high" if context==""
sum _margin _ci_lb _ci_ub 
twoway connected _margin _at1 if context=="low" , msize(small) lcolor(red) mcolor(red) ///
|| rcap _ci_lb _ci_ub _at1 if context=="low" ,  color(gray) ///
|| connected _margin _at1 if context=="high" , msize(small) lcolor(black) mcolor(black) ///
|| rcap _ci_lb _ci_ub _at1 if context=="high" ,  color(gray) ///
, ylabel(0(0.01)0.03, labsize(small) angle(0)) ytitle("") xtitle("")  ///
xlabel(0(1)20,  labsize(vsmall))  legend(order( 1 "Low contraceptive prevalence" ///
3 "High contraceptive prevalence" )) ///
legend(size(small) cols(1) ring(0) pos(1) symxsize(6) symysize(2) forcesize rowgap(.4)) ///
legend(region(lwidth(none))) xtitle("Women's education in years", size(small)) xscale(titlegap(2)) ///
graphregion(margin(2 2 0 2)) plotregion(margin(2 2 0 2)) 

