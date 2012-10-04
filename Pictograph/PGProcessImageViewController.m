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
#import "PGFiltersAndBordersAndAditionalView.h"
#import "PGFacesView.h"
#import "FacesViewController.h"
#include <stdlib.h>
#include <stdio.h>
#define IMAGE_SIZE 640
#define ANIMATION_DISTANCE 75
#define LEFT_IMAGE 1
#define RIGHT_IMAGE 2
@interface PGProcessImageViewController () <PGFilterViewDelegate, FaceViewDelegate>

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
        
        //assert(img != nil);
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
        
        filtersDic = [[NSMutableDictionary alloc] init];

        activeFontName = @"Freehand521BT-RegularC";
        
        pthread_mutex_init(&mutxFilter, NULL);
        sem_unlink("Picket image status semaphore");
        sem_unlink("View load semaphore");
        
        if (picketImage != nil) {
            picketImageSem = sem_open("Picket image status semaphore", O_CREAT,0,2);
        }
        else
        {
            picketImageSem = sem_open("Picket image status semaphore", O_CREAT,0,0);
        }
       
        viewLoadSemaphore = sem_open("View load semaphore", O_CREAT,0,0);
        
        
        facesSet = [[NSMutableSet alloc] init];
        
    }
    
    return self;
}


//- (void)loadView
//{
//    NSLog(@"Load view");
//    
//    CGRect rect = [[UIScreen mainScreen] bounds];
//    UIScrollView *primaryView = [[UIScrollView alloc] initWithFrame:rect];
//    primaryView.contentSize = rect.size;
//    self.view = primaryView;
//}
- (IBAction)cancelButtonPressed:(id)sender {
    [filterThread cancel];
    [filterObject removeFilter];
    picketImage = nil;
    [self.delegate PGProcessImageViewController:self processedImage:nil];
    //[[self presentingViewController] dismissModalViewControllerAnimated:YES];
}

- (IBAction)captionButtonPressed:(id)sender {
    

    if (!isCaptionMode)
    {
       isCaptionMode = YES;
        CGRect newPhotoFrame = self.imageView.frame;
        CGRect filterFrame = mulitiFilterView.frame;
        
        newPhotoFrame.origin.y -= ANIMATION_DISTANCE;
        filterFrame.origin.y -= ANIMATION_DISTANCE;
        [UIView beginAnimations:@"FolderOpen" context:NULL];
        [UIView setAnimationDuration:0.45];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self.imageView.frame = newPhotoFrame;
        mulitiFilterView.frame = filterFrame;
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
        CGRect filterFrame = mulitiFilterView.frame;
        
        newPhotoFrame.origin.y += ANIMATION_DISTANCE;
        filterFrame.origin.y += ANIMATION_DISTANCE;
        [UIView beginAnimations:@"FolderClose" context:NULL];
        [UIView setAnimationDuration:0.45];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self.imageView.frame = newPhotoFrame;
        mulitiFilterView.frame = filterFrame;
        captionView.alpha = 0;
        [UIView commitAnimations];
        
        [(UIButton*)sender setBackgroundImage:buttonNormalImg forState:UIControlStateNormal];
        [textField resignFirstResponder];
    }
    
    
    
}

