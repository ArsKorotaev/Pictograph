//
//  PGProcessImageViewController+ViewMovement.h
//  Pictograph
//
//  Created by Арсений Коротаев on 03.10.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//


#import <UIKit/UIKit.h>
@class PGFacesView;
@interface FacesViewController : UIView
{
    NSMutableSet *facesArray;
    UIView *touchedFace;
    CGPoint lastTouchLocation;
}

- (void) addface:(PGFacesView*) face;
@end
