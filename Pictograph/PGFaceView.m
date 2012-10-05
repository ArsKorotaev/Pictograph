//
//  PGFaceView.m
//  Pictograph
//
//  Created by Арсений Коротаев on 05.10.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#import "PGFaceView.h"
#import "FilterMicroView.h"
@implementation PGFaceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void) handleGesture:(UIGestureRecognizer *)sender
{
    
    //    for (FilterMicroView *mv in viewsArray) {
    //        if (mv.isSelected == YES)
    //        {
    //            [mv deselect];
    //        }
    //        if (mv.view == sender.view)
    //        {
    //            [mv select];
    //        }
    //    }
    
    
    NSInteger viewIndex = sender.view.tag;
    NSString *filterName;
   
    FilterMicroView *mv = [viewsArray objectAtIndex:viewIndex];
    filterName = mv.filterName;
    [mv highlight];

    [self.del setFilterNamed:filterName];
    
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
