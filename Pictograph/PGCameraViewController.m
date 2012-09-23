//
//  PGCameraViewController.m
//  Pictograph
//
//  Created by Арсений Коротаев on 23.09.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#import "PGCameraViewController.h"
#import "PGFilterView.h"

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

//- (void) loadView
//{
//    CGRect mainScreenFrame = [[UIScreen mainScreen] bounds];
//    
////    // Yes, I know I'm a caveman for doing all this by hand
////	GPUImageView *primaryView = [[GPUImageView alloc] initWithFrame:mainScreenFrame];
////	primaryView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
////        //
//// 
////   
////	self.view = primaryView;
//    
//    [self.view setBackgroundColor:[UIColor whiteColor]];
//
//    //Задний фон камеры
//    UIImage *cameraImage = [UIImage imageNamed:@"Camera_Background.png"];
//    UIImageView *cameraBackground = [[UIImageView alloc] initWithImage:cameraImage];
//    [self.view addSubview:cameraBackground];
//    
//    //Кнопка "сфотографировать"
//    UIImage *photoBtnImg = [UIImage imageNamed:@"PhotoBtn.png"];
//    UIButton *photoBtn = [[UIButton alloc] initWithFrame:CGRectMake(111,404, 98, 46)];
//    [photoBtn setBackgroundImage:photoBtnImg forState:UIControlStateNormal];
//    [cameraBackground addSubview:photoBtn];
//    
//    
//}

- (void) createInterface
{
    
    self.flashSwitch.backgroundColor = [UIColor clearColor];
    //Задний фон камеры
//    UIImage *cameraImage = [UIImage imageNamed:@"Camera_Background.png"];
//    UIImageView *cameraBackground = [[UIImageView alloc] initWithImage:cameraImage];
//    [self.view addSubview:cameraBackground];
//        //
//    //Кнопка "сфотографировать"
//    UIImage *photoBtnImg = [UIImage imageNamed:@"PhotoBtn.png"];
//    UIImage *photoBtnImgPressed = [UIImage imageNamed:@"PhotoBtn_Pressed.png"];
//    UIButton *photoBtn = [[UIButton alloc] initWithFrame:CGRectMake(111,404, 98, 46)];
//    [photoBtn setBackgroundImage:photoBtnImg forState:UIControlStateNormal];
//    [photoBtn setBackgroundImage:photoBtnImgPressed forState:UIControlStateSelected];
//    [cameraBackground addSubview:photoBtn];
    //
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createInterface];
    
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
    
    self.flashSwitch.titleLabel.text = @"Auto";
    
    
    //add view
    
     UIImage *filterMask = [UIImage imageNamed:@"FilterMask.png"];
    
    
    
    
    GPUImageView *addFilterView = [[GPUImageView alloc] initWithFrame:CGRectMake(10, 300, 66, 65)];
    [self.view addSubview:addFilterView];
    
    
    UIImage *_maskingImage = [UIImage imageNamed:@"FilterMask.png"];
    CALayer *_maskingLayer = [CALayer layer];
    _maskingLayer.frame = addFilterView.bounds;
    [_maskingLayer setContents:(id)[_maskingImage CGImage]];
    [addFilterView.layer setMask:_maskingLayer];

    
    [addFilterView addSubview:[[UIImageView alloc] initWithImage:filterMask]];
    
    GPUImageFilter *filter1 = [[GPUImageGaussianBlurFilter alloc] init];
    [filter1 forceProcessingAtSize:addFilterView.sizeInPixels];
    
    [stillCamera addTarget:filter1];
    
    [filter1 addTarget:addFilterView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {

    [self setCancelButton:nil];
    [self setFiltersButton:nil];
    [self setFlashSwitch:nil];
    [super viewDidUnload];
}
- (IBAction)changeCamera:(id)sender {
    

    [stillCamera rotateCamera];
    // stillCamera.cameraPosition = AVCaptureDevicePositionFront;
}

- (IBAction)flashButtonPressed:(id)sender {
    
    if (stillCamera.inputCamera.flashMode == AVCaptureFlashModeOff)
    {
        self.flashSwitch.titleLabel.text = @"On";
        [stillCamera.inputCamera setFlashMode:AVCaptureFlashModeOn];
    } else if (stillCamera.inputCamera.flashMode == AVCaptureFlashModeOff)
    {
        self.flashSwitch.titleLabel.text = @"Auto";
        [stillCamera.inputCamera setFlashMode:AVCaptureFlashModeAuto];
    } else
    {
        self.flashSwitch.titleLabel.text = @"Off";
        [stillCamera.inputCamera setFlashMode:AVCaptureFlashModeOn];
    }
    
}

- (IBAction)filtersButtonPressed:(id)sender {
    PGFilterView *fv = [[PGFilterView alloc] initFilterView];
    
    [self.view addSubview:fv];
}
@end
