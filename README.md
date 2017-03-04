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



## Data Points Format

  - **Category** fields that define categories that you can filter on
  - **variable** the original measure (mean, n, etc)
  - **value** the value of the measure

## QC Analysis Workflow

One of the applications of data points is QC Analysis. The workflow is to ingest the 
dataset to be QC'ed named `f` (for fulfiller). The next step is to attempt to build a reference
dataset named `q` (for QC'er) that follows the same specifications that the fulfiller
used.

Once you have these datasets, you use them to create two datapoints objects. Then you 
create a `data_points` object with the `f` and `q` data points. This is the
object that you will test. You can look to see if the expected categories are in place
and in the right format. You can also tests if the values in both datasets match.

### Example Workflow

Here is how to see if two sets of categories match up using datapoints using the 
`quakes` built-in dataset as an example.

    # PULL THE DATASETS
    
    f <- quakes
    q <- quakes
    
    # BUILD THE DATAPOINTS OBJECTS
    
    f <- as.data.points(f, c(1,2,5))
    q <- as.data.points(q, c(1,2,5))
    
    # BUILD THE DATAPOINTS OBJECT
    
    dp <- data_points(f, q)
    
    # CHECK TO SEE IF THEY MATCH
    
    match_categories(dp)

This would report back `Equal`. If you don't specify the list member that you want you will
get more information.

You can also look more closely at the result:

    show_categories(dp)
    
This can be done for categories, category metadata and values.
  
