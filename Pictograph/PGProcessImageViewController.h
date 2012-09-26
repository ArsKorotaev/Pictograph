//
//  PGProcessImageViewController.h
//  Pictograph
//
//  Created by Арсений Коротаев on 23.09.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PGFilterView;
@class PGFilter;
@class GPUImageView;
@interface PGProcessImageViewController : UIViewController <UIScrollViewDelegate>
{
    UIImage *picketImage;
    
    UIScrollView *imageArea;
    
    UIImageView *dispImage;
    
    GPUImageView *dispImageView;
    
    PGFilterView *filterView;
    PGFilter *filterObject;
    NSString *currentFilterName;
    
    BOOL isCaptionMode;
    
    
    
    
    IBOutlet UIImageView *captionView;
    IBOutlet UIImageView *mBottomPartOfMainBackgroundView;
    UIImageView *mFolderView;
    UIImageView *mSelectedArrowTipView;
    
    UIImage *buttonActiveImg;
    UIImage *buttonNormalImg;
    
    
    //Caption
    UISegmentedControl *segmentedControl;
    UITextField *textField;
}
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *saveBtn;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *captionButton;


-(id) initWithImage:(UIImage*) img andFilterName:(NSString*) filterName;
- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)captionButtonPressed:(id)sender;
@end
