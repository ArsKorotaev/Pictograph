//
//  PGFilterView.h
//  Pictograph
//
//  Created by Арсений Коротаев on 23.09.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GPUImage.h"
//@class PGFilterView;

@protocol  PGFilterViewDelegate
- (void) setFilterNamed:(NSString*) filterName;
@end

@interface PGFilterView : UIView
{
    GPUImageView *view1, *view2, *view3, *view4, *view5;
    
    NSMutableArray *viewsArray;
    
    NSInteger oldeSelectedView;
    
}
@property BOOL isAdded;
@property (readonly) NSThread *thread;
@property (strong) id<PGFilterViewDelegate> del;
- (id) initFilterView;

@end
