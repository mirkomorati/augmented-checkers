
axisLim=10000;
figure
hold on 
plot(1:axisLim);
p1=patch([10 10 500 500],[0 axisLim axisLim 0],[1 1 1 1],...
  'EdgeColor','r','FaceColor','r')
p2=patch([9000 9000 9010 9010],[0 axisLim axisLim 0],[1 1 1 1],...
  'FaceColor','r','EdgeColor','r')