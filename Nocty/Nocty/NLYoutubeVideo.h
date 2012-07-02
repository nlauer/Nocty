//
//  NLYoutubeVideo.h
//  Nocty
//
//  Created by Nick Lauer on 12-07-02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NLYoutubeVideo : NSObject

@property (strong, nonatomic) NSString *videoID;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *thumbnailURL;
@property (strong, nonatomic) NSString *category;

- (id)initWithDataDictionary:(NSDictionary*)dictionary;

@end
