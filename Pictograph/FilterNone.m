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
     processedImage = image;
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
