//
//  PGProcessImageViewController.m
//  Pictograph
//
//  Created by Арсений Коротаев on 23.09.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#import "PGProcessImageViewController.h"

@interface PGProcessImageViewController ()

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
        
        UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
        [self.view addSubview:imgView];
        //imgView.frame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
        [self.imageView setImage:img];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setImageView:nil];
    [super viewDidUnload];
}
@end
