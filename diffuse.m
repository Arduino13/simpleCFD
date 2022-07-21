%diffuse velocity or density field
function fluidArray = diffuse(boundaryCond, fluidArray, prevArray, diff, dt)
mat_size = size(fluidArray, 1)-1;

a = dt*diff*mat_size^2;

for k=1:20
    fluidArray(2:end-1, 2:end-1) = (((fluidArray(1:end-2,2:end-1) + fluidArray(3:end,2:end-1) + ...
        fluidArray(2:end-1,1:end-2) + fluidArray(2:end-1,3:end)) ...
        *a) + prevArray(2:end-1, 2:end-1))/(1+4*a);
    
    fluidArray = set_bnd(boundaryCond, fluidArray);
end
end