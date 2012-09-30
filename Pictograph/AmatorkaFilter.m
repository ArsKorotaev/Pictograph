//
//  WarmFilter.m
//  Pictograph
//
//  Created by Арсений Коротаев on 24.09.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#import "AmatorkaFilter.h"
#import "GPUImage.h"

NSString *const kCustomFilterShaderString = SHADER_STRING
(
 uniform sampler2D inputImageTexture;
 varying highp vec2 textureCoordinate;
 
 uniform highp float vignetteStart;
 uniform highp float vignetteEnd;
 
 void main()
 {
     lowp vec3 rgb = texture2D(inputImageTexture, textureCoordinate).rgb;
     lowp float d = distance(textureCoordinate, vec2(0.5,0.5));
     rgb *= smoothstep(vignetteEnd, vignetteStart, d);
     gl_FragColor = vec4(rgb.r, rgb.g, 0 ,1.0);
 }
 );


@implementation AmatorkaFilter

- (void) filterForCamer:(GPUImageStillCamera *)camera andView:(GPUImageView *)view
{
    
    [super filterForCamer:camera andView:view];
    
    [self processFilterInitialization];
    filter1 = [[GPUImageAmatorkaFilter alloc] init];

    [filter1 prepareForImageCapture];
    //[filter2 prepareForImageCapture];
    
    [camera addTarget:filter1];
    [filter1 addTarget:view];
    
    //[filter2 addTarget:view];
    
  
}

- (void) filterForImage:(UIImage *)image andView:(UIImageView *)view

{
    
    [super filterForImage:image andView:view];
    
    if (processedImage == nil)
    {
        GPUImageAmatorkaFilter *stillImageFilter2 = [[GPUImageAmatorkaFilter alloc] init];
        processedImage = [stillImageFilter2 imageByFilteringImage:image];
        [view setImage:processedImage];
    }

}

-(void) processFilterInitialization
{
    filter1 = [[GPUImageGaussianBlurFilter alloc] init];
   // filter2 = [[GPUImageVignetteFilter alloc] init];
}

-(GPUImageFilter*) lastFilter
{
    return filter1;
}

-(void) removeFilter
{
    [super removeFilter];
  //  [filter2 removeAllTargets];
    [filter1 removeAllTargets];
    
    [filter1 deleteOutputTexture];
   // [filter2 deleteOutputTexture];
    

}
@end
