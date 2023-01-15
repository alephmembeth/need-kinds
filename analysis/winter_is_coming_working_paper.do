/* header */
version 14.2

set more off, permanently
set scheme s2color


/* study 1, sample */
use "study_1.dta", clear

label define gender_lb 0 "Female" 1 "Male" 2 "Diverse", replace
   label values gender gender_lb

gen age_quota = .
   replace age_quota = 1 if age >= 18 & age < 30
   replace age_quota = 2 if age >= 30 & age < 40
   replace age_quota = 3 if age >= 40 & age < 50
   replace age_quota = 4 if age >= 50 & age < 60
   replace age_quota = 5 if age >= 60 & age < 75
label define age_quota_lb 1 "18 – 29" 2 "30 – 39" 3 "40 – 49" 4 "50 – 59" 5 "60 – 74", replace
   label values age_quota age_quota_lb

gen income_quota = .
   replace income_quota = 1 if household_net_income >= 0    & household_net_income < 1500
   replace income_quota = 2 if household_net_income >= 1500 & household_net_income < 2500
   replace income_quota = 3 if household_net_income >= 2500 & household_net_income < 3500
   replace income_quota = 4 if household_net_income >= 3500 & household_net_income < 4500
   replace income_quota = 5 if household_net_income >= 4500
label define income_quota_lb 1 "0 – 1500" 2 "1500 – 2500" 3 "2500 – 3500" 4 "3500 – 4500" 5 "> 4500", replace
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
   replace fail_2 = ///
      checker_community_heat != 1 | ///
      checker_community_carving == 1 | ///
      checker_community_renovating == 1 ///
      if complete == 1 | quality_fail == 1

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


/* study 1, importance */
preserve
   keep if complete == 1

   tab need_type_survival
   tab need_type_decency
   tab need_type_belonging
   tab need_type_autonomy

   ci means need_type_survival
   ci means need_type_decency
   ci means need_type_belonging
   ci means need_type_autonomy

   signrank need_type_survival = need_type_decency
   signrank need_type_decency = need_type_belonging
   signrank need_type_belonging = need_type_autonomy

   rename need_type_survival  eval_1
   rename need_type_decency   eval_2
   rename need_type_belonging eval_3
   rename need_type_autonomy  eval_4

   reshape long eval_, i(id) j(kind_of_need)

   label define kind_of_need_lb 1 "Survival" 2 "Decency" 3 "Belonging" 4 "Autonomy", replace
      label values kind_of_need kind_of_need_lb

   oneway eval kind_of_need, bonferroni tabulate

   cibar eval_, over1(kind_of_need) ///
      baropts( ///
         lcolor(black) ///
         lpattern(solid) ///
         lwidth(medium) ///
         ) ///
      graphopts( ///
         xtitle(Kind of Need) ///
         xlabel(1 "Survival" 2 "Decency" 3 "Belonging" 4 "Autonomy") ///
         ytitle(Importance) ///
         ylabel(, angle(horizontal)) ///
         legend(off) ///
         graphregion(color(white)) ///
         )
      graph export "figure_2.pdf", as(pdf) replace

   regress eval i.kind_of_need, vce(ols)
   regress eval i.kind_of_need age gender household_net_income political_attitude sensitivity_to_cold, vce(ols)

   margins i.kind_of_need, pwcompare(pv) level(95) mcompare(bonferroni)
restore


/* study 2, sample */
use "study_2.dta", clear

label define gender_lb 0 "Female" 1 "Male" 2 "Diverse", replace
   label values gender gender_lb

gen age_quota = .
   replace age_quota = 1 if age >= 18 & age < 30
   replace age_quota = 2 if age >= 30 & age < 40
   replace age_quota = 3 if age >= 40 & age < 50
   replace age_quota = 4 if age >= 50 & age < 60
   replace age_quota = 5 if age >= 60 & age < 75
label define age_quota_lb 1 "18 – 29" 2 "30 – 39" 3 "40 – 49" 4 "50 – 59" 5 "60 – 74", replace
   label values age_quota age_quota_lb

gen income_quota = .
   replace income_quota = 1 if household_net_income >= 0    & household_net_income < 1500
   replace income_quota = 2 if household_net_income >= 1500 & household_net_income < 2500
   replace income_quota = 3 if household_net_income >= 2500 & household_net_income < 3500
   replace income_quota = 4 if household_net_income >= 3500 & household_net_income < 4500
   replace income_quota = 5 if household_net_income >= 4500
label define income_quota 1 "0 – 1500" 2 "1500 – 2500" 3 "2500 – 3500" 4 "3500 – 4500" 5 "> 4500", replace
   label values income_quota income_quota_lb

