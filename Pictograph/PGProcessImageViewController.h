//
//  PGProcessImageViewController.h
//  Pictograph
//
//  Created by Арсений Коротаев on 23.09.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGProcessImageViewController : UIViewController
{
    UIImage *picketImage;
}
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

-(id) initWithImage:(UIImage*) img;
@end
