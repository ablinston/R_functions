rm(list=ls())

library(dplyr)
library(data.table)
library(dtplyr)


testdata <- bind_rows(replicate(10e4, mtcars, FALSE))


        
# Base R ------------------------------------------------------------------

testdata2 <- testdata
invisible(gc())
t0 <- Sys.time()

testdata2$wtgear <- testdata2$wt * testdata2$gear
testdata2 <- testdata2[testdata2$gear > 3,]
testdata2 <- testdata2[,c("mpg", "disp", "wt", "gear", "hp")]

Sys.time() - t0





# Dplyr -------------------------------------------------------------------

testdata3 <- testdata
invisible(gc())
t0 <- Sys.time()

testdata3 <- mutate(testdata3, wtgear = wt * gear)
testdata3 <- filter(testdata3, gear > 3)
testdata3 <- select(testdata3, mpg, disp, wt)

# testdata3 <- testdata3 %>% mutate(wtgear = wt * gear)
# testdata3 <- testdata3 %>% filter(gear > 3)
# testdata3 <- testdata3 %>% select(mpg, disp, wt, gear, hp)

Sys.time() - t0





# Data table --------------------------------------------------------------

testdata4 <- as.data.table(testdata)
invisible(gc())
t0 <- Sys.time()

testdata4[, wtgear := wt * gear]
testdata4 <- testdata4[gear > 3, ]
testdata4 <- testdata4[, .(mpg, disp, wt, gear, hp)]

Sys.time() - t0












# Base R ------------------------------------------------------------------

testdata2 <- testdata
invisible(gc())
t0 <- Sys.time()

testdata2$wtgear <- testdata2$wt * testdata2$gear
testdata2$wtgear2 <- testdata2$wt * testdata2$gear
testdata2$wtgear3 <- testdata2$wt * testdata2$gear
testdata2$wtgear4 <- testdata2$wt * testdata2$gear
testdata2$wtgear5 <- testdata2$wt * testdata2$gear
testdata2$wtgear6 <- testdata2$wt * testdata2$gear
testdata2 <- testdata2[testdata2$gear > 3,]
testdata2 <- testdata2[,c("mpg", "disp", "wt", "gear", "hp")]

Sys.time() - t0





# Dplyr -------------------------------------------------------------------

testdata3 <- testdata
invisible(gc())
t0 <- Sys.time()

testdata3 <- testdata3 %>% mutate(wtgear = wt * gear,
                                  wtgear2 = wt * gear,
                                  wtgear3 = wt * gear,
                                  wtgear4 = wt * gear,
                                  wtgear5 = wt * gear,
                                  wtgear6 = wt * gear) %>%
  filter(gear > 3) %>%
  select(mpg, disp, wt, gear, hp)

Sys.time() - t0





# Data table --------------------------------------------------------------

testdata4 <- as.data.table(testdata)
invisible(gc())
t0 <- Sys.time()

testdata4 <- testdata4[, ":=" (wtgear = wt * gear,
                               wtgear2 = wt * gear,
                               wtgear3 = wt * gear,
                               wtgear4 = wt * gear,
                               wtgear5 = wt * gear,
                               wtgear6 = wt * gear)][gear > 3, ][, .(mpg, disp, wt, gear, hp)]

Sys.time() - t0









# Dtplyr ------------------------------------------------------------------

testdata5 <- lazy_dt(testdata)
invisible(gc())
t0 <- Sys.time()

testdata5 <- testdata5 %>% mutate(wtgear = wt * gear,
                                  wtgear2 = wt * gear,
                                  wtgear3 = wt * gear,
                                  wtgear4 = wt * gear,
                                  wtgear5 = wt * gear,
                                  wtgear6 = wt * gear) %>%
  filter(gear > 3) %>%
  select(mpg, disp, wt, gear, hp) %>%
  as.data.table

Sys.time() - t0











###########################################################################
# MERGING -----------------------------------------------------------------
###########################################################################