preserve
   keep if complete==1

   tab gender
   tab age_quota
   tab income_quota
restore


/* study 2, failure rates */
gen fail_1 = .
   replace fail_1 = checker_justice != "42" if complete == 1 | quality_fail == 1

gen fail_2 = .
   replace fail_2 = ///
      checker_winter != 1 | ///
      checker_house == 1 | ///
      checker_drinking == 1 | ///
      checker_mill == 1 | ///
      checker_wheat == 1 | ///
      checker_rye == 1 | ///
      checker_sunflowers == 1 ///
      if complete == 1 | quality_fail == 1

gen fail_3 = .
   replace fail_3 = checker_amount != 1000 if complete == 1 | quality_fail == 1

tab1 fail_1 fail_2 fail_3

tab number_of_quality_fails

tab quality_fail

preserve
   keep if complete == 1 | quality_fail == 1

   tab gender quality_fail, chi2
   tab age_quota quality_fail, chi2
   tab income_quota quality_fail, chi2
restore


/* study 2, paired cases */
keep if complete == 1

reshape long ///
   allocation_a_unequal_ need_a_unequal_ productivity_a_unequal_ needtype_a_unequal_ ///
   allocation_b_unequal_ need_b_unequal_ productivity_b_unequal_ needtype_b_unequal_ ///
   allocation_a_equal_ need_a_equal_ productivity_a_equal_ needtype_a_equal_ ///
   allocation_b_equal_ need_b_equal_ productivity_b_equal_ needtype_b_equal_ ///
   , i(id) j(case)

rename *_ *

reshape long ///
   allocation_a_ need_a_ productivity_a_ needtype_a_ ///
   allocation_b_ need_b_ productivity_b_ needtype_b_ ///
   , i(id case) j(productivity) string

rename *_ *

gen need_share_a = need_a / (need_a + need_b)

gen share_a = allocation_a / (productivity_a + productivity_b)

gen allocation_diff = allocation_a - allocation_b

encode productivity, gen(supply)
   drop productivity
   ren supply productivity

encode needtype_a, gen(need_type_a)
   drop needtype_a
   ren need_type_a needtype_a

encode needtype_b, gen(need_type_b)
   drop needtype_b
   ren need_type_b needtype_b

preserve
   keep if case == 0 | case == 4 | case == 7 | case == 9

   replace case = 1 if case == 0
   replace case = 2 if case == 4
   replace case = 3 if case == 7
   replace case = 4 if case == 9

   label define case_lb 1 "Survival" 2 "Decency" 3 "Belonging" 4 "Autonomy", replace
      label values case case_lb

   label define productivity_lb 1 "Equal Productivity Scenario" 2 "Unequal Productivity Scenario", replace
      label values productivity productivity_lb

   by case, sort: ttest allocation_diff, by(productivity) unequal welch

   cibar allocation_diff, over2(case) over1(productivity) ///
      baropts( ///
         lcolor(black) ///
         lpattern(solid) ///
         lwidth(medium) ///
         ) ///
      graphopts( ///
         xtitle("Paired Case") ///
         xlabel(, angle(forty_five)) ///
         ytitle("Difference") ///
         ylabel(-300 "— 300" -200 "— 200" -100 "— 100" 0 "0" 100 "100", angle(horizontal)) ///
         legend(cols(1)) ///
         graphregion(color(white)) ///
         )
      graph export "figure_4.pdf", as(pdf) replace

   mean allocation_diff, over(case productivity)
restore

gen productivity_share_a = productivity_a / (productivity_a + productivity_b)

preserve
   gen deviation_a = abs(((share_a - productivity_share_a) / (need_share_a / productivity_share_a))) * 100

   sum deviation_a if productivity == 1 & case == 0
   sum deviation_a if productivity == 1 & case == 4
   sum deviation_a if productivity == 1 & case == 7
   sum deviation_a if productivity == 1 & case == 9

   sum deviation_a if productivity == 2 & case == 0
   sum deviation_a if productivity == 2 & case == 4
   sum deviation_a if productivity == 2 & case == 7
   sum deviation_a if productivity == 2 & case == 9
restore


