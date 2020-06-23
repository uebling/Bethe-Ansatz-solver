% clear screen, clear all variables from workspace, and close all figures.
clc; clear all; close all;

% define global params to be passed to eqns function, the lazy way.
global U N M L

ls=[ ; ];

% parameters: N = total electron number. M = number in minority spin component, L = length of Hubbard chain
N = 10; M = 5; L = 21;

%It's quite difficult to immediately find the solution for a particular value of U. I found it better to start with the non-interacting
%case, where the solution is known, and use a loop with stepwise increase of U, using the solution of the last step as initial guess for the next
U = -0.001; %Starting value of U
Utarget = -2.; %Target value of U
dU = -0.001; %Step size

%This is an array of length N I use to put a small imaginary seed into the solution, to help complex conjugate pairs split up.
imag = [1i,-1i,1i,-1i,1i,-1i,1i,-1i,1i,-1i];
epsilon = abs(U)*5;

% set some options for the5 solver (optional, can  be important depending on what your roots do & how easy it is to lock on to them/follow them)
options = optimset('MaxfunEvals',100000*N,'MaxIter',500000,'TolFun',1e-8,'TolX',1e-8);

%This is used as an initial guess for the solver. I(length N) are the momenta, J(length M) the rapidities
I = [-2,-2,-1,-1,0,0,1,1,2,2]; %For starting at weak interactions, the numbers basically are the momenta of a Fermi sea
%I = [-1,-1,-0.5,-0.5,0,0,0.5,0.5,1,1]; %For starting at strong interactions
J = [-2,-1,0,1,2];

%The initial guess, a vector of N+M elements which has all momenta and rapidities and contains the complex-conjugate seed
ks = horzcat(2.*pi*I/L+epsilon*imag/4, sin(2.*pi*J/L))
%Below without the imaginary seed. If you do the repulsive Hubbard model, you can probably use this?
%ks = horzcat(2.*pi*I/L, sin(2.*pi*J/L))

while abs(U) <= abs(Utarget) %Flip here, if you want to start in the strongly interacting regime
	guess = ks; %Use last result as initial guess%

	%The following lines can prevent the solver from getting stuck, but can easily break things
	%guess = guess+epsilon*horzcat(imag,zeros(1,M)); %put some complex conjugate seed there to help pairs split up
	%guess = guess+horzcat(zeros(1,N),1i*real(1i*ks(N+1:N+M))); %Force Lambdas to be real


% call the solver, giving it a handle to the eqn function, starting point, and options.
% guess is the input, ks the output (solution)
	ks = fsolve(@rBeqns,guess,options);

%Here, we calculate total momentum and energy
%If they get non-zero imaginary parts, something is wrong
	energy = 0;
	momentum = 0;
	kl = ks*L/(2*pi);

	fprintf('momenta')
	kl(1:N)
	fprintf('spin rapidities')
	kl(N+1:N+M)

	for j=1:N
		momentum = momentum + kl(j);
		energy = energy +real(2-2*cos(ks(j)));	
	end

% I think if you calculate the energy like above, you get comparable results to NECI, but there may offsets like below
%	energy = energy + U*(L-2*N)
%	energy = energy - 2*N

    fprintf('Interaction: ')
    U
    fprintf('Total momentum: ')
    momentum
    fprintf('Energy: ')
    energy

	
%This should make a table of all U,E-value pairs	
	ls(end+1,1)=U;
	ls(end,2)=energy;

%Below is a primitive way to generate a plot of the complex plane where you can follow the roots moving around
	hold on
	scatter(real(kl(1:N)),real(-1i*kl(1:N)))
	%scatter(real(sin(ks(1:N))),real(-1i*sin(ks(1:N))))
	%figure(1)
	%plot(U,real(kl(1:N)),'.')
	%hold off
	%hold on
	%figure(2)
	%plot(U,real(-1i*kl(1:N)),'.')
	%hold off
	%hold on
	%figure(3)
	%plot(U,real(kl(N+1:N+M)),'.')
	%scatter(real(kl(N+1:N+M)),real(-1i*kl(N+1:N+M)))
	hold off
	
	
%Increase U
	U=U+dU;
%Below is an experimental udpate procedure which decreases the step size over time and allows to reach larger U values faster	
%	U=U+dU*((epsilon+abs(Utarget)-abs(U))/abs(Utarget))
	
end
