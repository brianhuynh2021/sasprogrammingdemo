/* Accessing Data */

filename covid_19 temp;

proc http
	url="https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/owid-covid-data.csv"
	method="GET"
	out= covid_19;
run;

libname covidata "/home/u50079342";
/* Tell SAS to allow "nonstandard" names */
options validvarname=any;

/* import to a SAS data set */
proc import
  file=covid_19
  out=loaddata.covid_19 replace
  dbms=csv;
run;

/* ------------------------------------------------------------------------- */
/* Exploring Data */

proc print data=covidata.covid_19 (obs=300);
	var  continent date location population total_cases total_deaths;	
run;

/* proc print data=covidata.covid_19 (obs=300); */
/* 	var  continent date location population total_cases total_deaths; */
/* run; */

/* Preparing Data */
/* Reading and creating a data set */

data Vi_covid;
	set covidata.covid_19;
	where date >= "23JAN2020"d and date<= "06NOV2020"d and location like "Viet%";
	format date ddmmyy10.;
	keep continent date location population total_cases total_deaths;
	if total_cases =. then total_cases=0;
	if total_deaths ='' then total_deaths=0;
run;





