% Raises scoop arm.

function [position] = raise_scoop(brick, motorPort, range)
    brick.MoveMotorAngleRel(motorPort, 5, range, 'Brake');

    position = 1;
    pause(1);
end