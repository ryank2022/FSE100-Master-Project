% Moves forward a set amount
% Distance is a rotation amount in degrees

function increment_drive(brick, leftWheelPort, rightWheelPort, distance, speed)
   MoveMotorAngleRel(brick, leftWheelPort, speed, distance, 'Brake')
   MoveMotorAngleRel(brick, rightWheelPort, speed, distance, 'Brake')

   pause(3);
end