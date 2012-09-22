//
//  PGViewController.h
//  Pictograph
//
//  Created by Арсений Коротаев on 22.09.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIButton *takePhoto;
@property (retain, nonatomic) IBOutlet UIButton *cameraRoll;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;

@end
