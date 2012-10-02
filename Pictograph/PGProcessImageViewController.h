//
//  PGProcessImageViewController.h
//  Pictograph
//
//  Created by Арсений Коротаев on 23.09.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <pthread.h>
#import <semaphore.h>
@class PGFilterView;
@class PGFilter;
@class GPUImageView;
@class PGCaptionTextView;
@class PGSegmentedControl;
@protocol PGSegmentedControlDelegate;

@class PGProcessImageViewController;
@class PGFiltersAndBordersAndAditionalView;

@protocol PGProcessImageDelegate <NSObject>

-(void) PGProcessImageViewController:(PGProcessImageViewController*) controller processedImage:(UIImage*) image;

@end

@interface PGProcessImageViewController : UIViewController <UIScrollViewDelegate, UITextFieldDelegate, PGSegmentedControlDelegate>
{
    
    UIImage *picketImage; //Толькочто сделанное фото или полученное из библиотеки
    UIImage *activeBorderImage; //Текущая рамка изображения
    
    UIScrollView *imageArea;//Вью на котором расположена фотография
    
    UIImageView *dispImage;
    
    UIImageView *dispImageView;
    
    UIScrollView *borderView;//Скрол для хранения рамок
    
    PGFilterView *filterView;
    PGFilter *filterObject;
    NSString *currentFilterName;
    
    BOOL isCaptionMode;
    
    BOOL isExitFromProcessing;
    
    PGFiltersAndBordersAndAditionalView *mulitiFilterView;
    
    //Лица добавленные на фото
    NSArray *facesArray;
    
    IBOutlet UIScrollView *interfaceScroll;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    UIImageView *captionView;
    IBOutlet UIImageView *mBottomPartOfMainBackgroundView;
    UIImageView *mFolderView;
    UIImageView *mSelectedArrowTipView;
    
    UIImage *buttonActiveImg;
    UIImage *buttonNormalImg;
    
    
    //Caption
    PGSegmentedControl *segmentedControl;
    UITextField *textField;
    PGCaptionTextView *captionTextView;
    
    PGCaptionTextView *captionTextViewUp;

    NSString *activeFontName;
    
    NSMutableDictionary *filtersDic;
    NSLock *lockFilter;
    
    
    NSThread *filterThread;
    pthread_mutex_t mutxFilter;
    sem_t *viewLoadSemaphore;
    sem_t *picketImageSem;
    
}
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *saveBtn;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *captionButton;
@property (strong, nonatomic) UILabel *downText;
@property (strong, nonatomic) UILabel *upText;
@property (unsafe_unretained) id <PGProcessImageDelegate> delegate;
@property NSString* cancelButtonCaption;

- (id) initWithImage:(UIImage*) img andFilterName:(NSString*) filterName;
- (void) addPicketImage:(UIImage*) image;
- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)captionButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;

@end
