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


@interface PGFacesView : UIView <UIAlertViewDelegate>
{
    UIImage *faceImage;
    UIImageView *faceImageView;
    UIPinchGestureRecognizer *pinchGestureRec;
    UILongPressGestureRecognizer *longPressGestureRec;
    
    BOOL isMoved;
    CGPoint lastTouchLocation;
    
    UIView *parent;
    
    UIAlertView *alert;
}

@property (unsafe_unretained) id <FaceViewDelegate> delegate;

- (id) initWithFaceImage:(UIImage*) image;
- (void) deleteFaceView;
@end
