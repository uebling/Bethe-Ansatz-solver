# Bethe-Ansatz-solver
Matlab-code that solves the Lieb-Wu equations of the Bethe Ansatz for the Hubbard model

Notes for my Bethe Ansatz code:

0) At the top of the code, you enter the parameters: N (total particle number), M (number of minority spin = maximum number of pairs), L (lattice length)
	* Utarget is the interaction value at which it stops
	* I,J are the initial values for the momenta and spin rapidities. The length of the arrays must be N, M respectively. The current code has as an example a lattice with 10 particles (5+5) in 21 sites.

	* The array "imag" is an array of length N with elements +i,-i,..., so you have to change it too if you change N. For repulsive interactions it may not be needed.
	
	* Other parameters are epsilon (for a tiny complex-conjugate seed, maybe not needed in repulsive case), and the parameters for the fsolve routine. The default one I currently have usually work, but sometimes it might help changing them. fsolve has a help page in matlab.

1) This code is very primitive and cobbled together. I worked with it mostly by commenting in/out lines to get it to do what I want. Also, solving the Bethe Ansatz often requires manual intervention by stopping the simulation mid-run in Matlab and adding/removing some lines.

2) This code uses a non-linear equation solver to solve the Lieb-Wu equations. The equations are in the file "rBeqns.m". That file contains two versions of the equations, which differ by a factor of U/U (multiplying both parts of the quotient by U). One is better for very large values of U, the other (default) for small/intermediate values.

3) I used it for negative values of U exclusively. This regime is very tricky, because the Bethe-roots do things like meeting each other on the real axis, then splitting into a complex-conjugate pair. This often requires manual intervention by adding an imaginary seed (not too big, not too small) at the right step. I did a few tests with positive U and everything seems to be real and handle much easier, but then I don't know what you are trying to do with it. You may run into problems I didn't encounter. I also didn't do much with imbalanced systems.

4) The non-linear solver needs as input an initial guess. I found that to get a trustworthy result, the initial guess must be very close to the result. Instead of calculating the energy directly for a non-zero value of U, this code starts close to zero with the non-interacting solution, then increases U stepwise, using the result of the last step as the initial guess for the next and so on. For large U values, this can take a lot of time, the larger your targeted U is, the smaller the steps need to be. It can also work to start from a very large value of U with an asymptotic solutions and decrease it. If you need large values, the Bethe-Ansatz actually simplifies a lot and I also have a different code for this case.

5) Currently I can only run Matlab in the console, but the code was written with the graphical interface in mind. With the graphical interface, you get a plot with the complex plane where you can watch the roots move around. The results (U, E(U)) are also written into a table called "ls" from where they can be c&p'ed out.

6) At each step it outputs the momenta and spin-rapidities, as well as momentum and energy. Typical signs that the solver "lost" the solution are:
	* Rapidities get non-zero imaginary parts (I don't know if there are cases where this is actually possible)
	* Rapiditites or momenta suddenly get very large (from O(1) to O(10^6) or similar.
	* Momenta are no longer either real or in complex-conjugate pairs.
	* Total momentum jumps/becomes complex.
	* The solver takes very long for a single step or gets stuck. Abort the script then.
	
	In this case, you have to reduce the step-size dU and try again.
	
	If the output annoys you, add a ";" behind the line to stop the output or comment it out.
	
7) Any questions please send to uebling97@gmail.com
