# discque-hearto-pulse
A Pulsing Heart Disco Floor in POV-Ray

# rendering
Run povray with `povray discque-hearto-pulse.pov anim.ini` or for a still use `povray discque-hearto-pulse.pov +H1080 +W1920 +A +AM2 +Q11`

![discque](https://raw.githubusercontent.com/discatte/discque-hearto-pulse/main/discque-hearto-pulse-snapshot.png)

# modifying
The included program source `pgm2nya.c` converts pgm grayscale files to a 2d povray array `pgm2nya in.pgm out.inc`. Best luck converting it with ImageMagick via `convert heartgrid.png -grayscale average -depth 8 -scale 15x15 heartgrid.pgm`
