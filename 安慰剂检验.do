*************安慰剂检验 *************//这个可借鉴使用，很便利，直接跑完，不用自己手动尝试
forvalue i=1/1000{
 sysuse EST-MMR_panel7, clear 
 g obs_id= _n 
 gen random_digit= runiform() 
 sort random_digit 
 g random_id= _n 
 preserve
 keep random_id did 
 rename did random_did
 rename random_id id 
 label var id 
 save random_did, replace
 restore 
 drop random_digit random_id did 
 rename obs_id id
label var id 
 save rawdata, replace 
 use rawdata, clear
 merge 1:1 id using random_did,nogen
 xtreg  imr random_did lnrjgdp lnspr lnurb lnseg lnmmr lnk lnd2m tcwv  t2m
 g _b_random_did= _b[random_did] 
 g _se_random_did= _se[random_did] 
 keep _b_random_did _se_random_did 
 duplicates drop _b_random_did, force
 save placebo`i', replace 
}
 use placebo1, clear
forvalue i=2/1000{
 append using placebo`i' 
} 
gen tvalue= _b_random_did/ _se_random_did
  gen pvalue = 2 * ttail(e(df_r), abs(tvalue))  // 计算t值和P值
  
   
  
  **# 2.2.1 系数

  sum _b_random_did, detail

  twoway(kdensity _b_random_did,                                                                     ///
             xline(`r(mean)', lpattern(dash)  lcolor(black))                                 ///
             xline(-0.0391  , lpattern(solid) lcolor(black))                                 ///
             scheme(qleanmono)                                                               ///
             xtitle("{stSans:Coefficient}"                        , size(medlarge))                 ///
             ytitle("{stSans:Kernel}""{stSans:density}", size(medlarge) orientation(h))  ///
             saving(placebo_test_Coefficient2, replace)),                                    ///
         xlabel(, labsize(medlarge) format(%02.1f))                                          ///
         ylabel(, labsize(medlarge) format(%02.1f))  // 绘制1,000次回归did的系数的核密度图

  graph export "placebo_test_Coefficient2.png", replace  // 导出为矢量图，方便论文中的图形展示；可改medlarge为large以加大字体

  
  **# 2.2.2 P值

  sum _b_random_did, detail
scatter pvalue _b_random_did
  twoway(scatter pvalue _b_random_did,   ///                                             
             msy(oh) mcolor(black)                                              ///
             xline(`r(mean)', lpattern(dash)      lcolor(black))                ///
             xline(-0.0391   , lpattern(solid)     lcolor(black))                ///
             yline( 0.1     , lpattern(shortdash) lcolor(black))                ///
             scheme(qleanmono)                                                  ///
             xtitle("{stSans:Coefficient}"           , size(medlarge))                 ///
             ytitle("{stSans:P}""{stSans:Value}" , size(medlarge) orientation(h))  ///
             saving(placebo_test_Pvalue2, replace)),                            ///
         xlabel(        , labsize(medlarge) format(%02.1f))                     ///
         ylabel(0(0.25)1, labsize(medlarge) format(%03.2f))

  graph export "placebo_test_Pvalue2.png", replace
  
  
  *# 2.2.3 t值

  sum tvalue, detail

  twoway(kdensity tvalue,                                                                    ///
             xline(`r(mean)', lpattern(dash)      lcolor(black))                             ///
             xline(-3.5872  , lpattern(solid)     lcolor(black))                             ///
             xline(-1.65    , lpattern(shortdash) lcolor(black))                             ///
             xline( 1.65    , lpattern(shortdash) lcolor(black))                             ///
             scheme(qleanmono)                                                               ///
             xtitle("{stSans:t值}"                         , size(medlarge))                 ///
             ytitle("{stSans:核}""{stSans:密}""{stSans:度}", size(medlarge) orientation(h))  ///
             saving(placebo_test_Tvalue2, replace)),                                         ///
         xlabel(, labsize(medlarge))                                                         ///
         ylabel(, labsize(medlarge) format(%02.1f))  // 绘制1,000次回归did的t值的核密度图

  graph export "placebo_test_Tvalue2.png", replace