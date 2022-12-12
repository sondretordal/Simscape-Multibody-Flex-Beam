
% Load FE data from example
if(~exist('beamLink','var'))
    sm_flex_fe_import_params
end
% sm_flex_fe_import_beam_configure_load(bdroot,'Tip Load');


% Parameters from Flexible Beam block in library
M = beamFE_3fr10m.M;                    % Mass matrix
K = beamFE_3fr10m.K;                    % Stiffness matrix
mass = beamLink.iner.mass;              % Mass (kg)
com = beamLink.iner.com;                % Center of mass [x,y,z] (m)
moi = beamLink.iner.moi;                % Moments of Inertia (kg*m^2)
poi = beamLink.iner.poi;                % Products of Inertia (kg*m^2)
tau = 1e-7;                             % Algebraic loop filter constant
dofIdxMap = beamFE_3fr10m.dofIdxMap;    % DOF idx map ??
H = beamFE_3fr10m.H;                    % C-B Transformation Matrix
sensedFeaDofs_UI = [];                  % C-B Transformation Matrix Indices for Logging

% Tunable
Nf = 3;                                 % Number of frames                               
rigidBodyFrame = 2;                     % Specify rigid body frame
ksi = 0.05;                             % Modal Damping Parameter

% Create DOF idx map
clear dofIdxMap
for i = 1:Nf
    dofIdxMap(i,:) = [1, 2, 3, 4, 5, 6] + (i - 1)*6;

end

dofIdxMap = reshape([1:Nf*6]', [Nf, 6]);

% Sensed FEA dofs
if(isempty(sensedFeaDofs_UI))
    sensedFeaDofs = 1;
else
    sensedFeaDofs = sensedFeaDofs_UI;
end

% Create deformation matrices
[M2, L2, K2, H2] = sm_flex_body_lib_fei_form_def_matrices( ...
    H, M, K, ksi, Nf, dofIdxMap, rigidBodyFrame, sensedFeaDofs);

% Create flexibility state-space model
sys = sm_flex_body_lib_fei_form_statespace(Nf, M2, L2, K2, H2);



