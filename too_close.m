% Returns true if a wall is too close.

function [output] = too_close(brick, sensorPort)
    distance = brick.UltrasonicDist(sensorPort);

    if distance < 10
        output = true;
    else
        output = false;
    end

end