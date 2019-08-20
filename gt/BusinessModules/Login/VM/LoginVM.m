//
//  YBHomeDataCenter.m
//  Aa
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "LoginVM.h"
#import "AboutUsModel.h"
#import "RongCloudManager.h"
#import <UserNotifications/UserNotifications.h>
@interface LoginVM()

@property (strong,nonatomic)NSMutableArray   *listData;
@property (nonatomic,strong) LoginModel* model;
@property (nonatomic,strong) AboutUsModel* aboutUsModel;
@property (nonatomic, strong) NSDictionary* requestParams;
@end

@implementation LoginVM

- (void)network_rongCloudTemporaryTokenWithRequestParams:(id)requestParams
                                                 success:(DataBlock)success
                                                  failed:(DataBlock)failed
                                                   error:(DataBlock)err{
    
    //    if (requestParams == nil) {
    //
    //        [YKToastView showToastText:@"缺失userID"];
    //        return;
    //    }
    
    NSDictionary* proDic = @{
                             @"captchaValidate":requestParams
                             };
    
    [SVProgressHUD showWithStatus:@"加载中..."
                         maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager] postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_RongCloudTemporaryToken]
                                                      andType:All
                                                      andWith:proDic
                                                      success:^(NSDictionary *dic) {
                                                          
                                                          [SVProgressHUD dismiss];
                                                          
                                                          if ([NSString getDataSuccessed:dic]) {
                                                              
                                                              self.model = [LoginModel mj_objectWithKeyValues:dic];
                                                              
                                                              success(weakSelf.model);
                                                          }
                                                          else{
                                                              [YKToastView showToastText:self.model.msg];
                                                              failed(weakSelf.model);
                                                          }
                                                      } error:^(NSError *error) {
                                                          
                                                          [SVProgressHUD dismiss];
                                                          err(error);
                                                          [YKToastView showToastText:error.description];
                                                      }];
}


- (void)network_rongCloudTokenWithRequestParams:(id)requestParams
                                        success:(DataBlock)success
                                         failed:(DataBlock)failed
                                          error:(DataBlock)err {
//
//    if (requestParams==nil) {
//        [YKToastView showToastText:@"缺失userID"];
//        return;
//    }
    NSDictionary* proDic =@{
//                            @"captchaValidate":requestParams
                            
                            };
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_RongCloudToken]
                                                     andType:All
                                                     andWith:proDic
                                                     success:^(NSDictionary *dic) {
        
        self.model = [LoginModel mj_objectWithKeyValues:dic];
        [SVProgressHUD dismiss];
        
        if ([NSString getDataSuccessed:dic]) {
            success(weakSelf.model);
        }
        else{
            [YKToastView showToastText:self.model.msg];
            failed(weakSelf.model);
        }
    } error:^(NSError *error) {
        [SVProgressHUD dismiss];
        err(error);
        [YKToastView showToastText:error.description];
    }];
}

- (void)network_identityVertifyWithRequestParams:(NSString *)name
                                        idNumber:(NSString *)idNumber
                                           email:(NSString *)email
                                         idPhoto:(NSString *)idPhoto
                                         success:(DataBlock)success
                                          failed:(DataBlock)failed
                                           error:(DataBlock)err {
    NSDictionary* proDic =@{
                            @"name": name,
                            @"idNumber": idNumber,
                            @"email": email,
                            @"idPhoto":idPhoto == nil ? @"":idPhoto,
                            };
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_IdentityVertify]
                                                     andType:All
                                                     andWith:proDic
                                                     success:^(NSDictionary *dic) {
        self.model = [LoginModel mj_objectWithKeyValues:dic];
        [SVProgressHUD dismiss];
        [YKToastView showToastText:self.model.msg];
        if ([NSString getDataSuccessed:dic]) {
            success(weakSelf.model);
        }
        else{
            failed(weakSelf.model);
        }
    } error:^(NSError *error) {
        [SVProgressHUD dismiss];
        err(error);
        [YKToastView showToastText:error.description];
    }];
}

