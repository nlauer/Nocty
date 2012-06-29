//
//  NLAppDelegate.h
//  Nocty
//
//  Created by Nick Lauer on 12-06-28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NLViewController;

@interface NLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NLViewController *viewController;

@end
