% Stops the car with out braking.

function stop_driving(brick)
    brick.StopAllMotors('Coast');

    pause(1);
end
    