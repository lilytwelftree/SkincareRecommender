% Ingest the CSV and apply any needed changes or functions to ensure it can
% be read in the format that is needed. Do all typecasting here to simplify
% further developments.

function products = cleanData2(filePath)

    % Read Product CSV
    products = readtable(filePath, 'VariableNamingRule', 'preserve');

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

    % Convert variables being used as filters are lowercase
    products.MadeWithout = lower(products.("MadeWithout"));
    products.KeyIngredients = lower(products.("KeyIngredients"));
end
