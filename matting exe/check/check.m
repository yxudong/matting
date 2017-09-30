function varargout = check(varargin)
% CHECK MATLAB code for check.fig
%      CHECK, by itself, creates a new CHECK or raises the existing
%      singleton*.
%
%      H = CHECK returns the handle to a new CHECK or the handle to
%      the existing singleton*.
%
%      CHECK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHECK.M with the given input arguments.
%
%      CHECK('Property','Value',...) creates a new CHECK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before check_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to check_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help check

% Last Modified by GUIDE v2.5 18-Sep-2017 15:35:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @check_OpeningFcn, ...
                   'gui_OutputFcn',  @check_OutputFcn, ...
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


% --- Executes just before check is made visible.
function check_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to check (see VARARGIN)

% Choose default command line output for check
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes check wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = check_OutputFcn(hObject, eventdata, handles) 
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


%read  original image
[filename1, pathname1] =uigetfile({'*.jpg;*.tif;*.png;*.bmp'},'select the origin image');
orgName = fullfile(pathname1,filename1);
image = imread(orgName);
axes(handles.origin);
imshow(image);

%backimage
redimg = zeros(size(image));
redimg(:, :, 1) = 1.0;
blueimg = zeros(size(image));
blueimg(:, :, 3) = 1.0;

%read  old Alpha
[filename2, pathname2] =uigetfile({'*.jpg;*.tif;*.png;*.bmp'},'select the alpha image');
orgAlpha_name = fullfile(pathname2,filename2);
orgAlpha = (imread(orgAlpha_name));
orgAlpha = orgAlpha(:,:,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[F,B]=solveFB(double(image)/255,  double(orgAlpha)/255);

newimg_red = F.*repmat(double(orgAlpha)/255,[1,1,3]) + redimg.*repmat(1-double(orgAlpha)/255,[1,1,3]);
axes(handles.red);
imshow(newimg_red);

newimg_blue = F.*repmat(double(orgAlpha)/255,[1,1,3]) + blueimg.*repmat(1-double(orgAlpha)/255,[1,1,3]);
axes(handles.blue);
imshow(newimg_blue);

%为了显示出来前景多了哪些部分和前景少了哪些部分
newbk = B.*repmat(1- double(orgAlpha)/255,[1,1,3]) + repmat(double(orgAlpha)/255,[1,1,3]);
figure, imshow([F.*repmat(double(orgAlpha)/255,[1,1,3]),newbk]);

directoryname = uigetdir('', 'Pick Composite Image Save Directory');   % 选择trimap结果保存目录
savename_red = strrep(filename1,'.jpg','-composite_red.bmp');
savename_blue = strrep(filename1,'.jpg','-composite_blue.bmp');
fullname_red = fullfile(directoryname,savename_red);
fullname_blue = fullfile(directoryname,savename_blue);
imwrite(newimg_red,fullname_red);
imwrite(newimg_blue,fullname_blue);