/* study 2, mixed cases */
preserve
   drop if case == 0 | case == 4 | case == 7 | case == 9

   recode case (1 = 6) (3 = 1) (6 = 3)

   recode case (1 = 0) (2 = 1) (3 = 2) (5 = 3) (6 = 4) (8 = 5)

   label define case_lb 0 "Survival – Autonomy" 1 "Survival – Belonging" 2 "Decency – Autonomy" 3 "Decency – Belonging" 4 "Survival – Decency" 5 "Belonging – Autonomy", replace
      label values case case_lb

   label define productivity_lb 1 "Equal Productivity Scenario" 2 "Unequal Productivity Scenario", replace
      label values productivity productivity_lb

   by case, sort : ttest allocation_diff, by(productivity) unequal welch

   cibar allocation_diff, over2(case) over1(productivity) ///
      baropts( ///
         lcolor(black) ///
         lpattern(solid) ///
         lwidth(medium) ///
		 ) ///
      graphopts( ///
         xtitle("Mixed Case") ///
         xlabel(, angle(forty_five)) ///
         ytitle("Difference") ///
         ylabel(-200 "— 200" -100 "— 100" 0 "0" 100 "100" 200 "200" 300 "300" 400 "400" 500 "500" 600 "600", angle(horizontal)) ///
         legend(cols(1)) ///
         graphregion(color(white)) ///	  
         )
      graph export "figure_5.pdf", as(pdf) replace

   gen need_combination = case
   label var need_combination "Combination"
   label values need_combination case_lb

   replace case = case + 10 if productivity == 2

   xtset id case

   eststo: xttobit allocation_diff i.need_combination, vce(oim) ll(-1000) ul(1000)

   eststo: xttobit allocation_diff i.productivity##i.need_combination, vce(oim) ll(-1000) ul(1000)

   eststo: xttobit allocation_diff i.frame i.productivity i.frame##i.productivity i.need_combination, vce(oim) ll(-1000) ul(1000)

   eststo: xttobit allocation_diff i.frame i.productivity i.need_combination ///
      household_net_income ///
      age ///
      gender ///
      criteria_likert_need ///
      criteria_likert_productivity ///
      criteria_likert_equality ///
      political_attitude ///
      sensitivity_to_cold ///
      , vce(oim) ll(-1000) ul(1000)

   margins i.need_combination, pwcompare(pv) level(90) mcompare(bonferroni)

   mean allocation_diff, over(case productivity)
restore


/* study 2, additivity */
global barchart_options = "lcolor(black) lpattern(solid) lwidth(medium) graphregion(color(white))"

drop if case == 0 | case == 4 | case == 7 | case == 9

recode case (1 = 6) (3 = 1) (6 = 3)
recode case (1 = 0) (2 = 1) (3 = 2) (5 = 3) (6 = 4) (8 = 5)

label define case_lb 0 "Survival – Autonomy" 1 "Survival – Belonging" 2 "Decency – Autonomy" 3 "Decency – Belonging" 4 "Survival – Decency" 5 "Belonging – Autonomy", replace
   label values case case_lb

label define productivity_lb 1 "EPS" 2 "UPS", replace
   label values productivity productivity_lb

drop allocation_a allocation_b share_a needtype_a needtype_b
reshape wide allocation_diff, i(id productivity frame) j(case)

ren allocation_diff0 S_A
ren allocation_diff1 S_B
ren allocation_diff2 D_A
ren allocation_diff3 D_B
ren allocation_diff4 S_D
ren allocation_diff5 B_A

gen breakdown_sum_1 = S_A
gen breakdown_sum_2 = S_B + B_A
gen breakdown_sum_3 = S_D + D_A
gen breakdown_sum_4 = S_D + D_B + B_A
gen breakdown_sum_5 = D_A
gen breakdown_sum_6 = D_B + B_A
gen breakdown_sum_7 = S_B
gen breakdown_sum_8 = S_D + D_B

global breakdown_y_scale = "0(200)800"

