//
//  SepiaFilter.m
//  Pictograph
//
//  Created by Арсений Коротаев on 29.09.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#import "SepiaFilter.h"

@implementation SepiaFilter
- (void) filterForCamer:(GPUImageStillCamera *)camera andView:(GPUImageView *)view
{
    
    [super filterForCamer:camera andView:view];
    
    filter1 = [[GPUImageSepiaFilter alloc] init];
    [filter1 prepareForImageCapture];
    [camera addTarget:filter1];
    [filter1 addTarget:view];
    
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
    filter1 = [[GPUImageSepiaFilter alloc] init];

    
    
    GPUImageView *imageView = view;
    [filter1 forceProcessingAtSize:imageView.sizeInPixels]; // This is now needed to make the filter run at the smaller output size
    
    [sourcePicture addTarget:filter1];
    [filter1 addTarget:imageView];
    
    [sourcePicture processImage];

    
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
