//
//  PGViewController.m
//  Pictograph
//
//  Created by Арсений Коротаев on 22.09.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#import "PGViewController.h"
#import "PGCameraViewController.h"
@interface PGViewController ()

@end

@implementation PGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [[UIColor alloc]
                                  initWithPatternImage:[UIImage imageNamed:@"BackGround.png"]];
    
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
  

    
    self.titleLabel.font = [UIFont fontWithName:@"Ballpark" size:32];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.shadowOffset = CGSizeMake(0,2);
    self.titleLabel.shadowColor = [UIColor blackColor];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTakePhoto:nil];
    [self setCameraRoll:nil];
    [self setTitleLabel:nil];
    [super viewDidUnload];
}
- (IBAction)takePhotoButtonPressed:(id)sender {
    PGCameraViewController *cvc = [[PGCameraViewController alloc] initWithNibName:@"PGCameraViewController" bundle:nil];
    
    [self presentModalViewController:cvc animated:YES];
}
@end
