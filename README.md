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
analysis to independently create the table and then compare his or her results
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

First, create the fulfiller's statistical table:

    library(wicher)
    
    d <- wiche_graduate_projections %>% 
      filter(year %in% 2001:2010,
             grade == "g",
             race == "all",
             location == "us") %>% 
      mutate(variable = sprintf("count_%s", sector),
             value = n) %>% 
      select(year, location, variable, value) %>% 
      wide(f)

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


