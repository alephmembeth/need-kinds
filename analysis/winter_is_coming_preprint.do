/* header */
/* note: some commands require the cibar package; if not installed, run 'ssc install cibar' first */
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

gen fail_once_or_more = .
   replace fail_once_or_more = 1 if fail_1 == 1 | fail_2 == 1 | fail_3 == 1

tab fail_once_or_more


/* study 1, importance */
keep if complete == 1 /* to exclude subjects who failed at least one check, run 'drop if fail_once_or_more == 1' */

tab need_type_survival
tab need_type_decency
tab need_type_belonging
tab need_type_autonomy

ci means need_type_survival
ci means need_type_decency
ci means need_type_belonging
ci means need_type_autonomy

signrank need_type_survival  = need_type_decency
signrank need_type_survival  = need_type_belonging
signrank need_type_survival  = need_type_autonomy
signrank need_type_decency   = need_type_belonging
signrank need_type_decency   = need_type_autonomy
signrank need_type_belonging = need_type_autonomy

rename need_type_survival  eval_1
rename need_type_decency   eval_2
rename need_type_belonging eval_3
rename need_type_autonomy  eval_4

reshape long eval_, i(id) j(kind_of_need)

label define kind_of_need_lb 1 "Survival" 2 "Decency" 3 "Belonging" 4 "Autonomy", replace
   label values kind_of_need kind_of_need_lb

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
         ylabel(1(1)7, angle(horizontal)) ///
         legend(off) ///
         graphregion(color(white)) ///
         )
      graph export "figure_2.pdf", as(pdf) replace

ologit eval_ c.age i.gender household_net_income political_attitude sensitivity_to_cold if kind_of_need == 1, vce(robust)
predict score if kind_of_need == 1, xb
generate prob7 = 1 - 1 / (1 + exp(score - _b[/cut4]))
generate prob6 = 1 / (1 + exp(score - _b[/cut4])) - 1 / (1 + exp(score - _b[/cut3]))
generate prob5 = 1 / (1 + exp(score - _b[/cut3])) - 1 / (1 + exp(score - _b[/cut2]))
generate prob4 = 1 / (1 + exp(score - _b[/cut2])) - 1 / (1 + exp(score - _b[/cut1]))
generate prob3 = 1 / (1 + exp(score - _b[/cut1]))
drop score

ologit eval_ c.age i.gender household_net_income political_attitude sensitivity_to_cold if kind_of_need == 2, vce(robust)
predict score if kind_of_need == 2, xb
replace prob7 = 1 - 1 / (1 + exp(score - _b[/cut4])) if kind_of_need == 2
replace prob6 = 1 / (1 + exp(score - _b[/cut4])) - 1 / (1 + exp(score - _b[/cut3])) if kind_of_need == 2
replace prob5 = 1 / (1 + exp(score - _b[/cut3])) - 1 / (1 + exp(score - _b[/cut2])) if kind_of_need == 2
replace prob4 = 1 / (1 + exp(score - _b[/cut2])) - 1 / (1 + exp(score - _b[/cut1])) if kind_of_need == 2
replace prob3 = 1 / (1 + exp(score - _b[/cut1])) if kind_of_need == 2
drop score

ologit eval_ c.age i.gender household_net_income political_attitude sensitivity_to_cold if kind_of_need == 3, vce(robust)
predict score if kind_of_need == 3, xb
replace prob7 = 1 - 1 / (1 + exp(score - _b[/cut6])) if kind_of_need == 3
replace prob6 = 1 / (1 + exp(score - _b[/cut6])) - 1 / (1 + exp(score - _b[/cut5])) if kind_of_need == 3
replace prob5 = 1 / (1 + exp(score - _b[/cut5])) - 1 / (1 + exp(score - _b[/cut4])) if kind_of_need == 3
replace prob4 = 1 / (1 + exp(score - _b[/cut4])) - 1 / (1 + exp(score - _b[/cut3])) if kind_of_need == 3
replace prob3 = 1 / (1 + exp(score - _b[/cut3])) - 1 / (1 + exp(score - _b[/cut2])) if kind_of_need == 3
gen prob2 = 1 / (1 + exp(score - _b[/cut2])) - 1 / (1 + exp(score - _b[/cut1])) if kind_of_need == 3
gen prob1 = 1 / (1 + exp(score - _b[/cut1])) if kind_of_need == 3
drop score

