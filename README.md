# Data Points

Data points makes it easy to look at statistical tables. Data in
a statistical table is the end result of an analysis. Statistical
tables usally contain descriptive statistics or sometimes just counts
of objects in a group.

Data points melts statistical tables into a long format so it's
easy to do an exact comparison between two sets of data points. This
is helpful when you are looking for differences between two sets
of data points.

## Data Points and Tidy Data

Data points is heavily influenced by the [Tidyverse](https://github.com/tidyverse/tidyverse).
A key componement of the tidyverse is *tidy dataset*,

>Tidy datasets are easy to manipulate, model and visualise, and have a specific structure: each variable is a column, each observation is a row, and each type of observational unit is a table.<br>
>[*Tidy Data*](http://vita.had.co.nz/papers/tidy-data.pdf), Hadley Wickham

However, data points is not tidy because observations are rolled up into aggregated
measures like counts or means. Also, variables are not situated in columns but they
are kept in a long list index by the variable name. Each variable value get it's
own row.

Usually, I would work with data in a tidy format while doing an analysis. But, if I wanted
to try to do a match for a QC analysis I would use data points format to put the results
into a long format that is easy to compare and contrast.

However, like the tidyverse components data points also makes use of a grammer
syntax that includes easy to remember verbs.

## Data Points Format

  - **Categories** fields that define categories that you can filter on
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
  
