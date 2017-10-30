function feat=getFeat2(A,pSize)

nProc=size(A,2)/2; %no of parallel processes
nSize=nProc^(1/3);
nodes=zeros(size(A,1)*nProc,5); %Variable to store x,y,z,t,value in the global co-ordinate
count=0;
for i=1:nProc
    % x-offset
    x_off=(mod(floor((i-1)/(nSize^0)),nSize)~=0)*pSize;
    % y-offset
    y_off=(mod(floor((i-1)/(nSize^1)),nSize)~=0)*pSize;
    % z-offset
    z_off=(mod(floor((i-1)/(nSize^2)),nSize)~=0)*pSize;
    
    for j=1:size(A,1)
        count=count+1;
        nodes(count,1)=mod(A(j,2*i-1),pSize)+x_off;
        nodes(count,2)=floor(mod(A(j,2*i-1),pSize^2)/pSize)+y_off;
        nodes(count,3)=floor(A(j,2*i-1)/pSize^2)+z_off;
        nodes(count,4)=floor((j-1)/pSize^3);
        nodes(count,5)=A(j,2*i);
    end
end
[~, order] = sort(nodes(:,4));
t_nodes=nodes;
nodes = t_nodes(order,:);
feat=[];
for i=1:size(nodes,1)
    if ( nodes(i,1)~=0 && nodes(i,2)~=0 && nodes(i,3)~=0 && nodes(i,1)~=pSize*nSize-1 && nodes(i,2)~=pSize*nSize-1 && nodes(i,3)~=pSize*nSize-1 && nodes(i,4)~=0)
        feat=[feat; [nodes(i,5), nodes(i-(pSize^2),5), nodes(i-pSize,5), nodes(i-1,5), nodes(i+1,5), nodes(i+(pSize),5), nodes(i+pSize^2,5),nodes(i-pSize^3,5) ]];
    end
end