- (void)network_getLoginWithRequestParams:(id)requestParams
                                  success:(DataBlock)success
                                   failed:(DataBlock)failed
                                    error:(DataBlock)err {
    NSArray* model = requestParams;
    
    NSString* n =  model[0];
    NSString* p =  model[1];
    NSString* v =  model[2];
    
    NSDictionary* proDic =@{@"loginname":n,
                            @"pwd":p,
                            @"captchaValidate":v};
    
    proDic = [proDic vic_appendKey:@"registrationId" value:[JPUSHService registrationID]];
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_Login]
                                                     andType:All
                                                     andWith:proDic
                                                     success:^(NSDictionary *dic) {
        self.model = [LoginModel mj_objectWithKeyValues:dic];
        [SVProgressHUD dismiss];
        if ([NSString getDataSuccessed:dic]) {
            
            [self network_rongCloudTokenWithRequestParams:self.model.userinfo.userid success:^(id data) {
                
                LoginModel* rcdata = data;
                NSString* rcT = rcdata.rongyunToken!=nil?rcdata.rongyunToken:@"";
                [RongCloudManager loginWith:rcT success:^(NSString *userId) {
//                    [UserManager defaultCenter].userInfo.rongyunToken = response.rongyunToken;
                } error:^(RCConnectErrorCode status) {
                    
                } tokenIncorrect:^{
                    
                }];
            } failed:^(id data) {
                
            } error:^(id data) {
                
            }];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_IsLoginRefresh object:nil];
            if(![NSString isEmpty:self.model.msg]){
               [YKToastView showToastText:self.model.msg];
            }
            success(weakSelf.model);
        }
        else{
            [YKToastView showToastText:self.model.msg];
            failed(weakSelf.model);
        }
        
        
    } error:^(NSError *error) {
        [SVProgressHUD dismiss];
        err(error);
        [YKToastView showToastText:error.description];
    }];
}

- (void)network_getLoginVertifyWithRequestParams:(id)requestParams
                                         success:(DataBlock)success
                                          failed:(DataBlock)failed
                                           error:(DataBlock)err {
    NSDictionary* model = requestParams;
    NSString* n =  model.allKeys[0];
    NSString* p =  model.allValues[0];
    NSDictionary* proDic =@{@"code":n,@"type":p};
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_Vertify]
                                                     andType:All
                                                     andWith:proDic
                                                     success:^(NSDictionary *dic) {
        self.model = [LoginModel mj_objectWithKeyValues:dic];
        [SVProgressHUD dismiss];
        if ([NSString getDataSuccessed:dic]) {
            
            
            success(weakSelf.model);
        }
        else{
            failed(weakSelf.model);
        }
        [YKToastView showToastText:self.model.msg];
        
    } error:^(NSError *error) {
        [SVProgressHUD dismiss];
        err(error);
        [YKToastView showToastText:error.description];
    }];
    
}

- (void)network_getLoginOutWithRequestParams:(id)requestParams
                                     success:(DataBlock)success
                                      failed:(DataBlock)failed
                                       error:(DataBlock)err {
//    NSDictionary* model = requestParams;
    
    
//    NSString* n =  model.allKeys[0];
//    NSString* p =  model.allValues[0];
//    @"loginname":n,@"pwd":p
    
    NSDictionary* proDic =@{};
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_LoginOut]
                                                     andType:All
                                                     andWith:proDic
                                                     success:^(NSDictionary *dic) {
        self.model = [LoginModel mj_objectWithKeyValues:dic];
        [SVProgressHUD dismiss];
        if ([NSString getDataSuccessed:dic]) {
            SetUserBoolKeyWithObject(kIsLogin, NO);
//            SetUserDefaultKeyWithObject(kUserInfo, nil);
            DeleUserDefaultWithKey(kUserInfo);
            
            UserDefaultSynchronize;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_IsLoginOutRefresh object:nil];

            
            [JPUSHService setBadge:0];
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
            
            if (@available(iOS 10.0, *)) {
                [[UNUserNotificationCenter currentNotificationCenter]removeAllPendingNotificationRequests];
                // To remove all pending notifications which are not delivered yet but scheduled.
                [[UNUserNotificationCenter currentNotificationCenter] removeAllDeliveredNotifications]; // To remove all delivered notifications
            } else {
                [[UIApplication sharedApplication] cancelAllLocalNotifications];
            }
            
            success(weakSelf.model);
        }
        else{
            failed(weakSelf.model);
        }
        [YKToastView showToastText:self.model.msg];
        
    } error:^(NSError *error) {
        err(error);
        [SVProgressHUD dismiss];
        [YKToastView showToastText:error.description];
    }];
    
}
- (void)network_changeLoginPWWithRequestParams:(id)requestParams
                                       success:(DataBlock)success
                                        failed:(DataBlock)failed
                                         error:(DataBlock)err {
    
//    NSArray* req = requestParams !=nil?requestParams:@[@"",@"",@""];
//    NSDictionary* proDic =@{
//                            @"oldpwd": req[0],
//                            @"newpwd": req[1],
//                            @"confirmpwd": req[2],
//                            @"type": @"loginpwd"
//                            };
    
    NSArray* req = requestParams !=nil?requestParams:@[@"",@"",@"",@""];
    NSDictionary* proDic =@{
                            @"oldpwd": req[0],
                            @"newpwd": req[1],
                            @"confirmpwd": req[2],
                            @"googlecode": req[3],
                            @"type": @"loginpwd"
                            };
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_ChangeLoginPW]
                                                     andType:All
                                                     andWith:proDic
                                                     success:^(NSDictionary *dic) {
        self.model = [LoginModel mj_objectWithKeyValues:dic];
        [SVProgressHUD dismiss];
        [YKToastView showToastText:self.model.msg];
        if ([NSString getDataSuccessed:dic]) {
            
            success(weakSelf.model);
        }
        else{
            failed(weakSelf.model);
        }
    } error:^(NSError *error) {
        [SVProgressHUD dismiss];
        err(error);
        [YKToastView showToastText:error.description];
    }];
}
- (void)network_changeFundPWWithRequestParams:(id)requestParams
                                      success:(DataBlock)success
                                       failed:(DataBlock)failed
                                        error:(DataBlock)err {
    
    NSArray* req = requestParams !=nil?requestParams:@[@"",@"",@""];
    NSDictionary* proDic =@{
                            @"newpwd": req[0],
                            @"confirmpwd": req[1],
                            @"googlecode": req[2],
                            @"type": @"tradepwd"
                            };
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_ChangeFundPW]
                                                     andType:All
                                                     andWith:proDic
                                                     success:^(NSDictionary *dic) {
        self.model = [LoginModel mj_objectWithKeyValues:dic];
        [SVProgressHUD dismiss];
        [YKToastView showToastText:self.model.msg];
        if ([NSString getDataSuccessed:dic]) {
            
            success(weakSelf.model);
        }
        else{
            failed(weakSelf.model);
        }
    } error:^(NSError *error) {
        [SVProgressHUD dismiss];
        err(error);
        [YKToastView showToastText:error.description];
    }];
}

