% primary: https://www.cs.technion.ac.il/~ron/PAPERS/retinex_ijcv2003.pdf
% chapter 3, https://onlinelibrary-wiley-com.ezproxy.library.wisc.edu/doi/pdfdirect/10.1002/9781119407416
% https://arxiv.org/pdf/1906.06690.pdf,

function [lightingImg,albedoImg] = retinexExtract(img, alpha, beta)
%RETINEXEXTRACT Estimate lighting and albedo data given one grayscale image.
%   Follows algorithm from primary citation.
%   Uses settings from that paper (p = 4, K_i ~ i).
img = log(im2double(img)+eps);
p = 4;
if numel(img) < 10000000 % algorithm converges quickly - do not use unnecessary iterations if expensive
    K = [10 20 30 40];
else
    K = [2 4 6 8];
end
pyramid = cell(p,1);
pyramid{1} = img;
for i=2:p
    f = [pyramid{i-1}(1,1) pyramid{i-1}(1,:) pyramid{i-1}(1,size(pyramid{i-1},2)); 
         pyramid{i-1}(:,1) pyramid{i-1} pyramid{i-1}(:,size(pyramid{i-1},2));
         pyramid{i-1}(size(pyramid{i-1},1),1) pyramid{i-1}(size(pyramid{i-1},1),:) pyramid{i-1}(size(pyramid{i-1},1),size(pyramid{i-1},2))];
    f = imfilter(f,[.0625 .125 .0625; .125 .25 .125; .0625 .125 .0625]);
    f = f(2:size(f,1)-1,2:size(f,2)-1);
    pyramid{i} = f(1:2:size(f,1),1:2:size(f,2));
    %figure; imshow(exp(pyramid{i}));
end
    L = zeros(size(pyramid{p})) + max(pyramid{p}(:));
    %L = pyramid{p};
    %imshow(exp(L));
for k=p:-1:1
    g_b = laplacian(pyramid{k})*2^(-2*(k-1));
    %g_b(1:10,1:10)
    for j=1:K(k)
        g_a = laplacian(L)*2^(-2*(k-1));
        g = -g_a + alpha*(L - pyramid{k}) - beta*(g_a - g_b); % typo in paper!
        g_sq = g .^ 2;
        mu_a = sum(g_sq(:));
        g_prod = g .* laplacian(g)*2^(-2*(k-1));
        mu_b = -sum(g_prod(:));
        mu = mu_a/(alpha*mu_a + (1+beta)*mu_b);
        L = L - mu*g;
        %figure; imshow(exp(L));
        L = max(cat(3,L,pyramid{k}),[],3);
%         for y=1:size(L,1)
%             for x=1:size(L,2)
%                 L(y,x) = max([L(y,x) pyramid{k}(y,x)]);
%                 %L(y,x) = min([1 L(y,x)]);
%             end
%         end
    end
    %figure; imshow(exp(L));
    %max(pyramid{k}(:))
    %max(L(:))
    %min(pyramid{k}(:))
    %min(L(:))
    if k>1
        L_new = zeros(size(pyramid{k-1}));
        %Lp = griddedInterpolant(L);
        for y=1:size(L_new,1)
            for x=1:size(L_new,2)
                L_new(y,x) = L(fix((y+1)*size(L,1)/size(L_new,1)),fix((x+1)*size(L,2)/size(L_new,2)));
                %L_new(y,x) = Lp((y+1)/2,(x+1)/2);
            end
        end
        %figure; imshow(L);
        L = L_new;
        %figure; imshow(L);
    end
end
lightingImg = exp(L);
%lightingImg = lightingImg / max(lightingImg(:));
albedoImg = exp(img-L);
%albedoImg = albedoImg / max(albedoImg(:));
end

function out_img = laplacian(img)
%Compute discrete Laplacian given that image is constant past boundaries.
su = cat(1, img, img(size(img,1),:));
su = su(2:size(su,1),:);
sd = cat(1, img(1,:), img);
sd = sd(1:size(sd,1)-1,:);
sl = cat(2, img, img(:,size(img,2)));
sl = sl(:,2:size(sl,2));
sr = cat(2, img(:,1), img);
sr = sr(:,1:size(sr,2)-1);
out_img = su + sd + sl + sr - 4*img;
end
