//
//  MissEtikateFilter.m
//  Pictograph
//
//  Created by Арсений Коротаев on 29.09.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#import "MissEtikateFilter.h"
#import "GPUImage.h"
@implementation MissEtikateFilter
- (void) filterForCamer:(GPUImageStillCamera *)camera andView:(GPUImageView *)view
{
    
    [super filterForCamer:camera andView:view];
    
    [self processFilterInitialization];
    filter1 = [[GPUImageMissEtikateFilter alloc] init];
    
    [filter1 prepareForImageCapture];
    //[filter2 prepareForImageCapture];
    
    [camera addTarget:filter1];
    [filter1 addTarget:view];
    
    //[filter2 addTarget:view];
    
    
}

- (void) filterForImage:(UIImage *)image andView:(UIImageView *)view
{
    [super filterForImage:image andView:view];
    
    if (processedImage == nil)
    {
        GPUImageMissEtikateFilter *stillImageFilter2 = [[GPUImageMissEtikateFilter alloc] init];
        processedImage = [stillImageFilter2 imageByFilteringImage:image];
        [view setImage:processedImage];
    }
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
