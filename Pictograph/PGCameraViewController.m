//
//  PGCameraViewController.m
//  Pictograph
//
//  Created by Арсений Коротаев on 23.09.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#import "PGCameraViewController.h"

@interface PGCameraViewController ()

@end

@implementation PGCameraViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) loadView
{
    CGRect mainScreenFrame = [[UIScreen mainScreen] bounds];
    
    // Yes, I know I'm a caveman for doing all this by hand
	GPUImageView *primaryView = [[GPUImageView alloc] initWithFrame:mainScreenFrame];
	primaryView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
	self.view = primaryView;
    

    //Задний фон камеры
    UIImage *cameraImage = [UIImage imageNamed:@"Camera_Background.png"];
    UIImageView *cameraBackground = [[UIImageView alloc] initWithImage:cameraImage];
    [self.view addSubview:cameraBackground];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    stillCamera = [[GPUImageStillCamera alloc] init];
    //    stillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    //    filter = [[GPUImageGammaFilter alloc] init];
   // filter = [[GPUImageSketchFilter alloc] init];
    filter = [[GPUImageSepiaFilter alloc] init];
    //    [(GPUImageSketchFilter *)filter setTexelHeight:(1.0 / 1024.0)];
    //    [(GPUImageSketchFilter *)filter setTexelWidth:(1.0 / 768.0)];
    //    filter = [[GPUImageSmoothToonFilter alloc] init];
    //    filter = [[GPUImageSepiaFilter alloc] init];
    
	[filter prepareForImageCapture];
    
    [stillCamera addTarget:filter];
    GPUImageView *filterView = (GPUImageView *)self.view;
    [filter addTarget:filterView];
    
    //    [stillCamera.inputCamera lockForConfiguration:nil];
    //    [stillCamera.inputCamera setFlashMode:AVCaptureFlashModeOn];
    //    [stillCamera.inputCamera unlockForConfiguration];
    
    [stillCamera startCameraCapture];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {

    [super viewDidUnload];
}
@end
