clear; clc; clf;

m = 100;
g = 9.81;
rho = 1.292;
CzA = 1;
CxA = 1;
Jw = 1;
Jm = 1;
Rw = 0.15;
f = 1; % rolling resistance
tau = 1; % wm / ww
RPM = 30/pi * 120;

Nv = 10; % velocity steps
Nell = 25; % number of ellipse points

meq = m + 4*(Jw/(Rw^2)) + 4*(Jm*tau^2/(Rw^2));

Fza = @(V) m*g + 0.5*rho*CzA*(V.^2);
Fxa = @(V) m*g + 0.5*rho*CxA*(V.^2);

FRR = @(F) f*F; %% rolling resistance

Vmax = RPM*pi*Rw / (tau*30);
Vn = linspace(0,Vmax,Nv);

V_muxp_muyp = zeros(Nv,3);
V_muxp_muyp(:,1) = Vn;

% this section handles the friction of the tires, should be replaced with
% magic formula I think
% mu x nom, mu y nom, @ a certain Fz
muxnom = 1.0;
muynom = 1.0;

% slopes of mu x and y curves as a function of the vertical force
LSx = 0.01;
LSy = 0.01;

% find mu x peak and mu y peak for all values of V
V_muxp_muyp(:,2) = muxnom + LSx*Fza(V_muxp_muyp(:,1));
V_muxp_muyp(:,3) = muynom + LSy*Fza(V_muxp_muyp(:,1));

%TODO GGV forward and GGV backward
GGV = zeros(Nv*Nell*4,3); %V, Ax, Ay
GGVf = zeros(Nv*Nell*2,3);
GGVr = zeros(Nv*Nell*2,3);

for i = 1:Nv
    Vcur = V_muxp_muyp(i,1);
    muxp = V_muxp_muyp(i,2);
    muyp = V_muxp_muyp(i,3);

    % friction coefficients in the first quadrant
    muy = linspace(0,muyp,Nell);
    mux = sqrt((1-((muy).^2/(muyp)^2)) * (muxp)^2); % ellipse equation

    % forces and equations
    Axf = zeros(1,Nell*2);
    Ayf = zeros(1,Nell*2);
    Axr = zeros(1,Nell*2);
    Ayr = zeros(1,Nell*2);

    AxQn = @(mux) (Fza(Vcur)*mux - Fxa(Vcur) - FRR(Fza(Vcur))) / meq;
    AyQn = @(muy) (Fza(Vcur)*muy) / m;

    % vectorizing all four quadrants
    Axf(1:Nell)          = AxQn( mux);
    Ayf(1:Nell)          = AyQn( muy);
    Axf((Nell+1):2*Nell) = AxQn( mux);
    Ayf((Nell+1):2*Nell) = AyQn(-muy);
    Axr(1:Nell)          = AxQn(-mux);
    Ayr(1:Nell)          = AyQn( muy);
    Axr((Nell+1):2*Nell) = AxQn(-mux);
    Ayr((Nell+1):2*Nell) = AyQn(-muy);

    % appending to GGV matrix for plotting
    GGV((4*Nell*(i-1)+1):4*Nell*i,1) = Vcur;
    GGV((4*Nell*(i-1)+1):4*Nell*i,2) = [Axf Axr];
    GGV((4*Nell*(i-1)+1):4*Nell*i,3) = [Ayf Ayr];

    GGVf((2*Nell*(i-1)+1):2*Nell*i,1) = Vcur;
    GGVf((2*Nell*(i-1)+1):2*Nell*i,2) = Axf;
    GGVf((2*Nell*(i-1)+1):2*Nell*i,3) = Ayf;

    GGVr((2*Nell*(i-1)+1):2*Nell*i,1) = Vcur;
    GGVr((2*Nell*(i-1)+1):2*Nell*i,2) = Axr;
    GGVr((2*Nell*(i-1)+1):2*Nell*i,3) = Ayr;
end

scatter3(GGVf(:,2),GGVf(:,3),GGVf(:,1),'bo'); hold on;
scatter3(GGVr(:,2),GGVr(:,3),GGVr(:,1),'ro');

%[Axmg,Aymg] = meshgrid(GGV(:,2),GGV(:,3));
%surf(Axmg,Aymg,GGV(:,1));
%scatter3(GGV(:,2),GGV(:,3),GGV(:,1),'ko');

xlabel("Ax [m/s^2]");
ylabel("Ay [m/s^2]");
zlabel("V [m/s]");
%daspect([1 1 1/1000]);