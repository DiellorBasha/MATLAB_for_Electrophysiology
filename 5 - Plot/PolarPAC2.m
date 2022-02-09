resolution = 360; 
h(4) = figure ('Name', 'PAC', 'units','normalized','outerposition',[0.2 0.2 0.8 0.8]);
clf

k=5;
subplot(3,2,1, polaraxes)
    polarplot(s(k).PAC.respiration.edges(1:resolution),s(k).PAC.respiration.mean, 'k.');
        title (s(k).channel+  " amplitude on respiration phase")
  subplot(3,2,2, polaraxes)
    polarplot(s(k).PAC.SO.edges(1:resolution),s(k).PAC.SO.mean, 'k.');
        title (s(k).channel+  " amplitude on SO phase")      
        
        
k=2;
subplot(3,2,3, polaraxes)
    polarplot(s(k).PAC.respiration.edges(1:resolution),s(k).PAC.respiration.mean, 'k.');
        title (s(k).channel+  " gamma on respiration phase")
  subplot(3,2,4, polaraxes)
    polarplot(s(k).PAC.SO.edges(1:resolution),s(k).PAC.SO.mean, 'k.');
        title (s(k).channel+  " gamma on SO phase")    
       
        
k=1;
subplot(3,2,5, polaraxes)
    polarplot(s(k).PAC.respiration.edges(1:resolution),s(k).PAC.respiration.mean, 'k.');
        title (s(k).channel+  " gamma on respiration phase")
  subplot(3,2,6, polaraxes)
    polarplot(s(k).PAC.SO.edges(1:resolution),s(k).PAC.SO.mean, 'k.');
        title (s(k).channel+  " gamma on SO phase")    
  
