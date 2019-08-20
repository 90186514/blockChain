
//
//  PaymentAccountVM.m
//  gt
//
//  Created by Aalto on 2019/2/1.
//  Copyright © 2019 GT. All rights reserved.
//

#import "PaymentAccountVM.h"
#import "PaymentAccountModel.h"
@interface PaymentAccountVM()

@property (strong,nonatomic)NSMutableArray   *listData;
@property (nonatomic,strong) PaymentAccountModel* model;

@property (nonatomic, strong) NSDictionary* requestParams;
@end
@implementation PaymentAccountVM
- (void)network_accountListRequestParams:(id)requestParams  success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err{
    NSDictionary* proDic =
    @{
      };
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_PayMentAccountList] andType:All andWith:proDic success:^(NSDictionary *dic) {
        self.model = [PaymentAccountModel mj_objectWithKeyValues:dic];
        [SVProgressHUD dismiss];
        
        if ([NSString getDataSuccessed:dic]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_IsPayCellInPostAdsRefresh object:nil ];
            success(weakSelf.model.paymentWay);
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

- (void)network_switchAccountRequestParams:(id)requestParams withOpenStatus:(id)status  success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err{
    NSDictionary* proDic =
    @{@"paymentWayId":requestParams,
      @"status":status
      };
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_EditAccount] andType:All andWith:proDic success:^(NSDictionary *dic) {
        self.model = [PaymentAccountModel mj_objectWithKeyValues:dic];
        [SVProgressHUD dismiss];
        
        if ([NSString getDataSuccessed:dic]) {
            [YKToastView showToastText:self.model.msg];
            success(weakSelf.model.paymentWay);
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
- (void)network_deleteAccountRequestParams:(id)requestParams  success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err{
    NSDictionary* proDic =
    @{@"paymentWayId":requestParams
      };
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_DeleteAccount] andType:All andWith:proDic success:^(NSDictionary *dic) {
        self.model = [PaymentAccountModel mj_objectWithKeyValues:dic];
        [SVProgressHUD dismiss];
        
        if ([NSString getDataSuccessed:dic]) {
            success(weakSelf.model.paymentWay);
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

- (void)network_addAccountRequestParams:(NSString *)paymentWay name:(NSString *)name account:(NSString *)account remark:(NSString *)remark tradePwd:(NSString *)tradePwd QRCode:(NSString *)QRCode accountOpenBank:(NSString *)accountOpenBank accountOpenBranch:(NSString *)accountOpenBranch accountBankCard:(NSString *)accountBankCard accountBankCardRepeat:(NSString *)accountBankCardRepeat  success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err {
    NSDictionary* proDic =
    @{
      @"paymentWay": paymentWay,
      @"name": name,
      @"account": account,
      @"remark": remark,
      @"tradePwd": tradePwd,
      
      @"QRCode": QRCode == nil ? @"" : QRCode,
      
      @"accountOpenBank": accountOpenBank,
      @"accountOpenBranch": accountOpenBranch,
      @"accountBankCard": accountBankCard,
      @"accountBankCardRepeat": accountBankCardRepeat,
      
      };
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_AddAccount] andType:All andWith:proDic success:^(NSDictionary *dic) {
        self.model = [PaymentAccountModel mj_objectWithKeyValues:dic];
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
