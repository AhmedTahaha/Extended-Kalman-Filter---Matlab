function shut_down()
% SHUT_DOWN() to clear global variables and project paths after an EKF session

clear path
global usersPath

try
  path(usersPath);
catch
  disp('Warning: global variable usersPath was changed and now is not valid');
end

clearvars
clearvars -global

disp('EKF session closed.');

end