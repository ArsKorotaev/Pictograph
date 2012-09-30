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
@class PGCaptionTextView;
@class PGSegmentedControl;
@protocol PGSegmentedControlDelegate;

@class PGProcessImageViewController;

@protocol PGProcessImageDelegate <NSObject>

-(void) PGProcessImageViewController:(PGProcessImageViewController*) controller processedImage:(UIImage*) image;

@end

@interface PGProcessImageViewController : UIViewController <UIScrollViewDelegate, UITextFieldDelegate, PGSegmentedControlDelegate>
{
    UIImage *picketImage;
    
    UIScrollView *imageArea;
    
    UIImageView *dispImage;
    
    UIImageView *dispImageView;
    
    PGFilterView *filterView;
    PGFilter *filterObject;
    NSString *currentFilterName;
    
    BOOL isCaptionMode;
    
    
    
    
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UIImageView *captionView;
    IBOutlet UIImageView *mBottomPartOfMainBackgroundView;
    UIImageView *mFolderView;
    UIImageView *mSelectedArrowTipView;
    
    UIImage *buttonActiveImg;
    UIImage *buttonNormalImg;
    
    
    //Caption
    PGSegmentedControl *segmentedControl;
    UITextField *textField;
    PGCaptionTextView *captionTextView;
    

    NSString *activeFontName;
    
    NSMutableDictionary *filtersDic;
    NSLock *lockFilter;
    NSThread *filterThread;
}
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *saveBtn;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *captionButton;
@property (strong, nonatomic) UILabel *downText;
@property (strong, nonatomic) UILabel *upText;
@property (unsafe_unretained) id <PGProcessImageDelegate> delegate;
@property NSString* cancelButtonCaption;

-(id) initWithImage:(UIImage*) img andFilterName:(NSString*) filterName;
- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)captionButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;

@end