to_merge <- mtcars %>% select(wt) %>% unique %>% mutate(random = runif(row_number()))


# Base R ------------------------------------------------------------------

testdata2 <- testdata
invisible(gc())
t0 <- Sys.time()

testdata2 <- merge(testdata2, to_merge, by = "wt", all.x = TRUE)

Sys.time() - t0





# Dplyr -------------------------------------------------------------------

testdata3 <- testdata
invisible(gc())
t0 <- Sys.time()

testdata3 <- left_join(testdata3, to_merge, by = "wt")

Sys.time() - t0





# Data table --------------------------------------------------------------

testdata4 <- as.data.table(testdata)
setDT(to_merge)

invisible(gc())
t0 <- Sys.time()

setkey(testdata4, wt)
setkey(to_merge, wt)
testdata4 <- testdata4[to_merge]
# testdata4 <- merge(testdata4, to_merge, by = "wt", all.x = TRUE)

Sys.time() - t0






###########################################################################
# AGGREGATE ---------------------------------------------------------------
###########################################################################



# Base R ------------------------------------------------------------------

testdata2 <- testdata
invisible(gc())
t0 <- Sys.time()

testdata2 <- aggregate(hp ~ gear,
                       testdata2,
                       FUN = mean)

Sys.time() - t0





# Dplyr -------------------------------------------------------------------

testdata3 <- testdata
invisible(gc())
t0 <- Sys.time()

testdata3 <- testdata3 %>% 
  group_by(gear) %>%
  summarise(mean_hp = mean(hp))

Sys.time() - t0





# Data table --------------------------------------------------------------

testdata4 <- as.data.table(testdata)
invisible(gc())
t0 <- Sys.time()

testdata4 <- testdata4[,.(mean_hp = mean(hp)), by = gear]

Sys.time() - t0













###########################################################################
# COMBINING ---------------------------------------------------------------
###########################################################################




# Base R ------------------------------------------------------------------

testdata2 <- testdata
invisible(gc())
t0 <- Sys.time()

testdata2$wtgear <- testdata2$wt * testdata2$gear
testdata2$wtgear2 <- testdata2$wt * testdata2$gear
testdata2$wtgear3 <- testdata2$wt * testdata2$gear
testdata2$wtgear4 <- testdata2$wt * testdata2$gear
testdata2$wtgear5 <- testdata2$wt * testdata2$gear
testdata2$wtgear6 <- testdata2$wt * testdata2$gear
testdata2 <- testdata2[testdata2$gear > 3,]
testdata2 <- testdata2[,c("mpg", "disp", "wt", "gear", "hp")]
testdata2 <- merge(testdata2, to_merge, by = "wt", all.x = TRUE)
testdata2 <- aggregate(hp ~ gear,
                       testdata2,
                       FUN = mean)

Sys.time() - t0





# Dplyr -------------------------------------------------------------------

testdata3 <- testdata
setDF(to_merge)
invisible(gc())
t0 <- Sys.time()

testdata3 <- testdata3 %>% 
  lazy_dt %>%
  mutate(wtgear = wt * gear,
         wtgear2 = wt * gear,
         wtgear3 = wt * gear,
         wtgear4 = wt * gear,
         wtgear5 = wt * gear,
         wtgear6 = wt * gear, ) %>%
  filter(gear > 3) %>% 
  select(mpg, disp, wt, gear, hp) %>%
  as.data.frame %>%
  left_join(to_merge, by = "wt") %>% 
  group_by(gear) %>%
  summarise(mean_hp = mean(hp))

Sys.time() - t0




# Data table --------------------------------------------------------------

testdata4 <- as.data.table(testdata)
setDT(to_merge)
invisible(gc())
t0 <- Sys.time()

setkey(testdata4, wt)
setkey(to_merge, wt)
testdata4 <- testdata4[, wtgear := wt * gear][gear > 3, ][, .(mpg, disp, wt, gear, hp)][to_merge][,.(mean_hp = mean(hp)), by = gear]

Sys.time() - t0

