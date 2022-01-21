function start_up()
% START_UP() to make Matlab aware of the EKF project paths

disp('Initializing EKF session...');
global usersPath
usersPath = path;

subfoldersToAdd = {'src', 'examples', 'preProcessing', 'postProcessing'};
%each iteration one foldeler is added to the path
for subfolder = 1:length(subfoldersToAdd)
  fileName = mfilename('fullpath');
  separatorIndices = find(fileName == filesep);
  folderName = [fileName(1:separatorIndices(end)), subfoldersToAdd{subfolder}];

  allSubFolders = genpath(folderName);
  folderSeparator = find(allSubFolders == pathsep);

  indexToDelete = false(size(allSubFolders));

  for separatorNumber = 2 : length(folderSeparator)
    if any(strfind(allSubFolders(folderSeparator(separatorNumber - 1) + 1 : folderSeparator(separatorNumber) - 1), '.svn'))
      indexToDelete(folderSeparator(separatorNumber - 1) + 1 :  folderSeparator(separatorNumber)) = true;
    end
  end
  %delete
  allSubFolders(indexToDelete) = [];
  addpath(allSubFolders);

  clear fileName folderName allSubFolders indexToDelete folderSeparator separatorNumber separatorIndices
end

clear subfoldersToAdd fileName separatorIndices folderName allSubFolders folderSeparator indexToDelete allSubFolders 

disp('Done.');
end