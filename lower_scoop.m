% Lowers scoop arm.

function [position] = lower_scoop(brick, motorPort, range)
    brick.MoveMotorAngleRel(motorPort, 5, -range, 'Brake');

    position = 0;
    pause(1);
end