preserve
   gen breakdown = 1
      label var breakdown "Combination"

   forval i = 2/8 {
      expand 2 if breakdown == 1, gen(dupindicator)
      replace breakdown = `i' if dupindicator == 1
      drop dupindicator
      }

   replace S_A = . if breakdown != 1
   replace D_A = . if breakdown != 3 & breakdown != 5
   replace S_B = . if breakdown != 2 & breakdown != 7
   replace D_B = . if breakdown != 4 & breakdown != 6 & breakdown != 8
   replace S_D = . if breakdown != 3 & breakdown != 4 & breakdown != 8
   replace B_A = . if breakdown != 2 & breakdown != 4 & breakdown != 6

   collapse B_A D_B D_A S_D S_B S_A ///
      (mean)   mean_1 = breakdown_sum_1 mean_2 = breakdown_sum_2 ///
               mean_3 = breakdown_sum_3 mean_4 = breakdown_sum_4 ///
               mean_5 = breakdown_sum_5 mean_6 = breakdown_sum_6 ///
               mean_7 = breakdown_sum_7 mean_8 = breakdown_sum_8 ///
      (sd)     sd_1 = breakdown_sum_1 sd_2 = breakdown_sum_2 ///
               sd_3 = breakdown_sum_3 sd_4 = breakdown_sum_4 ///
               sd_5 = breakdown_sum_5 sd_6 = breakdown_sum_6 ///
               sd_7 = breakdown_sum_7 sd_8 = breakdown_sum_8 ///
      (count)  n_1 = breakdown_sum_1 n_2 = breakdown_sum_2 ///
               n_3 = breakdown_sum_3 n_4 = breakdown_sum_4 ///
               n_5 = breakdown_sum_5 n_6 = breakdown_sum_6 ///
               n_7 = breakdown_sum_7 n_8 = breakdown_sum_8 ///
               , by(breakdown productivity)

   label variable S_A "Survival – Autonomy"
   label variable S_B "Survival – Belonging"
   label variable D_A "Decency – Autonomy"
   label variable D_B "Decency – Belonging"
   label variable S_D "Survival – Decency"
   label variable B_A "Belonging – Autonomy"

   local tail_size = 0.05
   gen ci_lo = .
   gen ci_hi = .
   forval i = 1/8 {
      replace ci_lo = mean_`i' - invttail(n_`i' / 2 - 1, `tail_size') * (sd_`i' / sqrt(n_`i' / 2)) if breakdown == `i'
      replace ci_hi = mean_`i' + invttail(n_`i' / 2 - 1, `tail_size') * (sd_`i' / sqrt(n_`i' / 2)) if breakdown == `i'
      }

   replace S_B = S_B + B_A if breakdown == 2
   replace S_D = S_D + D_A if breakdown == 3
   replace S_D = S_D + D_B + B_A if breakdown == 4
   replace D_B = D_B + B_A if breakdown == 4 | breakdown == 6
   replace S_D = S_D + D_B if breakdown == 8

   twoway (bar S_A breakdown, $barchart_options) ///
      (bar S_B breakdown, $barchart_options) ///
      (bar S_D breakdown, $barchart_options) ///
      (bar D_A breakdown, $barchart_options) ///
      (bar D_B breakdown, $barchart_options) ///
      (bar B_A breakdown, $barchart_options) ///
      (rcap ci_hi ci_lo breakdown, lcolor(black)) if breakdown < 5, ///
      by(productivity, ///
         note("") ///
         graphregion(color(white)) ///
         ) ///
      xlabel(1 2 3 4) ///
      ytitle("Difference") ///
      ylabel($breakdown_y_scale, angle(0)) ///
      legend(order(1 2 3 4 5 6))
      graph export "figure_6.pdf", as(pdf) replace

   twoway (bar S_A breakdown, $barchart_options) ///
      (bar S_B breakdown, $barchart_options) ///
      (bar S_D breakdown, $barchart_options) ///
      (bar D_A breakdown, $barchart_options) ///
      (bar D_B breakdown, $barchart_options) ///
      (bar B_A breakdown, $barchart_options) ///
      (rcap ci_hi ci_lo breakdown, lcolor(black)) if breakdown > 4 & breakdown < 7, ///
      by(productivity, ///
         note("") ///
         graphregion(color(white)) ///
         ) ///
      xlabel(5 "1" 6 "2") ///
      ytitle("Difference") ///
      ylabel($breakdown_y_scale, angle(0)) ///
      legend(order(4 5 6))
      graph export "figure_7.pdf", as(pdf) replace

   twoway (bar S_A breakdown, $barchart_options) ///
      (bar S_B breakdown, $barchart_options) ///
      (bar S_D breakdown, $barchart_options) ///
      (bar D_A breakdown, $barchart_options) ///
      (bar D_B breakdown, $barchart_options) ///
      (bar B_A breakdown, $barchart_options) ///
      (rcap ci_hi ci_lo breakdown, lcolor(black)) if breakdown > 6, ///
      by(productivity, ///
         note("") ///
         graphregion(color(white)) ///
         ) ///
      xlabel(7 "1" 8 "2") ///
      ytitle("Difference") ///
      ylabel($breakdown_y_scale, angle(0)) ///
      legend(order(2 3 5))
      graph export "figure_8.pdf", as(pdf) replace
restore

reshape long breakdown_sum_, i(id productivity frame) j(breakdown)

label var breakdown "Breakdown"
label define breakdown_lb 1 "A S" 2 "A B S" 3 "A D S" 4 "A B D S" 5 "A D" 6 "A B D" 7 "B S" 8 "B D S", replace
   label values breakdown breakdown_lb

preserve
   keep if breakdown < 5
   bysort productivity: oneway breakdown_sum_ breakdown, bonferroni tabulate
restore

preserve
   keep if breakdown > 4 & breakdown < 7
   bysort productivity: oneway breakdown_sum_ breakdown, bonferroni tabulate
restore

preserve
   keep if breakdown > 6
   bysort productivity: oneway breakdown_sum_ breakdown, bonferroni tabulate
restore
