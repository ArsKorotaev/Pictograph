//
//  PGViewController.m
//  Pictograph
//
//  Created by Арсений Коротаев on 22.09.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#import "PGViewController.h"
#import "PGCameraViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "PGAppDelegate.h"
#import "PGProcessImageViewController.h"
#define MAX_RECENT_IMAGES 10
@interface PGViewController ()

@end

@implementation PGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [[UIColor alloc]
                                  initWithPatternImage:[UIImage imageNamed:@"BackGround.png"]];
    
    UIImage *takePhotoBtnImgNormal = [[UIImage imageNamed:@"ShootBtn.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:0];
    UIImage *takePhotoBtnImgPressed = [[UIImage imageNamed:@"ShootBtn_Pressed.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:0];
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
    
    
    UIImage *recentImagesImg = [UIImage imageNamed:@"HomeBottomRoll.png"];
    self.recentImages.backgroundColor = [UIColor colorWithPatternImage:recentImagesImg];
    [self.recentImages setContentSize:CGSizeMake(MAX_RECENT_IMAGES*75+10, self.recentImages.frame.size.height)];
    [self addImages];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [self.recentImages addGestureRecognizer:tapGesture];
}

- (void) addImages
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    
    
    // Enumerate just the photos and videos group by using ALAssetsGroupSavedPhotos.
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        // Within the group enumeration block, filter to enumerate just photos.
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
    
        
        // Chooses the photo at the last index
        //[group numberOfAssets]
//        NSRange rangeOfPhotos;
//        rangeOfPhotos.length = MAX_RECENT_IMAGES;
//        rangeOfPhotos.location = [group numberOfAssets] - 1 - MAX_RECENT_IMAGES;
        NSRange rangeOfPhotos;
        
        if ([group numberOfAssets] < MAX_RECENT_IMAGES)
        {
            rangeOfPhotos.length = [group numberOfAssets];
            rangeOfPhotos.location = 0;
            startIndex = 0;
        }
        else
        {
            rangeOfPhotos.location = [group numberOfAssets]-MAX_RECENT_IMAGES;
            rangeOfPhotos.length = MAX_RECENT_IMAGES;
        }
        
        startIndex = rangeOfPhotos.location;
        rangeLength = rangeOfPhotos.length;
        
        
        [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:rangeOfPhotos]
                                options:0
                             usingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop) {
                                 
                                 // The end of the enumeration is signaled by asset == nil.
                                 if (alAsset) {
                                     ALAssetRepresentation *representation = [alAsset defaultRepresentation];
                                     UIImage *latestPhoto = [UIImage imageWithCGImage:[representation fullScreenImage]];
                                     
                                     // Do something interesting with the AV asset.
                                     //[self sendTweet:latestPhoto];
                                     
                                     UIImageView *phView = [[UIImageView alloc] initWithFrame:CGRectMake((10 + (index-startIndex)*75), 10, 70, 70)];
                                     [phView setImage:latestPhoto];
                                    // [self.view addSubview:phView];
                                     
                                     [self.recentImages addSubview:phView];
                                     
                                     
                                     
                                 }
                             }];
    }
                         failureBlock: ^(NSError *error) {
                             // Typically you should handle an error more gracefully than this.
                             NSLog(@"No groups");
                         }];

}

- (void) handleGesture:(UIGestureRecognizer *)sender
{
    
    CGPoint touchLocation = [sender locationInView:sender.view];
    for (UIView *imView in sender.view.subviews)
    {
        if (CGRectContainsPoint(imView.frame, touchLocation))
        {
            UIImage *image = [(UIImageView*)imView image];
            PGProcessImageViewController *pivc = [[PGProcessImageViewController alloc] initWithImage:image andFilterName:@"FilterNone"];
            
            [self presentModalViewController:pivc animated:YES];
            break;
        }
    }
}
- (BOOL) startMediaBrowserFromViewController: (UIViewController*) controller usingDelegate: (id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>) delegate {
    
//    if (([UIImagePickerController isSourceTypeAvailable:
//          UIImagePickerControllerSourceTypePhotoLibrary] == NO)
//        || (delegate == nil)
//        || (controller == nil))
//        return NO;
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    // Displays saved pictures and movies, if both are available, from the
    // Camera Roll album.
    mediaUI.mediaTypes  = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    mediaUI.allowsEditing = NO;
    
    mediaUI.delegate = delegate;
    
    [controller presentModalViewController: mediaUI animated: YES];
    return YES;
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
    [self setRecentImages:nil];
    [super viewDidUnload];
}
- (IBAction)takePhotoButtonPressed:(id)sender {
    PGCameraViewController *cvc = [[PGCameraViewController alloc] initWithNibName:@"PGCameraViewController" bundle:nil];
    
//    PGAppDelegate *del = (PGAppDelegate*)[UIApplication sharedApplication].delegate;
//    [del transitionToViewController:cvc withTransition:nil];
    [self presentModalViewController:cvc animated:YES];
}

- (IBAction)cameraRollButtonPressed:(id)sender {
    [self startMediaBrowserFromViewController:self usingDelegate:nil];
}
@end
