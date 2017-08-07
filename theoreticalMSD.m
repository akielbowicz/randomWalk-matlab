function [out,varargout]= theoreticalMSD(type,values)
% THEORETICALMSD es devuelve la funcion de msd del tipo pedido.
% con los valores dados
% Y = THEORETICALMSD(TYPE,VALUES) es una funcion msd(t) donde
% TYPE es un string con los valores
%       Para movimiento libre : 'free','linear','browniano'
%       Para movimiento con deriva: 'drift','cuadratic'
%       Para movimiento dirigido/correlacionado: 'directed','correlated'
%       Para movimiento dirigido en el caso continuo: 'telegraph'
%       Para movimiento confinado: 'confined'
%       Para movimiento anomalo: 'anomalous'
% VALUES es una celda con pares de elementos de la forma {'D',D}
%       Para todos los casos: 'd' las dimension del movimiento
%       Para movimiento libre : 'D' el coeficiente de difusion
%       Para movimiento con deriva: 'D','v' el modulo del valor medio  de
%       los pasos.
%       Para movimiento dirigido/correlacionado: 'D','rho' la correlacion
%       entre pasos;
%       Para movimiento dirigido en el caso continuo: 'D','labda' el tiempo
%       medio de decorrelacion
%       Para movimiento confinado: 'D','Ro' el radio de confinamiento medio
%       Para movimiento anomalo: 'D', 'alpha' el exponente anomalo
% [Y, LATEX ]= THEORETICALMSD(TYPE,VALUES) devuelve la formula funcional en
% con formato de LaTeX


D = nan;
d = nan;
v = nan;
rho = nan;
lambda = nan;
Ro = nan;
alpha = nan;

for i = 1:numel(values)
    if ischar(values{i})
        switch values{i}
            case 'D'
                D = values{i+1};
                fprintf('D = %.2g\n',D)
            case 'd'
                d = values{i+1};
                fprintf('d = %.2g\n',d)
            case 'v'
                v = values{i+1};
                fprintf('v = %.2g\n',v)
            case 'rho'
                rho = values{i+1};
                fprintf('rho = %.2g\n',rho)
            case 'lambda'
                lambda = values{i+1};
                fprintf('lambda = %.2g \n',lambda)
            case 'Ro'
                Ro = values{i+1};
                fprintf('Ro = %.2g\n',Ro)
            case 'alpha'
                alpha = values{i+1};
                fprintf('alpha = %.2g\n',alpha)
            otherwise
                error('Parametro no valido')
        end
    end
end

if strcmpi(type,'free') || strcmpi(type,'linear') || strcmpi(type,'brownian')
    
    out =@(t) 2*D*d*t;
    fLatex = '$2Ddt$';
elseif strcmpi(type,'drift') || strcmpi(type,'quadratic')
    
    out =@(t) (v*t).^2 + 2*d*D*t;
    fLatex = '$\left( vt \right)^2 + 2dDt$';
elseif strcmpi(type,'correlated') || strcmpi(type,'directed')
    
    out =@(t)  2*d*D*t* ...
        (1+rho)/(1-rho) ...
        - 2*(2*d*D*rho*(1-rho.^t) )/ ...
        ((1-rho)^2) ;
    fLatex = [ '$ 2dDt '...
        '\frac{1+\rho}{1-\rho}' ...
        '- 2 \frac{2dD \rho \left(1-\rho^t\right)}' ...
        '{\left(1-\rho\right)^2} $'];

elseif strcmpi(type,'telegraph')
    
    out =@(t)  2*d*D/(lambda)*( t - (1/(2*lambda)) * ( 1 - exp(-2*lambda*t) ) );
    fLatex =  '$ 2dDt - \frac{2dD}{2\lambda} \left( 1 - exp\left[-2\lambda t\right]\right)$';
    if lambda == 0
        error('lambda == 0')
    end
elseif strcmpi(type,'confined')
    
    out =@(t)  Ro^2*( 1 - exp( -( t*2*d*D/(Ro^2) ) ) );
    fLatex = '$ R_{o}^{2}\left( 1 - exp\left[ -\frac{2dDt}{R_{o}^{2}} \right] \right) $';

elseif strcmpi(type,'anomalous')
    
    out =@(t) 2*d*D*t.^alpha;
    fLatex = '$ 2dDt^\alpha $';
end

if nargout > 1
    varargout{1} = fLatex;
end

end