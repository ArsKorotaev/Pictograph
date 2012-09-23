//
//  PGFilterView.m
//  Pictograph
//
//  Created by Арсений Коротаев on 23.09.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#import "PGFilterView.h"

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
    self = [super initWithFrame:CGRectMake(0, 200, 320, 70)];
    if (self)
    {
        UIImage *filterMask = [UIImage imageNamed:@"FilterMask.png"];
        //UIImageView *filterMaskView = [[UIImageView alloc] initWithImage:filterMask];
        
        view1 = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 70, 66, 65)];
        [view1 addSubview:[[UIImageView alloc] initWithImage:filterMask]];
        view2 = [[GPUImageView alloc] initWithFrame:CGRectMake(70, 70, 66, 65)];
        [view2 addSubview:[[UIImageView alloc] initWithImage:filterMask]];
        
        [self addSubview:view1];
        [self addSubview:view2];
        
    }
    
    return self;
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
