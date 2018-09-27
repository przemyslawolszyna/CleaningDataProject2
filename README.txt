Script ' ' cleans up input date from X_Train, X_test files at following steps.:

1) load X_train and X_test files
2) Removes NA by columns (exclusion columns with all NA)
3) Removes NA by rows (removing each filed with NA accross row)
4) Add  Activity Id by Marge X_train with Y_Train, and X_test with y_test
5) Add descriptive headers of variables
5) Prepare list of variablas ( std and mean) 
6) Filter out ony those columns into new subset
7) Adds descriptive rows Names
8) generate new subset with Mean values calculated per Variable and Activity

