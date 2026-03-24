function dydt = kronauerJewett(t,y,I,It,tau_c)

I_temp = interp1(It, I, t);
% Higher-order model
x = y(1);
xc = y(2);
n = y(3);

I0 = 9500;
p = .6;
a0 = 0.16;

alpha = a0*(I_temp.^p/I0.^p);
tx = tau_c;
G = 19.875;
b = 0.013;
k = .55;

mu = .1300;
q = 1/3;
Bh = G*alpha*(1-n);
B = Bh*(1-0.4*x)*(1-0.4*xc);

dydt(1) = pi/12* (xc + mu*(1/3*x+4/3*x^3-256/105*x^7) + B);
dydt(2) = pi/12* (q*B*xc - x*((24/(0.99729*tx))^2 + k*B));
dydt(3) = 60*(alpha*(1-n) - b*n);

dydt = dydt';
end