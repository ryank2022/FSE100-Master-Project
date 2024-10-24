% Stop driving only

function stop_driving(brick, leftWheelPort,rightWheelPort)
    brick.StopMotor(leftWheelPort, 'Coast');
    brick.StopMotor(rightWheelPort, 'Coast');
end
    