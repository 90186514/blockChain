//
//  UserManager.m
//  Traffic
//
//  Created by Terry.c on 30/03/2017.
//  Copyright © 2017 Terry.c. All rights reserved.
//

#import "UserManager.h"


//dic key
NSString* const dataKey = @"userinfo.dic";

@implementation UserManager

+ (UserManager *)defaultCenter
{
    static UserManager *_sharedCenter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedCenter = [[UserManager alloc] init];
    });
    return _sharedCenter;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.userInfo = [[TMCache sharedCache] objectForKey:dataKey];
    }
    return self;
}

-(BOOL) isLogin {
    if (self.userInfo && self.userInfo.userid && ![self.userInfo.userid isEqualToString: @""]) {
        return YES;
    }
    return NO;
}

- (void)updateUserInfo:(LoginData *)userInfo
{
    if (userInfo) {
        self.userInfo = userInfo;
//        [[TMCache sharedCache] setObject:userInfo forKey:dataKey block:nil];
    }
}

- (void)delegateUserInfo
{
    //是否实名认证 0:未验证,1:已验证
    self.userInfo.valiidnumber = @"";
    //状态 1:正常，0:屏蔽
    self.userInfo.status = @"";
    self.userInfo.userid = @"";
    //是否已设置交易密码 0:否,1:是
    self.userInfo.istrpwd = @"";
    //google验证开关 0关，1开
    self.userInfo.safeverifyswitch = @"";
    //是否验证google密匙 0-否,1-是
    self.userInfo.valigooglesecret = @"";
    self.userInfo.googlesecret = @"";
    
    self.userInfo.username = @"";
    
    self.userInfo.nickname = @"";
    
    self.userInfo.idnumber = @"";
    self.userInfo.realname = @"";

    
//    [[TMCache sharedCache] setObject:self.userInfo forKey:dataKey block:nil];
}


-(LoginData*)getUserInfo {
    return self.userInfo;
}


- (void)logoutCurrentUser:(BOOL)showLogin
{
//    [UMessage removeAlias:[self.userInfo.uId stringValue] type:kUMessageAliasTypeQQ response:nil];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kLInfo];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPlayVideoWifiSwitch];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kNotificationSwitch];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    [[SFLibMessageClient sharedClient] loginOut:nil];
    _userInfo = nil;
//    [[TMCache sharedCache] removeObjectForKey:dataKey];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserNeedLogout object:nil];
//    if (showLogin) {
//        [LoginViewController showLoginView:nil];
//    }
}

-(NSString*)getUserName {
    if (self.userInfo) {
        return [NSString isEmpty:self.userInfo.realname]?@"未命名用户":self.userInfo.realname;
    } else {
        return @"未命名用户";
    }
}


-(BOOL)isSetTransPassword {
    if (self.userInfo) {
        return [@"1" isEqualToString:self.userInfo.istrpwd]?YES:NO;
    } else {
        return NO;
    }
}

-(BOOL)isSetGoogleVerify {
    if (self.userInfo) {
        return [@"1" isEqualToString:self.userInfo.valigooglesecret]?YES:NO;
    } else {
        return NO;
    }
}

-(BOOL)isUserValiidNumber {
    if (self.userInfo) {
        return [@"1" isEqualToString:self.userInfo.valiidnumber]?YES:NO;
    } else {
        return NO;
    }
}

@end
