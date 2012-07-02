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
    [_youtubeVideoPlayer setDelegate:self];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://m.youtube.com/watch?v=%@", _videoID]]];
    [_youtubeVideoPlayer loadRequest:request];
}

- (void)viewDidUnload
{
    [_youtubeVideoPlayer setDelegate:nil];
    [self setYoutubeVideoPlayer:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (NSString*)createIFrameFromVideoID
{
    NSString *iFrame = [NSString stringWithFormat:@"<iframe class=\"youtube-player\" type=\"text/html\" width=\"300\" height=\"400\" src=\"http://www.youtube.com/embed/%@\" frameborder=\"0\"></iframe>", _videoID];
    return iFrame;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

@end
