function Dif=DifImage1(P)

% 
% //************************************************************************
% //*  Module Name: 
% //*        implementation of differential image class.
% //*  Abstract: 
% //*        implements a class to do difference operator of images.
% //*  Note: 
% //*        none.
% //* 
% //*  Last Modified on: 2013-11-23 10:38:42 by Zhenyu Zhao
% //***********************************************************************
% *

[m n s]=size(P);
F=zeros(m+4,n+4,s);
F(3:m+2,3:n+2,:)=P;
Dif=cell(6,1);

Dif{1}=P;
Dif{2}=(F(3:m+2,4:n+3,:)-F(3:m+2,2:n+1,:))/2;
Dif{3}=(F(4:m+3,3:n+2,:)-F(2:m+1,3:n+2,:))/2;
Dif{4}=F(3:m+2,2:n+1,:)+F(3:m+2,4:n+3,:)-2*P;
Dif{5}=(F(2:m+1,2:n+1,:)+F(4:m+3,4:n+3,:)-F(2:m+1,4:n+3,:)-F(4:m+3,2:n+1,:))/4;
Dif{6}=F(2:m+1,3:n+2,:)+F(4:m+3,3:n+2,:)-2*P;
