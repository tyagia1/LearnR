library(tidyverse)
library(mlr)
library(mlbench)

me <- read_csv('UAE MV Data.csv', col_names = TRUE)
me

colnames(me)

me2 <- me %>% 
    gather(key = "quarter", value = "val", -c("Mnemonic:","Description:","Source:","Native Frequency:", "Geography:")) %>%
    select("Mnemonic:", "quarter", "val") %>%
    spread("Mnemonic:", "val") %>%
    mutate_at(vars(2:117), as.numeric)

npl <- read_csv('npl.csv', col_names = TRUE)    
npl

me3 <- left_join(me2, npl, by = 'quarter')

me4 <- me3 %>% slice(29:81)

me5 <- me4 %>% 
    mutate('yr' = str_sub(quarter,start = 1,end = 4), 'qr' = str_sub(quarter,start = 6,end = 6))


me6 <- mutate (me5, 'ddmm' = recode(me5$qr, '1' = '03-31', '2' = '06-30', '3' ='09-30', '4' = '12-31'))

me7 <- mutate(me6, asof = str_c(yr, '-', ddmm))

me7$asof <- as.Date(me7$asof)

glimpse(me7)

me7 <- select(me7, -c(yr,qr,ddmm, quarter))