%adds new stream source as a rectangle, and all velocity vectors in
%velocity field are pointing in direction of given angle
function [u,v] = add_flow(circular, pos, radius, vel, angle, u, v)
x = pos(1);
y = pos(2);
sizeM = size(u,1);

if ~circular
    [u,v] = add_circular_flow(vel, radius, pos, u, v);
else
    yIndexes = (x-radius:x+radius);
    xIndexes = (y-radius:y+radius);
    yIndexes(yIndexes > sizeM) = sizeM;
    yIndexes(yIndexes < 1) = 1;
    xIndexes(xIndexes > sizeM) = sizeM;
    xIndexes(xIndexes < 1) = 1;
    
    u(yIndexes,xIndexes) =  u(yIndexes, xIndexes) + vel*cos(angle);
    v(yIndexes,xIndexes) = v(yIndexes, xIndexes) + vel*sin(angle);
end
end

%in case we want to make cicular stream source, for simulating for example
%water droplet
function [u,v] = add_circular_flow(vel, radius, pos, u, v)
x_start = pos(1);
y_start = pos(2);
sizeM = size(u,1);

x = repmat((1:radius)', 1, 360) .* repmat(cos(linspace(0,2*pi,360)), radius, 1);
y = repmat((1:radius)', 1, 360) .* repmat(sin(linspace(0,2*pi,360)), radius, 1);
x = floor(x) + x_start;
y = floor(y) + y_start;
y(y > sizeM) = sizeM;
y(y < 1) = 1;
x(x > sizeM) = sizeM;
x(x < 1) = 1;

indexes = sub2ind(size(u),x,y);

u(indexes) = u(indexes) + vel*cos(linspace(0,2*pi,360));
v(indexes) = v(indexes) + vel*sin(linspace(0,2*pi,360));
end