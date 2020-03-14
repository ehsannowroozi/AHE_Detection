function [Q, distances] = QF_Estimator( img, startQ )

% estimate the quality factor of a JPEG compressed image
% by means of idempotency
%
% Input:
%   img       = path to JPEG image file or Matlab matrix
%   startQ    = initial JPEG quality factor for idempotency (default: 1)
% Output:
%   Q         = estimated quality factor
%   distances = distance between idempotency version and input image
%

if nargin<2
    startQ = 70;
end

% Read file (skip if matrix) and convert to grayscale if color
if ischar(img), img = imread(img); end
% if size(img,3)>1, img = rgb2gray(img); end

% Container for distances
distances = zeros(1,100-startQ-1);

%--------------------------------------------------------------------------
% FIRST PASS: since idempotency does not work well when QF is high, first
% determine whether the image is compressed with quality in [1,89]
%--------------------------------------------------------------------------

CRITICAL_QF = 89;

% For each possible QF
% quality_factors = startQ:100;
quality_factors = startQ:98;
for q = 1:numel(quality_factors)
    
    if quality_factors(q)> CRITICAL_QF
        last_q = q-1;
        break
    end
    
    % Recompress
    imwrite(img, 'idempotency.jpg', 'jpeg', 'Quality', quality_factors(q))
    
    % Read the re-compressed image
    I_idemp = imread('idempotency.jpg');
    
    % Delete temporary file
    delete idempotency.jpg
    
    % Measure the distance of the input image and the idempotency image
    % as pixel-wise sum of absolute difference
    distances(q) = sum(abs(double(I_idemp(:))/255-double(img(:))/255));

end

% Find the minimum distance and its index in the array, then determine the
% estimated QF
estimatedqIdx = find(distances==min(distances(1:last_q)),1);

%--------------------------------------------------------------------------
% SECOND PASS: if estimate Q is in [1,89] then we're done. Otherwise,
% restrict the analysis to the remaining, high quality factors
%--------------------------------------------------------------------------

if estimatedqIdx < last_q
    Q = quality_factors(estimatedqIdx);
else
    %     dis_highQ = zeros(numel(quality_factors)-last_q,1);
    dis_highQ = zeros(numel(quality_factors)-last_q+1,1);
    cc = 1;
    
    %     for q=last_q+1:numel(quality_factors)
    for q=last_q:numel(quality_factors)
        
        % Recompress
        imwrite(img, 'idempotency.jpg', 'jpeg', 'Quality', quality_factors(q))
        
        % Read the re-compressed image
        I_idemp = imread('idempotency.jpg');
        
        % Delete temporary file
        delete idempotency.jpg
        
        % Measure the distance
        dis_highQ(cc) = sum(abs(double(I_idemp(:))/255-double(img(:))/255));
        % %         dis_highQ(cc) = psnr(I_idemp(:),img(:));
        cc = cc+1;
    end
    
    estimatedqIdx = find(dis_highQ==min(dis_highQ),1);
    Q = quality_factors(estimatedqIdx+last_q-1);
    distances(last_q:end) = dis_highQ;
end

end

