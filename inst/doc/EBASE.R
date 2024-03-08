## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>", 
  message = F, 
  warning = F, 
  fig.align = 'center'
)

## -----------------------------------------------------------------------------
library(EBASE)

## -----------------------------------------------------------------------------
head(exdat)

## -----------------------------------------------------------------------------
library(dplyr)
library(lubridate)

# subset four days in June
dat <- exdat %>%
  filter(month(exdat$DateTimeStamp) == 6 & day(exdat$DateTimeStamp) %in% 1:4)

head(dat)

## -----------------------------------------------------------------------------
res <- ebase(dat, interval = 900, Z = 1.85, n.chains = 2)
head(res)

## ----fig.height = 3, fig.width = 9--------------------------------------------
ebase_plot(res)

## ----fig.height = 3, fig.width = 9--------------------------------------------
ebase_plot(res, instantaneous = FALSE)

## -----------------------------------------------------------------------------
# setup parallel backend
library(doParallel)
cl <- makeCluster(2)
registerDoParallel(cl)

res <- ebase(dat, interval = 900, Z = 1.85, n.chains = 2)

stopCluster(cl)

## ----fig.height = 3, fig.width = 9--------------------------------------------
fit_plot(res)

## ----fig.height = 5, fig.width = 7--------------------------------------------
fit_plot(res, bygroup = TRUE)

## ----fig.height = 5, fig.width = 7--------------------------------------------
fit_plot(res, bygroup = TRUE, scatter = TRUE)

## ----eval = F-----------------------------------------------------------------
#  system.file('ebase_model.txt', package = 'EBASE')

## ----fig.height = 3, fig.width = 9--------------------------------------------
prior_plot()

## ----fig.height = 7, fig.width = 7--------------------------------------------
credible_plot(res)

## -----------------------------------------------------------------------------
credible_prep(res)

## -----------------------------------------------------------------------------
cl <- makeCluster(2)
registerDoParallel(cl)

res <- ebase(dat, interval = 900, Z = 1.85, n.chains = 2, ndays = 4)

stopCluster(cl)

## ----fig.height = 3, fig.width = 9--------------------------------------------
ebase_plot(res, instantaneous = TRUE)

## ----fig.height = 3, fig.width = 9--------------------------------------------
fit_plot(res)

## -----------------------------------------------------------------------------
cl <- makeCluster(2)
registerDoParallel(cl)

res <- ebase(dat, interval = 900, Z = 1.85, n.chains = 2, ndays = 1, doave = F)

stopCluster(cl)

## ----fig.height = 3, fig.width = 9--------------------------------------------
fit_plot(res)

## -----------------------------------------------------------------------------
set.seed(222)
dat2 <- dat %>% 
  slice_sample(prop = 0.9) %>% 
  arrange(DateTimeStamp)
head(dat2)

## ----message = F--------------------------------------------------------------
dat2interp <- ebase_prep(dat2, Z = 1.85, interval = 900)
head(dat2interp)

## ----fig.height = 3, fig.width = 9, message = F-------------------------------
interp_plot(dat2, Z = 1.85, interval = 900, param = 'DO_sat')

## ----fig.height = 3, fig.width = 9--------------------------------------------
prior_plot(bprior = c(0.2, 0.1))

## ----fig.height = 3, fig.width = 9--------------------------------------------
cl <- makeCluster(2)
registerDoParallel(cl)

res <- ebase(dat, interval = 900, Z = 1.85, n.chains = 2, bprior = c(0.2, 0.1))

stopCluster(cl)

ebase_plot(res, instantaneous = TRUE)

## ----fig.height = 7, fig.width = 7--------------------------------------------
credible_plot(res)

