function dX = VCDGlucoseProteinGlycationTest(t,X,S,P,GP,murand,qsrand)
% RHS
%dX = zeros(2,1);
%qp = (15e-12);%units g/cell/day
%X0 = 1.500e9;%units cells

%mu = 1*(0.0082*t^2-0.1784*t+0.8133);%units day-1
%mu = murand*(1+0.0*randn)*(0.0092*t^2-0.1731*t+0.7418);%units day-1
%FOLLOWing if loop was used for modelling B6-100411-F81
% if (t<3.45)
%     mu=0.54;
% else
%     mu=-0.00136;
% end

%FOLLOWING is for B3D-041112-PR107 111
% mu = 1*(-0.0008*t^3+0.028*t^2-0.3186*t+1.0642);%units day-1

% %fOLLOWING is a if loop for B3D-041112-PR107 111 to better reprodue
% %the growth.  This works pretty good even for
%the 0713 experiment
% 
if (t<4.27)
    mu = murand*1*1.08*(-0.0161*t^3+0.1305*t^2-0.478*t+1.1059);%units day-1
else
    mu = 1*(0.0006*t-0.038);%units day-1
end


%qs = qsrand*(1+0.0*randn)*(0.0075*t^2-0.1331*t +0.6228)*(1/10^6);%units orinal mg/10^6cells/day after correction mg/cell/day
%following if loop is used for modelling B6-041112-F81
% if (t<4)
%     qs=(-0.1616*t+0.7265)*(1/10^6);
% else
%     qs=0.10*(1/10^6);
% end
%mu =-0.0002*t^4+0.007*t^3-0.0619*t^2+0.0828*t+0.5213;
%S0 = 13000;%units mg
%if (t=3) 

%FOLLOWing is for B3D-041112-PR107 111.  
% if (S>0)
% qs = 1.15*(-0.0013*t^3+0.0323*t^2-0.2529*t+0.7304)*(1/10^6);%units orinal mg/10^6cells/day after correction mg/cell/day
% else
%     qs=0;
% end
%based on 0713 experiment
if (S>0)
qs = 1*(-0.0008*t^3+0.0195*t^2-0.1486*t+0.5049)*(1/10^6);%units orinal mg/10^6cells/day after correction mg/cell/day
else
    qs=0;
end
%following qp is for with hydrocortisone
%qp=40e-9;%mg/cell/day

%following qp is for without hydrocortisone

qp=1*39.4e-9;%mg/cell/day
if (t>12)
    if (murand>0.99)
    qp=0;
    end
end
Fs = 0;%

%  kg=0.000007;%glycation constant
% 

    kg=0.000007;


%end
%alp = 0.1;
dX(1) = mu*X;%cells
dX(2) = Fs- qs*X;%substrate
dX(3) = qp*X-kg*S*P;%unglycated protein
dX(4) = kg*S*P;%glycated protein
%dX(3) = qp*X(1) - alp*X(2)*X(3);%product
%dX(4) = alp*X(2)*X(3);