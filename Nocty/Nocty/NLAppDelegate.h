//
//  NLAppDelegate.h
//  Nocty
//
//  Created by Nick Lauer on 12-06-28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@class NLViewController;

@interface NLAppDelegate : UIResponder <UIApplicationDelegate, FBSessionDelegate, FBRequestDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) NLViewController *viewController;
@property (strong, nonatomic) Facebook *facebook;
@property (strong, nonatomic) NSMutableArray *friendArray;

- (void)createArrayOfFriendIds;
- (void)startGettingMoreLinks;
- (void)getNextFriendsLink;

@end
