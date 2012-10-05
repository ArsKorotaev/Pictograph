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
@synthesize image = faceImage;

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
        faceImage = image;
        faceImageView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:faceImageView];
        
        pinchGestureRec = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureHandel:)];
        longPressGestureRec = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPresGestureHandle:)];
        longPressGestureRec.minimumPressDuration = 1.5;
        [self addGestureRecognizer:pinchGestureRec];
        [self addGestureRecognizer:longPressGestureRec];
        scale = 1;
    }
    
    return self;
}

- (void) longPresGestureHandle:(UILongPressGestureRecognizer*) gesture
{
    if (alert == nil) {
        alert = [[UIAlertView alloc] initWithTitle:@"Delete face?"
                                           message:nil delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alert show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.delegate faceViewAskForDelete:self];
    }
    
    alert = nil;
}

- (void) deleteFaceView
{
    //Анимация удаления, вызывает делегат
    [UIView animateWithDuration:0.5 animations:^(void)
     {
         self.alpha = 0;
         CGAffineTransform xSacale = CGAffineTransformMakeScale(0, 0);
         self.transform = xSacale;
         
     }
                        completion:^(BOOL succes)
     {
         [self removeFromSuperview];
     }];

}

-(void) pinchGestureHandel:(UIPinchGestureRecognizer*) gesture
{
    //faceImageView.contentScaleFactor = gesture.scale;
    scale *= gesture.scale;
    CGAffineTransform xSacale = CGAffineTransformMakeScale(gesture.scale, gesture.scale);
    self.transform = xSacale;
}


//- (CGImageRef) image
//{
//    CGImageRef scaledImage = [faceImage CGImage];
//    
//    return [faceImage CGImage];
//}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self.superview];
    lastTouchLocation = touchLocation;
    isMoved = YES;
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (isMoved == YES) {
        UITouch *touch = [touches anyObject];

        CGPoint touchLocation = [touch locationInView:self.superview];
        CGFloat delta_x = touchLocation.x - lastTouchLocation.x;
        CGFloat delta_y = touchLocation.y - lastTouchLocation.y;

        self.center = CGPointMake(self.center.x + delta_x, self.center.y + delta_y);

        lastTouchLocation = touchLocation;

    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (isMoved == YES) {
        isMoved = NO;
    }

}

//-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    isMoved = YES;
//    
//    UITouch *touch = [touches anyObject];
//    prevTouchLocation = [touch locationInView:self.superview];
//    parent = self.superview;
//}
//
//-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    if (isMoved)
//    {
////        UITouch *touch = [touches anyObject];
////        CGPoint touchLocation = [touch locationInView:self];
////        CGFloat deltaX = touchLocation.x - prevTouchLocation.x;
////        CGFloat deltaY = touchLocation.y - prevTouchLocation.y;
////        
////        self.center = CGPointMake(self.center.x + deltaX, self.center.y + deltaY);
////        
////        prevTouchLocation = touchLocation;
//        UITouch *touch = [[event touchesForView:parent] anyObject];
//        
//        // get delta
//        //CGPoint previousLocation = [touch previousLocationInView:self];
//        CGPoint location = [touch locationInView:parent];
//        CGFloat delta_x = location.x - prevTouchLocation.x;
//        CGFloat delta_y = location.y - prevTouchLocation.y;
//        
//        self.center = CGPointMake(self.center.x + delta_x,
//                                           self.center.y + delta_y);
//        prevTouchLocation = location;
//    }
//}
//
//-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    isMoved = NO;
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
