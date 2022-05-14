library(tidyverse)
library(haven)
library(Synth)
library(SCtools)

states_data <- read_csv("D:/UT/Causal Inference/Final paper/cps_data.csv") %>%
  as.data.frame(.)

dataprep_out <- dataprep(
  foo = states_data,
  predictors = c("emp","self-emp","unemp","pri_hi","pub_hi","uninsured","self-emp-inc"),
  predictors.op = "mean",
  time.predictors.prior = 1999:2006,
  special.predictors = list(
    list("emp", 1999:2000, "mean"),
    list("self-emp", 2000:2004, "mean"),
    list("unemp", 1999:2004, "mean"),
    list("pri_hi", 1999:2003, "mean"),
    list("pub_hi", 1999:2002, "mean"),
    list("uninsured",2004:2004,"mean"),
    list("self-emp-inc",2000:2001,"mean")),
  dependent = "self-emp",
  unit.variable = "statefip",
  unit.names.variable = "state",
  time.variable = "year",
  treatment.identifier = 22,
  controls.identifier = c(5,7,9,11,23:29,33:50),
  time.optimize.ssr = 1999:2006,
  time.plot = 1999:2019
)

synth_out <- synth(data.prep.obj = dataprep_out)

path.plot(synth_out, dataprep_out)

gaps.plot(synth_out, dataprep_out)

placebos <- generate.placebos(dataprep_out, synth_out, Sigf.ipop = 3)

plot_placebos(placebos)

mspe.plot(placebos, discard.extreme = TRUE, mspe.limit = 1, plot.hist = TRUE)

synth_out$solution.w