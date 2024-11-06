% beeps
function beepUp(brick, beeps, volume)
    n = 1;
    for i = n:beeps
        brick.beep(volume);
        pause(0.1);
    end
end