//
//  PGFilterView.m
//  Pictograph
//
//  Created by Арсений Коротаев on 23.09.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#import "PGFilterView.h"
#import "FilterMicroView.h"
#define VIEW_COUNT 5
#define standartImageTag 1

@implementation PGFilterView
@synthesize avialebleFilterNames = filterNames;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initFilterView
{
    self = [super initWithFrame:CGRectMake(0, 340, 320, 70)];
    if (self)
    {
        self.isAdded = NO;
        filterNames = @[@"FilterNone", @"HipsterFilter", @"SepiaFilter", @"AmatorkaFilter", @"MissEtikateFilter"];
        //_thread = [[NSThread alloc] initWithTarget:self selector:@selector(addFilterViews:) object:nil];
        [self addFilterViews:nil];
        //[_thread start];
        
        oldeSelectedView = 0;
            
    }
    
    return self;
}

- (id) initFilterViewWithFilterNames:(NSArray *) names
{
    self = [super initWithFrame:CGRectMake(0, 340, 320, 70)];
    if (self)
    {
        self.isAdded = NO;
        filterNames = names;
        //_thread = [[NSThread alloc] initWithTarget:self selector:@selector(addFilterViews:) object:nil];
        [self addFilterViews:nil];
        //[_thread start];
        
        oldeSelectedView = 0;
        
    }
    
    return self;
}

- (void) addFilterViews:(id) param
{
    if (viewsArray == nil)
    {
        viewsArray = [[NSMutableArray alloc] initWithCapacity:5];
        FilterMicroView *viewToAdd;
        for (int i = 0; i < VIEW_COUNT; i++) {
            viewToAdd = [[FilterMicroView alloc] init];
            viewToAdd.view = [self createSubviewForIndex:i];
            viewToAdd.view.tag = i;
            viewToAdd.filterName = [filterNames objectAtIndex:i];
            NSString *imageName = [viewToAdd.filterName stringByAppendingString:@".png"];
            viewToAdd.image = [UIImage imageNamed:imageName];
            //[self performSelectorOnMainThread:@selector(addViewWithAnimation:) withObject:viewToAdd waitUntilDone:NO];
            //[NSThread sleepForTimeInterval:0.25];
            [viewsArray insertObject:viewToAdd atIndex:i];
            if (i == 0)
            {
                 [viewToAdd selectNoAnimation];
            }
           
            [self addViewWithAnimation:viewToAdd.view atIndex:i];
        }
    }
    else
    {
//        for (int i = 0; i < [viewsArray count]; i++)
//        {
//            [self addViewWithAnimation:[viewsArray objectAtIndex:i] atIndex:i];
//        }
    }
}

-(void) addViewWithAnimation:(UIView*) view atIndex:(NSInteger) index
{
    [self addSubview:view];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.25+0.25*index];
    view.alpha = 1.f;
    [UIView commitAnimations];
}

- (UIView*) createSubviewForIndex:(NSInteger) index
{
    GPUImageView *filterView = [[GPUImageView alloc] initWithFrame:CGRectMake(2 + 63*index, 0, 66, 65)];
    UIImage *filterMask = [UIImage imageNamed:@"FilterMask.png"];
    [filterView addSubview:[[UIImageView alloc] initWithImage:filterMask]];
    filterView.alpha = 0;
    
    UITapGestureRecognizer *tapGestureRec = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(handleGesture:)];
    tapGestureRec.numberOfTapsRequired = 1;
    tapGestureRec.numberOfTouchesRequired = 1;
    [filterView addGestureRecognizer:tapGestureRec];
    return filterView;
    
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
    if (oldeSelectedView != viewIndex)
    {
        FilterMicroView *mv = [viewsArray objectAtIndex:viewIndex];
        filterName = mv.filterName;
        [mv select];
        mv = [viewsArray objectAtIndex:oldeSelectedView];
        [mv deselect];
        
        oldeSelectedView = viewIndex;
        
        [self.del setFilterNamed:filterName];
    }

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
