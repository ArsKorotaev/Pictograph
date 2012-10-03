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
    self = [super initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    if (self) {
        faceImageView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:faceImageView];
        
        pinchGestureRec = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureHandel:)];
        [self addGestureRecognizer:pinchGestureRec];
        //[action:@selector(imageTouch:withEvent:) forControlEvents:UIControlEventTouchDown];
        
    }
    
    return self;
}

-(void) pinchGestureHandel:(UIPinchGestureRecognizer*) gesture
{
    //faceImageView.contentScaleFactor = gesture.scale;
    
    CGAffineTransform xSacale = CGAffineTransformMakeScale(gesture.scale, gesture.scale);
    self.transform = xSacale;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    isMoved = YES;
    UITouch *touch = [touches anyObject];
    prevTouchLocation = [touch locationInView:self];
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (isMoved)
    {
//        UITouch *touch = [touches anyObject];
//        CGPoint touchLocation = [touch locationInView:self];
//        CGFloat deltaX = touchLocation.x - prevTouchLocation.x;
//        CGFloat deltaY = touchLocation.y - prevTouchLocation.y;
//        
//        self.center = CGPointMake(self.center.x + deltaX, self.center.y + deltaY);
//        
//        prevTouchLocation = touchLocation;
        UITouch *touch = [[event touchesForView:self] anyObject];
        
        // get delta
        CGPoint previousLocation = [touch previousLocationInView:self];
        CGPoint location = [touch locationInView:self];
        CGFloat delta_x = location.x - previousLocation.x;
        CGFloat delta_y = location.y - previousLocation.y;
        
        self.center = CGPointMake(self.center.x + delta_x,
                                           self.center.y + delta_y);
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    isMoved = NO;
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
