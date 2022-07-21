function init_GUI()
size = 50;
figSize = [850, 810];
densScale = 10; %scale for colors of imagesc, which is used for displaying density of source material
dt = 0.01;

%matrixes with current displaying values
u = zeros(size); %horizontal velocity
v = zeros(size); %vertical velocity
dens = zeros(size); %density of source material

u_prev = zeros(size); %previous state of values
v_prev = zeros(size);
dens_prev = zeros(size);


to_addU = zeros(size); %valus of fields that are added every step 
                       %for example to have stable flow
to_addV = zeros(size);
to_addDens = zeros(size);

%% Timer initializaiton
tm = timer;
tm.Period = 0.1;
tm.ExecutionMode = 'fixedSpacing';
tm.TimerFcn = @timer_run;
    function timer_run(~, ~)
        [u,v] = vel_step(u,v,u_prev,v_prev, fluidVisc.Value/10, dt);
        dens = dens_step(dens, dens_prev, u, v, diff.Value/10, dt);
        
        graph.UData = v;
        graph.VData = u;
        graphH.CData = dens;
        
        u_prev = u;
        v_prev = v;
        dens_prev = dens;
        
        u_prev = u_prev + to_addU;
        v_prev = v_prev + to_addV;
        dens_prev = dens_prev + to_addDens;
    end

%% GUI initialization
root = groot();
window = uifigure('Position', ...
    [(root.ScreenSize(3:4) - figSize)/2 figSize], ...
    'Name', 'Simple CFD solver');

graphPanel = uipanel(window, 'Position', [5, 5, 500, 800]);
GUIpanel = uipanel(window, 'Position', [520, 5, 325, 800]);
speedPanel = uipanel(GUIpanel, 'Position', [20, 360, 285, 320], ...
    'Title', 'Speed');
densPanel = uipanel(GUIpanel, 'Position', [20, 220, 285, 115], ...
    'Title', 'Density');
controlPanel = uipanel(GUIpanel, 'Position', [20, 20, 285, 170], ...
    'Title', 'Program status');

uilabel(GUIpanel, 'Text', 'Matrix density:', ...
    'Position', [20, 735, 100, 25]);
matrixDens = uispinner(GUIpanel, 'Value', 50, ...
    'Limits', [20, 500], ...
    'Position', [120, 735, 75, 25]);
uilabel(GUIpanel, 'Text', 'Cursor radius', ...
    'Position', [20, 690, 100, 25]);
cursorRadius = uispinner(GUIpanel, 'Value', 5, ...
    'Limits', [1,30], ...
    'Position', [120, 690, 75, 25]);
uilabel(speedPanel, 'Text', 'Liquid speed:', ...
    'Position', [20, 260, 100 ,25]);
fluidVel = uispinner(speedPanel, 'Value', 5, ...
    'Limits', [1,50], ...
    'Position', [120, 260, 75, 25]);
angleOn = uicheckbox(speedPanel, 'Value', true, ...
    'Text', 'Flow angle', ...
    'Position', [20, 210, 150, 25]);
fluidAngle = uiknob(speedPanel, ...
    'Position', [50, 100, 75, 75], ...
    'Value', 180, ...
    'Limits', [0, 360]);
uilabel(speedPanel, 'Text', 'Viscosity', ...
    'Position', [20, 20, 100, 25]);
fluidVisc = uispinner(speedPanel, ...
    'Value', 20, ...
    'Limits', [0,1000], ...
    'Position', [120, 20, 75, 25]);
fluidAngle.MajorTicksMode = 'manual';
fluidAngle.MajorTicks = 0:30:360;
uilabel(densPanel, 'Text', 'Diffusion speed', ...
    'Position', [20, 55, 100, 25]);
diff = uispinner(densPanel, 'Value', 10, ...
    'Limits', [0, 1000], ...
    'Position', [120, 55, 75, 25]);
uilabel(densPanel, 'Text', 'Liquid density', ...
    'Position', [20, 15, 100, 25]);
