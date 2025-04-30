%% Clean the data file
% This file intakes the CSV and applies any needed changes to ensure the
% CSV can be read and manipulated by other functions.
% All typecasting is done here to simplify further developments.

function products = cleanData2(filePath)

    % Read Product CSV
    products = readtable(filePath);

    % Delete useless columns. While not immediatley necessary, in early
    % stages this helped when samples of the CSV were being printed.
    % Simplified outputs to see only informative columns. 

    % Delete 'Product Number'
    if ismember('ProductNumber', products.Properties.VariableNames)
        products.ProductNumber = [];
    end

    % Delete 'Ingredients'
    if ismember('Ingredients', products.Properties.VariableNames)
        products.Ingredients = [];
    end
    
    % Delete 'Stock'
    if ismember('StockStatus', products.Properties.VariableNames)
        products.StockStatus = [];
    end

    % Delete 'Category'
    if ismember('Category', products.Properties.VariableNames)
        products.Category = [];
    end

    % When price information was collected some products had a lower and 
    % upper price as some products had several weights. For the routine 
    % builder app, we are only really interested in the upper price tage. 

    % Process Price column: if there are two values, split the lower 
    % and upper and just save the upper price as 'Price'
    if contains(products.Price{1}, '-')
        price_split = split(products.Price, '-');
        products.Price = str2double(strrep(price_split(:, 2), '$', ''));
    else
        products.Price = str2double(strrep(products.Price, '$', ''));
    end
    

    % Check that the rating column is a number
    products.Rating = str2double(string(products.Rating));

    % Check that the review count column is a number
    products.("ReviewCount") = str2double(string(products.("ReviewCount")));
   
    % Save Product Name, brand and subcategory as strings rather than
    % characters
    products.("ProductName") = string(products.("ProductName"));
    products.Brand = string(products.Brand);
    products.Subcategory = string(products.Subcategory);

    % Ensure variables that will be used as filters are all read in 
    % lowercase.
    products.MadeWithout = lower(products.('MadeWithout'));
    products.KeyIngredients = lower(products.('KeyIngredients'));
end
