//
//  NLViewController.m
//  Nocty
//
//  Created by Nick Lauer on 12-06-28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NLViewController.h"
#import "NLAppDelegate.h"
#import "NLYoutubeVideoPlayerController.h"

@interface NLViewController ()

@end

@implementation NLViewController
@synthesize tableView = _tableView;
@synthesize youtubeLinks = _youtubeLinks;

- (void)viewDidLoad
{
    [super viewDidLoad];
    _youtubeLinks = [[NSMutableArray alloc] init];
    self.title = @"Nocty";
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
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

- (IBAction)getStuff:(id)sender {
    [((NLAppDelegate*)[[UIApplication sharedApplication] delegate]) getNextFriendsLink];
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
    }
    cell.textLabel.text = [_youtubeLinks objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark -
#pragma mark - Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NLYoutubeVideoPlayerController *youtubeVideoPlayerController = [[NLYoutubeVideoPlayerController alloc] initWithVideoID:[_youtubeLinks objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:youtubeVideoPlayerController animated:YES];
}

@end
