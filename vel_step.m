%makes one simlulation step for velocity field
function [horVelField, verVelField, prevHorField, prevVerField] ...
    = vel_step(horVelField, verVelField, prevHorField, prevVerField, visc, dt)
[horVelField, prevHorField] = swap(horVelField, prevHorField);
[verVelField, prevVerField] = swap(verVelField, prevVerField);

horVelField = diffuse(1, horVelField, prevHorField, visc, dt);
verVelField = diffuse(2, verVelField, prevVerField, visc, dt);

[horVelField, verVelField] = project(horVelField, verVelField);

[horVelField, prevHorField] = swap(horVelField, prevHorField);
[verVelField, prevVerField] = swap(verVelField, prevVerField);

horVelField = advect(1, horVelField, prevHorField, prevHorField, prevVerField,dt);
verVelField = advect(2, verVelField, prevVerField, prevHorField, prevVerField,dt);

[horVelField, verVelField] = project(horVelField, verVelField);
end

function [v1, v2] = swap(v2, v1)
end