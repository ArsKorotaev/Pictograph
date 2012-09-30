//
//  SepiaFilter.m
//  Pictograph
//
//  Created by Арсений Коротаев on 29.09.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#import "SepiaFilter.h"

@implementation SepiaFilter
- (void) filterForCamer:(GPUImageStillCamera *)camera andView:(GPUImageView *)view bloorEnable:(BOOL)blur
{
    
    [super filterForCamer:camera andView:view bloorEnable:blur];
    
    filter1 = [[GPUImageSepiaFilter alloc] init];
    [filter1 prepareForImageCapture];
    if (!blur)
    {
        [camera addTarget:filter1];
    }
    else
    {
        blurEffect = [[GPUImageFastBlurFilter alloc] init];
        blurEffect.blurSize = 2;
        [blurEffect prepareForImageCapture];
        [camera addTarget:blurEffect];
        [blurEffect addTarget:filter1];
    }
    [filter1 addTarget:view];
    
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
    GPUImageSepiaFilter *stillImageFilter2 = [[GPUImageSepiaFilter alloc] init];
    processedImage = [stillImageFilter2 imageByFilteringImage:image];

}
-(GPUImageFilter*) lastFilter
{
    return filter1;
}

- (void) removeFilter
{
    [filter1 removeAllTargets];
    
    [filter1 deleteOutputTexture];
    [cam removeAllTargets];
}

@end
