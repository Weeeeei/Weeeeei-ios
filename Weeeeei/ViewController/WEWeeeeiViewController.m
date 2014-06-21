//
//  WEWeeeeiViewController.m
//  Weeeeei
//
//  Created by matsumoto on 2014/06/21.
//  Copyright (c) 2014年 y-matsuwitter. All rights reserved.
//

#import "WEWeeeeiViewController.h"
#import "WEUser.h"

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
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = self.followingUsers[indexPath.row];
    return cell;
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

- (IBAction)tapLogout:(id)sendeer {
}
@end
