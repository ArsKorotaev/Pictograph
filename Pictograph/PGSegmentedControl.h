//
//  PGSegmentedControl.h
//  Pictograph
//
//  Created by Арсений Коротаев on 26.09.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGSegmentedControl : UIView
{
    UIImage *leftPartImage, *rightPartImage;
    UIImage *leftPartActiveImage, *rightPartActiveImage;
    UIImage *bgImage, *bgActiveImage;
    NSInteger segmentLength;
    

    NSInteger selectedBtn;
    
    NSMutableArray *buttonArray;
    NSArray *buttonFonts;
}

@end
