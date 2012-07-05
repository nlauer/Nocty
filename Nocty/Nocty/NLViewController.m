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
#import "NLYoutubeVideo.h"

@interface NLViewController ()
@property (strong, nonatomic) NSMutableData *data;
@end

@implementation NLViewController
@synthesize tableView = _tableView;
@synthesize youtubeLinks = _youtubeLinks;
@synthesize data = _data;

- (void)viewDidLoad
{
    [super viewDidLoad];
    _youtubeLinks = [[NSMutableArray alloc] init];
    self.title = @"Nocty";
    _data = [[NSMutableData alloc] init];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *e;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:_data options:NSJSONReadingAllowFragments error:&e];
    if (dict) {
        NLYoutubeVideo *youtubeVideo = [[NLYoutubeVideo alloc] initWithDataDictionary:dict];
        if ([[youtubeVideo category] isEqualToString:@"Music"]) {
            [_youtubeLinks addObject:youtubeVideo];
            [_tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[_youtubeLinks count]-1 inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
        }
    }
    _data = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"error:%@", error);
}

- (void)request:(FBRequest *)request didLoad:(id)result
{
    NSDictionary *items = [(NSDictionary *)result objectForKey:@"data"];
    for (NSDictionary *friend in items) {
        NSString *link = [friend objectForKey:@"link"];
        if ([link rangeOfString:@"www.youtube.com/watch?v="].length > 0) {
            NSString *videoID = [self getVideoIdFromYoutubeLink:link];
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://gdata.youtube.com/feeds/api/videos/%@?v=2&alt=json", videoID]]];
            [NSURLConnection connectionWithRequest:request delegate:self];
        }
    }
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"view controller fail:%@", error);
}

#pragma mark - 
#pragma mark - Table View DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_youtubeLinks count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.row < [_youtubeLinks count]) {
        NSString *cellIdentifier = @"cell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        }
        cell.textLabel.text = [((NLYoutubeVideo*)[_youtubeLinks objectAtIndex:indexPath.row]) title];
        [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0f]];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.text = [((NLYoutubeVideo*)[_youtubeLinks objectAtIndex:indexPath.row]) category];
    }
    else {
        NSString *cellIdentifier = @"more";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        }
        [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0f]];
        cell.textLabel.text = @"MORE";
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.text = @"";
    }
    return cell;
}

#pragma mark -
#pragma mark - Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < [_youtubeLinks count]) {
        NLYoutubeVideoPlayerController *youtubeVideoPlayerController = [[NLYoutubeVideoPlayerController alloc] initWithVideoID:[[_youtubeLinks objectAtIndex:indexPath.row] videoID]];
        NSLog(@"videoID:%@",[[_youtubeLinks objectAtIndex:indexPath.row] videoID]);
        [self.navigationController pushViewController:youtubeVideoPlayerController animated:YES];
    }
    else {
        [((NLAppDelegate*)[[UIApplication sharedApplication] delegate]) startGettingMoreLinks];
    }
}

@end