ologit eval_ c.age i.gender household_net_income political_attitude sensitivity_to_cold if kind_of_need == 4, vce(robust)
predict score if kind_of_need == 4, xb
replace prob7 = 1 - 1 / (1 + exp(score - _b[/cut6])) if kind_of_need == 4
replace prob6 = 1 / (1 + exp(score - _b[/cut6])) - 1 / (1 + exp(score - _b[/cut5])) if kind_of_need == 4
replace prob5 = 1 / (1 + exp(score - _b[/cut5])) - 1 / (1 + exp(score - _b[/cut4])) if kind_of_need == 4
replace prob4 = 1 / (1 + exp(score - _b[/cut4])) - 1 / (1 + exp(score - _b[/cut3])) if kind_of_need == 4
replace prob3 = 1 / (1 + exp(score - _b[/cut3])) - 1 / (1 + exp(score - _b[/cut2])) if kind_of_need == 4
replace prob2 = 1 / (1 + exp(score - _b[/cut2])) - 1 / (1 + exp(score - _b[/cut1])) if kind_of_need == 4
replace prob1 = 1 / (1 + exp(score - _b[/cut1])) if kind_of_need == 4
drop score

replace prob2 = 0 if prob2 == .
replace prob1 = 0 if prob1 == .

mean prob7 prob6 prob5 prob4 prob3 prob2 prob1, over(kind_of_need)


/* study 2, sample */
use "data_study_2_need_type.dta", clear

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
   keep if complete == 1

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

gen fail_once_or_more = .
   replace fail_once_or_more = 1 if fail_1 == 1 | fail_2 == 1 | fail_3 == 1

tab fail_once_or_more


/* study 2, paired cases */
keep if complete == 1 /* to exclude subjects who failed at least one check, run 'drop if fail_once_or_more == 1' */

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

save "study2_long.dta", replace

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

   ttest allocation_diff if productivity == 1 & (needtype_a == 4 | needtype_a == 3), by(needtype_a) unequal welch
   ttest allocation_diff if productivity == 1 & (needtype_a == 4 | needtype_a == 2), by(needtype_a) unequal welch
   ttest allocation_diff if productivity == 1 & (needtype_a == 4 | needtype_a == 1), by(needtype_a) unequal welch
   ttest allocation_diff if productivity == 1 & (needtype_a == 3 | needtype_a == 2), by(needtype_a) unequal welch
   ttest allocation_diff if productivity == 1 & (needtype_a == 3 | needtype_a == 1), by(needtype_a) unequal welch
   ttest allocation_diff if productivity == 1 & (needtype_a == 2 | needtype_a == 1), by(needtype_a) unequal welch
   ttest allocation_diff if productivity == 2 & (needtype_a == 4 | needtype_a == 3), by(needtype_a) unequal welch
   ttest allocation_diff if productivity == 2 & (needtype_a == 4 | needtype_a == 2), by(needtype_a) unequal welch
   ttest allocation_diff if productivity == 2 & (needtype_a == 4 | needtype_a == 1), by(needtype_a) unequal welch
   ttest allocation_diff if productivity == 2 & (needtype_a == 3 | needtype_a == 2), by(needtype_a) unequal welch
   ttest allocation_diff if productivity == 2 & (needtype_a == 3 | needtype_a == 1), by(needtype_a) unequal welch
   ttest allocation_diff if productivity == 2 & (needtype_a == 2 | needtype_a == 1), by(needtype_a) unequal welch
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
use "study2_long", clear

