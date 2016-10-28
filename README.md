# Data Points

Data points makes it easy to look at statistical tables. Data in
a statistical table is the end result of an analysis. Statistical
tables usally contain descriptive statistics or even just counts
of things in a group.

Data points melts statistical tables into a long format so it's
easy to do an exact comparison between two sets of data points. This
is helpful when you are looking for differences between two sets
of data points.

## Data Points Format

  - **Categories** 
  - **variable** the original measure (mean, n, etc)
  - **value** the value of the measure

## Data Points and Tidy Data

## QC Analysis Workflow

One of the applications of data points is QC Analysis. The workflow is to ingest the 
dataset to be QC'ed named `f` (for fulfiller). Then I will attempt to build a reference
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
    
    # BUILD THE DATAPOINTS COMPARER OBJECT
    
    dp <- data_points(f, q)
    
    # CHECK TO SEE IF THEY MATCH
    
    match_categories(dp)

This would report back `Equal`. If you don't specify the list member that you want you will
get more information.

You can also look more closely at the result:

    show_categories(dp)
    
This can be done for categories, category metadata and values.
  
