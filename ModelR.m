
function [MeanGlycation MaxGlycation SpreadGlycation MeanNumberofGlucoseFeeds MaxNumberofGlucoseFeeds]=ModelR(x);
% 
% x(1) : BasalGlucose, g/L
% X(2) : FeedGlucose in first feed, g/L
% x(3) : FeedGlucose in second feed, g/L
% x(4) : GlucoseAddition, g/L
% x(5) : GlucoseThreshold, g/L
% X(6) : Numberofsamples total


% a<t<b
a=0; %lower limit of time
b=14; %upper limit
%number of equations
m=4;%VCD,Glucose,unglycated,glycated
%intervals of integration
N=10000;
%initial conditions code should be modified for more equations
InitialWorkingVolume=1600;%units ml
InitialViableCellDensity=1.00e6;%units cells/ml
InitialGlucoseConcentration=x(1);%units mg/mL
InitialProteinConcentration=0.038e-3;%mg/ml
alp(1) = InitialWorkingVolume*InitialViableCellDensity;%Initial condition for biomass units total cells
alp(2) = InitialWorkingVolume*InitialGlucoseConcentration;%Initial condition for glucose units mg
alp(3) = InitialWorkingVolume*InitialProteinConcentration;%Initial cond. for protein
alp(4) = 0.0*InitialWorkingVolume*InitialProteinConcentration;%glycated prot
alp(5) = InitialWorkingVolume;%Initial condition for working volume

FeedGlucoseConcentration(1)=x(2);%units mg/mL
FeedGlucoseConcentration(2)=x(3);%units mg/mL
FeedGlucoseConcentration(3)=0;%units mg/mL
FeedPercent(1)=15;%percent of initial working volume
FeedPercent(2)=15;%percent of initial working volume
FeedPercent(3)=0;%percent of initial working volume
GlucoseThreshold=x(5);%mg/ml below which glucose will be added
GlucoseAddition=x(4);%mg/ml glucose added if below threshold
NumberOfSamples=x(6);%
SampleVolume=30;%units ml
%NumberofSamplesperDay=1;



