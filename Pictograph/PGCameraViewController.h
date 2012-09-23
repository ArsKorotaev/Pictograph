//
//  PGCameraViewController.h
//  Pictograph
//
//  Created by Арсений Коротаев on 23.09.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"

@interface PGCameraViewController : UIViewController
{
    GPUImageStillCamera *stillCamera;
    GPUImageOutput<GPUImageInput> *filter;
}
- (IBAction)changeCamera:(id)sender;
- (IBAction)flashButtonPressed:(id)sender;
- (IBAction)filtersButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *filtersButton;
@property (strong, nonatomic) IBOutlet UIButton *flashSwitch;


@end
