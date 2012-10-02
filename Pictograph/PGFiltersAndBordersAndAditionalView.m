//
//  PGFiltersAndBordersAndAditionalView.m
//  Pictograph
//
//  Created by Арсений Коротаев on 28.09.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#import "PGFiltersAndBordersAndAditionalView.h"
#import "PGFilterView.h"
@implementation PGFiltersAndBordersAndAditionalView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _filtersView = [[PGFilterView alloc] initFilterViewWithFilterNames:@[@"FilterNone", @"HipsterFilter", @"SepiaFilter", @"AmatorkaFilter", @"MissEtikateFilter"]];
        _filtersView.frame = frame;
        _boredersView = [[PGFilterView alloc] initFilterViewWithFilterNames:@[@"B_None", @"B_Demotivator", @"B_Polaroid", @"B_DownCaption", @"B_BlackCorners"]];
        CGRect bordersViewFrame = _filtersView.frame;
        bordersViewFrame.origin.x += _filtersView.frame.size.width;
        [_boredersView setFrame:bordersViewFrame];
        
        
        
        scrollView = [[UIScrollView alloc] initWithFrame:_filtersView.frame];
        scrollView.pagingEnabled = YES;
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 2, scrollView.frame.size.height);
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.scrollsToTop = NO;
        scrollView.delegate = self;
        
        [scrollView addSubview:_filtersView];
        [scrollView addSubview:_boredersView];
        
        [self addSubview:scrollView];
        
    }
    return self;
}


- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (pageControlUsed)
    {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}


// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
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
