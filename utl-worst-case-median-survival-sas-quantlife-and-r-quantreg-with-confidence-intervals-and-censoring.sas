%let pgm=utl-worst-case-median-survival-sas-quantlife-and-r-quantreg-with-confidence-intervals-and-censoring;

%stop_submission;

Worst case Median survival treatment minus control sas quantlife and r quantreg with confidence intervals and censoring

Perhaps trials with less cesoring and less variability will work better?

Beware of instability near the critical the 0.5 quantile, see soapbox.

The median survival was eight months longer(0.6707 years) in the treatment group compared to the control group.

     Contents  (worst case 73% censoring and exponential time?)

          1 sas quantlife (7 minutes)
          2 r median difference
          3 r median CIs intervals quantreg crq(surv()) (most accurate R algorithm) (32 seconds)
          4 r median CIs intervals survfit(surv()

github
https://tinyurl.com/4t54xw3u
https://github.com/rogerjdeangelis/utl-worst-case-median-survival-sas-quantlife-and-r-quantreg-with-confidence-intervals-and-censoring

input data in r rds file
https://tinyurl.com/76fubssz
https://github.com/rogerjdeangelis/utl-worst-case-median-survival-sas-quantlife-and-r-quantreg-with-confidence-intervals-and-censoring/blob/main/have.rds

input as a csv
https://tinyurl.com/3c9srz29
https://github.com/rogerjdeangelis/utl-worst-case-median-survival-sas-quantlife-and-r-quantreg-with-confidence-intervals-and-censoring/blob/main/medians.csv

SAS is  using a different algorithm. For the 2000 sample, sas took 7 minutes and r took 32 seconds.

     Quantile    Median (difference years)

 R    0.5            0.6707 (8 months longer survival with treatment)
 SAS  0.5            0.6417

COMPARISONS SAS AND R
=====================
                                       95% Confidence Intervals on Median Difference
                                       ---------------------------------------------
               medians                  SAS                 R                   R
quantile     R       SAS             quantlife      quantreg crq(surv())    survfit(surv()
           ---------------       ---------------    -------------------     ---------------
0.1        0.0703   0.1019       -0.0530  0.1937     0.0276  0.1773       0.0255  0.1779
0.2        0.2434   0.2515        0.0850  0.4017     0.1300  0.4757       0.1381  0.4569
0.3        0.4740   0.4659        0.2935  0.6545     0.2950  0.6603       0.3029  0.6851
0.4        0.5071   0.5094        0.2740  0.7402     0.3397  0.8445       0.3043  0.9268
0.45       0.4916   0.5371        0.2884  1.0569     0.3352  1.2548       0.3336  1.2781
0.5        0.6707   0.6417       -0.1875  1.5289     0.3170  2.0813**     0.2939  2.1499**

*If we increase the sample size, from 1000 to 2000 the 0.5 quantile is more stable.

0.5        0.4830   0.4609        0.1771  0.7447     0.3091  0.7997       0.3146  0.9169


SOAPBOX ON

  Be sceptical. Not sure of this analysis?

  Note: the upper 95% value for the difference in medians at the 0.5 quantile differ between R and SAS.

  This can occur in heavily censored trials like this one

  From AI

  As the censoring rate increases and especially when it occurs before the 0.5 quantile,
  the CI for the median difference becomes much less precise, often resulting in wide or
  unbounded intervals that accurately reflect the high uncertainty in the estimate.

  The correct statistical practice is to report these wide or semi-infinite intervals as they are,
  to maintain accurate coverage and transparency about the uncertainty

SOAPBOX OFF


INPUT STATS (1000 sample)

        N                  N                                           Lower                 Upper
 trt  Obs  Variable   N Miss          Sum       Mean     Minimum    Quartile     Median   Quartile    Maximum
-------------------------------------------------------------------------------------------------------------
   0  500  time     500    0  161.0452333  0.3220905 0.000392906   0.0952025  0.2198264  0.4252169  2.5414811
   1  500  time     500    0  199.9268716  0.3998537 0.000327221   0.1224158  0.2803573  0.5610423  2.8206203
-------------------------------------------------------------------------------------------------------------

          N
trt     Obs    Variable        Mean            Sum
---------------------------------------------------
  0     500    status     0.3280000    164.0000000
  1     500    status     0.1960000     98.0000000
---------------------------------------------------

status    Frequency    Percent
------------------------------
     0         738      73.80   ** heavy censoring across treatments
     1         262      26.20


/********************************************************************************************************************************/
/*           INPUT                             |       PROCESS                             |              OUTPUT                */
/*           =====                             |       =======                             |              =====                 */
/*                                             |                                           |                                    */
/* SD1.HAVE total obs=1,000                    | 1 SAS QUANTLIFE                           |         MedianDif 95% Confidence   */
/*                                             | ===============                           | Quantile Estimate      Limits      */
/* Obs    trt    time(yrs)   status            |                                           |                                    */
/*                                             | proc quantlife                            | 0.500      0.6707  -0.1875 1.5289  */
/*   1     0     0.54180       1               |     data   = sd1.have                     |                                    */
/*   2     0     0.47357       0               |     maxit  = 1000                         | Much slower ie  5x than R          */
/*   3     0     0.50862       0               |     seed   = 12345                        |                                    */
/*   4     0     0.88833       0               |     nthreads = 4                          |                                    */
/*   5     0     1.26392       0               |     method=km                             |                                    */
/* ...                                         |     maxit=1000;                           |                                    */
/* 996     1     0.56146       0               |   model time*status(0) = trt              |                                    */
/* 997     1     0.07399       0               |     /  quantile=(0.50);                   |                                    */
/* 998     1     0.30379       0               | run;quit;                                 |                                    */
/* 999     1     1.28978       0               |                                           |                                    */
/*1000     1     0.16485       0               |--------------------------------------------------------------------------------*/
/*                                             |                                                                                */
/*                                             | 2 R MEDIAN DIFFERENCE                     | Median Dif (Trt-Control):0.6416645 */
/*                                             | =====================                     | agrees with SAS                    */
/* d:/csv/medians.csv                          |                                           |                                    */
/*                                             | %utl_rbeginx;                             |                                    */
/* trt,time,status                             | parmcards4;                               |                                    */
/* 0,0.5418002952,1                            | library(survival)                         |                                    */
/* 0,0.4735741185,0                            | library(survminer)                        |                                    */
/* 0,0.5086154345,0                            | library(quantreg)                         |                                    */
/* 0,0.88833431,0                              | library(haven)                            |                                    */
/* 0,1.2639247171,0                            | source("c:/oto/fn_tosas9x.R")             |                                    */
/* 0,0.0797214352,1                            | options(sqldf.dll = "d:/dll/sqlean.dll")  |                                    */
/* 0,0.0117366375,0                            | df<-read_sas("d:/sd1/have.sas7bdat")      |                                    */
/* 0,0.0834950781,0                            |                                           |                                    */
/* 0,0.1050377441,0                            | # Fit model for each arm separately       |                                    */
/* ....                                        | fit_trt1 <- crq(Surv(time                 |                                    */
/*                                             |    ,status) ~ 1                           |                                    */
/* Also RDS file                               |    ,data = subset(df, trt == 0)           |                                    */
/*                                             |    ,method = "Portnoy")                   |                                    */
/* d:/rds/have.rds                             |                                           |                                    */
/*                                             | fit_trt2 <- crq(Surv(time, status) ~ 1    |                                    */
/* *---- MAKE DATA ----;                       |    ,data = subset(df, trt == 1)           |                                    */
/*                                             |    ,method = "Portnoy")                   |                                    */
/* *---- create sas dataset ----;              |                                           |                                    */
/* data sd1.have;                              | med_trt1 <- coef(fit_trt1, taus = 0.50)   |                                    */
/* call streaminit(123);                       | med_trt2 <- coef(fit_trt2, taus = 0.50)   |                                    */
/* do i = 1 to 500;                            |                                           |                                    */
/*     trt = 0;                                | diff_median<-as.numeric(med_trt2-med_trt1)|                                    */
/*     time_event = rand('Exponential', 1);    | print(diff_median)                        |                                    */
/*     time_censor = rand('Exponential', 0.5); | cat("Median Difference(Treat-Control):"   |                                    */
/*     time = min(time_event, time_censor);    |   ,diff_median, "\n")                     |                                    */
/*     status = (time_event <= time_censor);   | ;;;;                                      |                                    */
/*     output;                                 | %utl_rendx;                               |                                    */
/* end;                                        |                                           |                                    */
/* do i = 1 to 500;                            |--------------------------------------------------------------------------------*/
/*     trt = 1;                                |
/*     time_event = rand('Exponential', 2);    | 3 R MEDIAN CIS                            |  95%   ( 0.3210,  2.1428 )**       */
/*     time_censor = rand('Exponential', 0.5); |   quantreg crq(surv())                    |                                    */
/*     time = min(time_event, time_censor);    |   (most accurate R algorithm)             |  Diff from SAS see above           */
/*     status = (time_event <= time_censor);   |  ============================             |  Increase sample size or           */
/*     output;                                 |                                           |  decrease censoring                */
/* drop time_censor time_event i;              | %utl_rbeginx;                             |  See soapbox                       */
/* end;                                        |      parmcards4;                          |                                    */
/* run;quit;                                   | library(survival)                         |                                    */
/*                                             | library(survminer)                        |                                    */
/* *---- create csv dataset ----;              | library(quantreg)                         |                                    */
/* proc export data=sd1.have                   | library(haven)                            |                                    */
/*     outfile="d:/csv/medians.csv"            | library(boot)                             |                                    */
/*     dbms=csv                                | source("c:/oto/fn_tosas9x.R")             |                                    */
/*     replace;                                | options(sqldf.dll = "d:/dll/sqlean.dll")  |                                    */
/* run;                                        | df<-read_sas("d:/sd1/have.sas7bdat")      |                                    */
/*                                             | head(df)                                  |                                    */
/* *---- create rds dataset ----;              | median_diff <- function(data, indices) {  |                                    */
/* %utl_rbeginx;                               |                                           |                                    */
/* parmcards4;                                 |   d <- data[indices, ]                    |                                    */
/* library(haven)                              |                                           |                                    */
/* source("c:/oto/fn_tosas9x.R")               |   fit1 <- crq(Surv(time                   |                                    */
/* options(sqldf.dll = "d:/dll/sqlean.dll")    |     , status) ~ 1                         |                                    */
/* have<-read_sas("d:/sd1/have.sas7bdat")      |     ,data = subset(d, trt == 0)           |                                    */
/* saveRDS(have, file = "d:/rds/have.rds")     |     ,method = "Portnoy")                  |                                    */
/* readRDS("d:/rds/have.rds")                  |                                           |                                    */
/* ;;;;                                        |   fit2 <- crq(Surv(time, status) ~ 1      |                                    */
/* %utl_rendx;                                 |     ,data = subset(d, trt == 1)           |                                    */
/*                                             |     ,method = "Portnoy")                  |                                    */
/*                                             |                                           |                                    */
/*                                             |   med1 <- coef(fit1, taus = 0.5)          |                                    */
/*                                             |   med2 <- coef(fit2, taus = 0.5)          |                                    */
/*                                             |                                           |                                    */
/*                                             |   return(as.numeric(med2 - med1))         |                                    */
/*                                             | }                                         |                                    */
/*                                             |                                           |                                    */
/*                                             | # Bootstrap                               |                                    */
/*                                             | set.seed(12345)                           |                                    */
/*                                             | boot_res <- boot(df                       |                                    */
/*                                             |    ,statistic = median_diff               |                                    */
/*                                             |    ,R = 1000)                             |                                    */
/*                                             | boot.ci(boot_res, type = "perc")          |                                    */
/*                                             |                                           |                                    */
/*                                             | # Calculate 95% confidence interval       |                                    */
/*                                             | ci <- boot.ci(boot_res, type = "perc")    |                                    */
/*                                             | ci                                        |                                    */
/*                                             | ;;;;                                      |                                    */
/*                                             | %utl_rendx;                               |                                    */
/*                                             |                                           |                                    */
/*                                             |--------------------------------------------------------------------------------*/
/*                                             |                                           |                                    */
/*                                             | 4 R MEDIAN CIS INTERVALS SURVFIT(SURV()   | 95% CI: 0.3148287 2.155048         */
/*                                             | ========================================  | agrres with 3.                     */
/*                                             |                                           |                                    */
/*                                             | %utl_rbeginx;                             |                                    */
/*                                             | parmcards4;                               |                                    */
/*                                             | library(survival)                         |                                    */
/*                                             | library(survminer)                        |                                    */
/*                                             | library(quantreg)                         |                                    */
/*                                             | library(haven)                            |                                    */
/*                                             | library(boot)                             |                                    */                                         |
/*                                             | source("c:/oto/fn_tosas9x.R")             |                                    */
/*                                             | options(sqldf.dll = "d:/dll/sqlean.dll")  |                                    */
/*                                             | df<-read_sas("d:/sd1/have.sas7bdat")      |                                    */
/*                                             | head(df)                                  |                                    */
/*                                             | km_median_diff<-function(data, indices) { |                                    */
/*                                             |  d <- data[indices, ]                     |                                    */
/*                                             |                                           |                                    */
/*                                             |  # Fit KM curves                          |                                    */
/*                                             |  km0 <- survfit(Surv(time, status) ~ 1    |                                    */
/*                                             |    ,data = d[d$trt == 0, ])               |                                    */
/*                                             |                                           |                                    */
/*                                             |  km1 <- survfit(Surv(time, status) ~ 1    |                                    */
/*                                             |    ,data = d[d$trt == 1, ])               |                                    */
/*                                             |                                           |                                    */
/*                                             |  med0 <- quantile(km0,probs=0.5)$quantile |                                    */
/*                                             |  med1 <- quantile(km1,probs=0.5)$quantile |                                    */
/*                                             |                                           |                                    */
/*                                             |  return(med1 - med0)                      |                                    */
/*                                             | }                                         |                                    */
/*                                             | # Run bootstrap                           |                                    */
/*                                             | boot_km <- boot(                          |                                    */
/*                                             |     data = df                             |                                    */
/*                                             |    ,statistic = km_median_diff            |                                    */
/*                                             |    ,R = 1000)                             |                                    */
/*                                             |                                           |                                    */
/*                                             | # Get 95% CI                              |                                    */
/*                                             | km_ci <- boot.ci(boot_km, type = "perc")  |                                    */
/*                                             | cat("Kaplan-Meier Approach:\n")           |                                    */
/*                                             | cat("Median Difference:",boot_km$t0, "\n")|                                    */
/*                                             | cat("95% CI:", km_ci$percent[4:5], "\n")  |                                    */
/*                                             | ;;;;                                      |                                    */
/*                                             | %utl_rendx;                               |                                    */
/*                                             |                                           |                                    */
/********************************************************************************************************************************/


/*                   _     _  ___   ___   ___                             _
(_)_ __  _ __  _   _| |_  / |/ _ \ / _ \ / _ \  ___  __ _ _ __ ___  _ __ | | ___
| | `_ \| `_ \| | | | __| | | | | | | | | | | |/ __|/ _` | `_ ` _ \| `_ \| |/ _ \
| | | | | |_) | |_| | |_  | | |_| | |_| | |_| |\__ \ (_| | | | | | | |_) | |  __/
|_|_| |_| .__/ \__,_|\__| |_|\___/ \___/ \___/ |___/\__,_|_| |_| |_| .__/|_|\___|
        |_|                                                        |_|
*/

data sd1.have;
call streaminit(123);
do i = 1 to 500;
    trt = 0;
    time_event = rand('Exponential', 1);
    time_censor = rand('Exponential', 0.5);
    time = min(time_event, time_censor);
    status = (time_event <= time_censor);
    output;
end;
do i = 1 to 500;
    trt = 1;
    time_event = rand('Exponential', 2);
    time_censor = rand('Exponential', 0.5);
    time = min(time_event, time_censor);
    status = (time_event <= time_censor);
    output;
drop time_censor time_event i;
end;
run;quit;

/*                   _     ____   ___   ___   ___                             _
(_)_ __  _ __  _   _| |_  |___ \ / _ \ / _ \ / _ \  ___  __ _ _ __ ___  _ __ | | ___
| | `_ \| `_ \| | | | __|   __) | | | | | | | | | |/ __|/ _` | `_ ` _ \| `_ \| |/ _ \
| | | | | |_) | |_| | |_   / __/| |_| | |_| | |_| |\__ \ (_| | | | | | | |_) | |  __/
|_|_| |_| .__/ \__,_|\__| |_____|\___/ \___/ \___/ |___/\__,_|_| |_| |_| .__/|_|\___|
        |_|                                                            |_|
*/

data sd1.have2000;
call streaminit(123);
do i = 1 to 1000;
    trt = 0;
    time_event = rand('Exponential', 1);
    time_censor = rand('Exponential', 0.5);
    time = min(time_event, time_censor);
    status = (time_event <= time_censor);
    output;
end;
do i = 1 to 1000;
    trt = 1;
    time_event = rand('Exponential', 2);
    time_censor = rand('Exponential', 0.5);
    time = min(time_event, time_censor);
    status = (time_event <= time_censor);
    output;
drop time_censor time_event i;
end;
run;quit;

/*                   _                                                _
  ___ _ __ ___  __ _| |_    ___ _____   __  ___  __ _ _ __ ___  _ __ | | ___
 / __| `__/ _ \/ _` | __|  / __/ __\ \ / / / __|/ _` | `_ ` _ \| `_ \| |/ _ \
| (__| | |  __/ (_| | |_  | (__\__ \\ V /  \__ \ (_| | | | | | | |_) | |  __/
 \___|_|  \___|\__,_|\__|  \___|___/ \_/   |___/\__,_|_| |_| |_| .__/|_|\___|
                                                               |_|
*/

*---- create csv dataset ----;
proc export data=sd1.have
    outfile="d:/csv/medians.csv"
    dbms=csv
    replace;
run;quit;

/*                   _                 _                                _
  ___ _ __ ___  __ _| |_ ___   _ __ __| |___  ___  __ _ _ __ ___  _ __ | | ___
 / __| `__/ _ \/ _` | __/ _ \ | `__/ _` / __|/ __|/ _` | `_ ` _ \| `_ \| |/ _ \
| (__| | |  __/ (_| | ||  __/ | | | (_| \__ \\__ \ (_| | | | | | | |_) | |  __/
 \___|_|  \___|\__,_|\__\___| |_|  \__,_|___/|___/\__,_|_| |_| |_| .__/|_|\___|
                                                                 |_|
*/
*---- create rds dataset ----;
%utl_rbeginx;
parmcards4;
library(haven)
source("c:/oto/fn_tosas9x.R")
options(sqldf.dll = "d:/dll/sqlean.dll")
have<-read_sas("d:/sd1/have.sas7bdat")
saveRDS(have, file = "d:/rds/have.rds")
readRDS("d:/rds/have.rds")
;;;;
%utl_rendx;

/**************************************************************************************************************************/
/*  SD1.HAVE total obs=1,000                                                                                              */
/*                                                                                                                        */
/*  Obs    trt    time(yrs)   status                                                                                      */
/*                                                                                                                        */
/*    1     0     0.54180       1                                                                                         */
/*    2     0     0.47357       0                                                                                         */
/*    3     0     0.50862       0                                                                                         */
/*    4     0     0.88833       0                                                                                         */
/*    5     0     1.26392       0                                                                                         */
/*  ...                                                                                                                   */
/*  996     1     0.56146       0                                                                                         */
/*  997     1     0.07399       0                                                                                         */
/*  998     1     0.30379       0                                                                                         */
/*  999     1     1.28978       0                                                                                         */
/* 1000     1     0.16485       0                                                                                         */
/*                                                                                                                        */
/*                                                                                                                        */
/* SD1.HAVE total obs=2,000                                                                                               */
/*                                                                                                                        */
/*  Obs    trt      time     status                                                                                       */
/*                                                                                                                        */
/*    1     0     0.54180       1                                                                                         */
/*    2     0     0.47357       0                                                                                         */
/*    3     0     0.50862       0                                                                                         */
/*    4     0     0.88833       0                                                                                         */
/*    5     0     1.26392       0                                                                                         */
/*;;;;                                                                                                                    */
/*                                                                                                                        */
/* 1996     1     0.91846       0                                                                                         */
/* 1997     1     0.58596       0                                                                                         */
/* 1998     1     0.25782       0                                                                                         */
/* 1999     1     0.08671       0                                                                                         */
/* 2000     1     1.61147       0                                                                                         */
/*                                                                                                                        */
/*                                                                                                                        */
/*  d:/csv/medians.csv                                                                                                    */
/*                                                                                                                        */
/*  trt,time,status                                                                                                       */
/*  0,0.5418002952,1                                                                                                      */
/*  0,0.4735741185,0                                                                                                      */
/*  0,0.5086154345,0                                                                                                      */
/*  0,0.88833431,0                                                                                                        */
/*  0,1.2639247171,0                                                                                                      */
/*  0,0.0797214352,1                                                                                                      */
/*  0,0.0117366375,0                                                                                                      */
/*  0,0.0834950781,0                                                                                                      */
/*  0,0.1050377441,0                                                                                                      */
/*  ....                                                                                                                  */
/*                                                                                                                        */
/*  Also binary RDS file                                                                                                  */
/*                                                                                                                        */
/*  d:/rds/have.rds                                                                                                       */
/**************************************************************************************************************************/

/*                                           _   _ _  __
/ |  ___  __ _ ___    __ _ _   _  __ _ _ __ | |_| (_)/ _| ___
| | / __|/ _` / __|  / _` | | | |/ _` | `_ \| __| | | |_ / _ \
| | \__ \ (_| \__ \ | (_| | |_| | (_| | | | | |_| | |  _|  __/
|_| |___/\__,_|___/  \__, |\__,_|\__,_|_| |_|\__|_|_|_|  \___|
                        |_|
     ___   ___   ___                              _
/ | / _ \ / _ \ / _ \   ___  __ _ _ __ ___  _ __ | | ___
| || | | | | | | | | | / __|/ _` | `_ ` _ \| `_ \| |/ _ \
| || |_| | |_| | |_| | \__ \ (_| | | | | | | |_) | |  __/
|_( )___/ \___/ \___/  |___/\__,_|_| |_| |_| .__/|_|\___|
  |/                                       |_|
*/

proc quantlife
    data   = sd1.have
    maxit  = 1000
    seed   = 12345
    nthreads = 4
    method=km
    maxit=1000;
  model time*status(0) = trt
    /  quantile=(0.50);
run;quit;

/**************************************************************************************************************************/
/* NOTE: PROCEDURE QUANTLIFE used (Total process time):                                                                   */
/*       real time           2:35.66                                                                                      */
/*       user cpu time       3:08.06                                                                                      */
/*                                                                                                                        */
/* The QUANTLIFE Procedure                                                                                                */
/*                                                                                                                        */
/*                Model Information                                                                                       */
/*                                                                                                                        */
/* Data Set                                SD1.HAVE                                                                       */
/* Dependent Variable                          time                                                                       */
/* Censoring Variable                        status                                                                       */
/* Censoring Value(s)                             0                                                                       */
/* Number of Observations                      1000                                                                       */
/* Method                              Kaplan-Meier                                                                       */
/* Replications                                 200                                                                       */
/* Seed for Random Number Generator           12345                                                                       */
/*                                                                                                                        */
/*                                                                                                                        */
/* Number of Observations Read        1000                                                                                */
/* Number of Observations Used        1000                                                                                */
/*                                                                                                                        */
/*                                                                                                                        */
/* Summary of the Number of Event and Censored Values                                                                     */
/*                                                                                                                        */
/*                                      Percent                                                                           */
/*    Total       Event    Censored    Censored                                                                           */
/*                                                                                                                        */
/*     1000         262         738       73.80                                                                           */
/*                                                                                                                        */
/*                                          Parameter Estimates                                                           */
/*                                                                                                                        */
/*                                              Standard       95% Confidence                                             */
/* Quantile    Parameter      DF    Estimate       Error           Limits           t Value    Pr > |t|                   */
/*                                                                                                                        */
/*   0.5000    Intercept       1      0.6708      0.0603      0.5526      0.7889      11.13      <.0001                   */
/*             trt             1      0.6707      0.4379     -0.1875      1.5289       1.53      0.1259                   */
/**************************************************************************************************************************/

/*___   ___   ___   ___                              _
|___ \ / _ \ / _ \ / _ \   ___  __ _ _ __ ___  _ __ | | ___
  __) | | | | | | | | | | / __|/ _` | `_ ` _ \| `_ \| |/ _ \
 / __/| |_| | |_| | |_| | \__ \ (_| | | | | | | |_) | |  __/
|_____|\___/ \___/ \___/  |___/\__,_|_| |_| |_| .__/|_|\___|
                                              |_|
*/

proc quantlife
    data   = sd1.have2000
    maxit  = 1000
    seed   = 12345
    nthreads = 4
    method=km
    maxit=1000;
  model time*status(0) = trt
    /  quantile=(0.50);


/**************************************************************************************************************************/
/* NOTE: PROCEDURE QUANTLIFE used (Total process time):                                                                   */
/*       real time           7:35.83                                                                                      */
/*       user cpu time       14:52.03    ************************** not bad                                               */
/*                                                                                                                        */
/* Data Set                                SD1.HAVE                                                                       */
/* Dependent Variable                          time                                                                       */
/* Censoring Variable                        status                                                                       */
/* Censoring Value(s)                             0                                                                       */
/* Number of Observations                      2000                                                                       */
/* Method                              Kaplan-Meier                                                                       */
/* Replications                                 200                                                                       */
/* Seed for Random Number Generator           12345                                                                       */
/*                                                                                                                        */
/*                                                                                                                        */
/* Number of Observations Read        2000                                                                                */
/* Number of Observations Used        2000                                                                                */
/*                                                                                                                        */
/*                                                                                                                        */
/* Summary of the Number of Event and Censored Values                                                                     */
/*                                                                                                                        */
/*                                      Percent                                                                           */
/*    Total       Event    Censored    Censored                                                                           */
/*                                                                                                                        */
/*     2000         541        1459       72.95                                                                           */
/*                                                                                                                        */
/*                                          Parameter Estimates                                                           */
/*                                                                                                                        */
/*                                              Standard       95% Confidence                                             */
/* Quantile    Parameter      DF    Estimate       Error           Limits           t Value    Pr > |t|                   */
/*                                                                                                                        */
/*   0.5000    Intercept       1      0.6905      0.0526      0.5873      0.7936      13.12      <.0001                   */
/*             trt             1      0.4609      0.1448      0.1771      0.7447       3.18      0.0015                   */
/**************************************************************************************************************************/

/*___                              _ _                  _ _  __  __
|___ \   _ __   _ __ ___   ___  __| (_) __ _ _ __    __| (_)/ _|/ _| ___ _ __ ___ _ __   ___ ___  ___
  __) | | `__| | `_ ` _ \ / _ \/ _` | |/ _` | `_ \  / _` | | |_| |_ / _ \ `__/ _ \ `_ \ / __/ _ \/ __|
 / __/  | |    | | | | | |  __/ (_| | | (_| | | | || (_| | |  _|  _|  __/ | |  __/ | | | (_|  __/\__ \
|_____| |_|    |_| |_| |_|\___|\__,_|_|\__,_|_| |_| \__,_|_|_| |_|  \___|_|  \___|_| |_|\___\___||___/
  ___   ___   ___   ___
|___ \ / _ \ / _ \ / _ \
  __) | | | | | | | | | |
 / __/| |_| | |_| | |_| |
|_____|\___/ \___/ \___/

*/

%utl_rbeginx;
parmcards4;
library(survival)
library(survminer)
library(quantreg)
library(haven)
source("c:/oto/fn_tosas9x.R")
options(sqldf.dll = "d:/dll/sqlean.dll")
df<-read_sas("d:/sd1/have2000.sas7bdat")

# Fit model for each arm separately
fit_trt1 <- crq(Surv(time
   ,status) ~ 1
   ,data = subset(df, trt == 0)
   ,method = "Portnoy")

fit_trt2 <- crq(Surv(time, status) ~ 1
   ,data = subset(df, trt == 1)
   ,method = "Portnoy")

med_trt1 <- coef(fit_trt1, taus = 0.50)
med_trt2 <- coef(fit_trt2, taus = 0.50)

diff_median<-as.numeric(med_trt2-med_trt1)
print(diff_median)
cat("Median Difference(Treat-Control):"
  ,diff_median, "\n")
;;;;
%utl_rendx;

/**************************************************************************************************************************/
/*  Median Difference(Treat-Control): 0.4829973                                                                           */
/**************************************************************************************************************************/

 /*
| | ___   __ _
| |/ _ \ / _` |
| | (_) | (_| |
|_|\___/ \__, |
         |___/
*/

> library(survival)
> library(survminer)
> library(quantreg)
> library(haven)
> source("c:/oto/fn_tosas9x.R")
> options(sqldf.dll = "d:/dll/sqlean.dll")
> df<-read_sas("d:/sd1/have2000.sas7bdat")
> # Fit model for each arm separately
> fit_trt1 <- crq(Surv(time
+    ,status) ~ 1
+    ,data = subset(df, trt == 0)
+    ,method = "Portnoy")
> fit_trt2 <- crq(Surv(time, status) ~ 1
+    ,data = subset(df, trt == 1)
+    ,method = "Portnoy")
> med_trt1 <- coef(fit_trt1, taus = 0.50)
> med_trt2 <- coef(fit_trt2, taus = 0.50)
> diff_median<-as.numeric(med_trt2-med_trt1)
> print(diff_median)
[1] 0.4829973
> cat("Median Difference(Treat-Control):"
+   ,diff_median, "\n")
Median Difference(Treat-Control): 0.4829973
>

/*  ___   ___   ___
/ |/ _ \ / _ \ / _ \
| | | | | | | | | | |
| | |_| | |_| | |_| |
|_|\___/ \___/ \___/

*/

%utl_rbeginx;
parmcards4;
library(survival)
library(survminer)
library(quantreg)
library(haven)
source("c:/oto/fn_tosas9x.R")
options(sqldf.dll = "d:/dll/sqlean.dll")
df<-read_sas("d:/sd1/have.sas7bdat")

# Fit model for each arm separately
fit_trt1 <- crq(Surv(time
   ,status) ~ 1
   ,data = subset(df, trt == 0)
   ,method = "Portnoy")

fit_trt2 <- crq(Surv(time, status) ~ 1
   ,data = subset(df, trt == 1)
   ,method = "Portnoy")

med_trt1 <- coef(fit_trt1, taus = 0.50)
med_trt2 <- coef(fit_trt2, taus = 0.50)

diff_median<-as.numeric(med_trt2-med_trt1)
print(diff_median)
cat("Median Difference(Treat-Control):"
  ,diff_median, "\n")
;;;;
%utl_rendx;


/**************************************************************************************************************************/
/* Median Difference(Treat-Control): 0.6416645                                                                            */
/**************************************************************************************************************************/
/*
| | ___   __ _
| |/ _ \ / _` |
| | (_) | (_| |
|_|\___/ \__, |
         |___/
*/
> library(survival)
> library(survminer)
> library(quantreg)
> library(haven)
> source("c:/oto/fn_tosas9x.R")
> options(sqldf.dll = "d:/dll/sqlean.dll")
> df<-read_sas("d:/sd1/have.sas7bdat")
> # Fit model for each arm separately
> fit_trt1 <- crq(Surv(time
+    ,status) ~ 1
+    ,data = subset(df, trt == 0)
+    ,method = "Portnoy")
> fit_trt2 <- crq(Surv(time, status) ~ 1
+    ,data = subset(df, trt == 1)
+    ,method = "Portnoy")
> med_trt1 <- coef(fit_trt1, taus = 0.50)
> med_trt2 <- coef(fit_trt2, taus = 0.50)
> diff_median<-as.numeric(med_trt2-med_trt1)
> print(diff_median)
[1] 0.6416645
> cat("Median Difference(Treat-Control):"
+   ,diff_median, "\n")
Median Difference(Treat-Control): 0.6416645
>

/*____                             _ _                ____ ___                               _
|___ /   _ __   _ __ ___   ___  __| (_) __ _ _ __    / ___|_ _|___    __ _ _   _  __ _ _ __ | |_ _ __ ___  __ _
  |_ \  | `__| | `_ ` _ \ / _ \/ _` | |/ _` | `_ \  | |    | |/ __|  / _` | | | |/ _` | `_ \| __| `__/ _ \/ _` |
 ___) | | |    | | | | | |  __/ (_| | | (_| | | | | | |___ | |\__ \ | (_| | |_| | (_| | | | | |_| | |  __/ (_| |
|____/  |_|    |_| |_| |_|\___|\__,_|_|\__,_|_| |_|  \____|___|___/  \__, |\__,_|\__,_|_| |_|\__|_|  \___|\__, |
 ____   ___   ___   ___                                                 |_|                               |___/
|___ \ / _ \ / _ \ / _ \
  __) | | | | | | | | | |
 / __/| |_| | |_| | |_| |
|_____|\___/ \___/ \___/

*/

%let beg=%sysfunc(datetime());
%utl_rbeginx;
parmcards4;
library(survival)
library(survminer)
library(quantreg)
library(haven)
library(boot)
source("c:/oto/fn_tosas9x.R")
options(sqldf.dll = "d:/dll/sqlean.dll")
df<-read_sas("d:/sd1/have2000.sas7bdat")
head(df)
median_diff <- function(data, indices) {

  d <- data[indices, ]

  fit1 <- crq(Surv(time
    , status) ~ 1
    ,data = subset(d, trt == 0)
    ,method = "Portnoy")

  fit2 <- crq(Surv(time, status) ~ 1
    ,data = subset(d, trt == 1)
    ,method = "Portnoy")

  med1 <- coef(fit1, taus = 0.5)
  med2 <- coef(fit2, taus = 0.5)

  return(as.numeric(med2 - med1))
}

# Bootstrap
set.seed(12345)
boot_res <- boot(df
   ,statistic = median_diff
   ,R = 1000)
boot.ci(boot_res, type = "perc")

# Calculate 95% confidence interval
ci <- boot.ci(boot_res, type = "perc")
ci
;;;;
%utl_rendx;
%let end=%sysfunc(datetime());
%put %sysevalf(&end-&beg);

/**************************************************************************************************************************/
/* 32 seconds 2000 sample auantreg crs(Surv()                                                                             */
/*                                                                                                                        */
/* Calculations and Intervals on Original Scale                                                                           */
/* 95%   ( 0.3091,  0.7997 )                                                                                              */
/**************************************************************************************************************************/

/*
| | ___   __ _
| |/ _ \ / _` |
| | (_) | (_| |
|_|\___/ \__, |
         |___/
*/

> library(survival)
> library(survminer)
> library(quantreg)
> library(haven)
> library(boot)
> source("c:/oto/fn_tosas9x.R")
> options(sqldf.dll = "d:/dll/sqlean.dll")
> df<-read_sas("d:/sd1/have2000.sas7bdat")
> head(df)
# A tibble: 6 Ã— 3
    trt   time status
  <dbl>  <dbl>  <dbl>
1     0 0.542       1
2     0 0.474       0
3     0 0.509       0
4     0 0.888       0
5     0 1.26        0
6     0 0.0797      1
> median_diff <- function(data, indices) {
+   d <- data[indices, ]
+   fit1 <- crq(Surv(time
+     , status) ~ 1
+     ,data = subset(d, trt == 0)
+     ,method = "Portnoy")
+   fit2 <- crq(Surv(time, status) ~ 1
+     ,data = subset(d, trt == 1)
+     ,method = "Portnoy")
+   med1 <- coef(fit1, taus = 0.5)
+   med2 <- coef(fit2, taus = 0.5)
+   return(as.numeric(med2 - med1))
+ }
> # Bootstrap
> set.seed(12345)
> boot_res <- boot(df
+    ,statistic = median_diff
+    ,R = 1000)
> boot.ci(boot_res, type = "perc")
BOOTSTRAP CONFIDENCE INTERVAL CALCULATIONS
Based on 994 bootstrap replicates

CALL :
boot.ci(boot.out = boot_res, type = "perc")

Intervals :
Level     Percentile
95%   ( 0.3091,  0.7997 )
Calculations and Intervals on Original Scale
> # Calculate 95% confidence interval
> ci <- boot.ci(boot_res, type = "perc")
> ci
BOOTSTRAP CONFIDENCE INTERVAL CALCULATIONS
Based on 994 bootstrap replicates

CALL :
boot.ci(boot.out = boot_res, type = "perc")

Intervals :
Level     Percentile
95%   ( 0.3091,  0.7997 )
Calculations and Intervals on Original Scale
>

/*  ___   ___   ___
/ |/ _ \ / _ \ / _ \
| | | | | | | | | | |
| | |_| | |_| | |_| |
|_|\___/ \___/ \___/

*/


%let beg=%sysfunc(datetime());
%utl_rbeginx;
     parmcards4;
library(survival)
library(survminer)
library(quantreg)
library(haven)
library(boot)
source("c:/oto/fn_tosas9x.R")
options(sqldf.dll = "d:/dll/sqlean.dll")
df<-read_sas("d:/sd1/have.sas7bdat")
head(df)
median_diff <- function(data, indices) {

  d <- data[indices, ]

  fit1 <- crq(Surv(time
    , status) ~ 1
    ,data = subset(d, trt == 0)
    ,method = "Portnoy")

  fit2 <- crq(Surv(time, status) ~ 1
    ,data = subset(d, trt == 1)
    ,method = "Portnoy")

  med1 <- coef(fit1, taus = 0.5)
  med2 <- coef(fit2, taus = 0.5)

  return(as.numeric(med2 - med1))
}

# Bootstrap
set.seed(12345)
boot_res <- boot(df
   ,statistic = median_diff
   ,R = 1000)
boot.ci(boot_res, type = "perc")

# Calculate 95% confidence interval
ci <- boot.ci(boot_res, type = "perc")
ci
;;;;
%utl_rendx;
%let end=%sysfunc(datetime());
%put %sysevalf(&end-&beg);

/**************************************************************************************************************************/
/* 13 seconds 1000 sample quantreg crq(Surv()                                                                             */
/*                                                                                                                        */
/* Calculations and Intervals on Original Scale                                                                           */
/*95%   ( 0.3210,  2.1428 )                                                                                               */
/**************************************************************************************************************************/

/*
| | ___   __ _
| |/ _ \ / _` |
| | (_) | (_| |
|_|\___/ \__, |
         |___/
*/

> library(survival)
> library(survminer)
> library(quantreg)
> library(haven)
> library(boot)
> source("c:/oto/fn_tosas9x.R")
> options(sqldf.dll = "d:/dll/sqlean.dll")
> df<-read_sas("d:/sd1/have.sas7bdat")
> head(df)
# A tibble: 6 Ã— 3
    trt   time status
  <dbl>  <dbl>  <dbl>
1     0 0.542       1
2     0 0.474       0
3     0 0.509       0
4     0 0.888       0
5     0 1.26        0
6     0 0.0797      1
> median_diff <- function(data, indices) {
+   d <- data[indices, ]
+   fit1 <- crq(Surv(time
+     , status) ~ 1
+     ,data = subset(d, trt == 0)
+     ,method = "Portnoy")
+   fit2 <- crq(Surv(time, status) ~ 1
+     ,data = subset(d, trt == 1)
+     ,method = "Portnoy")
+   med1 <- coef(fit1, taus = 0.5)
+   med2 <- coef(fit2, taus = 0.5)
+   return(as.numeric(med2 - med1))
+ }
> # Bootstrap
> set.seed(12345)
> boot_res <- boot(df
+    ,statistic = median_diff
+    ,R = 1000)
> boot.ci(boot_res, type = "perc")
BOOTSTRAP CONFIDENCE INTERVAL CALCULATIONS
Based on 887 bootstrap replicates

CALL :
boot.ci(boot.out = boot_res, type = "perc")

Intervals :
Level     Percentile
95%   ( 0.3210,  2.1428 )
Calculations and Intervals on Original Scale
> # Calculate 95% confidence interval
> ci <- boot.ci(boot_res, type = "perc")
> ci
BOOTSTRAP CONFIDENCE INTERVAL CALCULATIONS
Based on 887 bootstrap replicates

CALL :
boot.ci(boot.out = boot_res, type = "perc")

Intervals :
Level     Percentile
95%   ( 0.3210,  2.1428 )
Calculations and Intervals on Original Scale
>

/*  _                               _ _                ____ ___                            __ _ _    ____
| || |    _ __   _ __ ___   ___  __| (_) __ _ _ __    / ___|_ _|___  ___ _   _ _ ____   __/ _(_) |_ / /\ \
| || |_  | `__| | `_ ` _ \ / _ \/ _` | |/ _` | `_ \  | |    | |/ __|/ __| | | | `__\ \ / / |_| | __| |  | |
|__   _| | |    | | | | | |  __/ (_| | | (_| | | | | | |___ | |\__ \\__ \ |_| | |   \ V /|  _| | |_| |  | |
   |_|   |_|    |_| |_| |_|\___|\__,_|_|\__,_|_| |_|  \____|___|___/|___/\__,_|_|    \_/ |_| |_|\__| |  | |
                                                                                                    \_\/_/
 ____   ___   ___   ___
|___ \ / _ \ / _ \ / _ \
  __) | | | | | | | | | |
 / __/| |_| | |_| | |_| |
|_____|\___/ \___/ \___/

*/

%utl_rbeginx;
parmcards4;
library(survival)
library(survminer)
library(quantreg)
library(haven)
library(boot)
source("c:/oto/fn_tosas9x.R")
options(sqldf.dll = "d:/dll/sqlean.dll")
df<-read_sas("d:/sd1/have2000.sas7bdat")
head(df)
km_median_diff<-function(data, indices) {
 d <- data[indices, ]

 # Fit KM curves
 km0 <- survfit(Surv(time, status) ~ 1
   ,data = d[d$trt == 0, ])

 km1 <- survfit(Surv(time, status) ~ 1
   ,data = d[d$trt == 1, ])

 med0 <- quantile(km0,probs=0.5)$quantile
 med1 <- quantile(km1,probs=0.5)$quantile

 return(med1 - med0)
}
# Run bootstrap
boot_km <- boot(
    data = df
   ,statistic = km_median_diff
   ,R = 1000)

# Get 95% CI
km_ci <- boot.ci(boot_km, type = "perc")
cat("Kaplan-Meier Approach:\n")
cat("Median Difference:",boot_km$t0, "\n")
cat("95% CI:", km_ci$percent[4:5], "\n")
;;;;
%utl_rendx;

/**************************************************************************************************************************/
/* 2000 sample survfit(Surv())                                                                                            */
/*                                                                                                                        */
/* Kaplan-Meier Approach:                                                                                                 */
/* Median Difference: 0.4615096                                                                                           */
/* 95% CI: 0. 314061 0.888387                                                                                             */
/**************************************************************************************************************************/

/*
| | ___   __ _
| |/ _ \ / _` |
| | (_) | (_| |
|_|\___/ \__, |
         |___/
*/

> library(survival)
> library(survminer)
> library(quantreg)
> library(haven)
> library(boot)
> source("c:/oto/fn_tosas9x.R")
> options(sqldf.dll = "d:/dll/sqlean.dll")
> df<-read_sas("d:/sd1/have2000.sas7bdat")
> head(df)
# A tibble: 6 Ã— 3
    trt   time status
  <dbl>  <dbl>  <dbl>
1     0 0.542       1
2     0 0.474       0
3     0 0.509       0
4     0 0.888       0
5     0 1.26        0
6     0 0.0797      1
> km_median_diff<-function(data, indices) {
+  d <- data[indices, ]
+  # Fit KM curves
+  km0 <- survfit(Surv(time, status) ~ 1
+    ,data = d[d$trt == 0, ])
+  km1 <- survfit(Surv(time, status) ~ 1
+    ,data = d[d$trt == 1, ])
+  med0 <- quantile(km0,probs=0.5)$quantile
+  med1 <- quantile(km1,probs=0.5)$quantile
+  return(med1 - med0)
+ }
> # Run bootstrap
> boot_km <- boot(
+     data = df
+    ,statistic = km_median_diff
+    ,R = 1000)
> # Get 95% CI
> km_ci <- boot.ci(boot_km, type = "perc")
> cat("Kaplan-Meier Approach:\n")
Kaplan-Meier Approach:
> cat("Median Difference:",boot_km$t0, "\n")
Median Difference: 0.4615096
> cat("95% CI:", km_ci$percent[4:5], "\n")
95% CI: 0.314061 0.888387
>

/*  ___   ___   ___
/ |/ _ \ / _ \ / _ \
| | | | | | | | | | |
| | |_| | |_| | |_| |
|_|\___/ \___/ \___/

*/

%utl_rbeginx;
parmcards4;
library(survival)
library(survminer)
library(quantreg)
library(haven)
library(boot)
source("c:/oto/fn_tosas9x.R")
options(sqldf.dll = "d:/dll/sqlean.dll")
df<-read_sas("d:/sd1/have.sas7bdat")
head(df)
km_median_diff<-function(data, indices) {
 d <- data[indices, ]

 # Fit KM curves
 km0 <- survfit(Surv(time, status) ~ 1
   ,data = d[d$trt == 0, ])

 km1 <- survfit(Surv(time, status) ~ 1
   ,data = d[d$trt == 1, ])

 med0 <- quantile(km0,probs=0.5)$quantile
 med1 <- quantile(km1,probs=0.5)$quantile

 return(med1 - med0)
}
# Run bootstrap
boot_km <- boot(
    data = df
   ,statistic = km_median_diff
   ,R = 1000)

# Get 95% CI
km_ci <- boot.ci(boot_km, type = "perc")
cat("Kaplan-Meier Approach:\n")
cat("Median Difference:",boot_km$t0, "\n")
cat("95% CI:", km_ci$percent[4:5], "\n")
;;;;
%utl_rendx;

/**************************************************************************************************************************/
/* 1000 sample quantreg survfit(Surv()                                                                                    */
/*                                                                                                                        */
/* Kaplan-Meier Approach:                                                                                                 */
/* Median Difference: 0.5954384                                                                                           */
/* 95% CI: 0.3157524 2.155048                                                                                             */
/**************************************************************************************************************************/

/*
| | ___   __ _
| |/ _ \ / _` |
| | (_) | (_| |
|_|\___/ \__, |
         |___/
*/
> library(survival)
> library(survminer)
> library(quantreg)
> library(haven)
> library(boot)
> source("c:/oto/fn_tosas9x.R")
> options(sqldf.dll = "d:/dll/sqlean.dll")
> df<-read_sas("d:/sd1/have.sas7bdat")
> head(df)
# A tibble: 6 Ã— 3
    trt   time status
  <dbl>  <dbl>  <dbl>
1     0 0.542       1
2     0 0.474       0
3     0 0.509       0
4     0 0.888       0
5     0 1.26        0
6     0 0.0797      1
> km_median_diff<-function(data, indices) {
+  d <- data[indices, ]
+  # Fit KM curves
+  km0 <- survfit(Surv(time, status) ~ 1
+    ,data = d[d$trt == 0, ])
+  km1 <- survfit(Surv(time, status) ~ 1
+    ,data = d[d$trt == 1, ])
+  med0 <- quantile(km0,probs=0.5)$quantile
+  med1 <- quantile(km1,probs=0.5)$quantile
+  return(med1 - med0)
+ }
> # Run bootstrap
> boot_km <- boot(
+     data = df
+    ,statistic = km_median_diff
+    ,R = 1000)
> # Get 95% CI
> km_ci <- boot.ci(boot_km, type = "perc")
> cat("Kaplan-Meier Approach:\n")
Kaplan-Meier Approach:
> cat("Median Difference:",boot_km$t0, "\n")
Median Difference: 0.5954384
> cat("95% CI:", km_ci$percent[4:5], "\n")
95% CI: 0.3157524 2.155048
>

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/


