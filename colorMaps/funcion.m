function out = funcion(n)
    if n == 0
        out = 1;
    else
        out = n.*funcion(n-1);
    end
    