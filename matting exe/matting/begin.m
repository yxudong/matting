function varargout = begin(varargin)
% BEGIN MATLAB code for begin.fig
%      BEGIN, by itself, creates a new BEGIN or raises the existing
%      singleton*.
%
%      H = BEGIN returns the handle to a new BEGIN or the handle to
%      the existing singleton*.
%
%      BEGIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BEGIN.M with the given input arguments.
%
%      BEGIN('Property','Value',...) creates a new BEGIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before begin_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to begin_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help begin

% Last Modified by GUIDE v2.5 19-Sep-2017 09:38:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @begin_OpeningFcn, ...
                   'gui_OutputFcn',  @begin_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before begin is made visible.
function begin_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to begin (see VARARGIN)

% Choose default command line output for begin
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes begin wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = begin_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


srcImage = uigetdir('', 'Pick Origin Directory');
srcTrimap = uigetdir('', 'Pick Trimap Directory');
dstMatte = uigetdir('', 'Pick Alpha Directory');
dstComposition = uigetdir('', 'Pick Composition Directory');
% srcImage = 'E:\matting exe\mytool\data\image';
% srcTrimap = 'E:\matting exe\mytool\data\trimap';
% 
% dstMatte = 'E:\matting exe\mytool\data\matte';
% dstComposition = 'E:\matting exe\mytool\data\compo';

srcAll = dir([srcImage '\*.jpg']);

for  nI = 1 : length(srcAll)
    
    image = imread([srcImage '\' srcAll(nI).name]);
    %backimage
    sbkimg = zeros(size(image));
    sbkimg(:, :, 1) = 1.0;
    [~, fff] = fileparts(srcAll(nI).name);

    %trimap = rgb2gray(imread([srcTrimap '\' fff  '-trimap.bmp']));
    trimap = imread([srcTrimap '\' fff  '-trimap.bmp']);
    l=size(trimap, 3);
    if l==3
         trimap=rgb2gray(trimap);
    end
    
    
    %ComprehensiveSamplingMatting
%     try
%         a_cs = WeightedColorTextureMatting(image, trimap);   
%         a_cs = repmat(a_cs, [1,1,3]);
%         imwrite(uint8(a_cs), [dstMatte '\' fff '_0.bmp']);
% 
%         a_cs = a_cs(:,:,1);
%         [F,B]=solveFB(double(image)/255,  double(a_cs)/255);
%         newimg = F.*repmat(double(a_cs)/255,[1,1,3]) + sbkimg.*repmat(1-double(a_cs)/255,[1,1,3]);
%         imwrite(newimg, [dstComposition '\' fff '_0.bmp']);
%     catch
%         continue
%     end

    a_cs = WeightedColorTextureMatting(image, trimap);   
    a_cs = repmat(a_cs, [1,1,3]);
    imwrite(uint8(a_cs), [dstMatte '\' fff '_0.bmp']);

    a_cs = a_cs(:,:,1);
    [F,B]=solveFB(double(image)/255,  double(a_cs)/255);
    newimg = F.*repmat(double(a_cs)/255,[1,1,3]) + sbkimg.*repmat(1-double(a_cs)/255,[1,1,3]);
    imwrite(newimg, [dstComposition '\' fff '_0.bmp']);

    
    
    % Closed-form matting
    try
        a_cf = closedFormMatting(image, trimap);
        a_cf = repmat(a_cf, [1,1,3]);
        imwrite((a_cf), [dstMatte '\' fff '_1.bmp']);

        a_cf = a_cf(:,:,1);
        [F,B]=solveFB(double(image)/255,  (a_cf));
        newimg = F.*repmat(double(a_cf),[1,1,3]) + sbkimg.*repmat(1-double(a_cf),[1,1,3]);
        imwrite((newimg), [dstComposition '\' fff '_1.bmp']);
    catch
        continue
    end

    
    % KNN matting
    %a_knn = KNNMatting(image, trimap);
     
    
    % information flow matting:
    try
        a_ifm1 = informationFlowMatting(image, trimap);
        a_ifm1 = repmat(a_ifm1, [1,1,3]);    
        imwrite(a_ifm1, [dstMatte '\' fff '_2.bmp']);

        a_ifm1 = a_ifm1(:,:,1);     
        [F,B]=solveFB(double(image)/255,  a_ifm1);
        newimg = F.*repmat(double(a_ifm1),[1,1,3]) + sbkimg.*repmat(1-double(a_ifm1),[1,1,3]);
        imwrite((newimg), [dstComposition '\' fff '_2.bmp']);
    catch
        continue
    end

    
    % Get the parameter struct and edit for customization if desired
    try
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
    catch
        continue
    end
    
    
    %WeightedColorTextureMatting
    try
        a_wct = WeightedColorTextureMatting(image, trimap);   
        a_wct = repmat(a_wct, [1,1,3]);
        imwrite(uint8(a_wct), [dstMatte '\' fff '_4.bmp']);

        a_wct = a_wct(:,:,1);
        [F,B]=solveFB(double(image)/255,  double(a_wct)/255);
        newimg = F.*repmat(double(a_wct)/255,[1,1,3]) + sbkimg.*repmat(1-double(a_wct)/255,[1,1,3]);
        imwrite(newimg, [dstComposition '\' fff '_4.bmp']);
    catch
        continue
    end

end
