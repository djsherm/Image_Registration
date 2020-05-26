function m_sq_err = mean_sq_err(guess)
%% DOCUMENTATION

% FUNCTION ACCEPTS 2 IMAGES (ONE TRANSFORMED FROM THE EMAIL, ONE NOT) AND 
% TRANSFORMATIONS (THETA, SX, SY, TX, TY)
% FUNCTION PERFORMES THE TRANSFORMATION ON THE REFERENCE IMAGE, 
% AND CALCULATES THE MEAN SQUARED ERROR BETWEEN THE TWO
% FUNCTION IS USED TO FIND THE TRANSFORMATION OF THE MYSTERY IMAGE

% MADE BY: DANIEL SHERMAN
% MARCH 20, 2020

%% START OF CODE

%parse out initial guess from input vector
theta = guess(1);
Sx = guess(2);
tx = guess(3);
ty = guess(4);

%load in original image (hardcoded)
ref_img = imread('mri.jpg');

[m,n] = size(ref_img); %grab size of original image

% ~~~ UNCOMMENT THE NEXT 3 LINES AND COMMENT THE LINE THAT DEFINES  
% 'mys_img' TO RUN THIS FUNCTION WITH AN IMAGE OF ARBITRARY TRANSFORMATIONS ~~~
% NEXT THREE LINES WERE USED FOR FUNCTION VERIFICATION
% mys_shift = bilinear_interp_translate(ref_img, 10, 10);
% mys_rot = bilinear_interp_angle(mys_shift, deg2rad(33));
% mys_img = bilinear_interp_scale(mys_rot, 1.33, 1.33);

%load in mystery image
mys_img = imread('img_xfm07.jpg');

%% TRANSFORM REFERENCE IMAGE BASED ON GIVEN TRANSFORMATIONS

scale = bilinear_interp_scale(ref_img, Sx, Sx); %scale original image with guess
rotate = bilinear_interp_angle(scale, theta); %rotate origianl image with guess
full_tfd_img = bilinear_interp_translate(rotate, tx, ty); %translate original image with guess

%% FIND MEAN SQUARED ERROR BETWEEN THE TRANSFORMED IMAGE AND THE MYSTERY IMAGE

m_sq_err = immse(double(full_tfd_img), double(mys_img));
