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
}
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *saveBtn;

-(id) initWithImage:(UIImage*) img;
@end
