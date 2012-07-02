//
//  NLYoutubeVideoPlayerController.h
//  Nocty
//
//  Created by Nick Lauer on 12-07-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NLYoutubeVideoPlayerController : UIViewController <UIWebViewDelegate>

- (id)initWithVideoID:(NSString*)videoID;
@end
