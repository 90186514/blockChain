//
//  UserManager.h
//  Traffic
//
//  Created by Terry.c on 30/03/2017.
//  Copyright © 2017 Terry.c. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginModel.h"

@interface UserManager : NSObject

//@property (nonatomic, readonly, assign) BOOL isLogined;
@property (nonatomic, copy) LoginData *userInfo;

@property (nonatomic, assign) float asset; //资产
@property (nonatomic, assign) float assetCNY; //折合人民币
@property (nonatomic, strong) NSString * accountAddress; //

/**
 *  单例模式
 *
 *  @return 返回单例实例
 */
+ (UserManager *)defaultCenter;

-(BOOL) isLogin;

- (void)updateUserInfo:(LoginData *)userInfo;

-(LoginData*)getUserInfo;

- (void)logoutCurrentUser:(BOOL)showLogin;

-(NSString*)getUserName;

//是否设置交易密码
-(BOOL)isSetTransPassword;

//是否开启谷歌验证
-(BOOL)isSetGoogleVerify;

//是否实名认证
-(BOOL)isUserValiidNumber;

- (void)delegateUserInfo;

@end
