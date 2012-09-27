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
    
        
        buttonFonts = @[@"Freehand521 BT", @"Ballpark", @"Lobster 1.4", @"CollegiateHeavyOutline", @"Complete In Him", @"Helvetica"];
        
        buttonArray = [[NSMutableArray alloc] initWithCapacity:6];
        leftPartImage = [[UIImage imageNamed:@"FontTabLeft.png"] stretchableImageWithLeftCapWidth:25 topCapHeight:0];
        rightPartImage = [[UIImage imageNamed:@"FontTabRight.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:0];
        bgImage = [[UIImage imageNamed:@"FontTab.png"] stretchableImageWithLeftCapWidth:7 topCapHeight:0];
        
        leftPartActiveImage = [[UIImage imageNamed:@"FontTabLeft_Active.png"] stretchableImageWithLeftCapWidth:25 topCapHeight:0];
        rightPartActiveImage = [[UIImage imageNamed:@"FontTabRight_Active.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:0];
        bgActiveImage = [[UIImage imageNamed:@"FontTab_Active.png"] stretchableImageWithLeftCapWidth:7 topCapHeight:0];
        
        //assert(leftPartImage && rightPartImage && bgImage && leftPartActiveImage && rightPartActiveImage && bgActiveImage);
        
        segmentLength = 300/6;
        
        UIButton *controlButton = [self createButtonWithImage:leftPartImage atIndex:0];
        [buttonArray insertObject:controlButton atIndex:0];
        [self addSubview:controlButton];
        
        for (int i = 1; i < 5; i++) {
            controlButton = [self createButtonWithImage:bgImage atIndex:i];
            [buttonArray insertObject:controlButton atIndex:i];
            [self addSubview:controlButton];
            
        }
        
        controlButton = [self createButtonWithImage:rightPartImage atIndex:5];
        [buttonArray insertObject:controlButton atIndex:5];
        [self addSubview:controlButton];
        
        selectedBtn = 0;
        [[buttonArray objectAtIndex:0] setBackgroundImage:leftPartActiveImage forState:UIControlStateNormal];
        [[buttonArray objectAtIndex:0]  setBackgroundImage:leftPartActiveImage forState:UIControlStateHighlighted];
        
        self.backgroundColor = [UIColor clearColor];
    }
    
    

    return self;
}

-(UIButton *) createButtonWithImage:(UIImage*)img atIndex:(NSInteger) index
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(index*segmentLength, 0, segmentLength, self.frame.size.height)];
    [btn setBackgroundImage:img forState:UIControlStateNormal];
    [btn setBackgroundImage:img forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
    [btn setTitle:@"Aa" forState:UIControlStateNormal];
    [btn setTitle:@"Aa" forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];

    btn.titleLabel.font = [UIFont fontWithName:[buttonFonts objectAtIndex:index] size:19];
    
    [btn setTag:index];
    
    return btn;
}

-(UIImage*) normalImageForBtnAtIndex:(NSInteger) index
{
    UIImage *rezult;
    switch (index) {
        case 0:
        {
            rezult = leftPartImage;
            break;
        }
          
        case 5:
        {
            rezult =  rightPartImage;
            break;
        }
        default:
        {
            rezult =  bgImage;
        }
        break;
    }
    
    return rezult;
}

-(UIImage*) selectedImageForBtnAtIndex:(NSInteger) index
{
    UIImage *rezult;
    switch (index) {
        case 0:
        {
            rezult = leftPartActiveImage;
            break;
        }
            
        case 5:
        {
            rezult =  rightPartActiveImage;
            break;
        }
        default:
        {
            rezult =  bgActiveImage;
            break;
        }
            
    }
    
    return rezult;
}
-(void) buttonPressed:(id) sender
{
    UIButton *btn = sender;
    if (btn.tag != selectedBtn)
    {

        [btn setBackgroundImage:[self selectedImageForBtnAtIndex:btn.tag] forState:UIControlStateNormal];
        [btn setBackgroundImage:[self selectedImageForBtnAtIndex:btn.tag] forState:UIControlStateHighlighted];
        
        [[buttonArray objectAtIndex:selectedBtn] setBackgroundImage:[self normalImageForBtnAtIndex:selectedBtn] forState:UIControlStateNormal];
        [[buttonArray objectAtIndex:selectedBtn]  setBackgroundImage:[self normalImageForBtnAtIndex:selectedBtn] forState:UIControlStateHighlighted];
        
        selectedBtn = btn.tag;
    }
    
    NSLog(@"Pressed button tag: %d", btn.tag);
}

-(CGRect) frameForSegment:(NSInteger) segmentIndex
{
    CGRect rezult;
    if (segmentIndex == 0)
    {
        rezult = CGRectMake(0, 0, leftPartImage.size.width, self.frame.size.height);
    }
    else if (segmentIndex == 5)
    {
        rezult = CGRectMake(300 - rightPartImage.size.width, 0, rightPartImage.size.width, self.frame.size.height);
    }
    
    return rezult;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
//
//    
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//   // CGContextDrawImage(context,[self frameForSegment:0], [leftPartImage CGImage]);
//    //CGContextDrawImage(context,[self frameForSegment:5], [rightPartImage CGImage]);
//    
////    bgImage = [bgImage stretchableImageWithLeftCapWidth:14 topCapHeight:0];
////    CGContextSetRGBFillColor(context, 1, 1, 1, 1);
////    CGContextFillRect(context, rect);
//   // CGContextDrawImage(context,rect, [bgImage CGImage]);
//   // static const CGPatternCallbacks callbacks = { 0, &DrawBgImagePatern, NULL };
//    
//    
//    //CGRect backImgFrame = CGRectMake(10, 10, 10, 10);
//    //CGContextDrawTiledImage(context, backImgFrame, [bgImage CGImage]);
//    
//}

void DrawBgImagePatern (void *info, CGContextRef context)
{
    //CGRect imageRec = CGRectMake(0, 0, bgImage.size.width, bgImage.size.height);
    
}

@end
