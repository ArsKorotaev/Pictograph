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
@class PGCameraViewController;

@protocol PGCameraDelegate <NSObject>

-(void) PGCameraViewController:(PGCameraViewController*) controller tookImage:(UIImage*) image;

@end

@interface PGCameraViewController : UIViewController <PGFilterViewDelegate>
{
    GPUImageStillCamera *stillCamera;
    //GPUImageOutput<GPUImageInput> *filter;
    
    PGFilterView *filterView;
    PGFilter *filterObject;
    IBOutlet UILabel *flashStatusLabel;
    
    BOOL isBlured;
}
- (IBAction)changeCamera:(id)sender;
- (IBAction)flashButtonPressed:(id)sender;
- (IBAction)filtersButtonPressed:(id)sender;
- (IBAction)shot:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)blurButtonPressed:(id)sender;



@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *filtersButton;
@property (strong, nonatomic) IBOutlet UIButton *flashSwitch;
@property (strong, nonatomic) IBOutlet UIButton *photoCaptureButton;
@property (unsafe_unretained) id<PGCameraDelegate> delegate;


@end
