//
//  GoogleSecretVM.m
//  gt
//
//  Created by GT on 2019/1/30.
//  Copyright © 2019 GT. All rights reserved.
//

#import "GoogleSecretVM.h"
#import "GoogleSecretModel.h"
@interface GoogleSecretVM()
@property(nonatomic,strong)GoogleSecretModel* model;
@end
@implementation GoogleSecretVM
- (void)network_getGoogleSecretWithRequestParams:(id)requestParams success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err {
    
    NSDictionary* proDic =@{
                            @"name": requestParams
                            };
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_GoogleSecret] andType:All andWith:proDic success:^(NSDictionary *dic) {
        self.model = [GoogleSecretModel mj_objectWithKeyValues:dic];
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

- (void)network_bindingGoogleWithRequestParams:(id)requestParams success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err {
    
    NSArray* req = requestParams;
    NSDictionary* proDic =@{
                            @"googlesecret": req[0],
                            @"googlecode":req[1]
                            };
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_BindingGoogle] andType:All andWith:proDic success:^(NSDictionary *dic) {
        self.model = [GoogleSecretModel mj_objectWithKeyValues:dic];
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
        [YKToastView showToastText:error.description];
        err(error);
    }];
}

- (void)network_dismissGoogleWithRequestParams:(id)requestParams success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err {
    NSDictionary* dic = requestParams;
    NSDictionary* proDic =
    @{
      @"transactionPassword":dic.allKeys[0],
      @"googlecode":dic.allValues[0]
      };
//    NSDictionary* proDic =@{
//
//                            @"code":requestParams
//                            };
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_DismissGoogle] andType:All andWith:proDic success:^(NSDictionary *dic) {
        self.model = [GoogleSecretModel mj_objectWithKeyValues:dic];
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
        [YKToastView showToastText:error.description];
        err(error);
    }];
}

- (void)network_switchGoogleWithRequestParams:(id)requestParams withInputCodeDic:(NSDictionary*)codeDic success:(DataBlock)success  failed:(DataBlock)failed error:(DataBlock)err {
    
    NSDictionary* proDic = @{};
    if ([codeDic isEqual:@{}]) {
        proDic =@{
                  @"optype":@"1",
                  @"opstatus":requestParams
                  };
        
    }else{
        proDic =@{
                  @"optype":@"1",
                  @"opstatus":requestParams,
                  @"transactionPassword":codeDic.allKeys[0],
                  @"googlecode":codeDic.allValues[0]
                  };
    }
    
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_SwitchGoogle] andType:All andWith:proDic success:^(NSDictionary *dic) {
        self.model = [GoogleSecretModel mj_objectWithKeyValues:dic];
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
        [YKToastView showToastText:error.description];
        err(error);
    }];
}
@end
