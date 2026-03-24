function dVdt = simpler(t,V,I,It,tau_c)

I_temp = interp1(It, I, t);

kappa = (12 / pi); i_0 = 9500; p = 0.6; %gamma = 0.23;                        % Circadian parameter
k = 0.55; beta = 0.013; f = 0.99669; alpha_0 = 0.16; b = 0.4;
mu = 0.23;
G = 19.9;
lambda = 60;

x=V(1);
y=V(2);
n=V(3);

alpha = alpha_0*(I_temp/i_0)^p;
B = G*alpha*(1-n)*(1-b*x)*(1-b*y);

%higher-order circadian model
dxdt = (1 / kappa) * ( y + B);
dydt = (1 / kappa) * ( mu*(y-(4*y^3)/3) - x*( (24 / (f * tau_c))^2+ k*B ) );
dndt = lambda * ( alpha*(1-n) - beta*n );

% create vector of length 3x1
dVdt = zeros(3,1);

% assign elements to the model which are the differential equations in the
% model
dVdt(1) = dxdt;
dVdt(2) = dydt;
dVdt(3) = dndt;

end