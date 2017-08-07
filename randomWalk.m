classdef randomWalk < matlab.mixin.Copyable 
    properties (GetAccess = 'public', SetAccess = 'private')
        positions
        journal
        oldPositions
        name char = ''
    end
    
    properties
        segment = struct('byAnisotropy',[],...
            'cluster',[],'thread',[],'other',[])
        pixelSize double = 1
        stepTime double = 1
        timeUnit char = 'us'
        spaceUnit char = 'nm'
        voltageZoom = [800, 900, 1000, 2000, 3000, 4000, 5000, ...
            6000, 7000, 8000, 9000, 10000, 11000, 12000];
        pixelScale = [20.904 23.517 26.13 52.26 78.39 104.52 130.65 156.78 ...
            182.91 209.04 235.17 261.3 287.43 313.56];
    end
    
    properties (Access = private)
        originalPositions
    end
    
    methods
        function d = dimension(obj)
            d = size(obj.steps,2);
        end
        
        function n = stepsNumber(obj)
            n = size(obj.steps,1);
        end
        
        function T = duration(obj,unit)
            t = obj.stepTime*obj.stepsNumber;
            T = changeTimeUnit(t,unit);
            display(sprintf('La caminata tiene una duracion de %.3g ( %s )',T,unit))
        end
        
        function out = x(obj)
            out = obj.pixelSize*obj.positions(:,1);
        end
        
        function out = t(obj)
            out = obj.stepTime*(0:length(obj.positions)-1);
        end
        
        function out = y(obj)
            if dimension(obj)> 1
                out = obj.pixelSize*obj.positions(:,2);
            end
        end
        
        function out = z(obj)
            if dimension(obj)> 2
                out = obj.pixelSize*obj.positions(:,3);
            end
        end
        
        function out = XY(obj)
            if dimension(obj)> 1
                out = obj.pixelSize*obj.positions(:,1:2);
            end
        end
        
        function varargout = plot(obj,varargin)
            fig = figure;
            if numel(varargin) == 0
                if dimension(obj) == 1
                    pt = plot(obj.t,obj.x);
                    xlabel(['tiempo ( ' obj.timeUnit ' )']);
                    ylabel(['x ( ' obj.spaceUnit ' )']);
                elseif dimension(obj) == 2
                    pt = plot(obj.x,obj.y);
                    xlabel(['x ( ' obj.spaceUnit ' )']);
                    ylabel(['y ( ' obj.spaceUnit ' )']);
                elseif dimension(obj) == 3
                    pt = plot3(obj.x,obj.y,obj.z);
                    xlabel(['x ( ' obj.spaceUnit ' )']);
                    ylabel(['y ( ' obj.spaceUnit ' )']);
                    zlabel(['z ( ' obj.spaceUnit ' )']);
                end
            elseif numel(varargin) == 1
                switch varargin{1}
                    case 'x'
                        pt = plot(obj.t,obj.x);
                        xlabel(['tiempo ( ' obj.timeUnit ' )']);
                        ylabel(['x ( ' obj.spaceUnit ' )']);
                    case 'y'
                        pt = plot(obj.t,obj.y);
                        xlabel(['tiempo ( ' obj.timeUnit ' )']);
                        ylabel(['y ( ' obj.spaceUnit ' )']);
                    case 'z'
                        pt = plot(obj.t,obj.z);
                        xlabel(['tiempo ( ' obj.timeUnit ' )']);
                        ylabel(['z ( ' obj.spaceUnit ' )']);
                    case 'XY'
                        pt = plot(obj.x,obj.y);
                        xlabel(['x ( ' obj.spaceUnit ' )']);
                        ylabel(['y ( ' obj.spaceUnit ' )']);
                    case 'XZ'
                        pt = plot(obj.x,obj.z);
                        xlabel(['x ( ' obj.spaceUnit ' )']);
                        ylabel(['z ( ' obj.spaceUnit ' )']);
                    case 'YZ'
                        pt = plot(obj.y,obj.z);
                        xlabel(['x ( ' obj.spaceUnit ' )']);
                        ylabel(['y ( ' obj.spaceUnit ' )']);
                    case 'msd'
                        pt = plot(0:obj.stepsNumber,obj.msd(1));
                        xlabel(['tiempo ( ' obj.timeUnit ' )']);
                        ylabel(sprintf('msd ( %s^{2} )',obj.spaceUnit));
                    otherwise
                        warning('No se puede plotear lo que desea')
                end
            elseif numel(varargin)>1
                if ischar(varargin{1})
                    switch varargin{1}
                        case 'msd'
                            if isnumeric(varargin{2}) && varargin{2} <= 1
                                pt = plot(obj.stepTime*(0:numel(obj.msd(varargin{2}))-1),obj.msd(varargin{2}));
                                xlabel(['tiempo ( ' obj.timeUnit ' )']);
                                ylabel(sprintf('msd ( %s^{2} )',obj.spaceUnit));
                            end
                        otherwise
                    end
                end
            end
            set(pt,'LineStyle','-','Marker','.')
            formatFigure(fig)
            set(fig,'Name',obj.name)
            if nargout == 1
                varargout{1} = fig;
            end
        end
        function varargout = plotAngular(obj,varargin)
              varargout{:} = plotAngular(obj.XY,varargin{:});
        end
        
        function plotTheoreticalMSD(obj,type,fraction)
            t = obj.stepTime*(0:numel(obj.msd(fraction))-1);
            if ischar(type)
                if strcmpi(type,'free') || strcmpi(type,'linear') || strcmpi(type,'brownian')
                    values = {'D',obj.D,'d',obj.dimension};
                elseif strcmpi(type,'drift') || strcmpi(type,'quadratic')
                    values = {'D',obj.D,'d',obj.dimension,'v',obj.v};
                elseif strcmpi(type,'correlated') || strcmpi(type,'directed')
                    values = {'D',obj.D,'d',obj.dimension,'rho',obj.meanCosine};
                elseif strcmpi(type,'telegraph')
                    values = {'D',obj.D,'d',obj.dimension,'lambda',-log(obj.meanCosine)/2};
                elseif strcmpi(type,'confined')
                    values = {'D',obj.D,'d',obj.dimension,'Ro',obj.radius};
                else
                    error('Tipo no reconocido')
                end
            else
                error('Tipo tiene formato incorrecto')
            end
            plotTheoreticalMSD(t,type,values)
            set(gcf,'Name',obj.name)
        end
        
        function out = radius(obj)
            out = obj.pixelSize*sqrt(sum(diag(cov(obj.positions,1))));
        end
         function out = anisotropy(obj)
            eigCov = cov(obj.positions(:,1:2));
            out = min(eigCov)/max(eigCov);            
        end
        
        function varargout = plotScatter(obj,varargin)
            if nargout>0
                if nargin>1
                    varargout{1} = plotScatter(obj.pixelSize*obj.positions,varargin{:});
                else
                    varargout{1} = plotScatter(obj.pixelSize*obj.positions);
                end
            else
                if nargin>1
                    plotScatter(obj.pixelSize*obj.positions,varargin{:})
                else
                    plotScatter(obj.pixelSize*obj.positions)
                end
            end
        end
        
        function obj = setPixelSize(obj)
            voltage = obj.journal.ExperimentParameters('Voltage full scale');
            voltIndex = (obj.voltageZoom == voltage);
            obj.pixelSize = obj.pixelScale(voltIndex);
        end
        
        function obj = setStepTime(obj)
            obj.stepTime = obj.journal.ParametersForTracking('Period')*...
                obj.journal.ParametersForTracking('Rperiods')*...
                obj.journal.ParametersForTracking('Z-Period');
        end
        
        function obj = setUnits(obj)
            try
                obj.timeUnit  = obj.journal.timeUnit;
            catch
                
            end
        end
        
        function obj = setName(obj)
            [~,fName,~] = fileparts(obj.journal.Path);
            obj.name  = fName;
        end
        
        function out = steps(obj,varargin)
            if numel(varargin) == 0
                out = obj.pixelSize*diff(obj.positions);
            elseif numel(varargin) == 1
                switch varargin{1}
                    case 'x'
                        out = diff(obj.x);
                    case 'y'
                        out = diff(obj.y);
                    case 'z'
                        out = diff(obj.z);
                    case 'XY'
                        out = diff(obj.XY);
                    otherwise
                end
            else
                warning('No se puede calcular')
            end
        end
        
        function out = stepLength(obj,varargin)
            norm = @(x) sqrt(sum(x.^2,2));
            if numel(varargin) == 1
                out = norm(obj.steps(varargin{1}));
            elseif numel(varargin) == 0
                out = norm(obj.steps);
            end
        end
        
        function out = stepAngle(obj)
            [out ,~] = cart2pol(obj.x,obj.y);
        end
        
        function out = D(obj,varargin)
            % D es el coeficiente de difusion y es igual a var(pasos)/2
            if numel(varargin) == 0
                out = 1e6*sum(var(obj.steps))/(2*obj.dimension*obj.stepTime);
            elseif numel(varargin) == 1
                d = size(obj.steps(varargin{1}),2);
                out = 1e6*sum(var(obj.steps(varargin{1})))/(2*d*obj.stepTime);
            end
            disp(sprintf('D = %.2g ( nm^{2}/s )',out))
        end
        function out = stepVariance(obj,varargin)
            if numel(varargin) == 0
                out = var(obj.steps);
            elseif numel(varargin) == 1
                out = var(obj.steps(varargin{1}));
            end
        end
        function obj = removeZeroLengthStep(obj,varargin)
                if numel(varargin) == 0
                isZeroLength = (obj.stepLength == 0);
                obj.removePoints([false; isZeroLength])    
                else
                  isZeroLength = (obj.stepLength(varargin{:}) == 0);
                obj.removePoints([false; isZeroLength])    
                end
        end
        
        function out = v(obj,varargin)
            norm = @(x) sqrt(sum(x.^2,2));
            % v es el coeficiente de difusion y es igual a var(pasos)/2
            if numel(varargin) == 0
                out = 1e6*norm(obj.meanStep)/obj.stepTime;
            elseif numel(varargin) == 1
                out = 1e6*norm(obj.meanStep(varargin{1}))/obj.stepTime;
            end
            disp(sprintf('v = %.2g ( nm/s )',out))
        end
        
        function out = meanStep(obj,varargin)
            if numel(varargin) == 0
                out = mean(obj.steps);
            elseif numel(varargin) == 1
                out = mean(obj.steps(varargin{1}));
            end
        end
        
        function out = meanCosine(obj)
            angle = stepAngle(obj);
            r = mean(exp(1i*diff(angle)));
            out = real(r)/sqrt(r*r');
        end
        
        function obj = removePoints(obj,pointsIndex)
            if numel(obj.originalPositions) == 0;
                obj.originalPositions = obj.positions;
            end
            obj.oldPositions = obj.positions;
            obj.positions(pointsIndex,:) = [];
        end
        function obj = restoreOldPositions(obj)
            obj.positions = obj.oldPositions;
            obj.oldPositions = [];
        end
        function obj = restoreOriginalPositions(obj)
            obj.positions = obj.originalPositions;
        end
        function out = msd(obj,fraction)
            out = msd(obj.positions,fraction);
        end
        
        function sref = subsref(obj,s)
            % obj(i) is equivalent to obj.positions(i)
            sref = copy(obj);
            switch s(1).type
                case '.'
                    sref = builtin('subsref',sref,s);
                case '()'
                    if length(s) < 2
                        sref.positions = builtin('subsref',sref.positions,s);
                        sref.segment = struct('byAnisotropy',[],...
                            'cluster',[],'thread',[],'other',[]);
                        return
                    else
                        sref = builtin('subsref',sref,s);
                    end
                case '{}'
                    error('randomWalk:subsref',...
                        'Not a supported subscripted reference')
            end
        end
        
        function obj = segmentByAnisotropy(obj,varargin)
            if    isempty(obj.segment.byAnisotropy)
                obj.segment.byAnisotropy = segmentByAnisotropy(obj.XY,varargin{:});
            else
                warning('Ya existen segmentos por anisotropia')
            end
%             out = obj.segment.byAnisotropy;
        end
        
        function obj = segmentCluster(obj,varargin)
            if    isempty(obj.segment.cluster)
                obj.segment.cluster = segmentCluster(obj.XY,varargin{:});
            else
                warning('Ya existen cúmulos')
            end
        end
        
        function obj = segmentThread(obj,varargin)
            if    isempty(obj.segment.thread)
                obj.segment.thread = segmentThread(obj.XY,varargin{:});
            else
                warning('Ya existen filamentos')
            end
%             out = obj.segment.thread;
        end
        
    end
    methods %de los segmentos
        %         function seg_out = getSegment(obj,varargin)
        %             if nargin > 1
        %
        %             else
        %                 seg_out(obj.segmentos.Nsegmentos) = subcaminata;
        %                 k = 1;
        %                 for i = 1:size(obj.segmentos.Segment,1)
        %                     rang_seg = obj.segmentos.Segment{i,1};
        %                     for j = 1:obj.segmentos.Nsegmentos(rang_seg)
        %                         ind_seg = obj.segmentos.Segment{i,2}(j);
        %                         seg_out(k) = subcaminata(obj.pasos(ind_seg:ind_seg+rang_seg,:),ind_seg);
        %                         k = k + 1;
        %                     end
        %                 end
        %             end
        %         end
        
        %         function out = msd(obj,varargin)
        %
        %             if nargin>1
        %                 frac = 4;
        %                 rango = 1:obj.Npasos;
        %                 for i = 1:numel(varargin)
        %                     switch varargin{i}
        %                         case 'Segmentos'
        %                             out = cellfun(@MeanSD,obj.getSegment,'UniformOutput',false);
        %                         case 'Clusters'
        %                             out = cellfun(@MeanSD,obj.getCluster,'UniformOutput',false);
        %                         case 'Fraccion'
        %                             frac = varargin{i+1};
        %                         case 'Rango'
        %                             rango = varargin{i+1}:varargin{i+2};
        %                     end
        %                 end
        %                 out = MeanSD(obj.pasos(rango,:),frac);
        %             else
        %                 out = MeanSD(obj.pasos,4);
        %             end
        %
        %         end
        %
        %         function out = D(obj,varargin)
        %
        %         end
    end
    
    methods %%constructor
        %
        function obj = randomWalk(val)
            
            if nargin > 0
                if ischar(val)
                    [pathstr,name,~] = fileparts(val);
                    val = fullfile(pathstr,[name '.txt']);
                    val = regexprep(val,{'/','\\'},filesep);
                end
                
                if ismatrix(val) && isnumeric(val)
                    if size(val,1)<size(val,2)
                        obj.positions = val';
                    else
                        obj.positions = val;
                    end
                    
                elseif ischar(val) && exist(val,'file') == 2
                    
                    try
                        obj.positions = importWalk(fullfile(pathstr,[name '.txt']));
                    catch
                        [FileName,PathName,~] = uigetfile;
                        filePath = fullfile(PathName,FileName);
                        obj.positions = importWalk(filePath);
                    end
                    
                    try
                        obj.journal = importJournal(fullfile(pathstr,[name '.jrn']));
                        obj.setUnits();
                        obj.setPixelSize();
                        obj.setStepTime();
                        obj.setName();
                    catch
                        warning('No se encontro el journal en el directorio')
                    end
                    
                else
                    error('No se pudo generar la caminata')
                end
                
            else
                
                try
                    try
                        [FileName,PathName,~] = uigetfile('.txt');
                        filePath = fullfile(PathName,FileName);
                        obj.positions = importWalk(filePath);
                        try
                            [pathstr,name,~] = fileparts(filePath);
                            obj.journal = importJournal(fullfile(pathstr,[name '.jrn']));
                        catch
                            warning('No se encontro el journal en el directorio')
                        end
                    catch
                        warning('No se pudo importar la caminata')
                    end
                    obj.setUnits();
                    obj.setPixelSize();
                    obj.setStepTime();
                    obj.setName();
                catch
                    warning('Se creo una caminata vacia')
                end
            end
            
        end
        %         function addSegment(obj,varargin)
        %             if nargin == 2
        %                 obj.segmentos = varargin{1};
        %             else
        %                 if obj.segmentos.isempty
        %                     foo_seg = segmento(segmentacion_j(obj.pasos));
        %                     obj.segmentos = foo_seg;
        %                 end
        %             end
        %         end
    end
end


function out = changeTimeUnit(time,unit)
% CHANGETIMEUNITS cambia de microsegundos a segundo o minutos
switch unit
    case 'us'
        out = time;
    case 's'
        out = time/1e6;
    case 'min'
        out = time/6e7;
    otherwise
        warning('Unidad no valida')
end
end
