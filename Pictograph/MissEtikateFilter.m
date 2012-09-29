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

- (void) filterForImage:(UIImage *)image andView:(GPUImageView *)view
{
    
    //    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
    //    filter1 = [[GPUImageGaussianBlurFilter alloc] init];
    //    filter2 = [[GPUImageSepiaFilter alloc] init];
    //
    //    [stillImageSource addTarget:filter1];
    //    [filter1 addTarget:filter2];
    //    [stillImageSource processImage];
    
    //return [filter2 imageFromCurrentlyProcessedOutput];
    sourcePicture = [[GPUImagePicture alloc] initWithImage:image smoothlyScaleOutput:YES];
    filter1 = [[GPUImageMissEtikateFilter alloc] init];
    
    // filter1 =  [[GPUImageFilter alloc] initWithVertexShaderFromString:kCustomFilterShaderString];
    // fragmentShaderFromString://[[GPUImageVignetteFilter alloc] init];
    
    GPUImageView *imageView = view;
    [filter1 forceProcessingAtSize:imageView.sizeInPixels]; // This is now needed to make the filter run at the smaller output size
    
    [sourcePicture addTarget:filter1];
    [filter1 addTarget:imageView];
    
    [sourcePicture processImage];
    
    
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
