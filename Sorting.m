%Sorting 111114
%Sorting
%Sorting
clear SubTable
MeanGlycationMax=55;
MaxGlycationMax=55;
SpreadGlycationMax=100;
MeanNumberofGlucoseFeedsMax=10;
MaxNumberofGlucoseFeedsMax=10;
SpreadNumberofGlucoseFeedsMax=10;

SubTableRow=1
Row
for ii = 1:(Row-1)
    ii
    if (Table(ii,5)<=MeanGlycationMax)
        if (Table(ii,6)<=MaxGlycationMax)
            if (Table(ii,7)<=SpreadGlycationMax)
                if (Table(ii,8)<=MeanNumberofGlucoseFeedsMax)
                    if (Table(ii,9)<=MaxNumberofGlucoseFeedsMax)
                        if (Table (ii,10)<=SpreadNumberofGlucoseFeedsMax);
                            for jj=1:10
                               jj;
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
SubTable