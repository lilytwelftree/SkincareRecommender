function LaunchUserSkinInfo()
    % Clear workspace and command window
    clear;
    clc;
    
    disp('Launching SkincareRecommender app...');
    
    % Launch first app and wait until it is closed
    app1 = Homepage();
    pause(4);

    disp('SkincareRecommender app closed. Launching UserSkinInfo...');
    
    % Launch second app
    newApp = UserSkinInformation();
    uiwait(newApp.UIFigure);

    disp('UserSkinInfo launched.');
  
end