for sts=1:6
    %sts
    NumberofGlucoseFeeds(sts)=0; % This is meant to take care of number of glucose feeds
    %Introduce randomness in growth rate and substrate uptake
    %murand=1+0.1*randn;
    %murand=0.7+(0.3/5)*(sts-1);
    murand=0.8;
    %murand=x(7);
    %murand=1+0.1*randn;
    %samplerand=1+0.0*randn;
    %the std dev is set at 0.1666...which means 2SD is 0.32 which is roughly 8
    %hours
    qsrand=1+0.0*randn;
    
    for xy=1:NumberOfSamples
        %SampleTime(xy)=xy-1*samplerand*(1/NumberofSamplesperDay);
        IntervalBetweenSamples=14/NumberOfSamples;
        SampleTime(xy)=xy*IntervalBetweenSamples;
        
        FeedTime(xy)=0;%
        sampletest(xy)=0;%test for sampling changes to avoid duplication
    end
    
    FeedTime(1)=SampleTime(3/IntervalBetweenSamples);
    FeedTime(2)=SampleTime(6/IntervalBetweenSamples);
    FeedTime(3)=SampleTime(9/IntervalBetweenSamples);
    %written for just two equations m=2.  Think of asking input from user
    
    %STEP1
    h=(b-a)/N;
    t=a;
    
    
    for j=1:m+1
        w(j)=alp(j);
    end
    
    %STEP3
    Output(1,1)=t;
    %Output(1,4)=InitialWorkingVolume;%this is tracking working volume. Output(1,m+2) where m is number of equations
    for j=1:m+1
        Output(1,j+1)=w(j);
        
    end
    
    %STEP4
    for i=1:N
        
        %STEP5 code should be modified for more equations
        calla=VCDGlucoseProteinGlycationTest(t,w(1),w(2),w(3),w(4),murand,qsrand);%more terms inside brackets for more eqns
        for j=1:m
            
            k(1,j)=h*calla(j);
        end
        
        %STEP6 code should be modified for more equations
        callb=VCDGlucoseProteinGlycationTest(t+(h/2),w(1)+0.5*k(1,1),w(2)+0.5*k(1,2),w(3)+0.5*k(1,3),w(4)+0.5*k(1,4),murand,qsrand);%more terms inside brackets for more eqns
        for j = 1:m
            
            k(2,j)=h*callb(j);
        end
        
        %STEP7 code should be modified for more equations
        callc=VCDGlucoseProteinGlycationTest(t+(h/2),w(1)+0.5*k(2,1),w(2)+0.5*k(2,2),w(3)+0.5*k(2,3),w(4)+0.5*k(2,4),murand,qsrand);%more terms inside brackets for more eqns
        for j = 1:m
            
            k(3,j)=h*callc(j);
        end
        
        %STEP8code should be modified for more equations
       calld=VCDGlucoseProteinGlycationTest(t+(h/2),w(1)+0.5*k(3,1),w(2)+0.5*k(3,2),w(3)+0.5*k(3,3),w(4)+0.5*k(3,4),murand,qsrand);%more terms inside brackets for more eqns
       for j = 1:m
            
            k(4,j)=h*calld(j);
        end
        
        %STEP9
        for j =1:m
            w(j)=w(j)+(k(1,j)+2*k(2,j)+2*k(3,j)+k(4,j))/6;
        end
        
        %STEP10
        t= a + i*h;
        
        %STEP3
        Output(i+1,1)=t;
        for j=1:m+1
            Output(i+1,j+1)=w(j);
        end
        
        for xyz = 1:NumberOfSamples
            if (t>=SampleTime(xyz))&(sampletest(xyz)==0)
                
                for zx = 2:m
                    w(zx)=w(zx)-(SampleVolume/w(m+1))*w(zx);%cell, substrate, metabolite loss due to sampling
                end
                w(m+1)=w(m+1)-SampleVolume;%W.V loss due to sampling
                w(1)=w(1)-(SampleVolume/w(m+1))*w(1);%cells lost due to sampling
                %if (abs(t-firstfeedtime)>0.5)&(abs(t-secondfeedtime)>0.5)&(abs(t-thirdfeedtime)>0.5)
                if (SampleTime(xyz)==FeedTime(1))|(SampleTime(xyz)==FeedTime(2))|(SampleTime(xyz)==FeedTime(3))
                    
                    if (SampleTime(xyz)==FeedTime(1))
                        w(2)=w(2)+(InitialWorkingVolume)*(FeedPercent(1)/100)*(FeedGlucoseConcentration(1));
                        w(m+1)=w(m+1)+(FeedPercent(1)/100)*(InitialWorkingVolume);
                    end
                    if (SampleTime(xyz)==FeedTime(2))
                        w(2)=w(2)+(InitialWorkingVolume)*(FeedPercent(2)/100)*(FeedGlucoseConcentration(2));
                        w(m+1)=w(m+1)+(FeedPercent(2)/100)*(InitialWorkingVolume);
                    end
                    if (SampleTime(xyz)==FeedTime(3))
                        w(2)=w(2)+(InitialWorkingVolume)*(FeedPercent(3)/100)*(FeedGlucoseConcentration(3));
                        w(m+1)=w(m+1)+(FeedPercent(3)/100)*(InitialWorkingVolume);
                    end
                    if (FeedGlucoseConcentration(2)<15)
                        if ((w(2)/w(m+1))<=GlucoseThreshold)%this loop is for glucose addition
                            w(2)=w(2)+w(m+1)*GlucoseAddition;
                            NumberofGlucoseFeeds(sts)=NumberofGlucoseFeeds(sts)+1;
                        end
                    end
                    
                else
                    if ((w(2)/w(m+1))<=GlucoseThreshold)%this loop is for glucose addition
                        w(2)=w(2)+w(m+1)*GlucoseAddition;
                        NumberofGlucoseFeeds(sts)=NumberofGlucoseFeeds(sts)+1;
                    end
                end
                
                %end
                sampletest(xyz)=1;%"completed sampling"
            end
        end
        
        
        
        
        
    end
    
    %plot (Output(:,1),Output(:,4))
    %Post-processing
    for gh = 1:N
        Time(gh)=Output(gh,1);
        VCD(sts,gh)=Output(gh,2)/Output(gh,m+2);
        GlucoseConcentration(sts,gh)=Output(gh,3)/Output(gh,m+2);
        UGProteinConcentration(sts,gh)=Output(gh,4)/Output(gh,m+2);
        GProteinConcentration(sts,gh)=Output(gh,5)/Output(gh,m+2);
        ProteinConcentration(sts,gh)=(Output(gh,4)+Output(gh,5))/Output(gh,m+2);
        PercentGlycation(sts,gh)=(GProteinConcentration(sts,gh)/ProteinConcentration(sts,gh))*100;
        if (gh==N)
        FinalGlycation(sts)=PercentGlycation(sts,N);
        end
    end
    
end

MeanGlycation = mean(FinalGlycation);
ExpectedGlycation=FinalGlycation(5);
MaxGlycation = max(FinalGlycation);
SpreadGlycation = max(FinalGlycation)-min(FinalGlycation);
%StdGlycation = std(FinalGlycation);
MeanNumberofGlucoseFeeds = mean(NumberofGlucoseFeeds);
%StdNumberofGlucoseFeeds = std(NumberofGlucoseFeeds);
MaxNumberofGlucoseFeeds = max(NumberofGlucoseFeeds);
SpreadNumberofGlucoseFeeds = max(NumberofGlucoseFeeds)-min(NumberofGlucoseFeeds);


figure
subplot(1,3,1)
plot(Time,VCD)
subplot(1,3,2)
plot(Time,GlucoseConcentration)
subplot(1,3,3)
plot(Time,PercentGlycation)




