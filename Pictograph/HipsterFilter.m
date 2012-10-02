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
- (void) filterForCamer:(GPUImageStillCamera *)camera andView:(GPUImageView *)view bloorEnable:(BOOL)blur
{
    
    [super filterForCamer:camera andView:view bloorEnable:blur];
    
    [self processFilterInitialization];
    filter1 = [[GPUImageSoftEleganceFilter alloc] init];  
    [filter1 prepareForImageCapture];
    //[filter2 prepareForImageCapture];
    
    
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
    [super createProcessedImageForImage:image];
    GPUImageSoftEleganceFilter *stillImageFilter2 = [[GPUImageSoftEleganceFilter alloc] init];
    processedImage = [stillImageFilter2 imageByFilteringImage:image];
}
-(void) processFilterInitialization
{
    filter1 = [[GPUImageGaussianBlurFilter alloc] init];
    // filter2 = [[GPUImageVignetteFilter alloc] init];
}

//-(void) addBlur
//{
//    
//    if (!self.isBlurEnable)
//    {
//        self.isBlurEnable = YES;
//        blurEffect = [[GPUImageFastBlurFilter alloc] init];
//        [blurEffect prepareForImageCapture];
//        [cam removeAllTargets];
//        [filter1 deleteOutputTexture];
//    
//        [cam addTarget:blurEffect];
//        [blurEffect addTarget:filter1];
//    }
//    else
//    {
//        self.isBlurEnable = NO;
//        [cam removeAllTargets];
//       
//        [filter1 deleteOutputTexture];
//        [blurEffect removeAllTargets];
//        [blurEffect deleteOutputTexture];
//        [cam addTarget:filter1];
//        
//    }
//
//
//
//}
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
    
    [blurEffect removeAllTargets];
    [blurEffect deleteOutputTexture];
    // [filter2 deleteOutputTexture];
    
}

@end
