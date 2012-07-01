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

@implementation NLViewController {
    int linkThreshold;
}
@synthesize tableView = _tableView;
@synthesize youtubeLinks = _youtubeLinks;

- (void)viewDidLoad
{
    [super viewDidLoad];
    _youtubeLinks = [[NSMutableArray alloc] init];
    linkThreshold = 0;
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)request:(FBRequest *)request didLoad:(id)result
{
    NSDictionary *items = [(NSDictionary *)result objectForKey:@"data"];
    for (NSDictionary *friend in items) {
        NSString *link = [friend objectForKey:@"link"];
        if ([link rangeOfString:@"www.youtube.com"].length > 0) {
            [_youtubeLinks addObject:link];
        }
        NSLog(@"%@: link: %@", [[friend objectForKey:@"from"] objectForKey:@"name"], link);
    }
//    if (_youtubeLinks.count < linkThreshold) {
//        [((NLAppDelegate*)[[UIApplication sharedApplication] delegate]) getNextFriendsLink];
//    }
//    else {
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
//    }
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"view controller fail:%@", error);
//    [((NLAppDelegate*)[[UIApplication sharedApplication] delegate]) getNextFriendsLink];
}

- (IBAction)getStuff:(id)sender {
    [((NLAppDelegate*)[[UIApplication sharedApplication] delegate]) getNextFriendsLink];
//    linkThreshold = [_youtubeLinks count] + 10;
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
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[_youtubeLinks objectAtIndex:indexPath.row]]];
}

@end
