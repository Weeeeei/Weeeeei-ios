//
//  WERegistrationViewController.m
//  Weeeeei
//
//  Created by matsumoto on 2014/06/21.
//  Copyright (c) 2014年 y-matsuwitter. All rights reserved.
//

#import "WERegistrationViewController.h"
#import "WETutorialViewController.h"
#import <FlatUIKit.h>
#import "WEUser.h"

@interface WERegistrationViewController ()<UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet FUITextField *userNameTextField;
@property (strong, nonatomic) IBOutlet FUIButton *startButton;

@end

@implementation WERegistrationViewController

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
    [self setupViews];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setupViews
{
    self.startButton.buttonColor = [UIColor turquoiseColor];
    self.startButton.shadowColor = [UIColor greenSeaColor];
    self.startButton.shadowHeight = 3.0f;
    self.startButton.cornerRadius = 6.0f;
    self.startButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [self.startButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.startButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
}

- (IBAction)tapStart:(id)sender {
    NSString *userName = self.userNameTextField.text;
    if (userName == nil || [userName isEqualToString:@""]) {
        [self showInValidAlert];
        return;
    }
    [WEUser createWithUserName:userName complete:^(WEUser *user) {
        if (user == nil) {
            [self showAuthErrorAlert];
            return;
        }
        // Go to next view
        WETutorialViewController *tutorial = [[WETutorialViewController alloc] initWithNibName:@"WETutorialViewController" bundle:nil];
        [self.navigationController pushViewController:tutorial animated:YES];
    }];
}

- (void)showInValidAlert
{
    [self showNonTitleAlertWithMessage:@"ユーザー名を入力してください。"];
}

- (void)showAuthErrorAlert
{
    [self showNonTitleAlertWithMessage:@"通信に失敗しました。しばらくしてからもう一度お試しください。"];
}

- (void)showNonTitleAlertWithMessage:(NSString *)message
{
    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:nil
                                                          message:message
                                                         delegate:nil
                                                cancelButtonTitle:nil
                                                otherButtonTitles:@"OK", nil];
    alertView.titleLabel.textColor = [UIColor cloudsColor];
    alertView.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    alertView.messageLabel.textColor = [UIColor cloudsColor];
    alertView.messageLabel.font = [UIFont flatFontOfSize:14];
    alertView.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
    alertView.alertContainer.backgroundColor = [UIColor midnightBlueColor];
    alertView.defaultButtonColor = [UIColor cloudsColor];
    alertView.defaultButtonShadowColor = [UIColor asbestosColor];
    alertView.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
    alertView.defaultButtonTitleColor = [UIColor asbestosColor];
    [alertView show];
}

@end
