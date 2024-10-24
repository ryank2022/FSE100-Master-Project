% By: Jason Martin, Ryan Kereszturi, Rohan Kshatriya, Nancy Ruiz Sandoval
%brick = ConnectBrick('AA');

while true
    sensorRead = TouchPressed(brick, 1);
    
    brick.beep();
    if sensorRead > 0
        break
    end
end
