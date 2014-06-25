//
//  WETutorialViewController.m
//  Weeeeei
//
//  Created by matsumoto on 2014/06/26.
//  Copyright (c) 2014年 y-matsuwitter. All rights reserved.
//

#import "WETutorialViewController.h"
#import "WEWeeeeiViewController.h"
#import "WEAppDelegate.h"
#import <FUIButton.h>

static int const MaxPage = 5;

@interface WETutorialViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet FUIButton *weeeeeiButton;
@property (strong, nonatomic) IBOutlet UIView *firstPageView;
@property (strong, nonatomic) IBOutlet UIView *secondPageView;
@property (strong, nonatomic) IBOutlet UIView *thirdPageView;
@property (strong, nonatomic) IBOutlet UIView *forthPageView;
@property (strong, nonatomic) IBOutlet UIView *finalPageView;
@property (strong, nonatomic) IBOutlet FUIButton *inviteButton;

@property (nonatomic) BOOL animating;
@end

@implementation WETutorialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.animating = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.contentSize = CGSizeMake(self.firstPageView.frame.size.width * 5, self.firstPageView.frame.size.height);
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    
    
    [self.scrollView addSubview:self.firstPageView];
    self.secondPageView.frame = CGRectMake(self.firstPageView.frame.size.width,
                                           0, self.secondPageView.frame.size.width, self.secondPageView.frame.size.height);
    [self.scrollView addSubview:self.secondPageView];
    self.thirdPageView.frame = CGRectMake(self.secondPageView.frame.size.width + self.secondPageView.frame.origin.x,
                                           0, self.thirdPageView.frame.size.width, self.thirdPageView.frame.size.height);
    [self.scrollView addSubview:self.thirdPageView];
    self.forthPageView.frame = CGRectMake(self.thirdPageView.frame.size.width + self.thirdPageView.frame.origin.x,
                                           0, self.forthPageView.frame.size.width, self.forthPageView.frame.size.height);
    [self.scrollView addSubview:self.forthPageView];
    self.finalPageView.frame = CGRectMake(self.forthPageView.frame.size.width + self.forthPageView.frame.origin.x,
                                           0, self.finalPageView.frame.size.width, self.finalPageView.frame.size.height);
    [self.scrollView addSubview:self.finalPageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.animating) {
        return;
    }
    CGPoint point = scrollView.contentOffset;
    int page = (int)(point.x / self.scrollView.frame.size.width + 0.5);
    self.pageControl.currentPage = page;
}

- (void)next
{
    NSInteger page = self.pageControl.currentPage + 1;
    if (page >= MaxPage) {
        page = 0;
    }
    self.pageControl.currentPage = page;
    CGFloat next = self.pageControl.currentPage * self.scrollView.frame.size.width;
    self.animating = YES;
    [UIView animateWithDuration:0.3 animations:^{
        [self.scrollView setContentOffset:CGPointMake(next, 0)];
    } completion:^(BOOL finished) {
        self.animating = NO;
    }];
}

- (IBAction)tapSegmentedControl:(id)sender {
    CGFloat next = self.pageControl.currentPage * self.scrollView.frame.size.width;
    self.animating = YES;
    [UIView animateWithDuration:0.3 animations:^{
        [self.scrollView setContentOffset:CGPointMake(next, 0)];
    } completion:^(BOOL finished) {
        self.animating = NO;
    }];
}

- (IBAction)tapWeeeeei:(id)sender {
    if (self.pageControl.currentPage < 4) {
        [self next];
        return;
    }
    //画面切り替え
    WEWeeeeiViewController *weeeeei = [[WEWeeeeiViewController alloc] initWithNibName:@"WEWeeeeiViewController" bundle:nil];
    weeeeei.view.alpha = 0;
    [UIView animateWithDuration:0.15 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        WEAppDelegate *delegate = [UIApplication sharedApplication].delegate;
        delegate.window.rootViewController = weeeeei;
        [UIView animateWithDuration:0.15 animations:^{
            weeeeei.view.alpha = 1.0f;
        }];
    }];
}


- (IBAction)tapInviteLine:(id)sender {
    //LINE招待
}
@end
