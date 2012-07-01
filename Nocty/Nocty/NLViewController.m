//
//  NLViewController.m
//  Nocty
//
//  Created by Nick Lauer on 12-06-28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NLViewController.h"
#import "NLAppDelegate.h"

@interface NLViewController ()

@end

@implementation NLViewController
@synthesize tableView = _tableView;
@synthesize youtubeLinks = _youtubeLinks;

- (void)viewDidLoad
{
    [super viewDidLoad];
    _youtubeLinks = [[NSMutableArray alloc] init];
    [_tableView setRowHeight:120.0f];
    self.title = @"Nocty";
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (NSString*)getVideoIdFromYoutubeLink:(NSString*)link
{
    NSString *stringStartingWithVideoID = [[link componentsSeparatedByString:@"v="] objectAtIndex:1];
    NSString *videoID = [[stringStartingWithVideoID componentsSeparatedByString:@"&"] objectAtIndex:0];
    return videoID;
}

- (void)request:(FBRequest *)request didLoad:(id)result
{
    NSDictionary *items = [(NSDictionary *)result objectForKey:@"data"];
    for (NSDictionary *friend in items) {
        NSString *link = [friend objectForKey:@"link"];
        if ([link rangeOfString:@"www.youtube.com/watch?v="].length > 0) {
            NSString *videoID = [self getVideoIdFromYoutubeLink:link];
            [_youtubeLinks addObject:videoID];
        }
        NSLog(@"%@: link: %@", [[friend objectForKey:@"from"] objectForKey:@"name"], link);
    }
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"view controller fail:%@", error);
}

- (NSString*)createIFrameFromVideoID:(NSString*)videoID
{
    NSString *iFrame = [NSString stringWithFormat:@"<iframe class=\"youtube-player\" type=\"text/html\" width=\"320\" height=\"120\" src=\"http://www.youtube.com/embed/%@\" frameborder=\"0\"></iframe>", videoID];
    NSString *html = [NSString stringWithFormat:@"<html><head><title>.</title><style>body,html,iframe{margin:0;padding:0;}</style></head><body>%@</body></html>", iFrame];
    return html;
}

#pragma mark - 
#pragma mark - Table View DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_youtubeLinks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        UIWebView *youtubePlayerWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, 120.0f)];
        [youtubePlayerWebView setScalesPageToFit:NO];
        [youtubePlayerWebView setTag:1000];
        [cell addSubview:youtubePlayerWebView];
    }
    UIWebView *youtubePlayerWebView = (UIWebView*)[cell viewWithTag:1000];
    [youtubePlayerWebView loadHTMLString:[self createIFrameFromVideoID:[_youtubeLinks objectAtIndex:indexPath.row]] baseURL:nil];
    return cell;
}

@end
