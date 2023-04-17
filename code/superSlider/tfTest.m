% the superSlider.m is credit to 
% Danielle Ripsman (2023). superSlider
% (https://www.mathworks.com/matlabcentral/fileexchange/43285-superslider),
% MATLAB Central File Exchange. Retrieved April 17, 2023.

% Author: Ruiqi Li
% Date: 18/04/2023
% Description: An interactive tool to test whether the given radius 
% satisfies the torsional test or not.


function tfTest(R, r)
% torsional failure test
% Create figure window and components

if nargin ~= 2
    R = 15; % initial value of the outer radius
    r = 5;  % initial value of the inner radius
end
    superSlider(gcf, 'numSlides', 2, 'stepSize', 0.1, 'position',[0.1 0.1 0.6 0.1], 'callback',@myCallback);
    % comment this line if u wanna try the slider (bug not fixed yet)
    checkFeasibility(R, r);
end

function myCallback(hObject, eventData)
    clc;
    infoMatrix = get(hObject, 'UserData');
    r = infoMatrix(1,1)*20;
    R = infoMatrix(1,2)*20;
    checkFeasibility(R,r)
end

function checkFeasibility(R,r)
    assert(R>r); % the outer radius has to be larger than the inner radius
    R = R*0.001;
    r = r*0.001;
    area = pi*(R^2-r^2); % area in m^2

    clc;
    disp(['R = ', num2str(R*1000), 'mm, r = ', num2str(r*1000), 'mm, area = ', num2str(area*10^6), 'mm^2'])
    D = 2*R;
    d = 2*r;
    J = pi/32*(D^4-d^4);
    tau_max = 207*10^6; % max shear strength for the 6000 series Aluminium alloy, 207Mpa
    T = 3.5*9.8*0.85; % 3.5 kg at 0.85 m away from the pivot point, g = 9.8
    tau = T/J*R;
    if tau >= tau_max
        disp([tau, tau_max])
        disp([num2str(tau/10^6), 'MPa > 207MPa'])
        disp("Torsional Failure")
    else
        disp([num2str(tau/10^6), 'MPa < 207MPa'])
        disp('Design is safe')
    end
end
