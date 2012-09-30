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
@class GPUImagePicture;
@interface PGFilter : NSObject
{
    GPUImageStillCamera *cam;
    GPUImageView *imgView;
    GPUImagePicture* sourcePicture;
    
    NSArray *filterChain;
    
    UIImage *processedImage;
}
@property (readonly) GPUImageFilter *lastFilter;
@property BOOL isBlurEnable;
- (void) filterForCamer:(GPUImageStillCamera*) camera andView:(GPUImageView*) view;
- (void) removeFilter;
- (void) filterForImage:(UIImage*) image andView:(UIImageView*) view;
- (void) initializeFilterChain;
- (UIImage*) image;
- (UIImage *) processImage;
@end
