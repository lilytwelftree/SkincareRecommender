% Ingest the CSV and apply any needed changes or functions to ensure it can
% be read in the format that is needed. Do all typecasting here to simplify
% further developments.

function products = DataClean(filePath)

    % Read Product CSV
    products = readtable(filePath);

    % Delete useless columns

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

    % Process Price column: if there are two values
    % split the lower and upper and just save upper
    if contains(products.Price{1}, '-')
        price_split = split(products.Price, '-');
        products.Price = str2double(strrep(price_split(:, 2), '$', ''));
    else
        products.Price = str2double(strrep(products.Price, '$', ''));
    end

    % Rating (ensure it's numeric)
    products.Rating = str2double(string(products.Rating));

    % Review Count. (ensure it's numeric)
    products.("ReviewCount") = str2double(string(products.("ReviewCount")));
   
    % Save Product Name, brand and subcategory as strings
    products.("ProductName") = string(products.("ProductName"));
    products.Brand = string(products.Brand);
    products.Subcategory = string(products.Subcategory);
end

% Call the function and clean the data
filePath = '/Users/lilytwelftree/Documents/Uni/MATLAB/Project/Progress-2_Database/Details.csv';
products = DataClean(filePath);


% Print to verify the results
disp('First 5 rows of the dataset:');
disp(products(1:5, :));

disp('Sample Weights:');
disp(products.("Weight_g_")(1:20));  % Display first 3 product names
disp(products.("Weight_ml_")(1:3));  % Display first 3 product names