//
//  FilterNone.m
//  Pictograph
//
//  Created by Арсений Коротаев on 24.09.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#import "FilterNone.h"
#import "GPUImage.h"
@implementation FilterNone
- (void) filterForCamer:(GPUImageStillCamera *)camera andView:(GPUImageView *)view bloorEnable:(BOOL)blur
{
    
    [super filterForCamer:camera andView:view bloorEnable:blur];
    
    if (!blur)
    {
        [camera addTarget:view];
    }
    else
    {
        blurEffect = [[GPUImageFastBlurFilter alloc] init];
        blurEffect.blurSize = 2;
        [blurEffect prepareForImageCapture];
        [camera addTarget:blurEffect];
        [blurEffect addTarget:view];
    }
    
    
}

-(void) filterForImage:(UIImage *)image andView:(UIImageView *)view
{
    pthread_mutex_lock(&mutex);
   
    [super filterForImage:image andView:view];
    if (processedImage == nil)
    {
        [self createProcessedImageForImage:image];
        [view setImage:processedImage];
    }
//    sourcePicture = [[GPUImagePicture alloc] initWithImage:image smoothlyScaleOutput:YES];
//    [sourcePicture addTarget:view];
//    [sourcePicture processImage];
    
    
     pthread_mutex_unlock(&mutex);
    
}

-(void) createProcessedImageForImage:(UIImage *)image
{
    [super createProcessedImageForImage:image];
     processedImage = image;
}

-(GPUImageFilter*) lastFilter
{
    return nil;
}

- (void) removeFilter
{
    [super removeFilter];
}

@end
