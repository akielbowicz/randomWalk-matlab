function walk = importWalk(measurePath)
% measurePath = fullfile('~','Documents/WinRes-01-17/WindowsRec/vesiculas/2016-02-29','celulaNP1_estimulando.txt')

%importo las mediciones
data = importdata(measurePath);

% si jrn tiene header arma una estructura
if isstruct(data)
    data = data.data;
end

% tomo solo las dimensiones en las que hay movimiento
indexPositions = 7:9; %columnas con las posiciones
isMoving = any(data(:,indexPositions));

walk = data(:,indexPositions(isMoving));

% Para que comience en el origen
walk = walk-walk(ones(length(walk),1),:);



