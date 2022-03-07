
%masque 5

function I = masque5(I)
     [L,H] = size(I);
     for i=1:L-2
         for j=1:H-2
             if (sum(I(i:i+2,j:j+2),'all')==1 && I(i+1,j+1)==1)
                 I(i+1,j+1) = 0;
             end                      
         end
     end

end