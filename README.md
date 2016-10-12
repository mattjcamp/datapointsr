# datapointsr

**datapointsr** makes it easy to switch between long and wide format statistical summaries.

When I do QC Analysis I'm have to verify the contents of statistical summaries by doing an exact 1:1 match. To identify mismatched data points I usually need to melt both my own table and the the content that I am inspecting. This is a pain.

So, what I do now is put the data into a melted format that is easily to inspect with 
DataPoints. The format is: 

  - **Category** fields (used to filter data points)
  - **variable** (the name of the original measure or data table column name)
  - **value** (the statistic I need to verify)

With the statisical summary in a standard format, I can easily find what data points 
don't match. Also, it's easy to look at data points in a wide format (where each summary 
statistic gets it's own column). This makes some analysis, dashboard input and visualization 
easier.

The idea is that you would start the workflow by building a DataPoints object with the 
dataframe and category specifications. This object will maintain the full dataset in a long
format (the variable, value combination that comes from `reshape`). This would work as normal 
with  the `dplyr` verbs like `select()` and `filter()`. I would also want to define these 
new verbs specifically for DataPoints:

- `sql_filter()` 
- `wide()`

## QC Analysis Workflow

The first application of DataPoints is QC Analysis. The workflow is to ingest the 
dataset to be QC'ed named `f` (for fulfiller). Then I will attempt to build a reference
dataset named `q` (for QC'er) that follows the same specifications that the fulfiller
used.

Once you have these datasets, you use them to create two datapoints objects. Then you 
create a `compare_datapoints` object with the `f` and `q` datapoints. This is the
object that you will test. You can look to see if the expected categories are in place
and in the right format. You can also tests if the values in both datasets match.

### Example Workflow

Here is how to see if two sets of categories match up using datapoints using the 
`quakes` built-in dataset as an example.

    # PULL THE DATASETS
    
    f <- quakes
    q <- quakes
    
    # BUILD THE DATAPOINTS OBJECTS
    f <- datapoints(f, c(1,2,5))
    q <- datapoints(q, c(1,2,5))
    
    # BUILD THE DATAPOINTS COMPARER OBJECT
    
    dc <- compare_datapoints(f, q)
    
    # CHECK CATEGORY METADATA TO SEE IF THEY BOTH MATCH
    
    check_categories_meta(dc)$match

This would report back `TRUE`. If you don't specify the list member that you want you will
get more information.
