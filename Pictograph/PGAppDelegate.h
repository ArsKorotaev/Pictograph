//
//  PGAppDelegate.h
//  Pictograph
//
//  Created by Арсений Коротаев on 22.09.12.
//  Copyright (c) 2012 Арсений Коротаев. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PGViewController;

@interface PGAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) PGViewController *viewController;

@end
