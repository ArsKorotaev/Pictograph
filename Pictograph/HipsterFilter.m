//
//  HipsterFilter.m
//  Pictograph
//
//  Created by Арсений Коротаев on 24.09.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#import "HipsterFilter.h"
#import "GPUImage.h"
@implementation HipsterFilter
- (void) filterForCamer:(GPUImageStillCamera *)camera andView:(GPUImageView *)view
{
    
    [super filterForCamer:camera andView:view];
    
    [self processFilterInitialization];
    filter1 = [[GPUImageSoftEleganceFilter alloc] init];
    
    [filter1 prepareForImageCapture];
    //[filter2 prepareForImageCapture];
    
    [camera addTarget:filter1];
    [filter1 addTarget:view];
    
    //[filter2 addTarget:view];
    
    
}

- (void) filterForImage:(UIImage *)image andView:(UIImageView *)view
{
    
    pthread_mutex_lock(&mutex);
    [super filterForImage:image andView:view];
    
    if (processedImage == nil)
    {
        [self createProcessedImageForImage:image];
        [view setImage:processedImage];
    }
    pthread_mutex_unlock(&mutex);
}

-(void) createProcessedImageForImage:(UIImage *)image
{
    
    GPUImageSoftEleganceFilter *stillImageFilter2 = [[GPUImageSoftEleganceFilter alloc] init];
    processedImage = [stillImageFilter2 imageByFilteringImage:image];
}
-(void) processFilterInitialization
{
    filter1 = [[GPUImageGaussianBlurFilter alloc] init];
    // filter2 = [[GPUImageVignetteFilter alloc] init];
}

-(GPUImageFilter*) lastFilter
{
    return filter1;
}

-(void) removeFilter
{
    [super removeFilter];
    //  [filter2 removeAllTargets];
    [filter1 removeAllTargets];
    
    [filter1 deleteOutputTexture];
    // [filter2 deleteOutputTexture];
    
}

@end
