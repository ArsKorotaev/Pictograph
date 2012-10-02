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

-(void) setImage:(UIImage *)image
{
    mainImage = [[UIImageView alloc] initWithImage:image];
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

@end

