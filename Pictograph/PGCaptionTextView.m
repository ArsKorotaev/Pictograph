//
//  PGCaptionTextView.m
//  Pictograph
//
//  Created by Арсений Коротаев on 26.09.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#import "PGCaptionTextView.h"

@implementation PGCaptionTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef myContext = UIGraphicsGetCurrentContext();
    CGAffineTransform myTextTransform; // 2
    CGContextSelectFont (myContext, // 3
                         "Helvetica-Bold",
                         300,
                         kCGEncodingMacRoman);
    CGContextSetCharacterSpacing (myContext, 10); // 4
    CGContextSetTextDrawingMode (myContext, kCGTextFillStroke); // 5
    
    CGContextSetRGBFillColor (myContext, 0, 1, 0, .5); // 6
    CGContextSetRGBStrokeColor (myContext, 0, 0, 1, 1); // 7
    myTextTransform =  CGAffineTransformMakeRotation  (45); // 8
    CGContextSetTextMatrix (myContext, myTextTransform); // 9
    
}


@end
