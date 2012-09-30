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
- (void) filterForCamer:(GPUImageStillCamera *)camera andView:(GPUImageView *)view
{
    
    [super filterForCamer:camera andView:view];
    [camera addTarget:view];
    
}

-(void) filterForImage:(UIImage *)image andView:(UIImageView *)view
{
    processedImage = image;
    [super filterForImage:image andView:view];
//    sourcePicture = [[GPUImagePicture alloc] initWithImage:image smoothlyScaleOutput:YES];
//    [sourcePicture addTarget:view];
//    [sourcePicture processImage];
    
    
    
    
}

-(GPUImageFilter*) lastFilter
{
    return nil;
}
-(UIImage*) image
{
    return [sourcePicture imageFromCurrentlyProcessedOutput];
}
- (void) removeFilter
{
    [super removeFilter];
}

@end
