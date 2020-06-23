function out = rBeqns(k)

% the file specifying the eqns must return a vector of your eqns in the form LHS-RHS, such that is zero when the roots are plugged in for the unkowns. 

% I'm making the other variables in the eqns global, so that I only need to tell their values to the script that calls the solver, and it passes them here automatically. This is lazy coding, and one *can* have additional params as inputs, but meh. 
global N M L U %nj

% create a vector of zeros to fill up in for-loop (more RAM efficient)
out = zeros(N+M,1);

% go through and fill up with LHS-RHS. 'k' is the vector of rapidities to be solved for.

%for j=1:N
%    out(j) = L*k(j) - 2*pi*nj(j) + 2*sum(atan((k(j)-k)/c));
%end

%k are N+M rapidities: N quasi-momenta k, M lambdas


%I put two version of the equations here, the difference is a factor of U/U. In my experience one has to be careful when the numbers in the quotient become very large/small
for j=1:N
   Mprod=1.;
   for l=1:M
        Mprod=Mprod*(sin(k(j))-k(N+l)+1i*U/4.)/(sin(k(j))-k(N+l)-1i*U/4.);
  %      Mprod=Mprod*(sin(k(j))*1i/U-k(N+l)*1i/U-1/4)/(sin(k(j))*1i/U-k(N+l)*1i/U+1/4);
   end
   out(j) = exp(1i*k(j)*L) - Mprod;
end
for j=1:M
   Nprod=1.;
   for l=1:N
       Nprod=Nprod*(sin(k(l))-k(N+j)+1i*U/4.)/(sin(k(l))-k(N+j)-1i*U/4.);
%       Nprod=Nprod*(sin(k(l))*1i/U-k(N+j)*1i/U-1/4)/(sin(k(l))*1i/U-k(N+j)*1i/U+1/4);
   end
   Mprod=1.;
   for a=1:M
       Mprod=Mprod*(k(N+a)-k(N+j)+1i*U/2.)/(k(N+a)-k(N+j)-1i*U/2.);
%       Mprod=Mprod*(k(N+a)*1i/U-k(N+j)*1i/U-1/2)/(k(N+a)*1i/U-k(N+j)*1i/U+1/2);
   end
   out(N+j) = Nprod+Mprod;
end

%Below is for YG model
% for j=1:N
%     Mprod=1.;
%     for l=1:M
%          Mprod=Mprod*(k(j)-k(N+l)+1i*U)/(k(j)-k(N+l)-1i*U);
%     end
%     out(j) = exp(1i*asin(k(j))*L) - Mprod;
% end
% for j=1:M
%     Nprod=1.;
%     for l=1:N
%         Nprod=Nprod*(k(l)-k(N+j)+1i*U)/(k(l)-k(N+j)-1i*U);
%     end
%     Mprod=1.;
%     for a=1:M
%         Mprod=Mprod*(k(N+j)-k(N+a)+2*1i*U)/(k(N+j)-k(N+a)-2*1i*U);
%     end
%     out(N+j) = Nprod+Mprod;
% end
