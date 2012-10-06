//
//  PGCameraViewController.m
//  Pictograph
//
//  Created by Арсений Коротаев on 23.09.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#import "PGCameraViewController.h"
#import "PGFilterView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PGProcessImageViewController.h"
#import "PGViewController.h"

#import "PGFilter.h"
#import "PGProcessImageViewController.h"
@interface PGCameraViewController () <PGProcessImageDelegate>

@end

@implementation PGCameraViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isBlured = NO;
    }
    return self;
}

- (void) createInterface
{
    self.flashSwitch.backgroundColor = [UIColor clearColor];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createInterface];
    
       
    
    self.flashSwitch.titleLabel.text = @"Auto";
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToFocusGesture:)];
    [self.view addGestureRecognizer:tapGesture];
    

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
    [self setPhotoCaptureButton:nil];
    [filterView setDel:nil];
    flashStatusLabel = nil;

    [super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    stillCamera = [[GPUImageStillCamera alloc] init];
    stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    filterObject = [[NSClassFromString(@"FilterNone") alloc] init];
    [filterObject filterForCamer:stillCamera andView:(GPUImageView *)self.view bloorEnable:NO];
    isBlured = NO;
    [stillCamera startCameraCapture];

   
}

-(void) viewWillDisappear:(BOOL)animated
{
    
}
- (IBAction)changeCamera:(id)sender {
    


    [stillCamera rotateCamera];
    // stillCamera.cameraPosition = AVCaptureDevicePositionFront;
}

- (IBAction)flashButtonPressed:(id)sender {
    
    if (stillCamera.inputCamera.hasFlash)
    {
        NSError *error = nil;
        if (![stillCamera.inputCamera lockForConfiguration:&error])
        {
            NSLog(@"Error locking for configuration: %@", error);
            return;
        }
        
        if (stillCamera.inputCamera.flashMode == AVCaptureFlashModeOff)
        {
            flashStatusLabel.text = @"On";
            [stillCamera.inputCamera setFlashMode:AVCaptureFlashModeOn];
        } else if (stillCamera.inputCamera.flashMode == AVCaptureFlashModeOff)
        {
            flashStatusLabel.text = @"Auto";
            [stillCamera.inputCamera setFlashMode:AVCaptureFlashModeAuto];
        } else
        {
            flashStatusLabel.text = @"Off";
            [stillCamera.inputCamera setFlashMode:AVCaptureFlashModeOn];
        }
        
        [stillCamera.inputCamera unlockForConfiguration];
    }
   
}

- (IBAction)filtersButtonPressed:(id)sender {
    
    if (filterView == nil)
    {
        filterView = [[PGFilterView alloc] initFilterView];
        filterView.del = self;
    }
    
    //PGFilterView *fv = [[PGFilterView alloc] initFilterView];
    
    if (filterView.isAdded)
    {
        [filterView removeFromSuperview];
        filterView.isAdded = NO;
    }
    else
    {
        [self.view addSubview:filterView];
        filterView.isAdded = YES;
    }

    
    
}

-(void) endCamera:(id) sender
{
    //UIImage *image;
    //GPUImageView gpuView =    (GPUImageView *)self.view;
    
    [stillCamera stopCameraCapture];
    [filterObject removeFilter];
    [stillCamera deleteOutputTexture];
    [stillCamera removeInputsAndOutputs];
    
    PGProcessImageViewController *pivc;
    if (!isBlured)
    {
        pivc = [[PGProcessImageViewController alloc] initWithImage:sender andFilterName:NSStringFromClass([filterObject class])];
            }
    else
    {
         pivc = [[PGProcessImageViewController alloc] initWithImage:nil andFilterName:NSStringFromClass([filterObject class])];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^()
                       {
                           UIImage *image;
                           if  (isBlured)
                           {
                               NSLog(@"Start Blur");
                               GPUImageFastBlurFilter *stillImageFilter2 = [[GPUImageFastBlurFilter alloc] init];
                               image = [stillImageFilter2 imageByFilteringImage:sender];
                               NSLog(@"End Blur");
                           }
                           else
                           {
                               image = sender;
                           }
                           
                           [pivc addPicketImage:image];
                       });

    }
    pivc.delegate = self;
    pivc.selectedFilterIndex = filterView.selectedFilterIndex;
    [pivc setCancelButtonCaption:@"Retake"];
    [self presentModalViewController:pivc animated:YES];
    
    
    
    
}

