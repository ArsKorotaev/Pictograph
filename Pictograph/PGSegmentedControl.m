//
//  PGSegmentedControl.m
//  Pictograph
//
//  Created by Арсений Коротаев on 26.09.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#import "PGSegmentedControl.h"

@implementation PGSegmentedControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImage *bgImage = [[UIImage imageNamed:@"Input.png"] stretchableImageWithLeftCapWidth:19 topCapHeight:0];
        //UIImage *img2 = [UIImage alloc]
        self.backgroundColor = [UIColor colorWithPatternImage:bgImage];
    }
    

    return self;
}




//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
//
//}

@end
