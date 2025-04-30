%% Start of the Application
% Skincare Routine Builder is an app to help people find their perfect next
% skincare purchase. It asks the user a series of questions with each
% answer given acting as a filter on the CSV of 2,357 skincare products.
% Each question builds a list of ingredients that that particular user
% should avoid due and recommends them products thats specifically exclude
% those ingredients.
% 
% This is the main function, the only function that the user must run for
% the app to run. From here, each app screen is called one after the
% other. While all the information the user needs to understand the app is
% shown in the app, print statments are also used to shows the users where
% they are up to in the program.

function LaunchUserSkinInfo()
    
    % We call the homepage and give the user 4seconds to read and select to
    % partake in the quiz, even if they do not interact, the quiz moves on.
    disp('Launching Skincare Routine Builder...');
    app1 = Homepage();
    pause(4);

    disp('Homepage has closed. Time to catch us up to speed on your skin...');
    
    % Now the first app requiring input is launched. This app asks
    % the user historical information about their skin. From here, the
    % following user activity with dictate which apps are opened and
    % closed. 
    newApp = UserSkinInformation();
    uiwait(newApp.UIFigure);
  
end
