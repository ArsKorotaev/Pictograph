//
//  PGFacesView.h
//  Pictograph
//
//  Created by Арсений Коротаев on 02.10.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGFacesView : UIView
{
    UIImage *faceImage;
    UIImageView *faceImageView;
    UIPinchGestureRecognizer *pinchGestureRec;
}

- (id) initWithFaceImage:(UIImage*) image;
@end
