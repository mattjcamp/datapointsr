# DataPoints

DataPoints makes it easy to switch between long and wide format statistical summaries.

When I do QC Analysis I'm have to verify the contents of statistical summaries by doing an exact 1:1 match. To identify mismatched data points I usually need to melt both my own table and the the content that I am inspecting. This is a pain.

So, what I do now is put the data into a melted format that is easily to inspect with DataPoints. The format is: 
  - Category fields (used to filter data points)
  - Variable (the name of the original measure or data table column name)
  - Value (the statistic I need to verify)

With the statisical summary in an standard format, I can easily find what data points don't match. Also, it's easy look at data points in a wide format (where each statistical gets it's own column). This makes some analysis, dashboard input and visualization easier.

Finally, both the wide and long formats support SQL style filtering to make it easy to inspect subsets of data points.

## Next Version

I've been using DataPoints for a few weeks and it's working out fairly well. But, I think it would fit into my workflow better if I split out the methods (like long() and wide()) into their own verbs based on the syntax of dplyr.

The idea is that you would start the workflow by building a DataPoints object with the dataframe and category specifications. This object will maintain the full dataset in a long format (the Variable, Value combination that comes from reshape). This would work as normal with the dplyr verbs like select() and filter(). I would also want to define these new verbs specifically for DataPoints:

- sql.filter()
- wide()

### Wish List

Ultimately, I want to take advantage of the common format that DataPoints will enforce to build functions that will automate most of the QC process (iteratively comparing and contrasting two datasets). Also, it would be nice to add some pre-coded graphics for data exploration.
