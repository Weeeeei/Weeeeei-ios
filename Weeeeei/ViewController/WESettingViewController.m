//
//  WESettingViewController.m
//  Weeeeei
//
//  Created by matsumoto on 2014/06/22.
//  Copyright (c) 2014年 y-matsuwitter. All rights reserved.
//

#import "WESettingViewController.h"
#import "WEUnblockViewController.h"
#import "WEUser.h"

static CGFloat const CellHeight = 80.0f;

@interface WESettingViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation WESettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(20.0f, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(20.0f, 0, 0, 0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.separatorInset = UIEdgeInsetsZero;
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    
    cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, CellHeight);
    cell.textLabel.text = [self titleForIndex:indexPath.row];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:40.0f];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 1:
            //Invite
            break;
        case 2:
        {
            WEUnblockViewController *unblock = [[WEUnblockViewController alloc] initWithNibName:@"WEUnblockViewController" bundle:nil];
            [self presentViewController:unblock animated:YES completion:^{
                
            }];
        }
            break;
        case 3:
            //Add Friends
            break;
        case 4:
            // Close view
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        default:
            break;
    }
}

- (NSString *)titleForIndex:(NSInteger)index
{
    if (index >= 5 || index < 0) {
        return @"";
    }
    if (index == 0) {
        return [WEUser currentUser].userName;
    }
    return @[@"招待する", @"ブロック解除", @"+友だち追加", @"完了"][index - 1];
}
@end
