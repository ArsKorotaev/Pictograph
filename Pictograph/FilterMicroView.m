//
//  FilterMicroView.m
//  Pictograph
//
//  Created by Арсений Коротаев on 02.10.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#import "FilterMicroView.h"
#import <QuartzCore/QuartzCore.h>
@implementation FilterMicroView
- (id) init
{
    self = [super init];
    
    if (self) {
        UIImage *standartImg = [UIImage imageNamed:@"FilterMask.png"];
        UIImage *selectedImg = [UIImage imageNamed:@"FilterMask_Active.png"];
        
        
        
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

-(void) setImage:(UIImage *)image
{
        
    mainImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [mainImage setImage:image];
    mainImage.contentMode = UIViewContentModeCenter;
    //Добавление маски
    UIImage *_maskingImage = [UIImage imageNamed:@"FilterMask-2-1.png"];
    CALayer *_maskingLayer = [CALayer layer];
    _maskingLayer.frame = self.view.bounds;
    [_maskingLayer setContents:(id)[_maskingImage CGImage]];
    [mainImage.layer setMask:_maskingLayer];
    
    [self.view addSubview:mainImage];
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

- (void) highlight
{
    
    if (selectedImage.superview == nil) {
        [self.view addSubview:selectedImage];
    }

    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fadeInAnimation setFromValue:[NSNumber numberWithFloat:0.0]];
    [fadeInAnimation setToValue:[NSNumber numberWithFloat:1.0]];
    [fadeInAnimation setDuration:0.2];
    [fadeInAnimation setBeginTime:0.0];
    
    CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fadeOutAnimation setFromValue:[NSNumber numberWithFloat:1.0]];
    [fadeOutAnimation setToValue:[NSNumber numberWithFloat:0.0]];
    [fadeOutAnimation setDuration:0.2];
    [fadeOutAnimation setBeginTime:0.2];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    [group setDuration:0.4];
    [group setAnimations:@[fadeInAnimation, fadeOutAnimation]];
    
    [selectedImage.layer addAnimation:group forKey:nil];
   
 
    
}

@end

