#working with large datasets
library(tidyverse)
library(data.table)

zika_address <- paste0("https://raw.githubusercontent.com/cdcepi/zika/master/",
                       "Brazil/COES_Microcephaly/data/COES_Microcephaly-2016-06-25.csv")
brazil_zika <- fread(zika_address)
head(brazil_zika, 2)

class(brazil_zika)

fread(zika_address,
      select = c("location", "value", "unit")) %>%
  dplyr::slice(1:3)


