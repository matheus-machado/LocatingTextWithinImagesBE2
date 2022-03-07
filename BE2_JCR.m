%%% BE 2: LOCATING TEXT WITHIN IMAGES
%Julio CABALLERO
%Matheus MACHADO 


%First step: you must run the code interface.m to acess the
%parameters and choose the desired image to be analyzed


clc
m = evalin('base','m') % resize 0.125
t = evalin('base','t'); % threshold 0.8

lim = evalin('base','lim'); % 2 POURCENTAGE limite du nombre total des pixels pour obtenir u
histo_t = evalin('base','histo_t'); % seuil 15 / threshold pour établir les piques de l'histogramme

only_finalfigure=evalin('base','only_finalfigure');

%%%%%%%%%%%%% Part 3 %%%%%%%%%%%%%%

%% 3.1. Digital image tranformation
image = evalin('base','image')
I = imread(image);
G = rgb2gray(I);
G_t = G';

figure()
subplot(1,3,1), imshow(I);
title("Image original")
subplot(1,3,2), imshow(G);
title("Image aux niveaux de gris")
subplot(1,3,3), imshow(G_t);
title("Image transposée en niveaux de gris")

%% 3.2. Enhancement of text region patterns

% m = 0.13;
% t = 0.7;
%%%%%%%%%%%%%%%%%%%%%%%% 
H = imresize(G,m,'nearest');
J = im2bw(H,t);


figure()
subplot(1,3,1), imshow(H);
title("Image binaire")
subplot(1,3,2), imshow(J);
title('Image multi-résolution m = 0.125')

%% 3.3. Potential text regions localization

% figure(3)
% count = 0;
% count_2 = sum(I,'all');
fprintf('On y va \n')
J2 = J;
flag = 1;
J2 = masque5(J2);
while (min(min(J==J2)) == 0 || flag == 1)
    flag = 0;
    J = J2;
    fprintf('On est passé pour la boucle \n')
    M1 = masque1_4(J); %masque 4 inclue dans la masque 1
    M1 = masque2(M1);
    M1 = masque3(M1);

%     count = count_2;
%     count_2 = sum(M1,'all');
    J2 = M1;
%     figure()
%     imshow(J2)
end
J = J2;
% subplot(1,3,1), imshow(M1);
% title("After mask 1")
% subplot(1,3,2), imshow(M2);
% title("After mask 2")
% subplot(1,3,3), imshow(M3);
% title("After mask 3")

subplot(1,3,3), imshow(J);
title('Image après appliquer les masques 1, 2, 3')

%% 3.4. Selection of effective text regions

% Background pixels separation

% lim = 15; % POURCENTAGE limite du nombre total des pixels pour obtenir u
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Gs = BPS(imresize(G,m,'nearest'),lim);

figure()
subplot(1,3,1), imshow(I), title('Image originale')
subplot(1,3,2), imshow(G), title('I en niveaux de gris')
subplot(1,3,3), imshow(Gs), title('BPS')

% Effective text region filtering

[f,c] = size(J);
bloc = ones(f,c); %matrice de la même taille que J pour la comparer
coord = [];     %coord sera une matrice nx4 avec les coordonnées d'une 
                %région blanche dans chaque file
for i = 1:f
    for j = 1:c
        if(J(i,j)==1 && bloc(i,j) == 1) %je cherche les 1s dans J
            i1 = i ;
            j1 = j ; %chaque fois que je trouve un 1 je stocke les coord de la région
            i2 = i ; %coord de la région : coord du coin à gauche haut(i1, j1) + coord du coin à droite bas (i2, j2)
            j2 = j ;
            while (i2+1 <= f && J(i2+1,j1) == 1)
                i2 = i2 + 1 ;
            end  

            while (j2+1<= c && J(i1,j2+1) == 1)
                j2 = j2 + 1 ;
            end
            coord = [coord ; [i1 j1 i2 j2]] ;
            % et on va effacer la ligne qu'on a déjà traité de notre
            % matrice bloc pour pas repeter la démarche
            bloc(i1:i2,j1:j2) = 0 ;

        elseif (J(i,j) == 0) && (bloc(i,j) == 1)
            bloc(i,j) = 0 ; %si on trouve un 0 dans J on met un 0 dans bloc
        end
    end
end


[f_2, c_2] = size(coord)

if f_2 == 0
    fprintf("Il n'y a pas de texte dans cette image")
    figure()
    imshow(I)
    title('No text found - Original Image')
