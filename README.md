# Dot-Producer
Draws dots on a circle

Its functionality can be easily replicated using [PsychoPy's `visual.Circle`](http://www.psychopy.org/api/visual/circle.html) class as dots.
The position of each dot can be calculated in the following way:

    x = cos(angle) * radius
    y = sin(angle) * radius

Where `angle` is the position on the outer circle with radius `radius`.
