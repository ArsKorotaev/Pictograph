//
//  FilterMicroView.h
//  Pictograph
//
//  Created by Арсений Коротаев on 02.10.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterMicroView : NSObject
{
    UIImageView *standartImage;
    UIImageView *selectedImage;
    UIImageView *mainImage;
}
- (void) select;
- (void) deselect;
- (void) selectNoAnimation;
@property UIView *view;
@property (readonly) BOOL isSelected;
@property NSString *filterName;
@property (nonatomic) UIImage *image;
@end