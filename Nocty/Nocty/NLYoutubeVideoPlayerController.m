//
//  NLYoutubeVideoPlayerController.m
//  Nocty
//
//  Created by Nick Lauer on 12-07-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NLYoutubeVideoPlayerController.h"

@interface NLYoutubeVideoPlayerController ()
@property (strong, nonatomic) NSString *videoID;
@property (strong, nonatomic) IBOutlet UIWebView *youtubeVideoPlayer;
@end

@implementation NLYoutubeVideoPlayerController
@synthesize videoID = _videoID;
@synthesize youtubeVideoPlayer = _youtubeVideoPlayer;

- (id)initWithVideoID:(NSString*)videoID
{
    self = [super initWithNibName:@"NLYoutubeVideoPlayerController" bundle:[NSBundle mainBundle]];
    if (self) {
        self.videoID = videoID;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *youTubeVideoHTML = @"<html><head>\
    <body style=\"margin:0\">\
    <embed id=\"yt\" src=\"http://www.youtube.com/watch?v=%@\" type=\"application/x-shockwave-flash\" \
    width=\"%0.0f\" height=\"%0.0f\"></embed>\
    </body></html>";
    
    // Populate HTML with the URL and requested frame size
    NSString *html = [NSString stringWithFormat:youTubeVideoHTML, self.videoID, self.view.frame.size.width, self.view.frame.size.height];
    
    // Load the html into the webview
    [_youtubeVideoPlayer loadHTMLString:html baseURL:nil];
}

- (void)viewDidUnload
{
    [self setYoutubeVideoPlayer:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
