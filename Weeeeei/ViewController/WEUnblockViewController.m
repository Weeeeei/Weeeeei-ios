//
//  WEUnblockViewController.m
//  Weeeeei
//
//  Created by matsumoto on 2014/06/22.
//  Copyright (c) 2014年 y-matsuwitter. All rights reserved.
//

#import "WEUnblockViewController.h"
#import "WEUser.h"

static CGFloat const CellHeight = 80.0f;

@interface WEUnblockViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;

@property (nonatomic, strong) NSMutableArray *blockedUserNames;

@end

@implementation WEUnblockViewController

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
    [[WEUser currentUser] allBlockedUserWithComplete:^(NSArray *blocked) {
        self.blockedUserNames = [blocked mutableCopy];;
        [self.tableView reloadData];
    }];
    self.tableView.tableFooterView = self.doneButton;
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
    return [self.blockedUserNames count];
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
    cell.textLabel.text = self.blockedUserNames[indexPath.row];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:40.0f];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *userName = self.blockedUserNames[indexPath.row];
    [[WEUser currentUser] removeBlock:userName complete:^{
        [self.blockedUserNames removeObject:userName];
    }];
}

- (IBAction)tapDone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
