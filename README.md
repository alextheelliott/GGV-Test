# GGV-Test
Testing the GGV theories as outlined in the Master's Theory by *Alberto Reinero*
### [Lap time simulator for a single-seater electric car](https://webthesis.biblio.polito.it/20760/1/tesi.pdf)

## Notes:
This is a heavily simplified point mass simulation.

## Theoretical Process:
Create an ellipse of friction coefficients given the maximum x and y friction coefficients for different values of V.

Calculate the Ax and Ay for all the friction points around the ellipse, adding the effects of drag, downforce, and rolling resistance. The forward force uses Meq instead of M, see the paper.

Plot these forces vs the velocity to create the GGV plot.

## TODO:
- Include better estimations of tire friction
- Find accurate values for car performance
- Next steps outlined in the paper to incorporate YMD information
