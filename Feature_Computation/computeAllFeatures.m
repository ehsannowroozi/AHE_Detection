
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% In this Section the imgs_path features are computed by SPAM686.M
% (SPATIAL). The dimention of SPAM is 686.
% The features of SPAM686 by default are in columns, we are clip the features on rows.
% The SPAM686 is Copyright (c) 2011 DDE Lab, Binghamton University, NY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function F = computeAllFeatures(imgs_path)

images = dir(imgs_path);
images = images(3:end);

list_cell = cell(1, size(images,1) );

for i=1:size(images,1)
    
    i
    tic
    list_cell{i} = images(i).name; 
    %Calling SPAM686.M For Feature Extraction
    F.featuresS{i} = CRSPAM1372_New([imgs_path '/' list_cell{i}]);
    %End of Calling
    F.features{i} = [F.featuresS{i}'];
    F.name = list_cell{i};
    F.matrix(i,:) = F.features{i};
    
    t=toc;
    fprintf('Elapsed Time: %.3f sec.\n',t);
    
end

end
