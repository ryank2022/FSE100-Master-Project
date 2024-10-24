fig = uifigure("Name","Control Window");

%DisconnectBrick(brick)
global brick;
%brick = ConnectBrick('AA');

set(fig,'WindowKeyPressFcn',@keyPressFun); %Set force to -1/1 for left/right arrow keys 
set(fig,'WindowKeyReleaseFcn',@keyReleaseFun); %Set force to zero when released

brick.MoveMotorAngleAbs('C', 1, 0);

function keyPressFun(source,eventdata)
    global brick;
    keyPressed = eventdata.Key;

    if strcmpi(keyPressed, "a")
        raise_scoop(brick, 'C', 45);
    end

    if strcmpi(keyPressed, "s")
        lower_scoop(brick, 'C', 45);
    end
    
    % Steering
    if strcmpi(keyPressed, "i")
        drive_forward(brick, 'D', 'A', 100);
    end
    if strcmpi(keyPressed, "k")
        drive_backward(brick, 'D', 'A', 100);
    end
    if strcmpi(keyPressed, "l") %Turn right
        steer_drive(brick, "right", 'D', 'A', 50);
    end
    if strcmpi(keyPressed, "j") %Turn left
        steer_drive(brick, "left", 'D', 'A', 50);
    end
end

function keyReleaseFun(source,eventdata)
    global brick;

    stop_driving(brick, 'D', 'A')
end

running = (1==1);

%function fig_KeyPressFcn(hObject, eventdata, handles)
%    display(eventdata.Key);
%end

%lower_scoop(brick, 'C');

%while running
%    wall = too_close(brick, 1);
    
%end