function journal = importJournal(jrnPath)
% IMPORTJOURNAL extrae la informacion del .jrn
% Y = IMPORTJOURNAL(X) es una estructura con la informacion de la medicion.


% verificar extension

[filePath,fileName,~] = fileparts(jrnPath);

filePath = regexprep(filePath,{'/','\\'},filesep);

jrnPath = fullfile(filePath,[fileName '.jrn']);

journal = struct('Directory',[],'Path',[],...
    'Date',[],'Time',[],'ExperimentParameters',[],...
    'ParametersForTracking',[],'timeUnit',[]);

% verificar existencia
if exist(jrnPath,'file') == 2
    try
        jrnText = fileread(jrnPath);
    catch
        try
            [FileName,PathName,~] = uigetfile;
            jrnPath = fullfile(PathName,FileName);
            jrnText = fileread(jrnPath);
        catch
            error('No se pudo importar el archivo')
        end
    end
else
    warning('No existe el archivo')
end

% jrnPath = fullfile('mediciones','3D_790nm_z2000_radius1_cell1_exp3.jrn')

journal.Path = jrnPath;


% Buscar palabras en el texto
iCorrelation = strfind(jrnText,'Correlation');
iDate = strfind(jrnText,'DATE');
iTime =  strfind(jrnText,'TIME');
iParameters = strfind(jrnText,'Extension');
iTracking = strfind(jrnText,'for tracking');
iLabel = strfind(jrnText,'Label'); % en nuevas versiones esta presente
iComent = strfind(jrnText,'* COMMENTS');


experimentDirectory =  textscan(jrnText(iCorrelation:iDate-1),'%s %s %s','Delimiter',{':'});
journal.Directory = [experimentDirectory{2}{:}, ':' experimentDirectory{3}{:}];

try
    experimentDate = textscan(jrnText(iDate:iTime-1),'%s %{MMM-dd-yyyy}D','Delimiter',{':'});
catch
    try
        experimentDate = textscan(jrnText(iDate:iTime-1),'%s %{dd/MM/yyyy}D','Delimiter',{':'});
    catch
        experimentDate = textscan(jrnText(iDate:iTime-1),'%s %D','Delimiter',{':'});
    end
end
journal.Date = experimentDate{2};
journal.Time = jrnText(iTime+5:iParameters-3);


% Extraer la informacion
experimentParameters = textscan(jrnText(iParameters:iTracking-1),'%s %f','Delimiter',{':','=','=:'});
experimentParameters{:,1}(end) = [];
mapExperimentParameters = containers.Map(deblank(experimentParameters{1}),experimentParameters{2});
journal.ExperimentParameters = mapExperimentParameters;



if ~isempty(iLabel)
    foo1 = textscan(jrnText(iTracking:iLabel-1),'%s %f','Delimiter',{':'});
    foo1{1}(1) = [];
    foo1{2}(1) = [];
    
    iStart = strfind(jrnText,'start');
    foo2 = textscan(jrnText(iStart:iComent-1),'%s %f','Delimiter',{':'});
    parametersForTracking{1} = [foo1{1}; foo2{1}];
    parametersForTracking{2} = [foo1{2}; foo2{2}];
else
    parametersForTracking = textscan(jrnText(iTracking:iComent-1),'%s %f','Delimiter',{':'});
    parametersForTracking{1}(1) = [];
    parametersForTracking{2}(1) = [];
end

% Correccion Period y unidades temporales
iPeriod = strfind([parametersForTracking{1}],' Period');
fooText = parametersForTracking{1}{not(cellfun(@isempty,iPeriod))};
fooText = textscan(fooText,'%s %s','Delimiter',{' '});
parametersForTracking{1}{not(cellfun(@isempty,iPeriod))} = fooText{2}{:};

journal.timeUnit = fooText{1}{:};

mapParametersForTracking = containers.Map(deblank(parametersForTracking{1}),parametersForTracking{2});
journal.ParametersForTracking = mapParametersForTracking;

% parametersNames = {
% 'Extension',...
% 'Card type', ...
% 'Sampling freq',...
% 'Time/photon mode',...
% 'Maximum cycles',    ...
% 'Scanning period',   ...
% 'Scanning radius',...
% 'Number or r-periods',...
% 'Cycles per particle',...
% 'Voltage full scale',...
% 'DC threshold',...
% 'Z_radius',...
% 'Scanner t-constant'}
%
% parametersForTrackingNames = {'Radius',...
% 'Dwell time',...
% 'Period',...
% 'Rperiods',...
% 'Z-radius',...
% 'Z-Period',...
% 'Points per orbit',...
% 'Samplimg frequency',...
% 'R harmonics',...
% 'R%',...
% 'Mod for auto R',...
% 'Dark 1',...
% 'Dark 2',...
% 'Movement type',...
% 'Mode',...
% 'DC threshold',...
% 'Channel for tracking',...
% 'Up down flag'}
