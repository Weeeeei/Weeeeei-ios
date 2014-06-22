//
//  WEUser.m
//  Weeeeei
//
//  Created by matsumoto on 2014/06/21.
//  Copyright (c) 2014年 y-matsuwitter. All rights reserved.
//

#import "WEUser.h"
#import <Parse/Parse.h>

static NSString * const FollowingUserKey = @"following";

@interface WEUser ()
@property (nonatomic, strong) PFUser *userData;
@end

@implementation WEUser

- (NSString *)description
{
    return [self.userData description];
}

- (NSString *)userName
{
    return self.userData.username;
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
                [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
                                                                                      UIRemoteNotificationTypeAlert|
                                                                                      UIRemoteNotificationTypeSound];
                complete([WEUser userFromPFUser:user]);
            }else{
                complete(nil);
            }
        }];

    }];
}

+ (WEUser *)currentUser
{
    static WEUser *_sharedUser = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PFUser *user = [PFUser currentUser];
        _sharedUser = [WEUser userFromPFUser:user];
    });

    return _sharedUser;
}

+ (PFUser *)findPFUserByName:(NSString *)userName
{
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:userName];
    return (PFUser *)[query getFirstObject];
}

+ (WEUser *)findByUserName:(NSString *)userName
{
    return [WEUser userFromPFUser:[WEUser findPFUserByName:userName]];
}

+ (WEUser *)userFromPFUser:(PFUser *)user
{
    if (user == nil) {
        return nil;
    }
    WEUser *wUser = [WEUser new];
    wUser.userData = user;
    return wUser;
}

-(void)addFollowing:(NSString *)userName
{
    NSMutableArray *array = [[[NSUserDefaults standardUserDefaults] arrayForKey:FollowingUserKey] mutableCopy];
    if (array == nil) {
        array = [@[] mutableCopy];
    }
    if (![array containsObject:userName]) {
        [array addObject:userName];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:FollowingUserKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return;
}

- (void)removeFollowing:(NSString *)userName
{
    NSMutableArray *array = [[[NSUserDefaults standardUserDefaults] arrayForKey:FollowingUserKey] mutableCopy];
    if ([array containsObject:userName]) {
        [array removeObject:userName];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:FollowingUserKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return;
}

- (NSArray *)followingUserNames
{
    return [[NSUserDefaults standardUserDefaults] arrayForKey:FollowingUserKey];
}


- (void)addBlock:(NSString *)userName complete:(void (^)(void))complete
{
    [self blockObjectForUserName:userName complete:^(PFObject *block) {
        if (block) {
            complete();
            return;
        }
        PFObject *blockObject = [PFObject objectWithClassName:@"Block"];
        blockObject[@"username"] = userName;
        blockObject[@"user"] = self.userData;
        [blockObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            complete();
        }];
    }];
}

- (void)removeBlock:(NSString *)userName complete:(void (^)(void))complete
{
    [self blockObjectForUserName:userName complete:^(PFObject *block) {
        if (block) {
            [block deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                complete();
            }];
            return;
        }
        complete();
    }];
}

- (void)allBlockedUserWithComplete:(void (^)(NSArray *))complete
{
    PFQuery *query = [PFQuery queryWithClassName:@"Block"];
    [query whereKey:@"user" equalTo:self.userData];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSMutableArray *userNames = [@[] mutableCopy];
        for (int i = 0; i < [objects count]; i++) {
            PFObject *block = objects[i];
            [userNames addObject:block[@"username"]];
        }
        if (error) {
            complete(@[]);
        }else{
            complete(userNames);
        }
    }];
}

- (void)isBlockedFromUser:(NSString *)userName complete:(void (^)(BOOL))complete
{
    PFUser *user = [WEUser findPFUserByName:userName];
    if (!user) {
        complete(NO);
        return;
    }
    // TODO: find block object for user
    PFQuery *query = [PFQuery queryWithClassName:@"Block"];
    [query whereKey:@"user" equalTo:user];
    [query whereKey:@"username" equalTo:self.userName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            complete(NO);
        }else{
            complete([objects count] > 0);
        }
    }];
    return;
}

- (void)blockObjectForUserName:(NSString *)userName complete:(void (^)(PFObject *block))complete
{
    PFQuery *query = [PFQuery queryWithClassName:@"Block"];
    [query whereKey:@"user" equalTo:self.userData];
    [query whereKey:@"username" equalTo:userName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error || [objects count] == 0) {
            complete(nil);
        }else{
            complete([objects firstObject]);
        }
    }];
}

- (void)sendWeeeeeiToUserName:(NSString *)userName complete:(void (^)(BOOL))complete
{
    WEUser *target = [WEUser findByUserName:userName];
    if (target == nil) {
        complete(nil);
        return;
    }
    PFPush *push = [[PFPush alloc] init];
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSString stringWithFormat:@"%@: ｳｪｰｲ", self.userName], @"alert",
                          @"default", @"sound",
                          nil];
    [push setChannel:userName];
    [push setData:data];
    [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        complete(succeeded);
    }];
}

- (void)sendWeeeeeiToUser:(WEUser *)user complete:(void (^)(BOOL succeeded))complete
{
    [self sendWeeeeeiToUserName:user.userName complete:complete];
}
@end