drop if case == 0 | case == 4 | case == 7 | case == 9
recode case (3 = 0) (2 = 1) (1 = 2) (6 = 3) (5 = 4) (8 = 5)

label define case_lb 0 "Survival – Autonomy" 1 "Survival – Belonging" 2 "Survival – Decency" 3 "Decency – Autonomy" 4 "Decency – Belonging"  5 "Belonging – Autonomy", replace
   label values case case_lb

label define productivity_lb 1 "Equal Productivity Scenario" 2 "Unequal Productivity Scenario", replace
   label values productivity productivity_lb

label define frame_lb 1 "Avoidance" 2 "Enablement"
   label values frame frame_lb

by case, sort: ttest allocation_diff, by(productivity) unequal welch

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


/* study 2, need combination */
eststo clear

xttobit allocation_diff i.need_combination, vce(oim) ll(-1000) ul(1000)

eststo T1

margins i.need_combination

test (0 = _b[1.need_combination]) ///
     (0 = _b[2.need_combination]) ///
     (_b[1.need_combination] = _b[2.need_combination]) ///
     (_b[3.need_combination] = _b[4.need_combination]) ///
     , mtest(bonferroni)


/* study 2, interaction with productivity scenario */
xttobit allocation_diff i.need_combination##i.productivity, vce(oim) ll(-1000) ul(1000)

eststo T2

margins i.need_combination#i.productivity

