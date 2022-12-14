clear variables
clc

% https://www.youtube.com/watch?v=K7lfyAldj5k

% Symbolic variables
q = sym('q', [4, 1], 'real');
syms x L A rho E I kd 'real'

% Form q = B*a
B = [
    1, 0, 0, 0;
    0, 1, 0, 0;
    1, L, L^2, L^3;
    0, 1, 2*L, 3*L^2
];

% Solve for a
a = inv(B)*q;

% Shape functions
eq = simplify(a(1) + a(2)*x + a(3)*x^2 + a(4)*x^3);

% Collect coeficcients of q
for i = 1:4
    phi(i,1) = diff(eq, q(i));
end

% phi_x
phi_x = diff(phi, x);

% Find analytical M matrix
M = rho*A*int(phi*phi', x, 0, L);

% Create matlab function from M
matlabFunction(M, 'File', '+beam/M', 'Vars', [rho, A, L]);

% Find stifness matrix analytically
K = E*I*int(phi_x*phi_x', x, 0, L);

% Create matlab function from K
matlabFunction(K, 'File', '+beam/K', 'Vars', [E, I, L]);

% Dampening matrix C 
% kd is the coefficient of viscous damping for thematerial
C = kd*A*int(phi*phi', x, 0, L);

% Create matlab function from C
matlabFunction(C, 'File', '+beam/C', 'Vars', [kd, A, L]);


