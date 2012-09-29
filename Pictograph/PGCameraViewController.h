//
//  PGCameraViewController.h
//  Pictograph
//
//  Created by Арсений Коротаев on 23.09.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"
#import "PGFilterView.h"
@class PGFilterView;
@class PGFilter;

@interface PGCameraViewController : UIViewController <PGFilterViewDelegate>
{
    GPUImageStillCamera *stillCamera;
    //GPUImageOutput<GPUImageInput> *filter;
    
    PGFilterView *filterView;
    PGFilter *filterObject;
    IBOutlet UILabel *flashStatusLabel;
}
- (IBAction)changeCamera:(id)sender;
- (IBAction)flashButtonPressed:(id)sender;
- (IBAction)filtersButtonPressed:(id)sender;
- (IBAction)shot:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *filtersButton;
@property (strong, nonatomic) IBOutlet UIButton *flashSwitch;
@property (strong, nonatomic) IBOutlet UIButton *photoCaptureButton;


@end
