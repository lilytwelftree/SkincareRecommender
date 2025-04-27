% This function is the home for all the good and bad ingredients for
% users skin specifictaions. 

function [goodIngredients, badIngredients] = GroupingConcerns (ageGroup, skinType, skinQuirks)
    
    % Define keywords for each age group
    keywords.good.Teen = {'glycerin', 'jojoba', 'hylauronic acid', 'salicylic acid'};
    keywords.bad.Teen = {'retinol', 'retinal', 'sulfates', 'parabens', 'phthalates'};
    
    keywords.good.Twenties = {'niacinamide', 'hyaluronic acid', 'vitamin C', 'peptides'};
    keywords.bad.Twenties = {'retinol', 'retinal'};
    
    keywords.good.Thirties = {'retinol', 'retinoid', 'AHA', 'BHA', 'ceramides'};
    keywords.bad.Thirties = {};
    
    keywords.good.Forties = {'peptides', 'hyaluronic acid', 'retinol', 'lactic acid', 'caffeine'};
    keywords.bad.Forties = {};
    
    keywords.good.FiftyPlus = {'retinol', 'retinal', 'collagen', 'peptide', 'squalane', 'caffeine'};
    keywords.bad.FiftyPlus = {};
    
    
    % Define keywords for each skin type
    keywords.good.Oily = {'niacinimide', 'salicylic acid'};
    keywords.bad.Oily = {'mineral oil', 'silicones'};
    
    keywords.good.Dry = {'vitamin E', 'Shea butter', 'ceramides'};
    keywords.bad.Dry = {'sulfates'};
    
    keywords.good.Combination = {'vitamin C', 'niacinamide'};
    keywords.bad.Combination = {'alcohol'};

    keywords.good.Normal = {};
    keywords.bad.Normal = {};
    
    % Define keywords for each skin quirk if one is provided
    keywords.good.Blank = {};
    keywords.bad.Blank = {};

    keywords.good.Sensitive = {'peptides'};
    keywords.bad.Sensitive = {'fragrance', 'alcohol'};
    
    keywords.good.AcneProne = {'sulfate'};
    keywords.bad.AcneProne = {'BHA', 'lactic acid' 'sulphur', 'niacinamide', 'sulphur', 'squalene', 'glycolic acid'};
    
    keywords.good.Dryness = {'sulfate', 'alcohol'};
    keywords.bad.Dryness = {'argan oil', 'jojoba oil', 'glycerine', 'squalene'};
    
    keywords.good.Psoriasis = {'fragrance', 'alcohol', 'sulfate'};
    keywords.bad.Psoriasis = {'argan oil', 'lactic acid', 'sulphur', 'squalene'};
    
    keywords.good.Rosacea = {'sulfates', 'parabens', 'fragrance'};
    keywords.bad.Rosacea = {'glycerine', 'squalene'};
    
    keywords.good.Eczema = {'fragrance', 'alcohol', 'sulfate'};
    keywords.bad.Eczema = {'cerimides'};

    %Collect Good ingreidntes for historical use info
    goodIngredients = [...
        keywords.good.(ageGroup), ...
        keywords.good.(skinType), ...
        keywords.good.(skinQuirks)];

    %Collect Bad ingreidntes for historical use info
    badIngredients = [...
        keywords.bad.(ageGroup), ...
        keywords.bad.(skinType), ...
        keywords.bad.(skinQuirks)];
end
