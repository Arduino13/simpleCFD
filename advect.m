%propagates fluid velocity field along itself and also move density field
%of source material along velocity field
function fluidArray = advect(boundaryCond, fluidArray, prevArray, horVelField, verVelField, dt)
mat_size = size(fluidArray, 1)-1;
dt0 = dt*mat_size;
prevSize = size(prevArray);

y = repmat((2:(mat_size)), mat_size-1, 1) - dt0*verVelField(2:end-1, 2:end-1);
x = repmat((2:(mat_size)).', 1, mat_size-1) - dt0*horVelField(2:end-1, 2:end-1);

x(x < 1.5) = 1.5;
x(x > (mat_size + 0.5)) = mat_size + 0.5;
y(y < 1.5) = 1.5;
y(y > (mat_size + 0.5)) = mat_size + 0.5;

i0 = floor(x);
i1 = i0 + 1;
j0 = floor(y);
j1 = j0 + 1;
s1 = x - i0;
s0 = 1 - s1;
t1 = y - j0;
t0 = 1 - t1;

fluidArray(2:end-1, 2:end-1) = s0 .* ( t0 .* prevArray(sub2ind(prevSize, i0, j0)) + ...
    t1 .* prevArray(sub2ind(prevSize, i0, j1))) + ...
    s1 .* (t0 .* prevArray(sub2ind(prevSize, i1, j0)) + ...
    t1 .* prevArray(sub2ind(prevSize, i1, j1)));

fluidArray = set_bnd(boundaryCond, fluidArray);
end