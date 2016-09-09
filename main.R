# TEST FUNCTIONS WITH QUAKES DATASET

f <- quakes
q <- quakes

# MAKE DIFFERENT NUMBERS OF CATEGORIES

f$Sigma <- "999"
f$G <- "Good"
q$New_Cat <- "MEOW"

# CHANGE DATA POINT CONTENT

q <- q[order(q$long), ]
q[56, 3] <- 1234
f <- f[c(1:35,39:1000),]

# ASSIGN DATAPOINTS OBJECTS

f <- datapoints(f, c(1,2,5,6,7))
q <- datapoints(q, c(1,2,5,6))

# COMPARE DATAPOINTS OBJECT

d <- compare_datapoints(f, q)

# CHECK CATEGORIES

check.cat <- check_datapoints_categories(d)
check.cat

