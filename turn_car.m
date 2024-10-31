% Turns the vehicle.

function turn_car(brick, direction, gyroPort, leftWheelPort, rightWheelPort)
    % Start motors in opposite direction, calibrate rotation, stop when
    % rotation is 90 degrees +/-
    
    rotationSpeed = 50;
    maxRotation = 0;

    if strcmpi(direction, "right")
        brick.MoveMotor(leftWheelPort, rotationSpeed);
        brick.MoveMotor(rightWheelPort, -rotationSpeed);
        maxRotation = 90;
    else if strcmpi(direction, "left")
        brick.MoveMotor(leftWheelPort, -rotationSpeed);
        brick.MoveMotor(rightWheelPort, rotationSpeed);
        maxRotation = -90;
    end
    end
    
    brick.GyroCalibrate(gyroPort);
    rotation = GyroAngle(brick, gyroPort);

    if maxRotation < 0
        while rotation > maxRotation
            rotation = GyroAngle(brick, gyroPort);
        end
        stop_driving(brick,leftWheelPort,rightWheelPort);
    else if maxRotation > 0
        while rotation < maxRotation
            rotation = GyroAngle(brick, gyroPort);
        end 
        stop_driving(brick,leftWheelPort,rightWheelPort);
    end
    end
    pause(1);
end