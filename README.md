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
like `dpyr`.

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
must be named `variable` and store the name of the measure (what used 
to in the wide set of columns). The last column must be named `value` and 
store the aggregated statistic.

  - **variable** the measure label
  - **value** the value of the measure

You can recognized these names as what comes out of the `melt` function. The remaining
columns are all categories. We are just giving each data point it's own row.

## Workflow
