

library(tidyverse)
library(datapointsr)

d <- data.frame(v1 = c("A","B","C","A","B","C","A","B","C"),
                v2 = c("A","wine/name","wine/name","A","B","C","A","B","wine/name"),
                v3 = c("A","B","C","A","B","C","A","B","C"))

i <- 0
d$id <- NA

for (r in 1:nrow(d)){
  print(r)
  if (d[r,2] == "wine/name")
    i <- i + 1

  d[r,4] <- i
}

d

d <-
  d %>% mutate(value = v3,
                  variable = id) %>%
  select(v1,v2, variable, value) %>%
  wide()

# d %>% group_by(v2) %>% count()
#
# d %>%
#   mutate(id = NA,
#          id = ifelse(v2 == "wine/name", row_number(), NA))
