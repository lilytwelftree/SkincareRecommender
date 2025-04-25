% Simple script to read CSV and show first 5 rows

% Define the file path
filePath = '/Users/lilytwelftree/Documents/Uni/MATLAB/Project/Progress-2_Database/Details.csv';

% Read the CSV file into a table
products = readtable(filePath);

% Display the first 5 rows of the table
disp('First 5 rows of the dataset:');
disp(products(1:5, :));
