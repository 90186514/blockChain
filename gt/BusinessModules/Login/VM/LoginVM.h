//
//  YBHomeDataCenter.h
//  Aa
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LoginVM : NSObject


- (void)network_rongCloudTemporaryTokenWithRequestParams:(id)requestParams
                                                 success:(DataBlock)success
                                                  failed:(DataBlock)failed
                                                   error:(DataBlock)err;

- (void)network_rongCloudTokenWithRequestParams:(id)requestParams
                                        success:(DataBlock)success
                                         failed:(DataBlock)failed
                                          error:(DataBlock)err;

- (void)network_identityVertifyWithRequestParams:(NSString *)name
                                        idNumber:(NSString *)idNumber
                                           email:(NSString *)email
                                         idPhoto:(NSString *)idPhoto
                                         success:(DataBlock)success
                                          failed:(DataBlock)failed
                                           error:(DataBlock)err;

- (void)network_getLoginWithRequestParams:(id)requestParams
                                  success:(DataBlock)success
                                   failed:(DataBlock)failed
                                    error:(DataBlock)err;

- (void)network_getLoginVertifyWithRequestParams:(id)requestParams
                                         success:(DataBlock)success
                                          failed:(DataBlock)failed
                                           error:(DataBlock)err;

- (void)network_getLoginOutWithRequestParams:(id)requestParams
                                     success:(DataBlock)success
                                      failed:(DataBlock)failed
                                       error:(DataBlock)err;

- (void)network_getChangeNicknameWithRequestParams:(id)requestParams
                                           success:(DataBlock)success
                                            failed:(DataBlock)failed
                                             error:(DataBlock)err;

- (void)network_changeLoginPWWithRequestParams:(id)requestParams
                                       success:(DataBlock)success
                                        failed:(DataBlock)failed
                                         error:(DataBlock)err;

- (void)network_changeFundPWWithRequestParams:(id)requestParams
                                      success:(DataBlock)success
                                       failed:(DataBlock)failed
                                        error:(DataBlock)err;

- (void)network_settingFundPWWithRequestParams:(id)requestParams
                                       success:(DataBlock)success
                                        failed:(DataBlock)failed
                                         error:(DataBlock)err;

- (void)network_inSecuritySettingCheckUserInfoWithRequestParams:(id)requestParams
                                                        success:(TwoDataBlock)success
                                                         failed:(DataBlock)failed
                                                          error:(DataBlock)err;

- (void)network_checkUserInfoWithRequestParams:(id)requestParams
                                       success:(TwoDataBlock)success
                                        failed:(DataBlock)failed
                                         error:(DataBlock)err;

- (void)network_getRegisterWithRequestParams:(id)requestParams
                                     success:(DataBlock)success
                                      failed:(DataBlock)failed
                                       error:(DataBlock)err;


- (void)network_myTransferCodeWithRequestParams:(id)requestParams
                                        success:(DataBlock)success
                                         failed:(DataBlock)failed
                                          error:(DataBlock)err;

- (void)network_aboutUsWithRequestParams:(id)requestParams
                                 success:(DataBlock)success
                                  failed:(DataBlock)failed
                                   error:(DataBlock)err;

- (void)network_helpCentreWithRequestParams:(id)requestParams
                                    success:(DataBlock)success
                                     failed:(DataBlock)failed
                                      error:(DataBlock)err;

@end

NS_ASSUME_NONNULL_END
