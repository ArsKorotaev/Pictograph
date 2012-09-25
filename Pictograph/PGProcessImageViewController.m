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

-(id) initWithImage:(UIImage *)img
{
    self = [super initWithNibName:@"PGProcessImageViewController" bundle:nil];
    
    if (self)
    {
        assert(img != nil);
        picketImage = img;
        
        //UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
       // [self.view addSubview:imgView];
        //[self.imageView setImage:img];
    
        
    }
    
    return self;
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
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customizeInterface];
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
    dispImage = [[UIImageView alloc] initWithImage:picketImage];
    [imageArea addSubview:dispImage];
    [self.imageView addSubview:imageArea];
    [imageArea setZoomScale:320.f / picketImage.size.width];
    
    //Инициализация фильтров
    filterView = [[PGFilterView alloc] initFilterView];
    filterView.frame = CGRectMake(0, 1, filterView.frame.size.width, filterView.frame.size.height);
    filterView.del = self;
    [self.view addSubview:filterView];
    // Do any additional setup after loading the view from its nib.
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setImageView:nil];
    [self setSaveBtn:nil];
    [super viewDidUnload];
}

#pragma mark - UIScrollViewDelegate methods

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [scrollView setContentOffset:scrollView.contentOffset animated:YES];
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView

{
    return dispImage;
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
    
    UIImage *newIm =  [filterObject filterForImage:picketImage];
    [dispImage setImage:newIm];
}


@end