- (void)network_settingFundPWWithRequestParams:(id)requestParams
                                       success:(DataBlock)success
                                        failed:(DataBlock)failed
                                         error:(DataBlock)err {
    
    NSArray* req = requestParams !=nil?requestParams:@[@"",@""];
    NSDictionary* proDic =@{
//                            @"nickName": req[0],
                            @"pwd": req[0],
                            @"confirmpwd": req[1],
                            };
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_SettingFundPW]
                                                     andType:All
                                                     andWith:proDic
                                                     success:^(NSDictionary *dic) {
        self.model = [LoginModel mj_objectWithKeyValues:dic];
        [SVProgressHUD dismiss];
        [YKToastView showToastText:self.model.msg];
        if ([NSString getDataSuccessed:dic]) {
            
            success(weakSelf.model);
        }
        else{
            failed(weakSelf.model);
        }
    } error:^(NSError *error) {
        [SVProgressHUD dismiss];
        err(error);
        [YKToastView showToastText:error.description];
    }];
}
- (void)network_inSecuritySettingCheckUserInfoWithRequestParams:(id)requestParams
                                                        success:(TwoDataBlock)success
                                                         failed:(DataBlock)failed
                                                          error:(DataBlock)err {
    _listData = [NSMutableArray array];
    NSDictionary* proDic =@{};
    
        [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_CheckUserInfo]
                                                     andType:All
                                                     andWith:proDic
                                                     success:^(NSDictionary *dic) {
        self.model = [LoginModel mj_objectWithKeyValues:dic];
        [SVProgressHUD dismiss];
        
        if ([NSString getDataSuccessed:dic]) {
            
            SetUserDefaultKeyWithObject(kUserInfo, [self.model mj_keyValues]);
            UserDefaultSynchronize;
            
            [RongCloudManager updateNickName:self.model.userinfo.nickname
                                      userId:self.model.userinfo.userid];
            
            [self assembleApiData:weakSelf.model.userinfo];
            success(weakSelf.listData,weakSelf.model);
            //            success(weakSelf.model);
        }
        else{
            [YKToastView showToastText:self.model.msg];
            failed(weakSelf.model);
        }
    } error:^(NSError *error) {
        [SVProgressHUD dismiss];
        [YKToastView showToastText:error.description];
        err(error);
        
    }];
}

