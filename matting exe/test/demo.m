
% image = imread('Training4.png');
% trimap = imread('Training4Trimap.png');

image = imread('E:\work\tools\temp\matting\AffinityBasedMattingToolbox-master\test\1fdee3a8-f29a-11e6-8c00-00163e06132a_1.jpg');
trimap = rgb2gray(imread('E:\work\tools\temp\matting\AffinityBasedMattingToolbox-master\test\1fdee3a8-f29a-11e6-8c00-00163e06132a_1-trimap.bmp'));
 
% Closed-form matting
a_cf = closedFormMatting(image, trimap);
% Some alternatives:
a_ifm = informationFlowMatting(image, trimap);
a_knn = KNNMatting(image, trimap);

% Get the parameter struct and edit for customization if desired
params = getMattingParams('IFM');
params.useKnownToUnknown = 0;
% params.iu_xyw = 0.1;
% params.loc_mult = 3;
a_ifm = informationFlowMatting(image, trimap, params);

% Trim the trimap
trimmed = patchBasedTrimming(image, trimap);
% An alternative:
% trimmed = trimmingFromUnknownToKnownEdges(image, trimap);

% Run K-to-U information flow to get a rough alpha and confidences
[alphaHat, conf] = knownToUnknownColorMixture(image, trimmed);

% Refine alphaHat shared matting
a_sm_ref = sharedMattingMatteRefinement(image, trimmed, alphaHat, conf);
% Alternative:
a_ifm_ref = informationFlowMatteRefinement(image, trimmed, alphaHat, conf);