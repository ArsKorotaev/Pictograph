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


-(id) init
{
    self = [super init];
    if (self) {
        
        pthread_mutex_init(&mutex, NULL);
    }
    
    return self;
}
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

-(void) filterForCamer:(GPUImageStillCamera*) camera andView:(GPUImageView*) view bloorEnable:(BOOL)blur
{
    self.isBlurEnable = blur;
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
    
    
    [blurEffect removeAllTargets];
    [blurEffect deleteOutputTexture];
    cam = nil;
    sourcePicture = nil;
}

- (void) createProcessedImageForImage:(UIImage *)image
{
    NSLog(@"Start processed: %@",NSStringFromClass([self class]));
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

-(void) addBlur
{
    
}

-(void) dealloc
{
    NSLog(@"Destroy filter: %@",NSStringFromClass([self class]));
    pthread_mutex_destroy(&mutex); 
}
@end
