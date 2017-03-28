data Cyst;
set Conhw3.Cyst;
run;



/* Descriptive statistics */
proc univariate plot data=cyst ;
var pemax weight;
histogram pemax weight;
qqplot pemax weight;
run;

/* Exploring the relationship */
		/* 1. Proc gplot */
proc gplot data=cyst;
	plot pemax*weight;
run;

/* Linear Regression */
proc reg data = cyst;
	model pemax=weight / clb;
RUN;


proc reg data=cyst;
	model pemax=weight; 
	output out=resid p=pman r=rman student=student; 
run;


proc gplot data=resid; 
	plot rman*weight /vref=0;
run;
proc gplot data=resid; 
	plot rman*pman /vref=0;
run;

/* squared residuals versus the predictor values */
data resid2; set resid; res2 = rman*rman; run;
goptions reset=all; proc gplot data=resid2; plot res2*weight; run; quit;
goptions reset=all; proc gplot data=resid2; plot Student*weight; run; quit;



/* Interaction term */

data resint;
set resid;
interaction = weight*height; 
run;


proc gplot data=resint; 
   plot rman*interaction /vref=0; 
   run;

   proc reg data=resint; 
   model pemax = weight height interaction/partial; 
   run; 

/*  mean-centering */
   
proc standard data = resint
   out = centdata
   mean = 0
   print;
  var weight height;
run; 

data centdataint;
set centdata;
interaction = weight*height; 
run;

proc reg data=centdataint; 
   model pemax = weight height interaction/clb; 
   run; 
