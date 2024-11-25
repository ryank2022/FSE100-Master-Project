% Turns the vehicle.

function turn_car(brick, direction, gyroPort, leftWheelPort, rightWheelPort)
    % Start motors in opposite direction, calibrate rotation, stop when
    % rotation is 90 degrees +/-
    
    rotationSpeed = 24;
    maxRotation = 0;

    if strcmpi(direction, "right")
        maxRotation = 85;
    else if strcmpi(direction, "left")
        maxRotation = -85;
    end
    end

    disp(maxRotation)
    
    brick.GyroCalibrate(gyroPort);
    rotation = GyroAngle(brick, gyroPort);

    disp(rotation)

    if maxRotation < 0
        while (rotation > maxRotation)
            rotation = GyroAngle(brick, gyroPort);
            
            disp(rotation);

            brick.MoveMotor(leftWheelPort, -rotationSpeed);
            brick.MoveMotor(rightWheelPort, rotationSpeed);
        end
        
        brake(brick);
    
    else if (maxRotation > 0)
        while rotation < maxRotation
            rotation = GyroAngle(brick, gyroPort);
            
            disp(rotation);

            brick.MoveMotor(leftWheelPort, rotationSpeed);
            brick.MoveMotor(rightWheelPort, -rotationSpeed);
        end
        
        brake(brick);

    end
    end
    pause(1);
end