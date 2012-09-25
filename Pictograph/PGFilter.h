//
//  PGFilter.h
//  Pictograph
//
//  Created by Арсений Коротаев on 24.09.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GPUImageStillCamera;
@class GPUImageView;
@class GPUImageFilter;

@interface PGFilter : NSObject
{
    GPUImageStillCamera *cam;
    GPUImageView *imgView;
}
@property (readonly) GPUImageFilter *lastFilter;
-(void) filterForCamer:(GPUImageStillCamera*) camera andView:(GPUImageView*) view;
-(void) removeFilter;
- (UIImage*) filterForImage:(UIImage*) image;
@end
