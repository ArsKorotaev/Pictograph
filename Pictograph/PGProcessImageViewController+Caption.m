//
//  PGProcessImageViewController+Caption.m
//  Pictograph
//
//  Created by Арсений Коротаев on 26.09.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#import "PGProcessImageViewController+Caption.h"
#import "PGSegmentedControl.h"
#import "PGCaptionTextView.h"
@implementation PGProcessImageViewController (Caption) 
-(void) finishInitCaptionView
{
    textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, 300, 30)];
    textField.delegate = self;
    segmentedControl = [[PGSegmentedControl alloc] initWithFrame:CGRectMake(10, 43, 300, 30)];
    segmentedControl.delegate = self;
    captionView.userInteractionEnabled = YES;
    [self customizeTextField];
    [self customizeSegmentedControl];
    [captionView addSubview:textField];
    [captionView addSubview:segmentedControl];

}

-(void) customizeTextField
{
    UIImage *textFieldBgImage = [[UIImage imageNamed:@"Input.png"] stretchableImageWithLeftCapWidth:19 topCapHeight:0];
    textField.background = textFieldBgImage;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.textColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(keyPressed:) name: UITextFieldTextDidChangeNotification object: nil];
}

-(void) customizeSegmentedControl
{
////    UIImage *bothUnselectedImageLeft = [UIImage imageNamed:@"FontTabLeft.png"];
////    [segmentedControl insertSegmentWithImage:bothUnselectedImageLeft atIndex:0 animated:NO];
//    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBordered;
//    for (int i = 0; i < 6; i++ ) {
//        [segmentedControl insertSegmentWithTitle:@"Aa" atIndex:i animated:NO];
//       
//    }
//    
////    UIImage *bothUnselectedImageLeft = [UIImage imageNamed:@"FontTabLeft.png"];
////    UIView *firstSegment = [segmentedControl.subviews objectAtIndex:0];
////    UIColor*bgCol = [UIColor colorWithPatternImage:bothUnselectedImageLeft];
////    [firstSegment setBackgroundColor:[UIColor blackColor]];
//    
////    UIImage *bothUnselectedImageRight = [UIImage imageNamed:@"FontTabRight.png"];
////    [segmentedControl insertSegmentWithImage:bothUnselectedImageRight atIndex:6 animated:NO];
////
//    UIImage *bgImage = [[UIImage imageNamed:@"Input.png"] stretchableImageWithLeftCapWidth:19 topCapHeight:0];
//  
//    //[segmentedControl setBackgroundImage:bgImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
////
////    
////    UIImage *bothUnselectedImage = [UIImage imageNamed:@"FontTabLeft.png"];
////    [[UISegmentedControl appearance] setDividerImage:bothUnselectedImage
////                                 forLeftSegmentState:UIControlStateNormal
////                                   rightSegmentState:UIControlStateNormal
////                                          barMetrics:UIBarMetricsDefault];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField1
{
    [textField1 resignFirstResponder];
    return YES;
}


-(void) keyPressed:(NSNotification *) sender
{
    UITextField *tf = sender.object;
    NSString *textString = tf.text;
    
    [captionTextView drawText:textString withFont:activeFontName];
}
@end
