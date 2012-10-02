//
//  PGFiltersAndBordersAndAditionalView.h
//  Pictograph
//
//  Created by Арсений Коротаев on 28.09.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "PGCaptionView.m"
@class PGFilterView;
@interface PGFiltersAndBordersAndAditionalView : UIView <UIScrollViewDelegate>
{
    //PGFilterView *filtersView, *boredersView, *facesView;
    
    //scrolll
    UIScrollView *scrollView;
	UIPageControl *pageControl;
    NSMutableArray *viewControllers;
    
    // To be used when scrolls originate from the UIPageControl
    BOOL pageControlUsed;

}
@property (readonly) PGFilterView *filtersView;
@property (readonly) PGFilterView *boredersView;

@property NSArray *contentList;
@end
