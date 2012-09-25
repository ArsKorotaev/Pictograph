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
    
}

- (UIImage*) filterForImage:(UIImage *)image
{
    return nil;
}
@end
