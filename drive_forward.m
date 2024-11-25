% Starts driving backward

function drive_forward(brick, leftWheelPort,rightWheelPort, speed)
    brick.MoveMotor(leftWheelPort, speed);
    brick.MoveMotor(rightWheelPort, speed-2);
end
    