- (IBAction)shot:(id)sender {
//
    
   
    [stillCamera capturePhotoAsSampleBufferWithCompletionHandler:^(CMSampleBufferRef sampleBuffer, NSError *error)
    {
        runOnMainQueueWithoutDeadlocking(^{
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:sampleBuffer];

        UIImage *image = [[UIImage alloc] initWithData:imageData];
            
            [self performSelectorOnMainThread:@selector(endCamera:) withObject:image waitUntilDone:NO];
           
        
        });
        
    }
     ];
    

}

- (IBAction)cancelButtonPressed:(id)sender {
    //PGViewController *mainVc = [PGViewController
    //[stillCamera stopCameraCapture];
    [[self presentingViewController] dismissModalViewControllerAnimated:YES];
}

- (IBAction)blurButtonPressed:(id)sender {
    
    [filterObject removeFilter];
    if (isBlured) {
        isBlured = NO;
    }
    else
    {
        isBlured = YES;
    }
    [self setFilterNamed:NSStringFromClass([filterObject class])];
}

- (void)tapToFocusGesture:(UITapGestureRecognizer*)sender {
    
    CGPoint touchLocation = [sender locationInView:self.view];
    if (stillCamera.inputCamera.focusPointOfInterestSupported)
    {
        CGPoint autofocusPoint = CGPointMake(touchLocation.x / self.view.frame.size.width, touchLocation.y / self.view.frame.size.height);
        [stillCamera.inputCamera setFocusPointOfInterest:autofocusPoint];
    }
}

-(void) setFilterNamed:(NSString *)filterName
{

    assert(filterName);
    [stillCamera pauseCameraCapture];
    [filterObject removeFilter];
   
    filterObject  = [[NSClassFromString(filterName) alloc] init];
    [filterObject filterForCamer:stillCamera andView:(GPUImageView *)self.view bloorEnable:isBlured];
    stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    [stillCamera resumeCameraCapture];

}

UIImage *imageFromSampleBuffer(CMSampleBufferRef sampleBuffer) {
    
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer.
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    
    // Get the number of bytes per row for the pixel buffer.
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height.
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space.
    static CGColorSpaceRef colorSpace = NULL;
    if (colorSpace == NULL) {
        colorSpace = CGColorSpaceCreateDeviceRGB();
        if (colorSpace == NULL) {
            // Handle the error appropriately.
            return nil;
        }
    }
    
    // Get the base address of the pixel buffer.
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    // Get the data size for contiguous planes of the pixel buffer.
    size_t bufferSize = CVPixelBufferGetDataSize(imageBuffer);
    
    // Create a Quartz direct-access data provider that uses data we supply.
    CGDataProviderRef dataProvider =
    CGDataProviderCreateWithData(NULL, baseAddress, bufferSize, NULL);
    // Create a bitmap image from data supplied by the data provider.
    CGImageRef cgImage =
    CGImageCreate(width, height, 8, 32, bytesPerRow,
                  colorSpace, kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Little,
                  dataProvider, NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    
    // Create and return an image object to represent the Quartz image.
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    
    return image;
}

#pragma marek - PGProcessImageDelegate methods
-(void) PGProcessImageViewController:(PGProcessImageViewController *)controller processedImage:(UIImage *)image
{
    if (image == nil)
    {
        //Убрать окно обработки
        [self dismissModalViewControllerAnimated:YES];
    }
    else
    {
        //self.view.alpha = 0;
        [self dismissModalViewControllerAnimated:NO];
        [self.delegate PGCameraViewController:self tookImage:image];
    }
}
@end