- (IBAction)saveButtonPressed:(id)sender {

    UIImage *imageToSave = [filterObject image];
//    if (filterObject.lastFilter != nil)
//    {
//        imageToSave = [[filterObject.lastFilter imageFromCurrentlyProcessedOutput] fixOrientation];
//    }
//    else
//    {
//        imageToSave = picketImage;
//    }
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

//    //Рисоавание рамки
//    UIImage *bImage;
//    if (borderView.contentOffset.x == 0)
//    {
//        bImage = [(UIImageView*)[borderView viewWithTag:LEFT_IMAGE] image];
//    }
//    else
//    {
//        bImage = [(UIImageView*)[borderView viewWithTag:RIGHT_IMAGE] image];
//
//    }
    if (activeBorderImage != nil)
    {
        CGImageRef borderImg = CGImageCreateWithImageInRect([activeBorderImage CGImage], myRect);
        CGContextDrawImage(context, myRect, borderImg);
        CGImageRelease(borderImg);
    }
    
    //Рисование текста
    DrawText(context, captionTextView.frame, [captionTextView.textToDraw UTF8String], [captionTextView.textToDraw length],[segmentedControl.curentFontName UTF8String], 'N');
    DrawUpText(context, captionTextViewUp.frame, [captionTextViewUp.textToDraw UTF8String], [captionTextViewUp.textToDraw length],[segmentedControl.curentFontName UTF8String], 'N');
    CGImageRef myImage;
    myImage = CGBitmapContextCreateImage (context);
    
    UIImage *scaledImage = [UIImage imageWithCGImage:myImage];
    CGImageRelease(myImage);
    CGImageRelease(mySubimage);
    CGContextRelease(context);
    
    [self.delegate PGProcessImageViewController:self processedImage:scaledImage];
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


-(void) createImageView
{
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
    dispImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, picketImage.size.width, picketImage.size.height)];
    
    if (picketImage != nil)
    {
        
        [self setFilterNamed:currentFilterName];
    }
    else
    {
        [activityIndicator startAnimating];
    }
    
    // [imageArea addSubview:dispImage];
    [imageArea addSubview:dispImageView];
    [self.imageView addSubview:imageArea];
    [imageArea setZoomScale:320.f / picketImage.size.width];
    
    captionTextView = [[PGCaptionTextView alloc] initWithFrame:CGRectMake(0, 240, 320, 80)];
    //    self.downText.textAlignment = NSTextAlignmentCenter;
    //    self.downText.numberOfLines = 3;
    captionTextViewUp = [[PGCaptionTextView alloc] initWithFrame:CGRectMake(0, 5, 320, 40)];
    
  
    facesView = [[FacesViewController alloc] initWithFrame:imageArea.frame];
   
    
    
    //Рамки
    CGRect borderViewFrame = CGRectMake(0, 6, imageArea.frame.size.width * 2, imageArea.frame.size.height);
    borderView = [[UIScrollView alloc] initWithFrame:borderViewFrame];
    borderView.userInteractionEnabled = NO;
    borderView.contentSize = self.imageView.frame.size;
    UIImageView *leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageArea.frame.size.width, imageArea.frame.size.height)];
    leftImage.tag = LEFT_IMAGE;
    UIImageView *rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(imageArea.frame.size.width, 0, imageArea.frame.size.width, self.imageView.frame.size.height)];
    rightImage.tag = RIGHT_IMAGE;
    [borderView addSubview:leftImage];
    [borderView addSubview:rightImage];
    
    
    [self.imageView addSubview:facesView];
    
    [self.imageView addSubview:borderView];
    [self.imageView addSubview:captionTextView];
    [self.imageView addSubview:captionTextViewUp];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
  
    
    //Окно для подписи
//    captionView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 314, 320, 92)];
//    UIImage *captionBgImage = [UIImage imageNamed:@"Filters_Menu.png"];
//    [captionView setImage:captionBgImage];
//    captionView.alpha = 0;
//    [interfaceScroll addSubview:captionView];
//    [interfaceScroll sendSubviewToBack:captionView];
    
   // [(UIScrollView*)self.view setContentSize:self.view.frame.size];
    
    if (picketImage != nil)
    {
        [self createImageView];
        [self setFilterNamed:currentFilterName];
    }
    else
    {
        [activityIndicator startAnimating];
    }
    
    //Инициализация фильтров
    mulitiFilterView = [[PGFiltersAndBordersAndAditionalView alloc] initWithFrame:CGRectMake(0, 1, 320, 70)];
  //  mulitiFilterView.frame = CGRectMake(0, 1, mulitiFilterView.frame.size.width, mulitiFilterView.frame.size.height);
    //filterView.del = self;
    
    [self.view addSubview:mulitiFilterView];
    mulitiFilterView.filtersView.del = self;
    mulitiFilterView.boredersView.del = self;
    mulitiFilterView.facesView.del = self;
    filterView = mulitiFilterView.filtersView;
    // Do any additional setup after loading the view from its nib.
//
//    
    //папка
    [self.view addSubview:mFolderView];
    [self customizeInterface];
    [self finishInitCaptionView];
    
    
    
    //Коментарий
//    [self.imageView addSubview:captionTextView];
//    [captionTextView setNeedsDisplay];
    
    
    //Реакция на клавиатуру
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(applyFilter:)
//                                                 name:@"FinishProcessing"
//                                               object:nil];
    //инициализация лейблов
    
    
    
    [self.cancelButton setTitle:self.cancelButtonCaption forState:UIControlStateNormal];
    [self.cancelButton setTitle:self.cancelButtonCaption forState:UIControlStateHighlighted];
//
//    
//    //Запуск фоновой обработки
    filterThread = [[NSThread alloc] initWithTarget:self selector:@selector(initializeFilterBg:) object:currentFilterName];
    [filterThread start];
    
    [(UIScrollView*)self.view setContentSize:self.view.frame.size];
    
    sem_post(viewLoadSemaphore);
}

-(void) keyboardWillShow:(id) sender
{
    CGRect newViewFrame = self.view.frame;
    CGPoint contentOfset = [(UIScrollView*)self.view contentOffset];
    contentOfset.y = 215;
    newViewFrame.size.height -= 215;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.3];
    self.view.frame = newViewFrame;
    [UIView commitAnimations];

    [(UIScrollView*)self.view setContentOffset:contentOfset animated:YES];
}


