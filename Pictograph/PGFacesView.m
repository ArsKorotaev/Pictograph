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
        faceImageView.backgroundColor = self.backgroundColor = [UIColor clearColor];
        //faceImageView.clipsToBounds = YES;
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
    
    //Проверить окуржности
    CGRect rect = self.frame;
    const CGPoint linePoints[] = {
        {rect.origin.x, rect.origin.y},
        {rect.origin.x, rect.origin.y + rect.size.height},
        {rect.origin.x + rect.size.width, rect.origin.y + rect.size.height},
        {rect.origin.x + rect.size.width, rect.origin.y}
    };
    for (int i = 0;  i < 4; i++) {
        if (CGRectContainsPoint(CGRectMake(linePoints[i].x - 30, linePoints[i].y - 30, 60, 60), touchLocation)) {
            isScaled = YES;
            anchorPoint = linePoints[i];
            switch (i) {
                case 0:
                    anchorPointType = kDownRightCorner;
                    break;
                case 1:
                    anchorPointType = kUprightCorner;
                    break;
                case 2:
                    anchorPointType = kUpLeftCorner;
                    break;
                case 3:
                    anchorPointType = kDownLeftCorner;
                    break;
                default:
                    break;
            }
            
            
            //anchorPointType = (AnchorPoint)i;
            //NSLog(@"Identify touch");
            break;
        }
    }
    lastTouchLocation = touchLocation;
    
    if (!isScaled)
    {
        isMoved = YES;
    }
    [self setNeedsDisplay];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self.superview];
    if (isMoved == YES) {
        

        
        CGFloat delta_x = touchLocation.x - lastTouchLocation.x;
        CGFloat delta_y = touchLocation.y - lastTouchLocation.y;

        self.center = CGPointMake(self.center.x + delta_x, self.center.y + delta_y);

        lastTouchLocation = touchLocation;

    } else if (isScaled == YES)
    {
        CGRect newFrame = self.frame;
        
        switch (anchorPointType) {
            case kUpLeftCorner:
            {
                newFrame.size.width = touchLocation.x - self.frame.origin.x;
                newFrame.size.height = touchLocation.y - self.frame.origin.y;
                 break;
            }
           case kDownRightCorner:
            {
                newFrame.origin.x = touchLocation.x;
                newFrame.origin.y = touchLocation.y;
                newFrame.size.width = self.frame.origin.x + self.frame.size.width - touchLocation.x;
                newFrame.size.height = self.frame.origin.y + self.frame.size.height - touchLocation.y;
                break;
            }
            case kUprightCorner:
            {
                newFrame.origin.x = touchLocation.x;
                newFrame.size.width = self.frame.origin.x + self.frame.size.width - touchLocation.x;
                newFrame.size.height = touchLocation.y - self.frame.origin.y;
                break;
               // newFrame.size.height = self.frame.origin.y + self.frame.size.height - touchLocation.y;
            }
            case kDownLeftCorner:
            {
                newFrame.origin.y = touchLocation.y;
                newFrame.size.height = self.frame.origin.y + self.frame.size.height - touchLocation.y;
                newFrame.size.width = touchLocation.x - self.frame.origin.x;
            }
    
                
            default:
                break;
        }
        
        self.frame = newFrame;
        faceImageView.frame = CGRectMake(0, 0, newFrame.size.width, newFrame.size.height);
        [self setNeedsDisplay];
        //CGFloat scaleParam = (lastTouchLocation.x*lastTouchLocation.x + lastTouchLocation.y*lastTouchLocation.y) / ();
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (isMoved == YES || isScaled == YES) {
        isMoved = NO;
        isScaled = NO;
        [self performSelector:@selector(setNeedsDisplay) withObject:nil afterDelay:2.0];
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

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
//    if (isMoved || isScaled)
//    {
        rect.origin.x += 10;
        rect.origin.y += 10;
        rect.size.width -= 20;
        rect.size.height -= 20;
        CGContextRef context = UIGraphicsGetCurrentContext();
        const CGPoint linePoints[] = {
            {rect.origin.x, rect.origin.y},
            {rect.origin.x, rect.origin.y + rect.size.height},
            {rect.origin.x + rect.size.width, rect.origin.y + rect.size.height},
            {rect.origin.x + rect.size.width, rect.origin.y}
        };
        CGContextClearRect(context, rect);
        CGContextAddLines(context, linePoints, 4);
        CGContextClosePath(context);
        CGContextSetLineWidth(context, 2.0f);
        CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);
        CGContextStrokePath(context);
        CGContextSetRGBFillColor(context, 0, 0, 1, 1);
        for (int i = 0; i < 4; i++) {
            
            CGContextFillEllipseInRect(context, CGRectMake(linePoints[i].x - 10, linePoints[i].y - 10, 20, 20));

        }
                
   // }
    
        
}


@end
