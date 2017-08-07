function rgb = divergente(m)
%GIMP Palette
%Name: CB_div_RdYlBu_6
%Columns: 3
%# This color palette was developed by Cynthia Brewer (see http://colorbrewer2.org/).
%215  48  39  div_RdYlBu_6_01
%252 141  89  div_RdYlBu_6_02
%254 224 144  div_RdYlBu_6_03
%224 243 248  div_RdYlBu_6_04
%145 191 219  div_RdYlBu_6_05
% 69 117 180  

%Form rgb values
rgb = [
215  48  39
252 141  89
254 224 144
224 243 248
145 191 219
 69 117 180
    ];
rgb=rgb/256;
% depending upon input m
if nargin==0, m=6; end
if m<6 % choose subset of colors, almost same order as matlab
    j=[2 4 3 5 1 6];
    j=sort(j(1:m));
    rgb=rgb(j(1:m),:);
else % linearly interpolate across spectrum
    %c=6*(1:m)'/m;
    c=1+5*(0:m-1)'/(m-1);
    i=floor(c); f=c-i; j=i+1;
    i=mod(i-1,6)+1; j=mod(j-1,6)+1;
    rgb=(1-[f,f,f]).*rgb(i,:)+[f,f,f].*rgb(j,:);
end
