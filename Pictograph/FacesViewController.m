//
//  PGProcessImageViewController+ViewMovement.m
//  Pictograph
//
//  Created by Арсений Коротаев on 03.10.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#import "FacesViewController.h"


@implementation FacesViewController 

- (void) addface:(PGFacesView *)face
{
    [facesArray addObject:face];
    [self addSubview:(UIView*)face];
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        facesArray = [[NSMutableSet alloc] init];
        self.userInteractionEnabled = NO;
    }
    
    return self;
}

#pragma mark - Touches Events
//- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    CGPoint touchLocation = [touch locationInView:self];
//    for (UIView *touchedView in facesArray) {
//        if (CGRectContainsPoint([touchedView frame], touchLocation))
//        {
//            touchedFace = touchedView;
//            lastTouchLocation = touchLocation;
//            break;
//        }
//    }
//}
//
//- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    if (touchedFace != nil) {
//        UITouch *touch = [touches anyObject];
//        
//        CGPoint touchLocation = [touch locationInView:self];
//        CGFloat delta_x = touchLocation.x - lastTouchLocation.x;
//        CGFloat delta_y = touchLocation.y - lastTouchLocation.y;
//        
//        touchedFace.center = CGPointMake(touchedFace.center.x + delta_x, touchedFace.center.y + delta_y);
//        
//        lastTouchLocation = touchLocation;
//        
//    }
//}
//
//- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    if (touchedFace != nil) {
//        touchedFace = nil;
//    }
//    
//}



@end
