
# MAKE TEST DATASETS

# SHORT CLASS MISMATCH

f <- quakes
q <- quakes
f <- datapoints(f, c(1,2,5))
q <- datapoints(q, c(1,2,5))
q <- q[1:5, ]
f <- f[1:5, ]
q$lat <- as.character(q$lat)
q_class_mismatch <- q[1:5, ]
f_class_mismatch <- f[1:5, ]
q <- q_class_mismatch
f <- f_class_mismatch

# SHORT DUPS

f <- quakes
q <- quakes
f <- datapoints(f, c(1,2,5))
q <- datapoints(q, c(1,2,5))
q <- q[1:5, ]
f <- f[1:5, ]
f_dups <- f[2:3,]
f <- rbind(f, f_dups)
q_short_matched_dups <- q
f_short_matched_dups <- f
q <- q_short_matched_dups
f <- f_short_matched_dups

# LONG CATEGORIES MISMATCHED

f <- quakes
q <- quakes
f$Sigma <- "999"
f$G <- "Good"
q$New_Cat <- "MEOW"
q <- q[order(q$long), ]
q[56, 3] <- 1234
f <- f[c(1:35,39:1000),]
f <- datapoints(f, c(1,2,5,6,7))
q <- datapoints(q, c(1,2,5,6))
f_long <- f
q_long <- q

# SHORT CATEGORIES MISMATCHED

f <- quakes
q <- quakes
f <- datapoints(f, c(1,2,5))
q <- datapoints(q, c(1,2,5))
q <- q[1:5, ]
f <- f[c(1, 2, 4, 5), ]
f_short_1 <- f
q_short_1 <- q

# SHORT MATCHING

f <- quakes
q <- quakes
f <- datapoints(f, c(1,2,5))
q <- datapoints(q, c(1,2,5))
q <- q[1:5, ]
f <- f[1:5, ]
q_short_matched <- q[1:5, ]
f_short_matched <- f[1:5, ]
q <- q_short_matched
f <- f_short_matched

f <- NULL
q <- NULL
rm(f)
rm(q)

# SHORT CAT MATCHING, VALUES OFF

f <- quakes
q <- quakes
f <- datapoints(f, c(1,2,5))
f$Value[3] <- f$Value[3] + 5
q <- datapoints(q, c(1,2,5))
q$Value[3] <- q$Value[4] + 15

q <- q[1:5, ]
f <- f[1:5, ]
q_short_unmatched <- q[1:5, ]
f_short_unmatched <- f[1:5, ]
q <- q_short_unmatched
f <- f_short_unmatched

f <- NULL
q <- NULL
rm(f)
rm(q)

# CATEGORIES OUT OF ORDER

f <- quakes
q <- quakes
f <- datapoints(f, c(1,2,5))
q <- datapoints(q, c(1,2,5))
q <- q[1:5, c(3,2,1,4,5)]
f <- f[1:5, ]
q_short_out_of_order <- q
f_short_out_of_order <- f
q <- q_short_out_of_order
f <- f_short_out_of_order

f <- NULL
q <- NULL
rm(f)
rm(q)

# CATEGORIES MISMATCHED
