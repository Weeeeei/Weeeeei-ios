//
//  WEUser.m
//  Weeeeei
//
//  Created by matsumoto on 2014/06/21.
//  Copyright (c) 2014年 y-matsuwitter. All rights reserved.
//

#import "WEUser.h"
#import <Parse/Parse.h>

static NSString * const DummyPassword = @"";

@interface WEUser ()
@property (nonatomic, strong) PFUser *userData;
@end

@implementation WEUser

- (NSString *)description
{
    return [self.userData description];
}

+ (void)createWithUserName:(NSString *)userName complete:(void (^)(WEUser *))complete
{
    [PFAnonymousUtils logInWithBlock:^(PFUser *user, NSError *error) {
        if (error != nil) {
            complete(nil);
            return;
        }
        user.username = userName;
        
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                complete([WEUser userFromPFUser:user]);
            }else{
                complete(nil);
            }
        }];

    }];
}

+ (WEUser *)currentUser
{
    PFUser *user = [PFUser currentUser];
    return [WEUser userFromPFUser:user];
}

+ (WEUser *)findByUserName:(NSString *)userName
{
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:userName];
    PFUser *user = (PFUser *)[query getFirstObject];
    return [WEUser userFromPFUser:user];
}

+ (WEUser *)userFromPFUser:(PFUser *)user
{
    WEUser *wUser = [WEUser new];
    wUser.userData = user;
    return wUser;
    
}
@end
