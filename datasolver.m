%datasolver.m

datasetdir = '/media/saurav/Local Disk/finaldatasetNYUv2';
homedir = '/media/saurav/Local Disk';
targetdir = '/media/saurav/Local Disk/Matdata1/';

%get the total number of folders to operate on..
folders = dir(fullfile(datasetdir));
folders = folders(~ismember({folders.name},{'.','..'}));

numfolders = size(folders,1);

totfiles = 0;

for i=1:numfolders
    disp(strcat('Currently working on',folders(i).name));
    
    %pass the folder location to get_synched_frames.m to get the
    %corresponding rgb and the depth file.
    foldername = folders(i).name;
    newdir = strcat(datasetdir,'/',foldername);
    framelist = get_synched_frames(newdir);
    
    numfiles = size(framelist,2);
    
    xtrain1 = zeros(numfiles,3,240,320);
    ytrain1 = zeros(numfiles,57,77);
    
    totfiles = totfiles + numfiles;
    
    for j=1:numfiles
        depthname = framelist(j).rawDepthFilename;
        rgbname = framelist(j).rawRgbFilename;

        imgDepth = imread(strcat(newdir,'/',depthname));
        rgb = imread(strcat(newdir,'/',rgbname));
        
        %first step is to go through the project_depth_map.m part..
        imgDepth = swapbytes(imgDepth);
        [depthout, rgbout] = project_depth_map(imgDepth, rgb);
        
        %second step is to go through the crop_image.m part..
        croprgb = crop_image(rgbout);
        cropdepth = crop_image(depthout);
        
        %third step is to apply the cross bilateral filter to fill in the
        %missing depth values...
        
        filldepth = fill_depth_cross_bf(croprgb,cropdepth);
        
        %fourth step is to adjust the data size as per the architecture...
        
        newxtrain1 = imresize(croprgb,[240 320]);
        newytrain1 = imresize(filldepth, [57 77]);
        
        revrgb = zeros(3,240,320);
        revrgb(1,:,:) = newxtrain1(:,:,1);
        revrgb(2,:,:) = newxtrain1(:,:,2);
        revrgb(3,:,:) = newxtrain1(:,:,3);
        
        %fifth step is to add the files to the mat files and save it...
        xtrain1(j,:,:,:) = revrgb;
        ytrain1(j,:,:) = newytrain1;
        
        
    
    end
    
    save(strcat(targetdir,'depth_',int2str(i),'.mat'),'ytrain1');
    save(strcat(targetdir,'image_',int2str(i),'.mat'),'xtrain1');
    
    
end