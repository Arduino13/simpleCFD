%simulates boundary for the liquid, so the liquid can't escape from the box
function fluidArray = set_bnd(boundaryType, fluidArray)
 if boundaryType == 2 %for horizontal velocity
     fluidArray(:, 1) = -fluidArray(:, 2);
     fluidArray(:, end) = -fluidArray(:, end-1);
 else
     fluidArray(:, 1) = fluidArray(:, 2);
     fluidArray(:, end) = fluidArray(:, end-1);
 end
 
 if boundaryType == 1 %for vertical velocity
     fluidArray(1, :) = -fluidArray(2, :);
     fluidArray(end, :) = -fluidArray(end-1, :);
 else
     fluidArray(1, :) = fluidArray(2, :);
     fluidArray(end, :) = fluidArray(end-1, :);
 end
 end