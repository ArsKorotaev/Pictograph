//
//  PGProcessImageViewController.m
//  Pictograph
//
//  Created by Арсений Коротаев on 23.09.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#import "PGProcessImageViewController.h"
#import "PGFilterView.h"
#import "PGFilter.h"
#import "PGProcessImageViewController+Caption.h"
#import "PGCaptionTextView.h"
#import "UIImage+FixOrientation.h"
#import "PGSegmentedControl.h"
#import "PGCaptionTextView.h"
#include <stdlib.h>
#include <stdio.h>
#define IMAGE_SIZE 640
#define ANIMATION_DISTANCE 75
@interface PGProcessImageViewController () <PGFilterViewDelegate>

@end

@implementation PGProcessImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id) initWithImage:(UIImage *)img andFilterName:(NSString *)filterName
{
    self = [super initWithNibName:@"PGProcessImageViewController" bundle:nil];
    
    if (self)
    {
        
        assert(img != nil);
        picketImage = [img fixOrientation];
        
        //UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
       // [self.view addSubview:imgView];
        //[self.imageView setImage:img];
    
        currentFilterName = filterName;
        //captionTextView = [[PGCaptionTextView alloc] initWithFrame:CGRectMake(0,0,self.imageView.frame.size.width, self.imageView.frame.size.height)];
        
    //		mBottomPartOfMainBackgroundView = [[UIImageView alloc] initWithFrame:self.view.frame];
//        [mBottomPartOfMainBackgroundView setImage:[UIImage imageNamed:@"Filters_Menu.png"]];
        isCaptionMode = NO;
       // [(UIScrollView*)self.view setContentSize:self.view.frame.size];
        
        

        activeFontName = @"Freehand521BT-RegularC";
    }
    
    return self;
}

- (IBAction)cancelButtonPressed:(id)sender {
    [filterObject removeFilter];
    [self.delegate PGProcessImageViewController:self processedImage:nil];
    //[[self presentingViewController] dismissModalViewControllerAnimated:YES];
}

- (IBAction)captionButtonPressed:(id)sender {
    

    if (!isCaptionMode)
    {
       isCaptionMode = YES;
        CGRect newPhotoFrame = self.imageView.frame;
        CGRect filterFrame = filterView.frame;
        
        newPhotoFrame.origin.y -= ANIMATION_DISTANCE;
        filterFrame.origin.y -= ANIMATION_DISTANCE;
        [UIView beginAnimations:@"FolderOpen" context:NULL];
        [UIView setAnimationDuration:0.45];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self.imageView.frame = newPhotoFrame;
        filterView.frame = filterFrame;
        [UIView commitAnimations];
        
        [UIView beginAnimations:@"FolderOpenView" context:NULL];
        [UIView setAnimationDuration:0.2];
        captionView.alpha = 1.0;
        [UIView commitAnimations];
        
        
        [(UIButton*)sender setBackgroundImage:buttonActiveImg forState:UIControlStateNormal];
    }
    
    else
    {
        isCaptionMode = NO;
        CGRect newPhotoFrame = self.imageView.frame;
        CGRect filterFrame = filterView.frame;
        
        newPhotoFrame.origin.y += ANIMATION_DISTANCE;
        filterFrame.origin.y += ANIMATION_DISTANCE;
        [UIView beginAnimations:@"FolderClose" context:NULL];
        [UIView setAnimationDuration:0.45];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self.imageView.frame = newPhotoFrame;
        filterView.frame = filterFrame;
        captionView.alpha = 0;
        [UIView commitAnimations];
        
        [(UIButton*)sender setBackgroundImage:buttonNormalImg forState:UIControlStateNormal];
    }
    
}

