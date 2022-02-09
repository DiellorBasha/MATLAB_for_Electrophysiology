myPath = 'I:\2. Analysis\4. Amande';
MyFolderInfo = dir (myPath);

nfiles = 5
nfiles = 4:8;
clear Gammas
for k = nfiles
    f = fullfile (myPath,MyFolderInfo(k).name, 'GammaRespiration.txt' );%MyFolderInfo(k).name, 
%     f1 = fullfile (myPath,MyFolderInfo(k).name, 'GammaFR_NREM.txt' );   %MyFolderInfo(k).name,
%     f2 = fullfile (myPath, MyFolderInfo(k).name,'GammaFR_REM.txt' ); %MyFolderInfo(k).name, 
% 
Gammas{1,k}=ImportGammaRespirationText(f);
% Gammas{2,k-8}=importfile (f1);
% Gammas{3,k-8}=importfile (f2);

end
% 

GammasAll = Gammas;

GammaText{1,1}=ImportGammaRespirationText(f);

for k = [1,2,4]
averages = GammasAll{1,k};log = isnan(averages (:,1));
idx = find (log==1);

Gammas {1,k} = averages(1:idx(1),2);Gammas {1,1} = 'mPFC';
Gammas {2,k} = averages(idx(1)+1:idx(2),2);Gammas {2,1} = 'Reu';
Gammas {3,k} = averages(idx(2)+1:idx(3),2);Gammas {3,1} = 'Motor';
Gammas {4,k} = averages(idx(3)+1:idx(4),2);Gammas {4,1} = 'Somato';
Gammas {5,k} = averages(idx(4)+1:idx(5),2);Gammas {5,1} = 'Supra';
Gammas {6,k} = averages(idx(5):end,2);Gammas {6,1} = 'Marginal';

end



for j=2:4
for k = 1:6
    Gammas {k,j} = Gammas{k,j}(2:end-1);
end
end

MA={};

for k =1:length(m)
MA{k}=m(k).wcoh;
end;

B=cat(3,Gammas{:,2:4});
out=mean(B,3);
plot (out)

for k=2:4
mPFC (:,k) = Gammas{1,k};
Reu (:,k) = Gammas{2,k};
Motor (:,k) = Gammas{3,k};
Somato (:,k) = Gammas{4,k};
Supra (:,k) = Gammas{5,k};
Marginal (:,k) = Gammas{2,k};
end

clf
for k = 1:6
    subplot (211)
    plot (Gammas{1,2})
    legend (Gammas{1,1})
    subplot (212)
    plot (Gammas{k,2})
  
    hold on
end
legend(Gammas{2:end,1})
hold off