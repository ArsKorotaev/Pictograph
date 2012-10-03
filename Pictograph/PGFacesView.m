//
//  PGFacesView.m
//  Pictograph
//
//  Created by Арсений Коротаев on 02.10.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#define IMAGE_SIZE 32
#import "PGFacesView.h"
#import <QuartzCore/QuartzCore.h>
@implementation PGFacesView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) initWithFaceImage:(UIImage *)image
{
    self = [super initWithFrame:CGRectMake(0, 0, IMAGE_SIZE, IMAGE_SIZE)];
    if (self) {
        faceImageView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:faceImageView];
        
        pinchGestureRec = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureHandel:)];
        
        //[action:@selector(imageTouch:withEvent:) forControlEvents:UIControlEventTouchDown];
        
    }
    
    return self;
}

-(void) pinchGestureHandel:(UIPinchGestureRecognizer*) gesture
{
    faceImageView.contentScaleFactor = gesture.scale;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touch began");
}
  
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
