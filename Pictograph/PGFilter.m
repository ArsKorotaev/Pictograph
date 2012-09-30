//
//  PGFilter.m
//  Pictograph
//
//  Created by Арсений Коротаев on 24.09.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#import "PGFilter.h"
#import "GPUImage.h"
@implementation PGFilter

-(void) initializeFilterChain
{
    if (filterChain != nil)
    {
        for (int i = 0; i < [filterChain count]-1; i++)
        {
            GPUImageOutput *setter = [filterChain objectAtIndex:i];
            id<GPUImageInput> getter = [filterChain objectAtIndex:i+1];
            [setter addTarget:getter];
            
        }
    }
}

-(void) filterForCamer:(GPUImageStillCamera*) camera andView:(GPUImageView*) view
{
    cam = camera;
    imgView = view;
}

- (void) removeFilter
{
    if (cam!=nil)
    {
        [cam removeAllTargets];
    }
    if (sourcePicture != nil)
    {
        [sourcePicture removeAllTargets];
    }
    
    
    
    cam = nil;
    sourcePicture = nil;
}

-(UIImage*) processImage
{
    return nil;
}
-(UIImage*) image
{
    return processedImage;
}
- (void) filterForImage:(UIImage *)image andView:(UIImageView *)view
{
    //imgView = view;
    if (processedImage != nil)
    {
        [view setImage:processedImage];
    }
}
@end
