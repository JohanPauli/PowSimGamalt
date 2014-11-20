fid=fopen('data/62-0-35N6-46-17w.tsv');
Data=textscan(fid,'%*s%*s%f%*s%*f%*f%f%f%f%*[^\n]','Headerlines',15);
fclose(fid);

Dates=datevec(Data{1});

Light=[Data{1} Data{2} Data{3} Data{4}];
Light(Light(:,2)<0,2:4)=nan;
Light96Tors=Light(Dates(:,1)==96,:);
Light97Tors=Light(Dates(:,1)==97,:);
Light98Tors=Light(Dates(:,1)==98,:);
Light99Tors=Light(Dates(:,1)==99,:);
Light2000Tors=Light(Dates(:,1)==100,:);

x96=Light96Tors(:,1)-Light96Tors(1,1);
x97=Light97Tors(:,1)-Light97Tors(1,1);
x98=Light98Tors(:,1)-Light98Tors(1,1);
x99=Light99Tors(:,1)-Light99Tors(1,1);
x2000=Light2000Tors(:,1)-Light2000Tors(1,1);

plot(x96,Light96Tors(:,2),'r',x97,Light97Tors(:,2),'g',...
    x98,Light98Tors(:,2),'b',x99,Light99Tors(:,2),'k',x2000,Light2000Tors(:,2),'m');
title('irradiance 1996-2000 in Torshavn')
ylabel('w/m2')
legend('1996','1997','1998','1999','2000')