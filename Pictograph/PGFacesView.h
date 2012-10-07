//
//  PGFacesView.h
//  Pictograph
//
//  Created by Арсений Коротаев on 02.10.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PGFacesView;

@protocol FaceViewDelegate <NSObject>
- (void) faceViewAskForDelete:(PGFacesView*) faveView;
@end

typedef enum AnchorPoint_ {
    kUpLeftCorner = 0,
    kUprightCorner = 3,
    kDownRightCorner = 2,
    kDownLeftCorner = 1
} AnchorPoint;

@interface PGFacesView : UIView <UIAlertViewDelegate>
{
    UIImage *faceImage;
    UIImage *pickerImage;
    UIImageView *faceImageView;
    UIPinchGestureRecognizer *pinchGestureRec;
    UILongPressGestureRecognizer *longPressGestureRec;
    
    BOOL isMoved;
    BOOL isScaled;
    BOOL touchBegan;
    CGPoint anchorPoint;
    CGPoint lastTouchLocation;
    AnchorPoint anchorPointType;
    UIView *parent;
    
    UIAlertView *alert;
    
    CGFloat scale;
}

@property (unsafe_unretained) id <FaceViewDelegate> delegate;
@property (readonly) UIImage* image;

- (id) initWithFaceImage:(UIImage*) image;
- (void) deleteFaceView;
@end