- (IBAction)saveButtonPressed:(id)sender {

    UIImage *imageToSave;
    if (filterObject.lastFilter != nil)
    {
        imageToSave = [[filterObject.lastFilter imageFromCurrentlyProcessedOutput] fixOrientation];
    }
    else
    {
        imageToSave = picketImage;
    }
    assert(imageToSave);
  
   // imageToSave = [UIImage imageWithCGImage:[imageToSave CGImage] scale:imageArea.zoomScale orientation:UIImageOrientationUp];
    
    //scale
    CGSize newSize = CGSizeMake(picketImage.size.width*imageArea.zoomScale, picketImage.size.height*imageArea.zoomScale);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [imageToSave drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    
    NSLog(@"Zoom scale %f", imageArea.zoomScale);
    CGRect myImageArea = CGRectMake (imageArea.contentOffset.x*2, imageArea.contentOffset.y*2, IMAGE_SIZE, IMAGE_SIZE);
    CGImageRef mySubimage = CGImageCreateWithImageInRect ([newImage CGImage], myImageArea);
    
    CGRect myRect = CGRectMake(0, 0, IMAGE_SIZE, IMAGE_SIZE);
    CGContextRef context = MyCreateBitmapContext(IMAGE_SIZE,IMAGE_SIZE);
    CGContextDrawImage(context, myRect, mySubimage);

   // CGContextScaleCTM(context, imageArea.zoomScale, imageArea.zoomScale);
    //MyDrawText(context, CGRectMake(0, 20, IMAGE_SIZE, 300), "Hellow every body!", 18);
    DrawText(context, captionTextView.frame, [captionTextView.textToDraw UTF8String], [captionTextView.textToDraw length],[segmentedControl.curentFontName UTF8String], 'N');
    CGImageRef myImage;
    myImage = CGBitmapContextCreateImage (context);
    
    UIImage *scaledImage = [UIImage imageWithCGImage:myImage];
    
//    
//    UIImage *rezult = [UIImage imageWithCGImage:mySubimage];
//    
//    UIImageWriteToSavedPhotosAlbum(rezult, nil, nil, NULL);
//    
//    UIImage *finalImage = [UIImage imageWithCGImage:mySubimage];
//
//    CGSize imageSize = CGSizeMake(IMAGE_SIZE, IMAGE_SIZE);
//    UIGraphicsBeginImageContext(imageSize);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
////    CGContextTranslateCTM (context, IMAGE_SIZE, IMAGE_SIZE);
////    CGContextRotateCTM (context, M_PI);
//    
//    CGContextDrawImage(context, CGRectMake(0, 0, IMAGE_SIZE, IMAGE_SIZE), mySubimage);
//    
//    
//    
//    NSString *text = @"Wa aw";
//    
//    [text drawInRect:CGRectMake(0, 0, IMAGE_SIZE, IMAGE_SIZE) withFont:[UIFont systemFontOfSize:40]];
//    
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    UIImage *scaledImage = [UIImage imageWithCGImage:[image CGImage] scale:1 orientation:UIImageOrientationDown];
    
    [self.delegate PGProcessImageViewController:self processedImage:scaledImage];
    //UIImageWriteToSavedPhotosAlbum(scaledImage, nil, nil, NULL);
}

void MyDrawText (CGContextRef myContext, CGRect contextRect, char *text, unsigned int length) // 1
{
    float w, h;
    w = contextRect.size.width;
    h = contextRect.size.height;
    
    CGContextSelectFont (myContext, // 3
                         "Helvetica-Bold",
                         h,
                         kCGEncodingMacRoman);
    CGContextSetCharacterSpacing (myContext, 10); // 4
    CGContextSetTextDrawingMode (myContext, kCGTextFillStroke); // 5
    
    CGContextSetRGBFillColor (myContext, 0, 1, 0, .5); // 6
    CGContextSetRGBStrokeColor (myContext, 0, 0, 1, 1); // 7
    
    CGContextShowTextAtPoint (myContext, 40, 0, text, length); // 10
}

CGContextRef MyCreateBitmapContext (int pixelsWide,
                                    int pixelsHigh)
{
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    bitmapBytesPerRow   = (pixelsWide * 4);// 1
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    colorSpace = CGColorSpaceCreateDeviceRGB();// 2
    bitmapData = calloc( bitmapByteCount , sizeof(Byte));//3
    if (bitmapData == NULL)
    {
        fprintf (stderr, "Memory not allocated!");
        return NULL;
    }
    context = CGBitmapContextCreate (bitmapData,// 4
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedLast);
    if (context== NULL)
    {
        free (bitmapData);// 5
        fprintf (stderr, "Context not created!");
        return NULL;
    }
    CGColorSpaceRelease( colorSpace );// 6
    
    return context;// 7
}

-(UIImage*) captureView:(UIView*) viewToCapture
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [viewToCapture.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}



- (void) customizeInterface
{
    
    self.view.backgroundColor = [[UIColor alloc]
                                 initWithPatternImage:[UIImage imageNamed:@"BackGround.png"]];
    
    UIImage *takePhotoBtnImgNormal = [[UIImage imageNamed:@"SaveBtn.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:0];
    UIImage *takePhotoBtnImgPressed = [[UIImage imageNamed:@"SaveBtn_Pressed.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:0];
    [self.saveBtn setBackgroundImage:takePhotoBtnImgNormal forState:UIControlStateNormal];
    [self.saveBtn setBackgroundImage:takePhotoBtnImgPressed forState:UIControlStateSelected];
    
    
    UIImage *photoShadowImg = [UIImage imageNamed:@"PhotoShadows.png"];
    [self.imageView setImage:photoShadowImg];
    
    //Инициализация двух нижних кнопок
    buttonNormalImg = [[UIImage imageNamed:@"ActionBtn.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:0];
    UIImage *buttonPressedImg = [[UIImage imageNamed:@"ActionBtn_Pressed.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:0];
    buttonActiveImg = [[UIImage imageNamed:@"ActionBtn_Active.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:0];
    
    [self.cancelButton setBackgroundImage:buttonNormalImg forState:UIControlStateNormal];
    [self.cancelButton setBackgroundImage:buttonPressedImg forState:UIControlStateSelected];
    
    [self.captionButton setBackgroundImage:buttonNormalImg forState:UIControlStateNormal];
    [self.captionButton setBackgroundImage:buttonPressedImg forState:UIControlStateSelected];
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
  
    //инициализация области с изображением
    imageArea = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 6, 320, 320)];
    imageArea.contentSize = picketImage.size;
    imageArea.scrollEnabled = YES;
    imageArea.showsHorizontalScrollIndicator = NO;
    imageArea.showsVerticalScrollIndicator = NO;
    imageArea.userInteractionEnabled = YES;
    imageArea.contentInset = UIEdgeInsetsZero;
    imageArea.bounces = NO;
    imageArea.maximumZoomScale = 2.0;
    imageArea.minimumZoomScale = 320.f / picketImage.size.width;
    imageArea.bouncesZoom = NO;
    imageArea.delegate = self;
    
   // dispImage = [[UIImageView alloc] initWithImage:picketImage];
    dispImageView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, picketImage.size.width, picketImage.size.height)];
    [self setFilterNamed:currentFilterName];
   // [imageArea addSubview:dispImage];
    [imageArea addSubview:dispImageView];
    [self.imageView addSubview:imageArea];
    [imageArea setZoomScale:320.f / picketImage.size.width];
    
    //Инициализация фильтров
    filterView = [[PGFilterView alloc] initFilterView];
    filterView.frame = CGRectMake(0, 1, filterView.frame.size.width, filterView.frame.size.height);
    filterView.del = self;
    [self.view addSubview:filterView];
    // Do any additional setup after loading the view from its nib.
    
    
    //папка
    [self.view addSubview:mFolderView];
    [self customizeInterface];
    [self finishInitCaptionView];
    
    
    
    //Коментарий
    [self.imageView addSubview:captionTextView];
    [captionTextView setNeedsDisplay];
    
    
    //Реакция на клавиатуру
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applyFilter:)
                                                 name:@"FinishProcessing"
                                               object:nil];
    //инициализация лейблов
    captionTextView = [[PGCaptionTextView alloc] initWithFrame:CGRectMake(0, 240, 320, 80)];
//    self.downText.textAlignment = NSTextAlignmentCenter;
//    self.downText.numberOfLines = 3;
    
    [self.imageView addSubview:captionTextView];
    
    
    [self.cancelButton setTitle:self.cancelButtonCaption forState:UIControlStateNormal];
    [self.cancelButton setTitle:self.cancelButtonCaption forState:UIControlStateHighlighted];
 
}

-(void) keyboardWillShow:(id) sender
{
    CGRect newViewFrame = self.view.frame;
    
    newViewFrame.origin.y -= 215;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.3];
    self.view.frame = newViewFrame;
    [UIView commitAnimations];

}


-(void)keyboardWillHide:(id) sender
{
    CGRect newViewFrame = self.view.frame;
    
    newViewFrame.origin.y += 215;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.3];
    self.view.frame = newViewFrame;
    [UIView commitAnimations];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
   // activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
   // activeField = nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setImageView:nil];
    [self setSaveBtn:nil];
    [self setCancelButton:nil];
    mBottomPartOfMainBackgroundView = nil;
 
    captionView = nil;
    [self setCaptionButton:nil];

    [self setDownText:nil];
    [self setUpText:nil];
    activityIndicator = nil;
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FinishProcessing" object:nil];
}
#pragma mark - PGViewControllerDelegate methods
- (void) segmentedControl:(PGSegmentedControl *)control setActiveTab:(NSInteger)tabIndex withFontName:(NSString *)font
{
//    UIFont *newFont = [UIFont fontWithName:font size:self.downText.font.pointSize];
//    
//    self.downText.font = newFont;
    activeFontName = font;
    [captionTextView drawText:nil withFont:activeFontName];
}

#pragma mark - UIScrollViewDelegate methods

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    [scrollView setContentOffset:scrollView.contentOffset animated:YES];
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView

{
    return dispImageView;
}

#pragma mark - PGFilterViewDelegate methods
-(void) setFilterNamed:(NSString *)filterName
{
    
   
    //[activityIndicator startAnimating];
    currentFilterName = filterName;
    if (filterObject != nil)
    {
        [filterObject removeFilter];
    }
    filterObject = [[NSClassFromString(filterName) alloc] init];
    [filterObject filterForImage:picketImage andView:dispImageView];
    
    
}

-(void) applyFilter:(id) filter
{
    
    [activityIndicator stopAnimating];
   
    
}
-(void) unlockThread
{
    [lockFilter unlock];
}





@end