test (0 = _b[2.productivity]) ///
     (_b[1.need_combination] = _b[2.productivity] + _b[1.need_combination] + _b[1.need_combination#2.productivity]) ///
     (_b[2.need_combination] = _b[2.productivity] + _b[2.need_combination] + _b[2.need_combination#2.productivity]) ///
     (_b[3.need_combination] = _b[2.productivity] + _b[3.need_combination] + _b[3.need_combination#2.productivity]) ///
     (_b[4.need_combination] = _b[2.productivity] + _b[4.need_combination] + _b[4.need_combination#2.productivity]) ///
     (_b[5.need_combination] = _b[2.productivity] + _b[5.need_combination] + _b[5.need_combination#2.productivity]) ///
     , mtest(bonferroni)

test (0 = _b[1.need_combination]) ///
     (0 = _b[2.need_combination]) ///
     (_b[1.need_combination] = _b[2.need_combination]) ///
     (_b[3.need_combination] = _b[4.need_combination]) ///
     , mtest(bonferroni)

test (_b[2.productivity] = _b[2.productivity] + _b[1.need_combination] + _b[1.need_combination#2.productivity]) ///
     (_b[2.productivity] = _b[2.productivity] + _b[2.need_combination] + _b[2.need_combination#2.productivity]) ///
     (_b[2.productivity] + _b[1.need_combination] + _b[1.need_combination#2.productivity] = _b[2.productivity] + _b[2.need_combination] + _b[2.need_combination#2.productivity]) ///
     (_b[2.productivity] + _b[3.need_combination] + _b[3.need_combination#2.productivity] = _b[2.productivity] + _b[4.need_combination] + _b[4.need_combination#2.productivity]) ///
     , mtest(bonferroni)


/* study 2, interaction with productivity scenario and control variables */
xttobit allocation_diff i.need_combination##i.productivity ///
   household_net_income ///
   age ///
   i.gender ///
   criteria_likert_need ///
   criteria_likert_productivity ///
   criteria_likert_equality ///
   political_attitude ///
   sensitivity_to_cold ///
   , vce(oim) ll(-1000) ul(1000)

eststo T3

margins i.need_combination#i.productivity

test (0 = _b[2.productivity]) ///
     (_b[1.need_combination] = _b[2.productivity] + _b[1.need_combination] + _b[1.need_combination#2.productivity]) ///
     (_b[2.need_combination] = _b[2.productivity] + _b[2.need_combination] + _b[2.need_combination#2.productivity]) ///
     (_b[3.need_combination] = _b[2.productivity] + _b[3.need_combination] + _b[3.need_combination#2.productivity]) ///
     (_b[4.need_combination] = _b[2.productivity] + _b[4.need_combination] + _b[4.need_combination#2.productivity]) ///
     (_b[5.need_combination] = _b[2.productivity] + _b[5.need_combination] + _b[5.need_combination#2.productivity]) ///
     , mtest(bonferroni)

test (0 = _b[1.need_combination]) ///
     (0 = _b[2.need_combination]) ///
     (_b[1.need_combination] = _b[2.need_combination]) ///
     (_b[3.need_combination] = _b[4.need_combination]) ///
     , mtest(bonferroni)

test (_b[2.productivity] = _b[2.productivity] + _b[1.need_combination] + _b[1.need_combination#2.productivity]) ///
     (_b[2.productivity] = _b[2.productivity] + _b[2.need_combination] + _b[2.need_combination#2.productivity]) ///
     (_b[2.productivity] + _b[1.need_combination] + _b[1.need_combination#2.productivity] = _b[2.productivity] + _b[2.need_combination] + _b[2.need_combination#2.productivity]) ///
     (_b[2.productivity] + _b[3.need_combination] + _b[3.need_combination#2.productivity] = _b[2.productivity] + _b[4.need_combination] + _b[4.need_combination#2.productivity]) ///
     , mtest(bonferroni)


/* study 2, interaction with formulation */
eststo: xttobit allocation_diff i.need_combination##i.frame, vce(oim) ll(-1000) ul(1000) /* to include interaction of frame and productivity scenario, run 'eststo: xttobit allocation_diff i.need_combination##i.frame i.frame##i.productivity, vce(oim) ll(-1000) ul(1000)' */

eststo T4

margins i.need_combination#i.frame

test (0 = _b[2.frame]) ///
     (_b[1.need_combination] = _b[2.frame] + _b[1.need_combination] + _b[1.need_combination#2.frame]) ///
     (_b[2.need_combination] = _b[2.frame] + _b[2.need_combination] + _b[2.need_combination#2.frame]) ///
     (_b[3.need_combination] = _b[2.frame] + _b[3.need_combination] + _b[3.need_combination#2.frame]) ///
     (_b[4.need_combination] = _b[2.frame] + _b[4.need_combination] + _b[4.need_combination#2.frame]) ///
     (_b[5.need_combination] = _b[2.frame] + _b[5.need_combination] + _b[5.need_combination#2.frame]) ///
     , mtest(bonferroni)

test (0 = _b[1.need_combination]) ///
     (0 = _b[2.need_combination]) ///
     (_b[1.need_combination] = _b[2.need_combination]) ///
     (_b[3.need_combination] = _b[4.need_combination]) ///
     , mtest(bonferroni)

test (_b[2.frame] = _b[2.frame] + _b[1.need_combination] + _b[1.need_combination#2.frame]) ///
     (_b[2.frame] = _b[2.frame] + _b[2.need_combination] + _b[2.need_combination#2.frame]) ///
     (_b[2.frame] + _b[1.need_combination] + _b[1.need_combination#2.frame] = _b[2.frame] + _b[2.need_combination] + _b[2.need_combination#2.frame]) ///
     (_b[2.frame] + _b[3.need_combination] + _b[3.need_combination#2.frame] = _b[2.frame] + _b[4.need_combination] + _b[4.need_combination#2.frame]) ///
     , mtest(bonferroni)

esttab T1 T2 T3 T4 using tobit_reg.tex, label se star(* 0.10 ** 0.05 *** 0.01) replace

mean allocation_diff, over(case productivity)

gen comptype = .
   replace comptype = 41 if needtype_a == 4 & needtype_b == 1
   replace comptype = 42 if needtype_a == 4 & needtype_b == 2
   replace comptype = 43 if needtype_a == 4 & needtype_b == 3
   replace comptype = 31 if needtype_a == 3 & needtype_b == 1
   replace comptype = 32 if needtype_a == 3 & needtype_b == 2
   replace comptype = 21 if needtype_a == 2 & needtype_b == 1

ttest allocation_diff if productivity == 1 & (comptype == 41 | comptype == 42), by(comptype) unequal welch
ttest allocation_diff if productivity == 1 & (comptype == 41 | comptype == 43), by(comptype) unequal welch
ttest allocation_diff if productivity == 1 & (comptype == 42 | comptype == 43), by(comptype) unequal welch
ttest allocation_diff if productivity == 1 & (comptype == 31 | comptype == 32), by(comptype) unequal welch


/* study 2, additivity */
use "study2_long", clear

global barchart_options = "lcolor(black) lpattern(solid) lwidth(medium) graphregion(color(white))"

drop if case == 0 | case == 4 | case == 7 | case == 9

recode case (1 = 6) (3 = 1) (6 = 3)
recode case (1 = 0) (2 = 1) (3 = 2) (5 = 3) (6 = 4) (8 = 5)

label define case_lb 0 "Survival – Autonomy" 1 "Survival – Belonging" 2 "Decency – Autonomy" 3 "Decency – Belonging" 4 "Survival – Decency" 5 "Belonging – Autonomy", replace
   label values case case_lb

label define productivity_lb 1 "EPS" 2 "UPS", replace
   label values productivity productivity_lb

drop allocation_a allocation_b share_a needtype_a needtype_b

ren _merge merge

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


/* comparing study 2 with study 1, mean evaluations, first vs. later evaluations */
use "data_study_2_need_type.dta", clear

keep if complete == 1

keep need_type_survival need_type_decency need_type_belonging need_type_autonomy need_type_order

replace need_type_survival  = . if need_type_survival  == 99
replace need_type_decency   = . if need_type_decency   == 99
replace need_type_belonging = . if need_type_belonging == 99
replace need_type_autonomy  = . if need_type_autonomy  == 99

tabulate need_type_order
tabulate need_type_survival
tabulate need_type_decency
tabulate need_type_belonging
tabulate need_type_autonomy

gen first_type = "."
   replace first_type = "survival"  if substr(need_type_order,1,1) == "s"
   replace first_type = "decency"   if substr(need_type_order,1,1) == "d"
   replace first_type = "belonging" if substr(need_type_order,1,1) == "b"
   replace first_type = "autonomy"  if substr(need_type_order,1,1) == "a"

gen survival_d  = (first_type == "survival")
gen decency_d   = (first_type == "decency")
gen belonging_d = (first_type == "belonging")
gen autonomy_d  = (first_type == "autonomy")

ttest need_type_survival, by(survival_d) unequal welch
ttest need_type_decency, by(decency_d) unequal welch
ttest need_type_belonging, by(belonging_d) unequal welch
ttest need_type_autonomy, by(autonomy_d) unequal welch

ranksum need_type_survival, by(survival_d)
ranksum need_type_decency, by(decency_d)
ranksum need_type_belonging, by(belonging_d)
ranksum need_type_autonomy, by(autonomy_d)

keep need_type_survival need_type_decency need_type_belonging need_type_autonomy

save "aux_study_2", replace

use "data_study_1.dta", clear

keep if complete == 1

append using "aux_study_2.dta", generate(file)

ttest need_type_survival, by(file) unequal welch
ttest need_type_decency, by(file) unequal welch
ttest need_type_belonging, by(file) unequal welch
ttest need_type_autonomy, by(file) unequal welch

ranksum need_type_survival, by(file)
ranksum need_type_decency, by(file)
ranksum need_type_belonging, by(file)
ranksum need_type_autonomy, by(file)

