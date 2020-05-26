mri = imread('mri.jpg');
mrim = imread('img_xfm07.jpg');
input = load('points07.txt');
%% Part 1: Compute Affine Transformation Function
%set up input/output point pairs
imshow(mri)
keyboard
x1 = input(1,:);
y1 = input(2,:);
x2 = input(3,:);
y2 = input(4,:);
imginput = [x1; y1; ones(1,20)];
imgtrans = [x2; y2; ones(1,20)];

V = imginput;
X = imgtrans; %X IS OUTPUT
%solve for affine transformation
A = (X*V')*inv(V*V');
%defining elements in affine transformation
tx = A(1,3);
ty = A(2,3);
a11 = A(1,1);
a12 = A(1,2);
a21 = A(2,1);
a22 = A(2,2);
%solve system of equations
syms scale1 theta1 theta2 scale2
eq1 = scale1*cos(theta1) == a11;
eq2 = sin(theta1) == a12;
eq3 = -sin(theta2) == a21;
eq4 = scale2*cos(theta2) == a22;
[theta1, scale1] = solve([eq1, eq2], [theta1, scale1]);
%[theta2, scale2] = solve([eq3, eq4], [theta2, scale2]);
%defining affine transformation(s)
A = double([scale1(1,1)*cos(theta1(1,1)), sin(theta1(1,1)), tx; ...
           -sin(theta1(1,1)), scale1(1,1)*cos(theta1(1,1)), ty; ...
           0,0, 1]); %scale11 theta11
A1 = double([scale1(2,1)*cos(theta1(1,1)), sin(theta1(1,1)), tx; ...
            -sin(theta1(1,1)), scale1(2,1)*cos(theta1(1,1)), ty; ...
            0,0, 1]); %scale21 theta11
A2 = double([scale1(1,1)*cos(theta1(2,1)), sin(theta1(2,1)), tx; ...
            -sin(theta1(2,1)), scale1(1,1)*cos(theta1(2,1)), ty; ...
            0,0, 1]); %scale11 theta 21
A3 = double([scale1(2,1)*cos(theta1(2,1)), sin(theta1(2,1)), tx; ...
            -sin(theta1(2,1)), scale1(2,1)*cos(theta1(2,1)), ty; ...
            0,0, 1]); %scale21 %theta21
%test affine transformation
Xtest = A*V;
Xtest1 = A1*V;
Xtest2 = A2*V;
Xtest3 = A3*V;
scatter(X(1,:), X(2,:))
hold on
scatter(Xtest(1,:), Xtest(2,:))

RMSE = mean(sqrt(mean((X-Xtest).^2)));
RMSE1 = mean(sqrt(mean((X-Xtest1).^2)));
RMSE2 = mean(sqrt(mean((X-Xtest2).^2)));
RMSE3 = mean(sqrt(mean((X-Xtest3).^2)));
keyboard
%% Part 2: Bilinear Interpolation
%input values
theta = 1;
scale = 2;
tx = 1;
ty = 1;
% %Part a) Define 2D points in output space
%     %QUESTION3: AM I SUPPOSED TO USE THE OLD XY COORDINATES HERE OR DO IT
%     %FOR ALL OF THE IMAGE? OR NOT SUPPOSED TO USE AFFINE TRANSFORM?
%     %create affine transformation
%     A = double([scale*cos(theta), sin(theta), tx; ...
%                 -sin(theta), scale*cos(theta), ty; ...
%                  0,0, 1]);
%     %using input points (from part1) define output
%     %Xim = 
%     Vnew = A*X;
%Part b) Bilinear Interpolation
%SCALING
    [row, col] = size(mri);
    mrinew = uint8(zeros(scale*row, scale*col)); %enlarging image, will crop late for comparison  
    %zoom in (enlarge image by scale)
        for v = 1:row
        for h = 1:col
            vnew = floor(v*scale);
            hnew = floor(h*scale);
            mrinew(vnew,hnew) = mri(v,h);
        end
        end
        imshow(mrinew)
        keyboard
    %bilinear
    for vnew = scale:floor(row*scale)-scale
        for hnew = scale:floor(col*scale)-scale
        if mrinew(vnew,hnew) == 0 %selecting only "new empty" pixels
        vf = vnew/scale;
        hf = hnew/scale;
        v = floor(vf);
        h = floor(hf);
        vdiff = vf - v;
        hdiff = hf - h;
        mrinew1(vnew,hnew) = uint8((double(mri(v,h))*double(1-vdiff)*double(1-hdiff)) ... 
            +(double(mri(v+1,h))*double(vdiff)*(1-hdiff))... 
            +(double(mri(v,h+1))*double(hdiff)*double(1-vdiff)) ... 
            +(double(mri(v+1,h+1))*double(vdiff)*hdiff)); 
        else
        mrinew1(vnew,hnew) = mrinew(vnew,hnew);  
        end
        end
    end
    subplot(1,2,1), imshow(mrinew)
    subplot(1,2,2), imshow(mrinew1)
    keyboard
        %QUESTION:kinda confused about bilinear logic here
% %ROTATION
% [row, col] = size(mrinew);
% mrinew2 = zeros(row, col);
% xm = col/2; %picking centre point
% yn = row/2;
% for vnew = 1:row
%     for hnew = 1:col
%         vr = floor(cos(theta)*(vnew-xm) + sin(theta)*(hnew-yn)) + xm;
%         hr = floor(sin(theta)*(hnew-yn) + cos(theta)*(hnew-yn)) + yn;
%         %mrinew1(vr,hr) = mrinew(vnew, hnew);
%     end
% end
% 
% %TRANSLATION
% %%%ORRRRR
% %1 Make Vector of all x,y coordinate pairs
% %1use affine transform to find their new locations
% %2"fill in the blanks"???
%% Part 3: