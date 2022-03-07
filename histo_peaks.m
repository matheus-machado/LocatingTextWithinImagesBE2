
%Fonction pour choisir les points de l'histogramme
%Output: it returns the coordinates of these peaks( the degree of gray )
%Input I :original  image, regs : potential regions
%flag: 1 or 0

function coord = histo_peaks(I,coord,histo_t)
    flag = [];    
    % we choose 15% as the threshold
    seuil = histo_t/100*256;           
    for reg = transpose(coord)         
        i1=reg(1);j1=reg(2);i2=reg(3);j2=reg(4);
        H = imhist(I(i1:i2,j1:j2));        
        [~,locs] = sort(H);
        
        if length(find(locs)) > 1 % eliminate those who have only one peak                   
            % choose the most important peaks 
            p1 = locs(end);
            p2 = locs(end-1);
            d = abs(p1-p2); 
            % eliminate those who don't satisfy the criteri
            % and who don't have enough pixels
            if d>seuil && H(p1) > 30   
                flag = [flag,1];  
%                 figure
%                 stem(H)
%                 xlim([0,300])
            else
                flag = [flag,0];
            end
        else
            flag = [flag,0];       
        end              
    end
     
    oldregs = coord;
    coord = [];
    ind = find(flag~=0);
    for i = ind
        coord = [coord;oldregs(i,:)];
    end
end
