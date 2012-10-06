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
@class PGFiltersAndBordersAndAditionalView;

@protocol PGFiltersAndBordersAndAditionalViewDelegate <NSObject>

- (void) filtersAndBordersAndAditionalView:(PGFiltersAndBordersAndAditionalView*) view scrolToViewAtIndex:(NSInteger) index;

@end

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
@property (readonly) PGFilterView *facesView;
@property NSArray *contentList;
@property (unsafe_unretained) id<PGFiltersAndBordersAndAditionalViewDelegate> delegate;
@end
