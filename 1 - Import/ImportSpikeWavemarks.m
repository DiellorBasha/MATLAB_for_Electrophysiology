ReSpike1=z;
ReSpike1_index=d_code1.spt;
ReSpike1_index(:,2)=ReSpike1_index*Fs;
ReSpike1_index=round (ReSpike1_index(2:end,:));
ReSpike1(round(ReSpike1_index(:,2)))=1;
clear ReSpike1_index

ReSpike2=z;
ReSpike2_index=d_code2.spt;
ReSpike2_index(:,2)=ReSpike2_index*Fs;
ReSpike2_index=ReSpike2_index(2:end,:);
ReSpike2(round(ReSpike2_index(:,2)))=1;


ReSpike7=z;
ReSpike7_index=d_code7.spt;
ReSpike7_index(:,2)=ReSpike7_index*Fs;
ReSpike7_index=ReSpike7_index(2:end,:);
ReSpike7(round(ReSpike7_index(:,2)))=1;

%% 
time=[1:length(CA1)].';
plot (time(ReSpike1_index), ones(1,length(ReSpike1_index)),'o')
