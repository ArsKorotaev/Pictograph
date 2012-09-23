//
//  PGCameraViewController.h
//  Pictograph
//
//  Created by Арсений Коротаев on 23.09.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"

@interface PGCameraViewController : UIViewController
{
    GPUImageStillCamera *stillCamera;
    GPUImageOutput<GPUImageInput> *filter;
}


@end
