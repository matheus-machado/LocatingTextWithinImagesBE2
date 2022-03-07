
% masque M3 de la partie 3.3

function I = mask3(I)
    [L,H] = size(I);
    for i=1:L-1
        for j = 1:H-1
          if (I(i,j)==1 && I(i+1,j+1)==1 && (I(i,j+1) == 0 || I(i+1,j) ==0) )
              I(i,j+1) = 1;
              I(i+1,j) = 1;
          elseif (I(i,j+1) == 1 && I(i+1,j) == 1 && (I(i,j)==0 || I(i+1,j+1)==0))
                  I(i,j)=1;
                  I(i+1,j+1)=1;
          end
        end
    end
end