//
//  PGViewController.h
//  Pictograph
//
//  Created by Арсений Коротаев on 22.09.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGViewController : UIViewController
{
    NSInteger startIndex;
    NSInteger rangeLength;
}
@property (strong, nonatomic) IBOutlet UIButton *takePhoto;
@property (strong, nonatomic) IBOutlet UIButton *cameraRoll;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *recentImages;

- (IBAction)takePhotoButtonPressed:(id)sender;
- (IBAction)cameraRollButtonPressed:(id)sender;

@end
