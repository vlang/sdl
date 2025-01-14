This program is about D2Q9 Lattice Boltzmann Method:
See : https://en.wikipedia.org/wiki/Lattice_Boltzmann_methods

It's a pet project in order to use V language: https://vlang.io/

The simulation is single threaded, probably buggy and should not be used
for serious things.  It's very sensible to tau parameter that should be
carefully set. This parameter is related to fluid viscosity, and is set so
that the fluid speed doesn't exceed a speed limit that breaks simulation.
Too narrow passage (speed increased) may reach this limit.

profiles files MUST be of the same size of defined width and weight and
should be 8bits per pixels. Every non zero value is considered as an
obstacle.

to compile the program from within source directory:

v -prod .

or if you want gcc as compiler:

v -prod -cc gcc .

SDL module must be installed: https://vpm.vlang.io/packages/sdl
and post install script executed, see link.

The simulation is quite slow, but would you like to slow it down, just
uncomment the sdl.delay(...) in file.



This program is released under MIT license.
