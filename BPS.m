
% Background Pixel Separation

function I = BPS(I,lim)
    [A,B] = size(I);
    Nb = 0; %nombre de pixels qui sera le 2% le plus lumineux du total
    u = 255; %va se reduire jusqu'à la valeur du pixel 98% plus lumineux
    while Nb <= lim/100*A*B    
        Nb = Nb + length(find(I==u));
        u = u - 1;
    end
    L = 255;
    for i = 1:A %nous allons parcourir l'image pixel par pixel
        for j = 1:B
            if I(i,j)>u         % on transforme en 255 tous les pixels 
                I(i,j) = L;     % de niveau de gris supérieur à u
            end
        end
    end
end