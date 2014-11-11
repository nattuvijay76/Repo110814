
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

Table = xlsread('Simulation Results.xlsx','Sheet1');

MeanGlycationMax=19;
MaxGlycationMax=23;
SpreadGlycationMax=20;
MeanNumberofGlucoseFeedsMax=5;
MaxNumberofGlucoseFeedsMax=5;
SpreadNumberofGlucoseFeedsMax=20;

SubTableRow=1;
for ii = 1:6237
    ii
    if (Table(ii,5)<=MeanGlycationMax)
        if (Table(ii,6)<=MaxGlycationMax)
            if (Table(ii,7)<=SpreadGlycationMax)
                if (Table(ii,8)<=MeanNumberofGlucoseFeedsMax)
                    if (Table(ii,9)<=MaxNumberofGlucoseFeedsMax)
                        if (Table (ii,10)<=SpreadNumberofGlucoseFeedsMax);
                            for jj=1:10
                               jj
                            SubTable(SubTableRow,jj)=Table(ii,jj);
                            
                            end
                            SubTableRow=SubTableRow+1;
                        end
                    end
                end
            end
        end
    end
end


Row=1
%BasalGlucose=BasalGlucoseLL;
for i=1:BasalNumberOfIter
    
    %FeedGlucose=FeedGlucoseLL;
    for j=1:FeedGlucoseNumberOfIter
        %GlucoseAddition=GlucoseAdditionLL;
        for k=1:GlucoseAdditionNumberOfIter;
            %GlucoseThreshold=GlucoseThresholdLL;
            for l = 1:GlucoseThresholdNumberOfIter;
%                 Table(Row,1)=BasalGlucose;
%                 Table(Row,2)=FeedGlucose;
%                 Table(Row,3)=GlucoseAddition;
%                 Table(Row,4)=GlucoseThreshold;
               % [MeanGlycation MaxGlycation SpreadGlycation MeanNumberofGlucoseFeeds MaxNumberofGlucoseFeeds SpreadNumberofGlucoseFeeds]= Model([BasalGlucose FeedGlucose FeedGlucose GlucoseAddition GlucoseThreshold 14]);
                MG(i,j,k,l)=Table(Row,5);    %MeanGlycation;
                MXG(i,j,k,l)=Table(Row,6);%MaxGlycation;
                SG(i,j,k,l)=Table(Row,7);%SpreadGlycation;
                MGF(i,j,k,l)=Table(Row,8);%MeanNumberofGlucoseFeeds;
                MXGF(i,j,k,l)=Table(Row,9);%MaxNumberofGlucoseFeeds;
                SGF(i,j,k,l)=Table(Row,10);%SpreadNumberofGlucoseFeeds;
%                 Table(Row,5)=MeanGlycation;
%                 Table(Row,6)=MaxGlycation;
%                 Table(Row,7)=SpreadGlycation;
%                 Table(Row,8)=MeanNumberofGlucoseFeeds;
%                 Table(Row,9)=MaxNumberofGlucoseFeeds;
%                 Table(Row,10)=SpreadNumberofGlucoseFeeds;
%                 GlucoseThreshold=GlucoseThreshold+GlucoseThresholdSS;
                Row=Row+1
            end
            %GlucoseAddition=GlucoseAddition+GlucoseAdditionSS;
        end
        %FeedGlucose=FeedGlucose+FeedGlucoseSS;
    end
    %BasalGlucose=BasalGlucose+BasalGlucoseSS;
    
end