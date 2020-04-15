clear;
close all;
clc;
get_map;

load('localization_data.mat');
writerObj = VideoWriter('CD.avi'); % Name it.
writerObj.FrameRate = 10; % How many frames per second.
open(writerObj);

%%
n=3;
alpha = cell(n,1);
for ii = 1:n
    alpha{ii} = 0.2*ones(30,1);
end
A = eye(30);
P = zeros(30);
Q = A;
R = 0.01*eye(2);
for ii = 1:1000
    x1(ii,:)= X1{ii}(1:2);
    x2(ii,:)= X2{ii}(1:2);
    x3(ii,:)= X3{ii}(1:2);
    if ii > 10
        P = A*P*A'+Q;
        z(:,1) = x1(ii,:)';
        z(:,2) = x2(ii,:)';
        z(:,3) = x3(ii,:)';
        H = [x1((ii-10):(ii-1),:);x2((ii-10):(ii-1),:);x3((ii-10):(ii-1),:)]';
        for jj = 1:n
            y(:,jj) = z(:,jj)-H*alpha{jj};
        end
        S = R+H*P*H';
        K = P*H'/S;
        for jj = 1:n
            alpha{jj} = alpha{jj}+K*y(:,jj);
        end
        
        P = (eye(30)-K*H)*P;
        Ht = H;
        for jj = 1:20
            for kk = 1:n
                Xp(:,jj,kk) = Ht*alpha{kk};
            end
            Ht_t = Ht;
            Ht = [Ht(:,2:10),Xp(:,jj,1)];
            for kk = 2:n
                Ht = [Ht,Ht_t(:,(10*(kk-1)+2):(10*kk)),Xp(:,jj,kk)];
            end
        end
        for kk = 1:n
           for mm = 1:n
              Hir(kk,mm) =  norm(alpha{kk}((10*(mm-1)+1):(10*mm)));
           end
        end
        Hir = (1-eye(n)).*Hir;
        [M,I] = max(Hir(:));
        [I_row, I_col] = ind2sub(size(Hir),I);
        if I_col == 2
            disp('2 is dom');
            plot(x2(ii,1),x2(ii,2),'g*','MarkerSize',20);
        end
        if  I_col == 3
            disp('3 is dom');
            plot(x3(ii,1),x3(ii,2),'m*','MarkerSize',20);
        end
        if  I_col == 1
            disp('1 is dom');
            plot(x1(ii,1),x1(ii,2),'r*','MarkerSize',20);
        end
        hold on;
        plot(x1((ii-10):ii,1),x1((ii-10):ii,2),'r.');
        
        
        plot(x2((ii-10):ii,1),x2((ii-10):ii,2),'g.');
        
        plot(x3((ii-10):ii,1),x3((ii-10):ii,2),'m.');
        for jj = 1:n
            plot(Xp(1,:,jj),Xp(2,:,jj),'b.');
        end
        scatter(obsticle_vector(:,1),obsticle_vector(:,2),'k.');
        hold off;
        xlim([-10.5 10.5]);
        ylim([-10.5 10.5]);
        pause(0.1)
        frame = getframe(gcf);       % Set up the movie.
        writeVideo(writerObj, frame);% Set up the movie.
    end
    
    
end
close(writerObj);