- (void)network_checkUserInfoWithRequestParams:(id)requestParams
                                       success:(TwoDataBlock)success
                                        failed:(DataBlock)failed
                                         error:(DataBlock)err {
    _listData = [NSMutableArray array];
    NSDictionary* proDic =@{};
    
//    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_CheckUserInfo]
                                                     andType:All
                                                     andWith:proDic
                                                     success:^(NSDictionary *dic) {
        self.model = [LoginModel mj_objectWithKeyValues:dic];
        [SVProgressHUD dismiss];
        
        if ([NSString getDataSuccessed:dic]) {
           
            SetUserDefaultKeyWithObject(kUserInfo, [self.model mj_keyValues]);
            UserDefaultSynchronize;
            
            [RongCloudManager updateNickName:self.model.userinfo.nickname
                                      userId:self.model.userinfo.userid];
            
            [self assembleApiData:weakSelf.model.userinfo];
            success(weakSelf.listData,weakSelf.model);
//            success(weakSelf.model);
        }
        else{
            [YKToastView showToastText:self.model.msg];
            failed(weakSelf.model);
        }
    } error:^(NSError *error) {
        [SVProgressHUD dismiss];
        [YKToastView showToastText:error.description];
        err(error);
        
    }];
}
- (void)assembleApiData:(LoginData*)data{
    
    [self removeContentWithType:IndexSectionZero];
    
    NSDictionary* dic0 = @{
                           kTip:@"实名认证",
                           kSubTip:@"姓名 | 身份证号",
                           kData:[NSString stringWithFormat:@"交易额度：每日%@元",data.idNumberAmount],
                           
                           kIndexSection:@(IndexSectionZero),
                           
                           kType:@([data getIdentityAuthType:data.valiidnumber]),
                           kIndexInfo:[data getIdentityAuthTypeName:[data getIdentityAuthType:data.valiidnumber]]
//                           kType:@(IdentityAuthTypeHandling),
//                           kIndexInfo:@{ @"审核中":@"user_auth_handling"}
                           };
    [self.listData addObject:@[dic0]];
    
    [self removeContentWithType:IndexSectionOne];
    NSDictionary* dic1 = @{
                           kTip:@"高级认证",
                           kSubTip:[data getIdentityAuthType:data.isSeniorCertification] ==SeniorAuthTypeUndone? @"尚未通过人脸视频认证":@"已通过人脸视频认证",
                           kData:[NSString stringWithFormat:@"交易额度：每日%@元",data.seniorCertificationAmount],
                           
                           kIndexSection:@(IndexSectionOne),
                           
                           kType:@([data getSeniorAuthType:data.isSeniorCertification]),
                           kIndexInfo:[data getSeniorAuthTypeName:[data getSeniorAuthType:data.isSeniorCertification]]
//                           kType:@(IdentityAuthTypeFinished),
//                           kIndexInfo:@{@"认证成功":@"user_auth_finished"}
                           };
    
    [self.listData addObject:@[dic1]];
    [self sortData];
}

- (void)network_getChangeNicknameWithRequestParams:(id)requestParams
                                           success:(DataBlock)success
                                            failed:(DataBlock)failed
                                             error:(DataBlock)err {
    
    NSString* n =  requestParams;
    
    NSDictionary* proDic =@{@"nickname":n};
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_ChangeNickname]
                                                     andType:All
                                                     andWith:proDic
                                                     success:^(NSDictionary *dic) {
        self.model = [LoginModel mj_objectWithKeyValues:dic];
        [SVProgressHUD dismiss];
        if ([NSString getDataSuccessed:dic]) {
           
            success(weakSelf.model);
        }
        else{
            [YKToastView showToastText:self.model.msg];
            failed(weakSelf.model);
        }
        
    } error:^(NSError *error) {
        [SVProgressHUD dismiss];
        err(error);
        [YKToastView showToastText:error.description];
    }];
}
- (void)network_getRegisterWithRequestParams:(id)requestParams
                                     success:(DataBlock)success
                                      failed:(DataBlock)failed
                                       error:(DataBlock)err {
    
    NSArray* model = requestParams != nil ? requestParams:@[@"",@"",@"",@""];
    
    NSString* n =  model[0];
    NSString* p =  model[1];
    NSString* p2 = model[2];
    NSString* v =  model[3];
    NSDictionary* proDic =@{@"userName":n,
                            @"password":p,
                            @"confirmpassword":p2,
                            @"captchaValidate":v};
    proDic = [proDic vic_appendKey:@"registrationId" value:[JPUSHService registrationID]];
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_Register]
                                                     andType:All
                                                     andWith:proDic
                                                     success:^(NSDictionary *dic) {
        [SVProgressHUD dismiss];
        self.model = [LoginModel mj_objectWithKeyValues:dic];
        if ([NSString getDataSuccessed:dic]) {
            
            [self network_rongCloudTokenWithRequestParams:self.model.userid success:^(id data) {

                LoginModel* rcdata = data;
                NSString* rcT = rcdata.rongyunToken!=nil?rcdata.rongyunToken:@"";
                [RongCloudManager loginWith:rcT success:^(NSString *userId) {
                    //                    [UserManager defaultCenter].userInfo.rongyunToken = response.rongyunToken;
                } error:^(RCConnectErrorCode status) {

                } tokenIncorrect:^{

                }];
            } failed:^(id data) {

            } error:^(id data) {

            }];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_IsLoginRefresh object:nil];
            if(![NSString isEmpty:self.model.msg]){
                
                [YKToastView showToastText:self.model.msg];
            }
            success(weakSelf.model);
        }
        else{
            [YKToastView showToastText:self.model.msg];
            failed(weakSelf.model);
        }
        
        
    } error:^(NSError *error) {
        [SVProgressHUD dismiss];
        err(error);
        [YKToastView showToastText:error.description];
    }];
    
}

