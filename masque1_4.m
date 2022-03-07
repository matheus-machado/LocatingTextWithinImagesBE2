
% masque 1 de la partie 3.3

function I = masque1(I)
    f = size(I,1);
    for i = 1:f
        A = find(I(i,:)); %on utilise la fonction find pour trouver les nonzero
        if length(A) >= 2 %si on a plus d'un pixel différent de 0
            gauche = min(A); %border pixel de gauche
            droite = max(A); %border pixel de droite
            if droite-gauche > 0.75 * f  %M4 -> negative form elimination
                I(i,gauche:droite) = 0;
            else
                I(i,gauche:droite) = 1; %on construit la ligne de 1s
            end                                              
        end
    end
end