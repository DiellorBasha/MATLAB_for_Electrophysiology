




for k = 1:8
    [pks(k) locs(k)] = findpeaks (zscore2 (:,k), 'MinPeakDistance', 900);
end


[~,idx] = sort(pks);
B = zscore2(:,idx);



x = [1 62]; % x is time from -1 to 1 seconds
y = [1 62]; % y is # of spikes
clf
I = imagesc(x,y,b.')

for k = 1:62
    b (:,k) = im(k, 1)*im(:,2)
end
