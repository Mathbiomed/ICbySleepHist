function dydt = nonphotic(t,y,I,It,tau_c)

I_temp = interp1(It, I, t);

% St. Hilaire Model 2007
x = y(1);
xc = y(2);
n = y(3);

I0 = 9500;
p = 0.5;
alpha0 = 0.1;
alpha = alpha0*((I_temp/I0)^p)*(I_temp/(I_temp+100));

G = 37;
Bh = G*alpha*(1-n);
B = Bh*(1-0.4*x)*(1-0.4*xc);

beta = 0.007;
dydt(3) = 60*(alpha*(1-n) - beta*n);

if I_temp == 0
    sigma = 0;
else
    sigma = 1;
end

tx = tau_c;
k = .55;
mu = .1300;
q = 1/3;
rho = 0.032;

Nsh = rho*(1/3 - sigma);
Ns = Nsh*(1 - tanh(10*x));

dydt(1) = pi/12* (xc + mu*(1/3*x+4/3*x^3-256/105*x^7) + B + Ns);
dydt(2) = pi/12* (q*B*xc - x*((24/(0.99729*tx))^2 + k*B));

dydt = dydt';
end