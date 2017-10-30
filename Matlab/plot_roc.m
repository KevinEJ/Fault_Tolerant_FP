function plot_roc(p,n)
x=[];
for i=0:50*median(p)/size(p,1):100*median(p)
    x=[x; [sum((p<i))/size(p,1) sum((n<i))/size(n,1)]];
end
plot((x(:,2)), x(:,1))