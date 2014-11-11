%Plotting
clear Plottable;
BasalGlucoseLL=4;
BasalGlucoseUL=12;
BasalNumberOfIter=9;
BasalGlucoseSS=(BasalGlucoseUL-BasalGlucoseLL)/(BasalNumberOfIter-1);

FeedGlucoseLL=15;
FeedGlucoseUL=25;
FeedGlucoseNumberOfIter=11;
FeedGlucoseSS=(FeedGlucoseUL-FeedGlucoseLL)/(FeedGlucoseNumberOfIter-1);

GlucoseAdditionLL=1.5;
GlucoseAdditionUL=3;
GlucoseAdditionNumberOfIter=7;
GlucoseAdditionSS=(GlucoseAdditionUL-GlucoseAdditionLL)/(GlucoseAdditionNumberOfIter-1);

GlucoseThresholdLL = 2.0;
GlucoseThresholdUL = 4.0;
GlucoseThresholdNumberOfIter = 9;
GlucoseThresholdSS = (GlucoseThresholdUL - GlucoseThresholdLL)/(GlucoseThresholdNumberOfIter-1);



for iii=1:FeedGlucoseNumberOfIter
    for kkk=1:BasalNumberOfIter
        for lll=1:GlucoseAdditionNumberOfIter
            Plottable(kkk,lll,iii)=SG(kkk,iii,lll,1);
        end
    end
end
    
    for iiii=1:FeedGlucoseNumberOfIter
        figure
        x=linspace(BasalGlucoseLL,BasalGlucoseUL,BasalNumberOfIter);
        y=linspace(GlucoseAdditionLL,GlucoseAdditionUL,GlucoseAdditionNumberOfIter);
        [C,h] = contourf(y,x,Plottable(:,:,iiii))
        set(h,'ShowText','on','TextStep',get(h,'LevelStep')*1)
        title(FeedGlucoseLL+(iiii-1)*FeedGlucoseSS)
    end
