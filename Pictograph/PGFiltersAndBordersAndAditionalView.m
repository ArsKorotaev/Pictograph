//
//  PGFiltersAndBordersAndAditionalView.m
//  Pictograph
//
//  Created by Арсений Коротаев on 28.09.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#import "PGFiltersAndBordersAndAditionalView.h"
#import "PGFilterView.h"
#import "PGFaceView.h"
#import "FilterMicroView.h"
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
        
        _facesView = [[PGFaceView alloc] initFilterViewWithFilterNames:@[@"F_TrollFace", @"F_Pocker", @"F_Happy", @"F_BlackDog", @"F_Dog"]];
        CGRect facesViewFrame = _boredersView.frame;
        facesViewFrame.origin.x *= 2;
        [_facesView setFrame:facesViewFrame];
        [[_facesView.views objectAtIndex:0] deselect];
        
        scrollView = [[UIScrollView alloc] initWithFrame:_filtersView.frame];
        scrollView.pagingEnabled = YES;
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 3, scrollView.frame.size.height);
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.scrollsToTop = NO;
        scrollView.delegate = self;
        
        [scrollView addSubview:_filtersView];
        [scrollView addSubview:_boredersView];
        [scrollView addSubview:_facesView];
        
        [self addSubview:scrollView];
        
        pageControl = [[UIPageControl alloc] init];
        pageControl.numberOfPages = 3;
        pageControl.center = CGPointMake(scrollView.frame.size.width / 2, scrollView.frame.size.height - 5);
        //[pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:pageControl];
        
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
    pageControl.currentPage = page;
    [self.delegate filtersAndBordersAndAditionalView:self scrolToViewAtIndex:page];
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

- (void)changePage:(id)sender
{
    int page = pageControl.currentPage;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    
	// update the scroll view to the appropriate page
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
    
    
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
