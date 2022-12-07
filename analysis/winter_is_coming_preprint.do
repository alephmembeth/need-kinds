/* header */
version 14.2

set more off, permanently
set scheme s2color


/* study 1, sample */
use "data_study_1.dta", clear

label define gender_lb 0 "Female" 1 "Male" 2 "Diverse", replace
   label values gender gender_lb

gen age_quota = .
   replace age_quota = 1 if age >= 18 & age < 30
   replace age_quota = 2 if age >= 30 & age < 40
   replace age_quota = 3 if age >= 40 & age < 50
   replace age_quota = 4 if age >= 50 & age < 60
   replace age_quota = 5 if age >= 60 & age < 75
label define age_quota_lb 1 "18–29" 2 "30–39" 3 "40–49" 4 "50–59" 5 "60–74", replace
   label values age_quota age_quota_lb

gen income_quota = .
   replace income_quota = 1 if household_net_income >= 0    & household_net_income < 1500
   replace income_quota = 2 if household_net_income >= 1500 & household_net_income < 2500
   replace income_quota = 3 if household_net_income >= 2500 & household_net_income < 3500
   replace income_quota = 4 if household_net_income >= 3500 & household_net_income < 4500
   replace income_quota = 5 if household_net_income >= 4500
label define income_quota_lb 1 "0–1500" 2 "1500–2500" 3 "2500–3500" 4 "3500–4500" 5 ">4500", replace
   label values income_quota income_quota_lb

preserve
   keep if complete == 1

   tab gender
   tab age_quota
   tab income_quota
restore


/* study 1, failure rates */
gen fail_1 = .
   replace fail_1 = checker_justice != "42" if complete == 1 | quality_fail == 1

gen fail_2 = .
   replace fail_2 = checker_community_heat != 1 | checker_community_carving == 1 | checker_community_renovating == 1 if complete == 1 | quality_fail == 1

gen fail_3 = .
   replace fail_3 = checker_number_of_need_types != 4 if complete == 1 | quality_fail == 1

tab1 fail_1 fail_2 fail_3

tab number_of_quality_fails

tab quality_fail

preserve
   keep if complete == 1 | quality_fail == 1

   tab gender quality_fail, chi2
   tab age_quota quality_fail, chi2
   tab income_quota quality_fail, chi2
restore
