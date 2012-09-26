//
//  PGCaptionView.m
//  Pictograph
//
//  Created by Арсений Коротаев on 25.09.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#import "PGCaptionView.h"

@implementation PGCaptionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, 280, 30)];
        segmentedControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(20, 58, 280, 44)];
        [self addSubview:textField];
        [self addSubview:segmentedControl];
        
        UIImage *backImage = [UIImage imageNamed:@"Filters_Menu.png"];
        [self setImage:backImage];
        self.alpha = 0;
    }
    return self;
}

- (id) init
{
    self = [super initWithFrame:CGRectMake(0, 320, 320, 92)];
    if (self) {
        
    }
    
    return self;
}

//-(void) setAlpha:(CGFloat)alpha
//{
//    [super setAlpha:alpha];
//}
//
//- (CGFloat) alpha
//{
//    return [super alpha];
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
