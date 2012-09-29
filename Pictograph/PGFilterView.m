//
//  PGFilterView.m
//  Pictograph
//
//  Created by Арсений Коротаев on 23.09.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#import "PGFilterView.h"
#define VIEW_COUNT 5
#define standartImageTag 1

@interface FilterMicroView : NSObject
{
    UIImageView *standartImage;
    UIImageView *selectedImage;
}
- (void) select;
- (void) deselect;
- (void) selectNoAnimation;
@property UIView *view;
@property (readonly) BOOL isSelected;
@property NSString *filterName;
@end

@implementation FilterMicroView
- (id) init
{
    self = [super init];
    
    if (self) {
        UIImage *standartImg = [UIImage imageNamed:@"FilterMask.png"];
        UIImage *selectedImg = [UIImage imageNamed:@"FilterMask_Active.png"];
        
        //Добавление маски
        UIImage *_maskingImage = [UIImage imageNamed:@"FilterMask-2.png"];
        CALayer *_maskingLayer = [CALayer layer];
        _maskingLayer.frame = self.view.bounds;
        [_maskingLayer setContents:(id)[_maskingImage CGImage]];
        [self.view.layer setMask:_maskingLayer];
        
        standartImage = [[UIImageView alloc] initWithImage:standartImg];
        selectedImage = [[UIImageView alloc] initWithImage:selectedImg];
        standartImage.tag = 1;
        selectedImage.alpha = 0;
        [self.view addSubview:standartImage];
        
        
        //Инициализация масиива с именами фильтров

        //= @[@"Standart", @"Sepia", @"Warm", @"Cool", @"Retro"];
        
    }
    
    return self;
}

 -(void) select
{
    if (!_isSelected)
    {
        _isSelected = YES;
        [standartImage removeFromSuperview];
        [self.view addSubview:selectedImage];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:0.2];
        selectedImage.alpha = 1.f;
        [UIView commitAnimations];
    }
}

- (void) selectNoAnimation
{
    if (!_isSelected)
    {
        _isSelected = YES;
        [standartImage removeFromSuperview];
        selectedImage.alpha = 1.f;
        [self.view addSubview:selectedImage];
    }
}

-(void) deselect
{
    if (_isSelected)
    {
        _isSelected = NO;
        [selectedImage removeFromSuperview];
        [self.view addSubview:standartImage];
        selectedImage.alpha = 0;
    }
}

@end



@implementation PGFilterView

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
        filterNames = @[@"FilterNone", @"HipsterFilter", @"SepiaFilter", @"VignetteFilter", @"WarmFilter"];
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
