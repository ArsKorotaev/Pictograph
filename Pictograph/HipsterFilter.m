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
    filter2 = [[GPUImageFastBlurFilter alloc] init];
    
    [filter1 prepareForImageCapture];
    [filter2 prepareForImageCapture];
  //  [(GPUImageGaussianBlurFilter*)filter1 setBlurSize:0.16];
   // filter2 = [[GPUImageToneCurveFilter alloc] init];

    
   // GPUImagePicture *pict = [GPUImagePicture alloc] initWith
    
    //filter1 = [[GPUImageGaussianBlurFilter alloc] init];
    //[filter1 prepareForImageCapture];
    [camera addTarget:filter1];
    [filter1 addTarget:filter2];
    
    [filter2 addTarget:view];
    
    
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
    filter1 = [[GPUImageFilter alloc] initWithFragmentShaderFromFile:@"HipsterFilterShader"];
    filter2 = [[GPUImageFastBlurFilter alloc] init];
    
    
    GPUImageView *imageView = view;
    [filter1 forceProcessingAtSize:imageView.sizeInPixels]; // This is now needed to make the filter run at the smaller output size
    [filter2 forceProcessingAtSize:imageView.sizeInPixels];
    
    [sourcePicture addTarget:filter1];
    [filter1 addTarget:filter2];
    [filter2 addTarget:imageView];
    
    [sourcePicture processImage];
    
    
}

// -(UIImage*) filterForImage:(UIImage *)image
//{
//    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
//    GPUImageFilter *filter1 = [[GPUImageFilter alloc] initWithFragmentShaderFromFile:@"HipsterFilterShader"];
//    
//    [stillImageSource addTarget:filter1];
//    [stillImageSource processImage];
//    
//    return [filter1 imageFromCurrentlyProcessedOutput];
//}

-(GPUImageFilter*) lastFilter
{
    return filter2;
}

- (void) removeFilter
{
    [filter1 removeAllTargets];
    [filter2 removeAllTargets];
    
    [filter2 deleteOutputTexture];
    [filter1 deleteOutputTexture];
    [cam removeAllTargets];
}

@end
