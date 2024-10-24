% Starts driving backward

function drive_backward(brick, leftWheelPort,rightWheelPort, speed)
    brick.MoveMotor(leftWheelPort, -speed);
    brick.MoveMotor(rightWheelPort, -speed);
end
    