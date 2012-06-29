//
//  NLViewController.h
//  Nocty
//
//  Created by Nick Lauer on 12-06-28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@interface NLViewController : UIViewController <FBRequestDelegate>
@property (strong, nonatomic) NSMutableArray *youtubeLinks;

@end
