//
//  PGViewController.m
//  Pictograph
//
//  Created by Арсений Коротаев on 22.09.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#import "PGViewController.h"

@interface PGViewController ()

@end

@implementation PGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [[[UIColor alloc]
                                  initWithPatternImage:[UIImage imageNamed:@"BackGround.png"]] autorelease];
    
    UIImage *takePhotoBtnImgNormal = [[UIImage imageNamed:@"SaveBtn.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:0];
    UIImage *takePhotoBtnImgPressed = [[UIImage imageNamed:@"SaveBtn_Pressed.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:0];
    [self.takePhoto setBackgroundImage:takePhotoBtnImgNormal forState:UIControlStateNormal];
    [self.takePhoto setBackgroundImage:takePhotoBtnImgPressed forState:UIControlStateSelected];
    self.takePhoto.titleLabel.textColor = [UIColor whiteColor];
    self.takePhoto.titleLabel.shadowOffset = CGSizeMake(0, -1);
    self.takePhoto.titleLabel.shadowColor = [UIColor grayColor];
    
    UIImage *cameraRollBtnImgNormal = [[UIImage imageNamed:@"RollBtn.png"]
                                       stretchableImageWithLeftCapWidth:21 topCapHeight:0];
    UIImage *cameraRollBtnImgPressed = [[UIImage imageNamed:@"RollBtn_Pressed.png"]
                                        stretchableImageWithLeftCapWidth:21 topCapHeight:0];
    
    [self.cameraRoll setBackgroundImage:cameraRollBtnImgNormal forState:UIControlStateNormal];
    [self.cameraRoll setBackgroundImage:cameraRollBtnImgPressed forState:UIControlStateSelected];
    
    self.cameraRoll.titleLabel.textColor =[UIColor whiteColor];
    self.cameraRoll.titleLabel.shadowOffset = CGSizeMake(0, -1);
    self.cameraRoll.titleLabel.shadowColor = [UIColor blackColor];
  
    
    
    UIFont *titleFont = [UIFont fontWithName:@"BALLW__.TTF" size:20];
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_takePhoto release];
    [_cameraRoll release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTakePhoto:nil];
    [self setCameraRoll:nil];
    [super viewDidUnload];
}
@end
