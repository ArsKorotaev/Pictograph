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

-(UIImage*) filterForImage:(UIImage *)image
{
    return image;
}

-(GPUImageFilter*) lastFilter
{
    return nil;
}
- (void) removeFilter
{
    if (cam != nil)
    {
        [cam removeAllTargets];
    }
}

@end
