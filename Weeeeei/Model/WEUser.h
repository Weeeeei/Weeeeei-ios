//
//  WEUser.h
//  Weeeeei
//
//  Created by matsumoto on 2014/06/21.
//  Copyright (c) 2014年 y-matsuwitter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WEUser : NSObject

@property (nonatomic, readonly) NSString *userName;

/**
 *  create new user by username
 *
 *  @param userName NSString, non alphanumeric goes well
 *
 *  @return created WEUser
 */
+ (void)createWithUserName:(NSString *)userName complete:(void (^)(WEUser *user))complete;


/**
 *  get current login user
 *
 *  @return current WEUser
 */
+ (WEUser *)currentUser;

/**
 *  find user by its name
 *
 *  @param name username
 *
 *  @return found user
 */
+ (WEUser *)findByUserName:(NSString *)userName;

- (void)addFollowing:(NSString *)userName;
- (void)removeFollowing:(NSString *)userName;
- (NSArray *)followingUserNames;

- (void)addBlock:(NSString *)userName complete:(void (^)(void))complete;
- (void)removeBlock:(NSString *)userName complete:(void (^)(void))complete;
- (void)isBlockedFromUser:(NSString *)userName complete:(void (^)(BOOL blocked))complete;
- (void)allBlockedUserWithComplete:(void (^)(NSArray *blocked))complete;

- (void)sendWeeeeeiToUserName:(NSString *)userName complete:(void (^)(BOOL succeeded))complete;
- (void)sendWeeeeeiToUser:(WEUser *)user complete:(void (^)(BOOL succeeded))complete;
@end
