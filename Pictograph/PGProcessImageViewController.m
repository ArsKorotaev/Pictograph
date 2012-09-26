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
        captionTextView = [[PGCaptionTextView alloc] initWithFrame:CGRectMake(0,0,self.imageView.frame.size.width, self.imageView.frame.size.height)];
    //		mBottomPartOfMainBackgroundView = [[UIImageView alloc] initWithFrame:self.view.frame];
//        [mBottomPartOfMainBackgroundView setImage:[UIImage imageNamed:@"Filters_Menu.png"]];
        isCaptionMode = NO;
    }
    
    return self;
}

- (IBAction)cancelButtonPressed:(id)sender {
    [filterObject removeFilter];
    [[self presentingViewController] dismissModalViewControllerAnimated:YES];
}

- (IBAction)captionButtonPressed:(id)sender {
    

    if (!isCaptionMode)
    {
       
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
        isCaptionMode = YES;
        
        [(UIButton*)sender setBackgroundImage:buttonActiveImg forState:UIControlStateNormal];
    }
    
    else
    {
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
        isCaptionMode = NO;
        [(UIButton*)sender setBackgroundImage:buttonNormalImg forState:UIControlStateNormal];
    }
    
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
    [super viewDidUnload];
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
    currentFilterName = filterName;
    if (filterObject != nil)
    {
        [filterObject removeFilter];
    }
    filterObject = [[NSClassFromString(filterName) alloc] init];
    
    [filterObject filterForImage:picketImage andView:dispImageView];
   
 
}


@end
