% For turning while manually driving

function steer_drive(brick, direction, leftWheelPort, rightWheelPort, rotationSpeed)
    if strcmpi(direction, "right")
        brick.MoveMotor(leftWheelPort, rotationSpeed);
        brick.MoveMotor(rightWheelPort, -rotationSpeed);
    else if strcmpi(direction, "left")
        brick.MoveMotor(leftWheelPort, -rotationSpeed);
        brick.MoveMotor(rightWheelPort, rotationSpeed);
    end
    end
end