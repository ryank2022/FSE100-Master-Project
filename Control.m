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

% Connects the keypress and release functions
set(fig,'WindowKeyPressFcn',@keyPressFun);
set(fig,'WindowKeyReleaseFcn',@keyReleaseFun);

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
            brick.MoveMotorAngleRel(leftWheelPort, defaultSpeed, 700, 'Coast');
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
            
            increment_drive(brick, leftWheelPort, rightWheelPort, -680, defaultSpeed);
            %turn_car(brick, 'left', gyroPort, leftWheelPort, rightWheelPort);
            brick.MoveMotorAngleRel(rightWheelPort, defaultSpeed, 700, 'Coast');
            pause(3);
        end
        
        %^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^%
        % Color Logic
        colorState = brick.ColorCode(colorPort);

        if colorState == RED
            disp("saw red");
            stop_driving(brick);
            pause(1.5);
            drive_forward(brick, leftWheelPort, rightWheelPort, defaultSpeed);
            pause(0.8); 
        end
        
        if colorState == BLUE
            disp("saw blue");
            stop_driving(brick);
            beepUp(brick, 2, 400);
            break
        end

        if colorState == GREEN
            disp("saw green")
            stop_driving(brick);
            beepUp(brick, 3, 400);
            break
        end

        if colorState == YELLOW
            disp("saw yellow");
            stop_driving(brick);
            beepUp(brick, 4, 400);
            break
        end

        touchReading = false;
        wall_found = false;

    end
    brick.StopAllMotors();

end

function keyPressFun(source,eventdata)
    global brick;

    global scoopPort;
    global rightWheelPort;
    global leftWheelPort;

    global defaultSpeed;

    global automatic_navigation;

    keyPressed = eventdata.Key;
    
    disp(keyPressed + " pressed");
    
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
        disp("Starting automatic navigation.");
        autoNav();
    end

    if strcmpi(keyPressed, "0") % Abort
        automatic_navigation = false;
        disp('Automatic navigation aborted');
    end

    if strcmpi(keyPressed, "r")
        resetStuff();
    end

    if strcmpi(keyPressed, "q")
        stop_driving(brick);
    end
end

function keyReleaseFun(source,eventdata)
    global brick;
    keyPressed = eventdata.Key;
    
    disp(keyPressed + " released");

    if strcmpi(keyPressed, "i") || strcmpi(keyPressed, "j") || strcmpi(keyPressed, "k") || strcmpi(keyPressed, "l")
        stop_driving(brick)
    end
end