else
%     histo_t = 50; % seuil / threshold pour établir les piques de l'histogramme
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% le plus petit le seuil, le plus de choses qu'il détecte comme text
    figure(4)
    nb_reg = f_2;
    subplot(2,round(nb_reg/2)+1,1), imshow(J)
    subplot(2,round(nb_reg/2)+1,2), imhist(Gs(coord(1,1):coord(1,3), coord(1,2):coord(1,4)))
    ylim auto
    if nb_reg > 1
        for i = 1:nb_reg-1
            subplot(2,round(nb_reg/2)+1,i+2), imhist(Gs(coord(i+1,1):coord(i+1,3), coord(i+1,2):coord(i+1,4)))
            ylim auto
        end
    end
    
    coord_check = [];
    for i = 1:f_2
        i1 = coord(i,1);
        j1 = coord(i,3);
        i2 = coord(i,2);
        j2 = coord(i,4);
        reg = Gs(i1:j1,i2:j2);
        [qty, loc] = imhist(reg);
    
        ord = sort(qty); %mettre en ordre tous les éléments de quantités
        P1 = find(qty==ord(length(qty)));    % prendre la quantité la plus grande
        P2 = find(qty==ord(length(qty)-1)); %et la deuxième plus grande
        dist = 260; % plus de 255 c'est bon
        for i = 1:length(P1)
            for j = 1:length(P2)
                dist_prov = abs(P1(i)-P2(j));
                if dist_prov < dist && dist_prov ~= 0
                    dist = dist_prov;
                end
            end
        end
        dist
        % on a déjà pris la distance la plus pétite, au cas où elle est répétée
        if dist > histo_t/100*255
             coord_check = [coord_check; i1 i2 j1 j2];
        end
    end
    aux = size(coord_check)

    if aux(1) == 0
        fprintf("Il n'y a pas de texte dans cette image (distance trop courte)") 
    else
        image_finale = I;   %on va dessiner les carrés blancs pour chaque région définitive
        
        
        for i = 1:aux(1)
            % on trouve les coordonnées pour la bonne taille de l'image originale
            i1 = round(coord_check(i,1));
            j1 = round(coord_check(i,2));
            i2 = round(coord_check(i,3));
            j2 = round(coord_check(i,4));
            [xi,xf,yi,yf] = coZone(J,i1,i2,j1,j2,G);
            % on dessine les lignes blanches du carré
            image_finale(xi,yi:yf,1:3) = 255;
            image_finale(xf,yi:yf,1:3) = 255;
            image_finale(xi:xf,yi,1:3) = 255;
            image_finale(xi:xf,yf,1:3) = 255;
        end
        
        if only_finalfigure == 1
            for i = 1:10
                close(figure(i))
            end
        end
        figure()
        imshow(image_finale)
    end
end
% 
%% Funções extras
%coord original
function [xi,xf,yi,yf] = coZone(I,xi,xf,yi,yf,Ireal)
    [r1,c1] = size(I);
    [r,c] = size(Ireal);
    factorY = c/c1;
    factorX = r/r1;
    if xf == xi && (xi-1)*factorX>0
        xi = floor((xi-1)*factorX);
    else
        xi = floor(xi*factorX);
    end
    xf = floor(r - (r1-xf)*factorX);
    yi = floor(yi*factorY);
    yf = floor(c - (c1-yf)*factorY);
    [xi,xf,yi,yf] =  textBoundaries(Ireal,xi,xf,yi,yf);
    
end
%Set the text horizontal and vertical boundaries as described in section
%3.5.1
function [xi,xf,yi,yf] =  textBoundaries(Ir,xi,xf,yi,yf)
    I = pixel_separation2(Ir,0.02);
    L =  max(max(I));
    maxCount = 0;
    start = xi;
    for i = xi:xf
        countL = sum(I(i,yi:yf) == L);
        if countL > maxCount
            start = i;
            maxCount = countL;
        end
    end
    
    %Up boundary
    if start ~= 1
    refLine = (I(start,:) == L);
    upBound = start - 1;
    upLine =  (I(upBound,:) == L);
    while sum(refLine(upLine == refLine)) > 0 && upBound > 1
        upBound = upBound -  1;  
        upLine =  (I(upBound,:) == L);
    end
    upBound = upBound ;
    else
        upBound = start;
    end
    
    %Bottom boundary
    if start ~= size(I,1)
    refLine = (I(start,:) == L);
    botBound = start + 1;
    botLine =  (I(botBound,:) == L);
    while sum(refLine(botLine == refLine)) > 0 && botBound < size(I,1) 
        botBound = botBound + 1;
        botLine =  (I(botBound,:) == L);
    end
    botBound = botBound;
    else
        botBound = start;
    end
    
    %Left boundary
    startCol = yi;
    leftBound = yi;
    for j = yi:-1:1
        if I(start,j) == L && abs(leftBound - j)<0.15*size(I,2)
            leftBound = j;
        end
    end
    if leftBound > 4
    leftBound = leftBound -4;
    end
    %Right boundary
    startCol = yf;
    rightBound = yf;
    for j = yf:size(I,2)
        if I(start,j) == L && abs(rightBound - j)<0.15*size(I,2)
            rightBound = j;
        end
    end
    if rightBound < size(I,2)-4
    rightBound = rightBound + 4;
    end
    xi = upBound;
    xf = botBound;
    if abs(yi - yf)/size(I,2) < 0.75
    yi = leftBound;
    yf = rightBound;
    end
    
end

function I = pixel_separation2(I,seuil)
    [count,shades] =  imhist(I);
    total = 0;
    threshold = 0;
    L = shades(size(shades,1));
    for i = size(shades):-1:1
        if total > sum(count)*seuil
            threshold = shades(i);
            break
        end
        total = total + count(i);        
    end
    I(I<=threshold) = threshold;
    I(I>threshold) = L;
    
end
