//
//  WarmFilter.m
//  Pictograph
//
//  Created by Арсений Коротаев on 24.09.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#import "WarmFilter.h"
#import "GPUImage.h"

@implementation WarmFilter

- (void) filterForCamer:(GPUImageStillCamera *)camera andView:(GPUImageView *)view
{
    
    [super filterForCamer:camera andView:view];
    
    filter1 = [[GPUImageGaussianBlurFilter alloc] init];
    filter2 = [[GPUImageSepiaFilter alloc] init];
    
    
    [filter1 prepareForImageCapture];
    [filter2 prepareForImageCapture];
    
    [camera addTarget:filter1];
    [filter1 addTarget:filter2];
    
    [filter2 addTarget:view];
    
  
}

- (UIImage*) filterForImage:(UIImage *)image
{
    
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
    filter1 = [[GPUImageGaussianBlurFilter alloc] init];
    filter2 = [[GPUImageSepiaFilter alloc] init];
    
    [stillImageSource addTarget:filter1];
    [filter1 addTarget:filter2];
    [stillImageSource processImage];
    
    return [filter2 imageFromCurrentlyProcessedOutput];
}

-(GPUImageFilter*) lastFilter
{
    return filter2;
}

-(void) removeFilter
{
    [filter2 removeAllTargets];
    [filter1 removeAllTargets];
    
    [filter1 deleteOutputTexture];
    [filter2 deleteOutputTexture];
    
    if (cam != nil)
    {
        [cam removeAllTargets];
    }
}
@end
