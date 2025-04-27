% This file takes in historical user information about their age, skin
% type and skin concerns before using that information to recommend them
% five products that align with their personal skin along with what they
% are looking for in their next product

% Read Product CSV
filePath = '/Users/lilytwelftree/Documents/Uni/MATLAB/Project/Progress-5_ComplexFiltering/Details.csv';
products = cleanData2(filePath);

% Get historical user info

age = input('How old are you \n');
skinType = input('What is your skin type? \n', 's');
skinQuirks = input ("Does your skin have any quirks? (Enter if none) \n", 's');

% Determine age group
if age <= 19
    ageGroup = 'Teen';
elseif age <= 29
    ageGroup = 'Twenties';
elseif age <= 39
    ageGroup = 'Thirties';
elseif age <= 49
    ageGroup = 'Forties';
else
    ageGroup = 'FiftyPlus';
end

% Determine age group
if isempty(skinQuirks)
    skinQuirks = 'Blank';
end

% Pass historical user info into GroupingConcerns function to collect full
% list of good and bad ingredients for each variable

[goodIngredients, badIngredients] = GroupingConcerns(ageGroup, skinType, skinQuirks);

% Exclude products with bad ingredients
madeWithout = ~contains(products.KeyIngredients, badIngredients) & ~contains(products.MadeWithout, badIngredients);

% Get Product Expectations
productType = input('What type of product are you in the market for? \n', 's');
productTargets = input('What are you hoping to target \n', 's');
budget = input('How much are you willing to spend? \n');

% Apply relevant filters to product CSV
filtered_products = products(products.Price <= budget & ...
    contains(products.Subcategory, productType) &...
    contains(products.Benefits, productTargets) & ...
    madeWithout,:);

% Display the filtered products
disp(filtered_products(1:5,:));