%one simulation step for diffusion and advection of source material in the fluid
function [fluidArray, prevArray] = dens_step(fluidArray, prevArray, horVelField, verVelField, diff, dt)
[prevArray, fluidArray] = swap(prevArray, fluidArray);

fluidArray = diffuse(0,fluidArray, prevArray, diff, dt);

[prevArray, fluidArray] = swap(prevArray, fluidArray);

fluidArray = advect(0,fluidArray, prevArray, horVelField, verVelField, dt);
end

function [v1, v2] = swap(v2, v1)
end