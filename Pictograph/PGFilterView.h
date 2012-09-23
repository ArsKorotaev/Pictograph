//
//  PGFilterView.h
//  Pictograph
//
//  Created by Арсений Коротаев on 23.09.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GPUImage.h"
@interface PGFilterView : UIView
{
    GPUImageView *view1, *view2, *view3, *view4, *view5;
}
- (id) initFilterView;

@end