density = uispinner(densPanel, 'Value', 10, ...
    'Limits', [0, 10], ...
    'Position', [120, 15, 75, 25]);
startButton = uibutton(controlPanel, 'Text', 'Start', ...
    'BackgroundColor', 'green', ...
    'Position', [90, 100, 100, 25]);
stopButton = uibutton(controlPanel, 'Text', 'Stop', ...
    'BackgroundColor', 'red', ...
    'Position', [90, 65, 100, 25]);
clearButton = uibutton(controlPanel, 'Text', 'Clear', ...
    'Position', [90, 30, 100, 25]);

[graph, graphH] = init_graphs(size, densScale, graphPanel);

matrixDens.ValueChangedFcn = @matrixSizeChanged;
startButton.ButtonPushedFcn = @startPressed;
stopButton.ButtonPushedFcn = @stopPressed;
graph.Parent.ButtonDownFcn = @addVel;
graphH.ButtonDownFcn = @addDens;
clearButton.ButtonPushedFcn = @clearSurf;
window.DeleteFcn = @closeWin;

%% Callback functions
    function closeWin(~, ~)
        stop(tm); 
    end

    function clearSurf(~, ~) %clears velocity and density matrixes
        u_prev = zeros(size);
        v_prev = zeros(size);
        dens_prev = zeros(size);
        u = zeros(size);
        v = zeros(size);
        dens = zeros(size);
        to_addU = zeros(size);
        to_addV = zeros(size);
        to_addDens = zeros(size);
        
        graph.UData = v_prev;
        graph.VData = u_prev;
        graphH.CData = dens_prev;
    end
    function addVel(hFig, ~) %adds new steram 
        mousePos = hFig.CurrentPoint(1,1:2);
        x = floor(mousePos(1));
        y = floor(mousePos(2));
        rad = cursorRadius.Value;
        [u_prev,v_prev] = add_flow(angleOn.Value, [y,x], rad, fluidVel.Value, ...
            deg2rad(fluidAngle.Value), u_prev, v_prev);
        
        if tm.Running == "off"
            to_addU = u_prev;
            to_addV = v_prev;
        end
        
        graph.UData = v_prev;
        graph.VData = u_prev;
    end
    function addDens(hFig, ~) %adds source material
        mousePos = hFig.Parent.CurrentPoint(1,1:2);
        x = floor(mousePos(1));
        y = floor(mousePos(2));
        rad = cursorRadius.Value;
        yIndexes = (y-rad:y+rad);
        xIndexes = (x-rad:x+rad);
        yIndexes(yIndexes > size) = size;
        yIndexes(yIndexes < 1) = 1;
        xIndexes(xIndexes > size) = size;
        xIndexes(xIndexes < 1) = 1;
        
        dens_prev(yIndexes, xIndexes) = ...
            dens_prev(yIndexes, xIndexes) + density.Value;
        
        if tm.Running == "off"
            to_addDens = dens_prev;
        end
        
        hFig.CData = dens_prev;
    end

    function startPressed(~, ~)
        start(tm);
    end
    function stopPressed(~, ~)
        stop(tm);
    end

    function matrixSizeChanged(obj, ~) %changich size of velocity and density matrixes
        if tm.Running == "off"
            [graph, graphH] = init_graphs(obj.Value, densScale, graphPanel);
            graph.Parent.ButtonDownFcn = @addVel;
            graphH.ButtonDownFcn = @addDens;
            size = obj.Value;
            u = zeros(size);
            v = zeros(size);
            dens = zeros(size);
            u_prev = zeros(size);
            v_prev = zeros(size);
            dens_prev = zeros(size);
            to_addU = zeros(size);
            to_addV = zeros(size);
            to_addDens = zeros(size);
        else
            uialert(window, 'Nelze měnit velikost mřížky za běhu programu', ...
                'Chybný parametr', 'icon', 'error');
        end
    end
end
