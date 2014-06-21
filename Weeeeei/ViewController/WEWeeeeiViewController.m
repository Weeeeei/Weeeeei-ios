//
//  WEWeeeeiViewController.m
//  Weeeeei
//
//  Created by matsumoto on 2014/06/21.
//  Copyright (c) 2014年 y-matsuwitter. All rights reserved.
//

#import "WEWeeeeiViewController.h"
#import <MCSwipeTableViewCell.h>
#import "WEUser.h"
#import "WESettingViewController.h"

static CGFloat const CellHeight = 80.0f;

@interface WEWeeeeiViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIView *tableFooterView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *footerButtonsWrapperView;
@property (strong, nonatomic) IBOutlet UITextField *userNameTextField;

@property (nonatomic, strong) NSMutableArray *followingUsers;
@end

@implementation WEWeeeeiViewController

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
    self.tableView.tableFooterView = self.tableFooterView;
    self.tableView.contentInset = UIEdgeInsetsMake(20.0f, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(20.0f, 0, 0, 0);
    self.followingUsers = [[[WEUser currentUser] followingUserNames] mutableCopy];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.followingUsers count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"cell";
    MCSwipeTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[MCSwipeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.separatorInset = UIEdgeInsetsZero;
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    NSString *userName = self.followingUsers[indexPath.row];
    
    cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, CellHeight);
    cell.textLabel.text = userName;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:40.0f];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    [cell setSwipeGestureWithView:[self labelForSwipeView:@"削除"]
                            color:[UIColor orangeColor]
                             mode:MCSwipeTableViewCellModeExit
                            state:MCSwipeTableViewCellState3
                  completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
                      WEUser *user = [WEUser currentUser];
                      [user removeFollowing:userName];
                      self.followingUsers = [[user followingUserNames] mutableCopy];
                      [self.tableView reloadData];
                  }];
    
    [cell setSwipeGestureWithView:[self labelForSwipeView:@"ブロック"]
                            color:[UIColor redColor]
                             mode:MCSwipeTableViewCellModeExit
                            state:MCSwipeTableViewCellState4
                  completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
                      WEUser *user = [WEUser currentUser];
                      [user addBlock:userName complete:^{
                          WEUser *currentUser = [WEUser currentUser];
                          [currentUser removeFollowing:userName];
                          self.followingUsers = [[currentUser followingUserNames] mutableCopy];
                          [self.tableView reloadData];
                      }];
                  }];
    return cell;
}

- (UIView *)labelForSwipeView:(NSString *)text
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60.0f, 20.0f)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:15.0f];
    label.text = text;
    return label;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    WEUser *user = [WEUser currentUser];
    NSString *userName = self.followingUsers[indexPath.row];
    [user isBlockedFromUser:userName complete:^(BOOL blocked) {
        if (blocked) {
            //alert
            return;
        }
        [user sendWeeeeeiToUserName:userName complete:^(BOOL succeeded) {
            if (succeeded) {
                DPDLog(@"pushed");
            }else{
                //alert
            }
        }];
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *userName = textField.text;
    if (![userName isEqualToString:@""]) {
        WEUser *user = [WEUser currentUser];
        [user addFollowing:userName];
        self.followingUsers = [[user followingUserNames] mutableCopy];
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.footerButtonsWrapperView.alpha = 1.0f;
        [self.tableView reloadData];
    } completion:^(BOOL finished) {
        self.footerButtonsWrapperView.userInteractionEnabled = YES;
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)tapFooter:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.footerButtonsWrapperView.alpha = 0;
    } completion:^(BOOL finished) {
        self.footerButtonsWrapperView.userInteractionEnabled = NO;
        [self.userNameTextField becomeFirstResponder];
    }];
}

- (IBAction)tapSetting:(id)sender {
    WESettingViewController *setting = [[WESettingViewController alloc] initWithNibName:@"WESettingViewController" bundle:nil];
    [self presentViewController:setting animated:YES completion:^{
        
    }];
}

- (IBAction)tapLogout:(id)sendeer {
}
@end
