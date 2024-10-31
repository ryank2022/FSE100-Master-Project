% Create 
fig = uifigure("Name","Control Window");

% Run in command window before executing: brick = ConnectBrick('AA');
global brick;

% Set values for relevant ports
global leftWheelPort;
leftWheelPort = 'D';
global rightWheelPort;
rightWheelPort = 'A';
global scoopPort;
scoopPort = 'C';

global gyroPort;
gyroPort = 1;
global touchPort;
touchPort = 3; 
global colorPort;
colorPort = 2;
global ultraPort;
ultraPort = 4;

global defaultSpeed;
defaultSpeed = 65;

set(fig,'WindowKeyPressFcn',@keyPressFun); %Set force to -1/1 for left/right arrow keys 
set(fig,'WindowKeyReleaseFcn',@keyReleaseFun); %Set force to zero when released

% Setup
function resetStuff()
    global brick;
    global colorPort;
    global scoopPort;

    brick.MoveMotorAngleAbs(scoopPort, 1, 0);
    brick.SetColorMode(colorPort, 4);
    stop_driving(brick);
end

function autoNav()
    global brick;
    global scoopPort;
    global rightWheelPort;
    global leftWheelPort;
    
    global gyroPort;
    global touchPort;
    global colorPort;
    global ultraPort;

    global defaultSpeed;
    
    % Color thresholds
    RED = 5;
    BLUE = 2;
    GREEN = 3;
    YELLOW = 4;
    
    global automatic_navigation;
    automatic_navigation = true;

    while automatic_navigation
        % returns true if there is a wall on the right
        
        % Wall detection logic
        wall_found = too_close(brick, ultraPort);
        
        if wall_found == true
            drive_forward(brick, leftWheelPort, rightWheelPort, defaultSpeed);
        else
            disp("No wall");

            stop_driving(brick);
            pause(1);

            % turn right if there is no wall on the right
            %increment_drive(brick, leftWheelPort, rightWheelPort, 360, defaultSpeed);

            %turn_car(brick, 'right', 's', leftWheelPort, rightWheelPort);
            disp("turning.");
            brick.MoveMotorAngleRel(leftWheelPort, 50, 660, 'Coast');
            pause(4);
            
            disp("going");
            drive_forward(brick, leftWheelPort, rightWheelPort, defaultSpeed);
            pause(2);
        
        end
        
        %^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^%
        % Front logic
        touchReading = brick.TouchPressed(touchPort);
        
        if touchReading
            disp("touch read");
            brick.beep();

            stop_driving(brick);
            pause(1);
            
            increment_drive(brick, leftWheelPort, rightWheelPort, -520, defaultSpeed);
            %turn_car(brick, 'left', gyroPort, leftWheelPort, rightWheelPort);
            brick.MoveMotorAngleRel(rightWheelPort, 50, 700, 'Brake');
            pause(2);
        end
        
        %^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^%
        % Color Logic
        colorState = brick.ColorCode(colorPort);

        if colorState == RED
            disp("saw red");
            pause(1);
            stop_driving(brick);
        end
        
        if colorState == BLUE
            disp("saw blue");
            stop_driving(brick);
            break
        end

        if colorState == YELLOW
            disp("saw yellow");
            stop_driving(brick);
            break
        end

        touchReading = false;
        wall_found = false;

        brick.StopAllMotors();

    end

end

function keyPressFun(source,eventdata)
    global brick;

    global scoopPort;
    global rightWheelPort;
    global leftWheelPort;

    global defaultSpeed;

    global automatic_navigation;

    keyPressed = eventdata.Key;
    
    disp(keyPressed);
    
    % Scooping
    if strcmpi(keyPressed, "a")
        raise_scoop(brick, scoopPort, 45);
    end

    if strcmpi(keyPressed, "s")
        lower_scoop(brick, scoopPort, 45);
    end
    
    % Steering
    if strcmpi(keyPressed, "i")
        drive_forward(brick, leftWheelPort, rightWheelPort, defaultSpeed*2);
    end
    if strcmpi(keyPressed, "k")
        drive_backward(brick, leftWheelPort, rightWheelPort, defaultSpeed*2);
    end
    if strcmpi(keyPressed, "l") %Turn right
        steer_drive(brick, "right", leftWheelPort, rightWheelPort', defaultSpeed);
    end
    if strcmpi(keyPressed, "j") %Turn left
        steer_drive(brick, "left", leftWheelPort, rightWheelPort, defaultSpeed);
    end

    % Start self-driving
    if strcmpi(keyPressed, "space")
        autoNav();
    end

    if strcmpi(keyPressed, "0") % Abort
        automatic_navigation = false;
    end

    if strcmpi(keyPressed, "r")
        resetStuff();
    end
end

function keyReleaseFun(source,eventdata)
    global brick;
    keyPressed = eventdata.Key;

    if keyPressed == "i" || keyPressed == "j" || keyPressed == "k" || keyPressed == "l"
        stop_driving(brick)
    end
end
