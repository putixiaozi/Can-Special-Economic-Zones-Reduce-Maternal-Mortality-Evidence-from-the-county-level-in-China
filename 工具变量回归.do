 cd C:\Users\xulij\Desktop\城市层面空气污染与儿童健康
use pm_stunt_526, clear
//use pm_stunt_pop_d, clear   
xtset city_code year
 gen lnt2m  = log(t2m)
 gen lnlight = log(light)
****************空气污染加剧儿童发育迟缓
 gen wstunt = stunt * 100    //单位为万分之一
 
  ********空气污染加剧儿童体重不足 underweight
    gen w_uw = uw * 100 //单位为万分之一
	 ********空气污染加剧儿童消瘦 wasting
gen w_ad_w = ad_xw*1000 //单位为十万分之一

   ********空气污染加剧儿童严重消瘦 wasting
  gen we_xsw = xsw*1000 //单位为十万分之一
 
 
 
 
 
 
 
 
 
 xi:xtivreg2  wstunt  lnlight lnpop_p  lnedu lnsec lnpop_doc   lnkl lnd2m lnt2m   lnpret (pm= sit) i.year, fe r first 
       est sto ivscity
esttab ivscity  using f1_2.rtf, replace b(4) se(4) ar2 star(* 0.1 ** 0.05 *** 0.01) nogap //输出结果到word

  xi:xtivreg2  w_uw  lnlight lnpop_p  lnedu lnsec lnpop_doc   lnkl lnd2m lnt2m   lnpret (pm= sit) t, fe r first 
     est sto ivscity
esttab ivscity  using f1_2.rtf, replace b(4) se(4) ar2 star(* 0.1 ** 0.05 *** 0.01) nogap //输出结果到word

   //gen we_ad_w = ad_w*1000 //单位为十万分之一
// winsor we_ad_w,gen(w_ad_w) p(0.01)
   xi:xtivreg2 w_ad_w  lnlight lnpop_p  lnedu lnsec lnpop_doc   lnkl lnd2m lnt2m   lnpret (pm= sit) t , fe r first 
       est sto ivscity
esttab ivscity  using f1_2.rtf, replace b(4) se(4) ar2 star(* 0.1 ** 0.05 *** 0.01) nogap //输出结果到word


    xi:xtivreg2 we_xsw  lnlight lnpop_p  lnedu lnsec lnpop_doc   lnkl lnd2m lnt2m   lnpret (pm= sit) t, fe r first 
    est sto ivscity
esttab ivscity  using f1.rtf, replace b(3) se(3) ar2 star(* 0.1 ** 0.05 *** 0.01) nogap //输出结果到word
