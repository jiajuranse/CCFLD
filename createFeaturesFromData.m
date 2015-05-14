
function [allFeatures, numThemes, rgbs, labs] = createFeaturesFromData(data,maxFeatures)


allFeatures=[];
%featureNames=[];


if size(maxFeatures,1)==0
    numThemes=size(data,1);
else
    numThemes= min([maxFeatures size(data,1)]);
end


%x = evalin('base', 'x');
hueProbs = evalin('base', 'hueProbs');
%y=(0:360)./360;
%mapping  = spline(x,y);
mapping = evalin('base', 'mapping');



rgbs=zeros(numThemes,15);
labs=zeros(numThemes,15);
%add
hsvs = zeros(numThemes, 15);
chsvs = zeros(numThemes, 15);
%add
color=zeros(numThemes,15);
sortedCol=zeros(numThemes,15);

diff=zeros(numThemes,12);
sortedDiff=zeros(numThemes,12);

means=zeros(numThemes,3);
stddevs=zeros(numThemes,3);
medians=zeros(numThemes,3);
mins=zeros(numThemes,3);
maxs=zeros(numThemes,3);
maxMinDiff=zeros(numThemes,3);

plane=zeros(numThemes,7);


satValThresh=0.2;


%[hueFeatures]=getHueProbFeatures(rand(3,5),satValThresh,hueProbs);

hueProbFeatures=-99*ones(numThemes,25);
%
for i = 1:numThemes
    if size(data,3)==1
        rgb=data;
    else
    %Color features
        rgb = squeeze(data(i,:,:))';
    end
    numColors = sum(rgb(1,:)>=0);
    rgb = rgb(:,1:numColors);
    rgbs(i,1:(3*numColors))=rgb(:)';
    [hsv, lab, chsv] = getColorSpaces(rgb,mapping);
    labs(i,1:(3*numColors))=lab(:)';
    hsvs(i,1:(3*numColors))=hsv(:)';
    chsvs(i,1:(3*numColors))=chsv(:)';
end

%
for c=1:4
    if (c==1)
        name='chsv';
    elseif(c==2)
        name='lab';
    elseif(c==3)
        name='hsv';
    elseif(c==4)
        name='rgb';
    end
    
    for i=1:numThemes
       
        rgb = reshape(rgbs(i, :), [3, 5]);
        numColors = sum(rgb(1,:)>=0);
        lab = reshape(labs(i, :), [3, 5]);
        hsv = reshape(hsvs(i, :), [3, 5]);
        chsv = reshape(chsvs(i, :), [3, 5]);
        
        if strcmp(name,'chsv')
            col=chsv;
        elseif strcmp(name,'lab')
            col=lab;
        elseif strcmp(name,'hsv')
            col=hsv;
        elseif strcmp(name,'rgb')
            col=rgb;
        end
        
        color(i,1:(3*numColors))=col(:)';
  
        if strcmp(name,'hsv')
            hueProbFeatures(i,:)=getHueProbFeatures(hsv,satValThresh,hueProbs);
        end
        
        diffs=zeros(3,numColors-1);
        for j=2:numColors
            
            %if this is hsv, then do the correct wraparound diff if
            %saturated and light enough
            if strcmp(name,'hsv')
                minSatVal = min([hsv(2,j-1:j) hsv(3,j-1:j)]);
                if (minSatVal>=satValThresh)
                    pts = sort([col(1,j) col(1,j-1)]);
                    diffs(1,j-1)= min((pts(2)-pts(1)),(1-(pts(2)-pts(1))));
                end
            else
                diffs(1,j-1)=col(1,j)-col(1,j-1);
            end
           diffs(2,j-1)=col(2,j)-col(2,j-1);
           diffs(3,j-1)=col(3,j)-col(3,j-1);
        end

        diff(i,1:3*(numColors-1))=[diffs(1,:) diffs(2,:) diffs(3,:)];
        
        numDiffs=numColors-1;
        sortedDiff(i,1:numDiffs)=sort(diffs(1,:),'descend');
        sortedDiff(i,(numDiffs+1):2*numDiffs)=sort(diffs(2,:),'descend');
        sortedDiff(i,(2*numDiffs+1):3*numDiffs)=sort(diffs(3,:),'descend');

        tcol = col';
        means(i,:)=mean(tcol);
        stddevs(i,:)=std(tcol);
        medians(i,:)=median(tcol);
        mins(i,:)=min(tcol);
        maxs(i,:)=max(tcol);
        maxMinDiff(i,:)=maxs(i,:)-mins(i,:);
       
        %http://www.mathworks.com/products/statistics/demos.html?file=/products
        %/demos/shipping/stats/orthoregdemo.html
        [plane(i,1:3), plane(i,4:6) , ~, plane(i,7)] = getPlaneFeatures(col');

        %sort colors
        [~, sortIdx] = sort(col(3,:));
        col = col(:,sortIdx);
        sortedCol(i,1:(3*numColors))=col(:); 
        
    end 
    
    allFeatures.([name,'Col'])=color;
    allFeatures.([name,'SortedCol'])=sortedCol;
    
    allFeatures.([name,'Diff'])=diff;
    allFeatures.([name,'SortedDiff'])=sortedDiff;
   
    allFeatures.([name,'Mean'])=means;
    allFeatures.([name,'StdDev'])=stddevs;
    allFeatures.([name,'Median'])=medians;
    allFeatures.([name,'Max'])=maxs;
    allFeatures.([name,'Min'])=mins;
    allFeatures.([name,'MaxMinDiff'])=maxMinDiff;
    
    if strcmp(name,'hsv')==0
        allFeatures.([name,'Plane'])=plane;    
    else
        for i=1:size(hueProbFeatures,2)   
            hueProbFeatures((hueProbFeatures(:,i)==-99),i)=max(hueProbFeatures(:,i)) + 0.0001;
        end
        allFeatures.([name,'HueProb'])=hueProbFeatures; 
    end
    
end
