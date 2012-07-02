//
//  NLAppDelegate.m
//  Nocty
//
//  Created by Nick Lauer on 12-06-28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NLAppDelegate.h"
#import "NLViewController.h"

#define FB_APP_ID @"330108183740459"

@implementation NLAppDelegate {
    int currentIndexInFriendsArray;
}

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize viewController = _viewController;
@synthesize facebook = _facebook;
@synthesize friendArray = _friendArray;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    _friendArray = [[NSMutableArray alloc] init];
    currentIndexInFriendsArray = 0;
    //Setup facebook login here, because the app cannot work without it
    _facebook = [[Facebook alloc] initWithAppId:FB_APP_ID andDelegate:self];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        _facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        _facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    if (![_facebook isSessionValid]) {
        NSArray *permissions = [[NSArray alloc] initWithObjects:@"read_stream", nil];
        [_facebook authorize:permissions];
    }
    else {
        [self createArrayOfFriendIds];
    }
    
    self.viewController = [[NLViewController alloc] initWithNibName:@"NLViewController" bundle:nil];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:_viewController];
    self.window.rootViewController = self.navigationController;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)getNextFriendsLink
{
    NSString *path = [NSString stringWithFormat:@"%lld/links", [[_friendArray objectAtIndex:currentIndexInFriendsArray] longLongValue]];
    NSLog(@"path:%@", path);
    [_facebook requestWithGraphPath:path andDelegate:_viewController];
    if (currentIndexInFriendsArray >= 10) {
        NSLog(@"DONEEEE");
        currentIndexInFriendsArray = 0;
    }
    else {
        currentIndexInFriendsArray = currentIndexInFriendsArray + 1;
        [((NLAppDelegate*)[[UIApplication sharedApplication] delegate]) getNextFriendsLink];
    }
}

#pragma mark -
#pragma mark Facebook Methods
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [_facebook handleOpenURL:url]; 
}

- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[_facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[_facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

- (void)createArrayOfFriendIds
{
    [_facebook requestWithGraphPath:@"me/friends" andDelegate:self];
}

#pragma mark - 
#pragma mark FB Request Delegate
- (void)request:(FBRequest *)request didLoad:(id)result
{
    NSDictionary *items = [(NSDictionary *)result objectForKey:@"data"];
    for (NSDictionary *friend in items) {
        long long fbid = [[friend objectForKey:@"id"]longLongValue];
        NSLog(@"id: %lld", fbid);
        [_friendArray addObject:[NSNumber numberWithLongLong:fbid]];
    }
    [self.window makeKeyAndVisible];
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"app delegate fail:%@", error);
}

@end
