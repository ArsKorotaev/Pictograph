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
    

    //filter1 = [[GPUImageGaussianBlurFilter alloc] init];
    filter1 = [[GPUImageFilter alloc] initWithFragmentShaderFromFile:@"HipsterFilterShader"];
    [filter1 prepareForImageCapture];
  //  [(GPUImageGaussianBlurFilter*)filter1 setBlurSize:0.16];
   // filter2 = [[GPUImageToneCurveFilter alloc] init];

    
   // GPUImagePicture *pict = [GPUImagePicture alloc] initWith
    
    //filter1 = [[GPUImageGaussianBlurFilter alloc] init];
    //[filter1 prepareForImageCapture];
    [camera addTarget:filter1];
    
    [filter1 addTarget:view];
    
    
}

+(UIImage*) filterForImage:(UIImage *)image
{
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
    GPUImageFilter *filter1 = [[GPUImageFilter alloc] initWithFragmentShaderFromFile:@"HipsterFilterShader"];
    
    [stillImageSource addTarget:filter1];
    [stillImageSource processImage];
    
    return [filter1 imageFromCurrentlyProcessedOutput];
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
