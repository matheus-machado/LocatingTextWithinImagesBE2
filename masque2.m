% mask M2 de la partie 3.3

function I = masque2(I)
    [A,H] = size(I);
    for i=1:A-1
        for j = 1:H-2   % on va analiser les matrices de 2x3 en commençant par l'élément en haute et à gauche 
          if (I(i,j)==1 && I(i+1,j+2)==1) % si les coins en haute et gauche et en bas et droite sont 1s
              I(i,j:j+2) = 1; % on remplie la première rangée de 1s
              I(i+1,j:j+2) = 1; % on remplie la deuxième rangée de 1s
          elseif (I(i,j+2) == 1 && I(i+1,j) == 1) % si les coins en haute et droite et en bas et gauche sont 1s
               I(i,j:j+2) = 1; % on remplie la première rangée de 1s
               I(i+1,j:j+2) = 1; % on remplie la deuxième rangée de 1s
          end
        end
    end
end