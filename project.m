%main purpose is to make a mass conserveting field for fluid, so that 
%dievergence of fluid is zero
function [horVelField, verVelField] = project(horVelField, verVelField)
mat_size = size(verVelField, 1)-1;
h = 1/(mat_size);
rho = 0.75;

p = zeros(mat_size+1);
div = zeros(mat_size+1);

div(2:end-1, 2:end-1) =  -rho*h*(horVelField(3:end,2:end-1) - horVelField(1:end-2,2:end-1) + ...
    verVelField(2:end-1,3:end) - verVelField(2:end-1,1:end-2));

div = set_bnd(0, div);
p = set_bnd(0, p);

for k=1:20 %Gauss-siedel iteration to solve pressure eqution
    p(2:end-1, 2:end-1) = (div(2:end-1, 2:end-1) + p(1:end-2, 2:end-1) + ...
        p(3:end, 2:end-1) + p(2:end-1, 1:end-2) + p(2:end-1, 3:end))/4;
    p = set_bnd(0,p);
end

%adding corrections to velocity field
horVelField(2:end-1, 2:end-1) = horVelField(2:end-1, 2:end-1) - ...
    rho*(p(3:end, 2:end-1) - p(1:end-2, 2:end-1))/h;
verVelField(2:end-1, 2:end-1) = verVelField(2:end-1, 2:end-1) - ...
    rho*(p(2:end-1, 3:end) - p(2:end-1, 1:end-2))/h;

horVelField =  set_bnd(1, horVelField);
verVelField = set_bnd(2, verVelField);
end