function rgb=qualitativo(m)
%GIMP Palette
%Name: CB_qual_Set1_9
%Columns: 3
%# This color palette was developed by Cynthia Brewer (see http://colorbrewer2.org/).
%228  26  28  qual_Set1_9_01
 %55 126 184  qual_Set1_9_02
 %77 175  74  qual_Set1_9_03
%152  78 163  qual_Set1_9_04
%255 127   0  qual_Set1_9_05
%255 255  51  qual_Set1_9_06
%166  86  40  qual_Set1_9_07
%247 129 191  qual_Set1_9_08
%153 153 153  qual_Set1_9_09

%Form rgb values
rgb = [
228  26  28
 55 126 184
 77 175  74
152  78 163
255 127   0
255 255  51
166  86  40
247 129 191
153 153 153
    ];
rgb=rgb/256;
% depending upon input m
if nargin==0, m=9; end
if m<9 % choose subset of colors, almost same order as matlab
    j=[2 4 7 3 8 5 1 6 9];
    j=sort(j(1:m));
    rgb=rgb(j(1:m),:);
else % linearly interpolate across spectrum
    %c=9*(1:m)'/m;
    c=1+8*(0:m-1)'/(m-1);
    i=floor(c); f=c-i; j=i+1;
    i=mod(i-1,9)+1; j=mod(j-1,9)+1;
    rgb=(1-[f,f,f]).*rgb(i,:)+[f,f,f].*rgb(j,:);
end
