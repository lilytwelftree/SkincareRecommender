% Pt2, I want to use the read CSV function and take basic user inputs to apply 
% filters to data. 

% Read Product CSV
filePath = '/Users/lilytwelftree/Documents/Uni/MATLAB/Project/Progress-4_SimpleFiltering/Details.csv';
products = cleanData2(filePath);

% Ask user for product type
product_type = input('What type of product are you in the market for? \n', 's');

% Ask user for budget
budget = input('How much are you willing to spend? \n');

% Ask user for skin concern
benefits = input('What benefits are you after? \n', 's');

% Apply relevant filters to product CSV
filtered_products = products(products.Price <= budget & ...
    contains(products.Subcategory, product_type) &...
    contains(products.Benefits, benefits), :);

% Display the filtered products
disp(filtered_products(1:5,:));