- (void)network_myTransferCodeWithRequestParams:(id)requestParams
                                        success:(DataBlock)success
                                         failed:(DataBlock)failed
                                          error:(DataBlock)err {
    NSDictionary* proDic =@{};
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_MyTransferCode]
                                                     andType:All
                                                     andWith:proDic success:^(NSDictionary *dic) {
                                                         
        self.aboutUsModel = [AboutUsModel mj_objectWithKeyValues:dic];
        [SVProgressHUD dismiss];
        if ([NSString getDataSuccessed:dic]) {
            success(weakSelf.aboutUsModel);
        }
        else{
            [YKToastView showToastText:self.aboutUsModel.msg];
            failed(weakSelf.model);
        }
    } error:^(NSError *error) {
        [SVProgressHUD dismiss];
        [YKToastView showToastText:error.description];
        err(error);
        
    }];
    
}

- (void)network_aboutUsWithRequestParams:(id)requestParams
                                 success:(DataBlock)success
                                  failed:(DataBlock)failed
                                   error:(DataBlock)err {
    
    NSDictionary* proDic =@{@"versionname":[YBSystemTool appVersion],
                            @"clientcfg":[YBSystemTool appSource]};
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_AboutUs]
                                                     andType:All
                                                     andWith:proDic success:^(NSDictionary *dic) {
        self.aboutUsModel = [AboutUsModel mj_objectWithKeyValues:dic];
        [SVProgressHUD dismiss];
        if ([NSString getDataSuccessed:dic]) {
            success(weakSelf.aboutUsModel);
        }
        else{
            [YKToastView showToastText:self.aboutUsModel.msg];
            failed(weakSelf.model);
        }
    } error:^(NSError *error) {
        [SVProgressHUD dismiss];
        [YKToastView showToastText:error.description];
        err(error);
        
    }];
}

- (void)network_helpCentreWithRequestParams:(id)requestParams
                                    success:(DataBlock)success
                                     failed:(DataBlock)failed
                                      error:(DataBlock)err {
    NSDictionary* proDic =@{};
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_HelpCentre]
                                                     andType:All
                                                     andWith:proDic
                                                     success:^(NSDictionary *dic) {
                                                         
        self.aboutUsModel = [AboutUsModel mj_objectWithKeyValues:dic];
        [SVProgressHUD dismiss];
        if ([NSString getDataSuccessed:dic]) {
            success(weakSelf.aboutUsModel);
        }
        else{
            [YKToastView showToastText:self.model.msg];
            failed(weakSelf.model);
        }
    } error:^(NSError *error) {
        [SVProgressHUD dismiss];
        [YKToastView showToastText:error.description];
        err(error);
        
    }];
    
}
//sections data not rows data
- (void)sortData {
    [self.listData sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSArray* arr1 = obj1;
        NSArray* arr2 = obj2;
        NSNumber *number1 = [NSNumber numberWithInteger:[[arr1.firstObject objectForKey:kIndexSection] integerValue]];
        NSNumber *number2 = [NSNumber numberWithInteger:[[arr2.firstObject objectForKey:kIndexSection] integerValue]];
        
        NSComparisonResult result = [number1 compare:number2];
        
        return result == NSOrderedDescending;
    }];
}

- (void)removeContentWithType:(IndexSectionType)type {
    [self.listData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSArray* arr = obj;
        IndexSectionType contentType = [[(NSDictionary *)arr.firstObject objectForKey:kIndexSection] integerValue];
        if (contentType == type) {
            *stop = YES;
            [self.listData removeObject:obj];
        }
    }];
}

@end
