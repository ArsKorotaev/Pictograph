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

- (void) createInterface
{
    self.flashSwitch.backgroundColor = [UIColor clearColor];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createInterface];
    
   //    //    filter = [[GPUImageGammaFilter alloc] init];
//   // filter = [[GPUImageSketchFilter alloc] init];
//    
//    
//    //filter = [[GPUImageSepiaFilter alloc] init];
//    filter = [[GPUImageFilter alloc] initWithFragmentShaderFromFile:@"WarmCool"];
//    
//    //    [(GPUImageSketchFilter *)filter setTexelHeight:(1.0 / 1024.0)];
//    //    [(GPUImageSketchFilter *)filter setTexelWidth:(1.0 / 768.0)];
//    //    filter = [[GPUImageSmoothToonFilter alloc] init];
//    //    filter = [[GPUImageSepiaFilter alloc] init];
//    
//	[filter prepareForImageCapture];
//    
//    [stillCamera addTarget:filter];
//    GPUImageView *filteredView = (GPUImageView *)self.view;
//    [filter addTarget:filteredView];
//    
//    //    [stillCamera.inputCamera lockForConfiguration:nil];
//    //    [stillCamera.inputCamera setFlashMode:AVCaptureFlashModeOn];
//    //    [stillCamera.inputCamera unlockForConfiguration];
    
       
    
    self.flashSwitch.titleLabel.text = @"Auto";
    
    

    
    
    //add view
    
//     UIImage *filterMask = [UIImage imageNamed:@"FilterMask.png"];
//    
//    
//    
//    
//    GPUImageView *addFilterView = [[GPUImageView alloc] initWithFrame:CGRectMake(10, 300, 66, 65)];
//    [self.view addSubview:addFilterView];
//    
//    
//    UIImage *_maskingImage = [UIImage imageNamed:@"FilterMask.png"];
//    CALayer *_maskingLayer = [CALayer layer];
//    _maskingLayer.frame = addFilterView.bounds;
//    [_maskingLayer setContents:(id)[_maskingImage CGImage]];
//    [addFilterView.layer setMask:_maskingLayer];
//
//    
//    [addFilterView addSubview:[[UIImageView alloc] initWithImage:filterMask]];
//    
//    GPUImageFilter *filter1 = [[GPUImageGaussianBlurFilter alloc] init];
//    [filter1 forceProcessingAtSize:addFilterView.sizeInPixels];
//    
//    [stillCamera addTarget:filter1];
//    
//    [filter1 addTarget:addFilterView];

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
    [super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  
    stillCamera = [[GPUImageStillCamera alloc] init];
    stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    filterObject = [[NSClassFromString(@"FilterNone") alloc] init];
    [filterObject filterForCamer:stillCamera andView:(GPUImageView *)self.view];

    [stillCamera startCameraCapture];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [filterObject removeFilter];
    [stillCamera stopCameraCapture];
  //  GPUImageView* imgView = (GPUImageView*)self.view;
    [self setView:nil];
    stillCamera = nil;
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

- (IBAction)shot:(id)sender {
//
    
   
    [stillCamera capturePhotoAsSampleBufferWithCompletionHandler:^(CMSampleBufferRef sampleBuffer, NSError *error)
    {
        runOnMainQueueWithoutDeadlocking(^{
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:sampleBuffer];

        UIImage *image = [[UIImage alloc] initWithData:imageData];
//        UIImage *image = imageFromSampleBuffer(sampleBuffer);
//        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(10, 100, 100, 100)];
//        [img setImage:image];
//        [self.view addSubview:img];
            
           
            
        PGProcessImageViewController *pivc = [[PGProcessImageViewController alloc] initWithImage:[image copy] andFilterName:NSStringFromClass([filterObject class])];
       
        [self presentModalViewController:pivc animated:YES];
        });
        
    }
     ];
    

    
 
//    [stillCamera capturePhotoAsImageProcessedUpToFilter:filterObject.lastFilter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
//        
//        runOnMainQueueWithoutDeadlocking(^{
//            NSLog(@"Size: %f", processedImage.size.width);
//                            PGProcessImageViewController *pivc = [[PGProcessImageViewController alloc] initWithImage:[processedImage copy]];
//                             [self presentModalViewController:pivc animated:YES];
//                        });
//        
//    }];
    

//    
//    [stillCamera capturePhotoAsJPEGProcessedUpToFilter:filter  withCompletionHandler:^(NSData *processedJPEG, NSError *error){
//        
//        
//        // Save to assets library
//        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//        //        report_memory(@"After asset library creation");
//        
//        [library writeImageDataToSavedPhotosAlbum:processedJPEG metadata:nil completionBlock:^(NSURL *assetURL, NSError *error2)
//         {
//             //             report_memory(@"After writing to library");
//             if (error2) {
//                 NSLog(@"ERROR: the image failed to be written");
//             }
//             else {
//                 NSLog(@"PHOTO SAVED - assetURL: %@", assetURL);
//             }
//			 
//             runOnMainQueueWithoutDeadlocking(^{
//                 //                 report_memory(@"Operation completed");
//                 [self.photoCaptureButton setEnabled:YES];
//             });
//         }];
//    }];

}

- (IBAction)cancelButtonPressed:(id)sender {
    //PGViewController *mainVc = [PGViewController
    //[stillCamera stopCameraCapture];
    [[self presentingViewController] dismissModalViewControllerAnimated:YES];
}

-(void) setFilterNamed:(NSString *)filterName
{

    assert(filterName);
    [stillCamera pauseCameraCapture];
    [filterObject removeFilter];
   
    filterObject  = [[NSClassFromString(filterName) alloc] init];
    [filterObject filterForCamer:stillCamera andView:(GPUImageView *)self.view];
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
@end