-(void)keyboardWillHide:(id) sender
{
    CGRect newViewFrame = self.view.frame;
    CGPoint contentOfset = [(UIScrollView*)self.view contentOffset];
    contentOfset.y = 0;
    
    newViewFrame.size.height += 215;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.3];
    self.view.frame = newViewFrame;
    [UIView commitAnimations];
    
    [(UIScrollView*)self.view setContentOffset:contentOfset animated:YES];
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
   
    isExitFromProcessing = YES;
    [self setImageView:nil];
    [self setSaveBtn:nil];
    [self setCancelButton:nil];
    mBottomPartOfMainBackgroundView = nil;
 
    captionView = nil;
    [self setCaptionButton:nil];

    [self setDownText:nil];
    [self setUpText:nil];
    activityIndicator = nil;
    filterView = nil;
     mulitiFilterView = nil;
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object: nil];
   // [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FinishProcessing" object:nil];
}
#pragma mark - FacesViewDelegate methods
- (void) faceViewAskForDelete:(PGFacesView *)faceView
{
    [faceView deleteFaceView];
    [facesSet removeObject:faceView];

}
#pragma mark - PGViewControllerDelegate methods
- (void) segmentedControl:(PGSegmentedControl *)control setActiveTab:(NSInteger)tabIndex withFontName:(NSString *)font
{
//    UIFont *newFont = [UIFont fontWithName:font size:self.downText.font.pointSize];
//    
//    self.downText.font = newFont;
    activeFontName = font;
    [captionTextView changeFontTo:activeFontName];
    [captionTextViewUp changeFontTo:activeFontName];
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
    if ([filterName hasPrefix:@"B_"])
    {
        NSRange prefixRange = {0,2};
        NSString *fileName = [[filterName stringByReplacingCharactersInRange:prefixRange withString:@""] stringByAppendingPathExtension:@"png"];
    
        activeBorderImage = [UIImage imageNamed:fileName];
        
        if (borderView.contentOffset.x == 0)
        {
            UIImageView *imageView = (UIImageView*)[borderView viewWithTag:RIGHT_IMAGE];
            [imageView setImage:activeBorderImage];
            [borderView setContentOffset:CGPointMake(borderView.frame.size.width / 2, 0) animated:YES];
        }
        else
        {
            UIImageView *imageView = (UIImageView*)[borderView viewWithTag:LEFT_IMAGE];
            [imageView setImage:activeBorderImage];
            [borderView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        
        //activeBorderImage = borderImage;
    }
    else if ([filterName hasPrefix:@"F_"])
    {
        UIImage *image = [UIImage imageNamed:@"Dog.png"];
        PGFacesView *face = [[PGFacesView alloc] initWithFaceImage:image];
        face.delegate = self;
        [facesSet addObject:face];
       // [facesView addface:face];
//        [facesArray addObject:face];
         [self.imageView addSubview:face];
        
    }
    else
    {
        pthread_mutex_lock(&mutxFilter);
        if (picketImage != nil)
        {
            currentFilterName = filterName;
            
            filterObject = [filtersDic objectForKey:filterName];
            if (filterObject == nil) {
                filterObject = [[NSClassFromString(filterName) alloc] init];
                [filtersDic setObject:filterObject forKey:filterName];
            }
            
          
            [filterObject filterForImage:picketImage andView:dispImageView];
        }
        pthread_mutex_unlock(&mutxFilter);
    }
}

-(void) initializeFilterBg:(NSString*) ignoreFilter
{
    NSLog(@"Start wait");
    sem_wait(picketImageSem);
    NSLog(@"Stop wait");
    [NSThread setThreadPriority:1.0];
    NSArray *avialableFiltrerNames = filterView.avialebleFilterNames;
    PGFilter *filter;
    for (NSString *curentFilterName in avialableFiltrerNames) {
        pthread_mutex_lock(&mutxFilter);
        if (![curentFilterName isEqualToString:ignoreFilter] && [filtersDic objectForKey:curentFilterName] == nil)
        {
            if (isExitFromProcessing == NO && picketImage != nil)
            {
                filter = [[NSClassFromString(curentFilterName) alloc] init];
                [filtersDic setObject:filter forKey:curentFilterName];
                [filter createProcessedImageForImage:picketImage];
            }
            else{
                 pthread_mutex_unlock(&mutxFilter);
                [NSThread exit];
                
            }
            
        }
        pthread_mutex_unlock(&mutxFilter);
       
        
    }
}
-(void) applyFilter:(id) filter
{
    
    [activityIndicator stopAnimating];
   
    
}
-(void) unlockThread
{
    [lockFilter unlock];
}





-(void) addPicketImage:(UIImage *)image
{
    NSLog(@"Add picet image enter");
    sem_wait(viewLoadSemaphore);
    picketImage = image;
    [self createImageView];
    [self setFilterNamed:currentFilterName];
    [activityIndicator stopAnimating];
    sem_post(picketImageSem);
    NSLog(@"Add picet image exit");
}
-(void) dealloc
{
    pthread_mutex_destroy(&mutxFilter);
    [filterThread cancel];
    filterThread = nil;
    [filtersDic removeAllObjects];
    sem_close(picketImageSem);
    sem_close(viewLoadSemaphore);
    NSLog(@"Processed image dealoc");
}



@end
