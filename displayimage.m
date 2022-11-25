function displayimage(x, image_size, figurenumber,plottitle);

figure(figurenumber);
x = reshape(x,image_size);
imagesc(1*uint8(abs(x)));
%imagesc(5*uint8(abs(x)));
title(plottitle);
