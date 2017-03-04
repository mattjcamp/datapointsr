# Data Points

**datapointsr** makes it easy to compare and contrast aggregated
statistics stored in wide tables. With datapointsr you can:

- turn wide tables into long normalized tables
- recast datapoints objects into wide tables
- filter on datapoints objects
- quickly track down differences between statistics stored
in two tables

## Data Points vs Tidy Data

datapointsr is heavily influenced by the [Tidyverse](https://github.com/tidyverse/tidyverse) 
and is meant to be used in conjunction with tidyverse packages
like dpyr.

A tidy dataset is one where each observation has one row and each
column has either an attribute or a measure. The first part of a data
analysis is to build a tidy dataset from the data sources that are
available. Tidy datasets are used to create visualizations, summarize
data and build models.

datapointsr was created to test statistical tables that are created from
tidy data. Usually, this means looking at a table where data has been rolled
up into aggregations like counts or means for lots of combinations of groups.
Typical statistical tables will include categories like gender or location then
then have columns for calculated statistics (sometimes one hundred or more).

Statistical tables are not tidy because they contained aggregated data. They 
are the kinds of artifacts that are sent to other areas for reports or further 
analysis.

>This is where datapointsr comes in

Our job is to either create these statistical tables or to verify that these
tables are correct. To verify that a statistical table is correct we need one
analyst to independently create the table and then compare his or her results
to the table we are sending out.

Comparing two wide tables with potentially hundreds of column and thousands of rows
can be hard to automate. datapoints helps by casting both tables into a common format.
Once we have this format, we can compare and contrast both statistical tables easily
and with reusable functions.

## Data Points Format

This common format is simply that the second to the last column
must be named variable and store the name of the measure (what used 
to in the wide set of columns). The last column must be named value and 
store the aggregated statistic.

  - **variable** the measure label
  - **value** the value of the measure

You might recognize these names as what comes out of the `melt` function. The remaining
columns are all categories. We are just giving each data point it's own row.

## Workflow

Here is an example of how to use datapointsr based on the data in the
wicher package.

### Build Datasets

I will use the data in wicher to build the two datasets that we want to
compare. BTW this part is going to be a little janky because I have to sort of artifically
create wide datasets for both roles (the Fulfiller and QC Analyst).

First, create the source statistical table:

    library(wicher)
    
    d <- wiche_graduate_projections %>% 
      filter(year %in% 2001:2010,
             grade == "g",
             race == "all",
             location == "us") %>% 
      mutate(variable = sprintf("count_%s", sector),
             value = n) %>% 
      select(year, location, variable, value) %>% 
      wide()

This gives you the enrollments of schools for 2001 to
2010 by sector:

    # A tibble: 10 × 5
        year location count_all count_np count_p
       <int>    <chr>     <int>    <int>   <int>
    1   2001       us   2850006   280806 2569200
    2   2002       us   2910675   289141 2621534
    3   2003       us   3019234   299287 2719947
    4   2004       us   3059929   300041 2759888
    5   2005       us   3095418   296168 2799250
    6   2006       us   3115511   302099 2813412
    7   2007       us   3196104   303059 2893045
    8   2008       us   3315437   314100 3001337
    9   2009       us   3347948   308933 3039015
    10  2010       us   3440691   312669 3128022

Now make the fulfiller dataset by copying `d` and then
artifically putting some errors into the dataset.

    f <- d
    f[3, 4] <- f[3, 4] + sample(1:100, 1)
    f[7, 5] <- f[7, 5] + sample(1:1000, 1)
    f[8, 2] <- "usa"

Create the QC Analyst data set by just copying the 
original `d` object:

    q <- d
    
>**NOTE** `f` means **fufiller analyst** and `q` means **QC analyst**

We now have two similar, but not identical datasets. 

### Put Datasets Into Datapoints Format

To check this dataset, we need a 
standard datapoints object. We will first need to make sure both
datasets are in a long, normalized format. Use the `long` function
to do this:

    f <- f %>% long(1:2)
    q <- q %>% long(1:2)

Take a took at `f`:

    head(f, 10)
    
    # A tibble: 10 × 5
        year location count_all variable  value
       <int>    <chr>     <int>    <chr>  <int>
    1   2001       us   2850006 count_np 280806
    2   2002       us   2910675 count_np 289141
    3   2003       us   3019234 count_np 299314
    4   2004       us   3059929 count_np 300041
    5   2005       us   3095418 count_np 296168
    6   2006       us   3115511 count_np 302099
    7   2007       us   3196104 count_np 303059
    8   2008      usa   3315437 count_np 314100
    9   2009       us   3347948 count_np 308933
    10  2010       us   3440691 count_np 312669

Now, we can use these datasets in long format to 
make a `datapoints` object:

    dp <- data_points(f, q)

This object can now used to test the two datasets. You can check the
category metadata, just the categories in each or you can just check
everything at once. Usually, you will attempt to check everything at
once first using `show_values`:

    t <- show_values(dp)
    
    t
    
    $message
    [1] "show_variables: Categories must match before you can match value content"

We can't match all the values yet because categories are not in sync. But, we 
can look more closely at the categories to see what is happening by using the
`show_categories` function:

    show_categories(dp)
    
    $match
    Rows in x but not y: 24, 23, 22. Rows in y but not x: 24, 23, 22. 
    $in_f
    # A tibble: 3 × 3
       year location  variable
      <int>    <chr>     <chr>
    1  2008      usa count_all
    2  2008      usa  count_np
    3  2008      usa   count_p
    
    $in_q
    # A tibble: 3 × 3
       year location  variable
      <int>    <chr>     <chr>
    1  2008       us count_all
    2  2008       us  count_np
    3  2008       us   count_p

Three datapoints are marked with a location of usa in the fulfiller
dataset. As an analyst I would mark this down as something for them
to change or if it is unclear I would have to investigate to find
out which version is correct.

With such a minor issue I would probably take these rows out so I 
could continue my investigation since I know that I will look at this 
again but I want to be able to give the fulfiller any further changes that
I could find:

    f <- f %>% filter(year != 2008)
    q <- q %>% filter(year != 2008)

Then I would recreate the datapoints object

    dp <- data_points(f, q)

Finally I would try again to match all values:

    t <- show_values(dp)
    
You can look at the `match` field if you rather avoid sifting
through all the information assigned to `t` here.

    t$match

    Rows in x but not y: 25, 12. Rows in y but not x: 25, 12. 

So, again we are not matching but the categories are not the issue.

>**NOTE** you might have used `show_categories` here to test but I 
skipped that to go right to the big check above.

In this instance the `t` object also returns a dataset that lists all the
datapoints, their values and whether they match:

    head(t$d)
    
    # A tibble: 6 × 7
      in_dataset  year location  variable value.f value.q match
           <chr> <int>    <chr>     <chr>   <int>   <int> <lgl>
    1     common  2001       us count_all 2850006 2850006  TRUE
    2     common  2002       us count_all 2910675 2910675  TRUE
    3     common  2003       us count_all 3019234 3019234  TRUE
    4     common  2004       us count_all 3059929 3059929  TRUE
    5     common  2005       us count_all 3095418 3095418  TRUE
    6     common  2006       us count_all 3115511 3115511  TRUE

You can inspect that dataset to find out where we are not matching
up:

    filter(t$d, match == FALSE)
    
    # A tibble: 2 × 7
      in_dataset  year location variable value.f value.q match
           <chr> <int>    <chr>    <chr>   <int>   <int> <lgl>
    1     common  2003       us count_np  299330  299287 FALSE
    2     common  2007       us  count_p 2893811 2893045 FALSE

As you can see for 2003 and 2007 we are reporting different numbers. So
the next step would be to talk either try to figure out why and then
attempt to resolve this with the fulfiller.

Sometimes, you will go through this process two or three times before
agreeing that a statistical table is ready to go
