/* Accessing Data */
filename covid_19 temp;

proc http url="https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/owid-covid-data.csv"
method="GET" out=covid_19;
run;

/* work library*/
libname covidata "/home/u50079342";

/* Tell SAS to allow "nonstandard" names */
options validvarname=any;

/* import to a SAS data set */
proc import file=covid_19 out=covidata .covid_19 replace dbms=csv;
run;

/* ------------------------------------------------------------------------- */
/* Exploring Data */
proc print data=covidata.covid_19 (obs=300);
var continent date location population total_cases total_deaths;
run;

/* proc means data=covidata.covid_19 (obs=300); */
/* var population total_cases total_deaths; */
/* run; */
/* Preparing Data */
/* Reading and creating a data set */
data Vi_covid;
set covidata.covid_19;
run;

data Vi_covid;
set covidata.covid_19;
keep continent date location population total_cases total_deaths;
format date ddmmyy10.;
run;

data Vi_covid;
set covidata.covid_19;
keep continent date location population total_cases total_deaths;
format date ddmmyy10.;
where date >="23JAN2020"d and date<="06NOV2020"d and location like "Viet%";
run;

/* */
data Vi_covid;
set covidata.covid_19;
keep continent date location population total_cases total_deaths;
format date ddmmyy10.;
where date >="23JAN2020"d and date<="06NOV2020"d and location like "Viet%";

if total_cases=. then
total_cases=0;

if total_deaths='' then
total_deaths=0;
run;

data Vi_covid;
set covidata.covid_19;
alives=sum(total_cases, total_deaths);

/* alives = total_cases - total_deaths; */
run;

/* Histogram chart */
proc univariate data=covidata.covid_19;
histogram total_cases;
where location like "Vi%";
run;

/* Analyzing and Reporting on Data with SQL*/
proc sql;
select date, location, total_cases, total_deaths from covidata.covid_19 where
total_cases > 100000;
format date ddmmyy10.;
quit;

***Notes: syntax /* text */ is comments in SAS, so it means the SAS will ignore those text in "/*   */
