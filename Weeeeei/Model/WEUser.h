//
//  WEUser.h
//  Weeeeei
//
//  Created by matsumoto on 2014/06/21.
//  Copyright (c) 2014年 y-matsuwitter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WEUser : NSObject

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

@end
