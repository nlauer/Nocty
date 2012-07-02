//
//  NLYoutubeVideo.m
//  Nocty
//
//  Created by Nick Lauer on 12-07-02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NLYoutubeVideo.h"

@implementation NLYoutubeVideo
@synthesize videoID = _videoID, thumbnailURL = _thumbnailURL, title = _title, category = _category;

- (id)initWithDataDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        self.videoID = [self getVideoIDFromDictionary:dict];
        self.title = [self getVideoTitleFromDictionary:dict];
        self.category = [self getVideoCategoryFromDictionary:dict];
    }
    return self;
}

- (NSString*)getVideoCategoryFromDictionary:(NSDictionary*)dict
{
    NSString *category = [[[[[dict objectForKey:@"entry"] objectForKey:@"media$group"] objectForKey:@"media$category"] objectAtIndex:0] objectForKey:@"label"];
    return category;
}

- (NSString*)getVideoTitleFromDictionary:(NSDictionary*)dict
{
    NSString *title = [[[[dict objectForKey:@"entry"] objectForKey:@"media$group"] objectForKey:@"media$title"] objectForKey:@"$t"];
    return title;
}

- (NSString*)getVideoIDFromDictionary:(NSDictionary*)dict
{
    NSString *videoID = [[[[dict objectForKey:@"entry"] objectForKey:@"media$group"] objectForKey:@"yt$videoid"] objectForKey:@"$t"];
    return videoID;
}

@end
