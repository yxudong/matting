function     fBuildMatteUsingAllMethods



srcImage = 'E:\matting exe\mytool\data\image';
srcTrimap = 'E:\matting exe\mytool\data\trimap';

dstMatte = 'E:\matting exe\mytool\data\matte';
dstComposition = 'E:\matting exe\mytool\data\compo';

srcAll = dir([srcImage '\*.jpg']);

for  nI = 1 : length(srcAll)
    
    image = imread([srcImage '\' srcAll(nI).name]);
    %backimage
    sbkimg = zeros(size(image));
    sbkimg(:, :, 1) = 1.0;
    [~, fff] = fileparts(srcAll(nI).name);
    trimap = rgb2gray(imread([srcTrimap '\' fff  '-trimap.bmp']));
    
    
    %ComprehensiveSamplingMatting
    a_cs = WeightedColorTextureMatting(image, trimap);   
    a_cs = repmat(a_cs, [1,1,3]);
    imwrite(uint8(a_cs), [dstMatte '\' fff '_0.bmp']);
    
    a_cs = a_cs(:,:,1);
    [F,B]=solveFB(double(image)/255,  double(a_cs)/255);
    newimg = F.*repmat(double(a_cs)/255,[1,1,3]) + sbkimg.*repmat(1-double(a_cs)/255,[1,1,3]);
    imwrite(newimg, [dstComposition '\' fff '_0.bmp']);
    
    %WeightedColorTextureMatting
    a_wct = WeightedColorTextureMatting(image, trimap);   
    a_wct = repmat(a_wct, [1,1,3]);
    imwrite(uint8(a_wct), [dstMatte '\' fff '_0.bmp']);
    
    a_wct = a_wct(:,:,1);
    [F,B]=solveFB(double(image)/255,  double(a_wct)/255);
    newimg = F.*repmat(double(a_wct)/255,[1,1,3]) + sbkimg.*repmat(1-double(a_wct)/255,[1,1,3]);
    imwrite(newimg, [dstComposition '\' fff '_0.bmp']);
  
    %newbk = B.*repmat(1- single(a_wct)/255,[1,1,3]) + repmat(single(a_wct)/255,[1,1,3]);
    %imwrite(uint8([F.*repmat(double(a_wct)/255,[1,1,3]),newbk]), [dstComposition '\' fff '_0.bmp']);
    
    
    % Closed-form matting
    a_cf = closedFormMatting(image, trimap);
    a_cf = repmat(a_cf, [1,1,3]);
    imwrite((a_cf), [dstMatte '\' fff '_1.bmp']);
    
    a_cf = a_cf(:,:,1);
    [F,B]=solveFB(double(image)/255,  (a_cf));
    newimg = F.*repmat(double(a_cf),[1,1,3]) + sbkimg.*repmat(1-double(a_cf),[1,1,3]);
    imwrite((newimg), [dstComposition '\' fff '_1.bmp']);

    
    % KNN matting
    %a_knn = KNNMatting(image, trimap);
     
    
    % information flow matting:
    a_ifm1 = informationFlowMatting(image, trimap);
    a_ifm1 = repmat(a_ifm1, [1,1,3]);    
    imwrite(a_ifm1, [dstMatte '\' fff '_2.bmp']);

    a_ifm1 = a_ifm1(:,:,1);     
    [F,B]=solveFB(double(image)/255,  a_ifm1);
    newimg = F.*repmat(double(a_ifm1),[1,1,3]) + sbkimg.*repmat(1-double(a_ifm1),[1,1,3]);
    imwrite((newimg), [dstComposition '\' fff '_2.bmp']);

    
    % Get the parameter struct and edit for customization if desired
    params = getMattingParams('IFM');
    params.useKnownToUnknown = 0;
    % params.iu_xyw = 0.1;
    % params.loc_mult = 3;
    a_ifm2 = informationFlowMatting(image, trimap, params);
    a_ifm2 = repmat(a_ifm2, [1,1,3]);  
    imwrite((a_ifm2), [dstMatte '\' fff '_3.bmp']);
    
    a_ifm2 = a_ifm2(:,:,1);    
    [F,B]=solveFB(double(image)/255,  double(a_ifm2));
    newimg = F.*repmat(double(a_ifm2),[1,1,3]) + sbkimg.*repmat(1-double(a_ifm2),[1,1,3]);
    imwrite((newimg), [dstComposition '\' fff '_3.bmp']);

%     a_ifm2 = imread([dstMatte '\' fff '_1.bmp']);
%     a_ifm2 = a_ifm2(:,:,1);
%     
%     [F,B]=solveFB(double(image)/255,  double(a_ifm2)/255);
%     newimg = F.*repmat(double(a_ifm2)/255,[1,1,3]) + sbkimg.*repmat(1-double(a_ifm2)/255,[1,1,3]);
%     imwrite((newimg), [dstComposition '\' fff '_1.bmp']);
%     
%     newbk = B.*repmat(1- single(a_ifm2)/255,[1,1,3]) + repmat(single(a_ifm2)/255,[1,1,3]);
%     imwrite(([F.*repmat(double(a_ifm2)/255,[1,1,3]),newbk]), [dstComposition '\' fff '_diff_1.bmp']);

    
end


 