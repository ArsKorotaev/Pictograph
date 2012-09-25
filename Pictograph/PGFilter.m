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

- (void) filterForImage:(UIImage *)image andView:(GPUImageView *)view
{
    imgView = view;
}
@end
