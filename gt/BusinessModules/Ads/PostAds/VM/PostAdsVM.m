//
//  YBHomeDataCenter.m
//  Aa
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "PostAdsVM.h"
#import "ModifyAdsModel.h"
@interface PostAdsVM()
@property (strong,nonatomic)NSMutableArray   *listData;

@property (nonatomic,strong) PostAdsModel* model;
@property (nonatomic, strong) id requestParams;
@end

@implementation PostAdsVM
- (void)network_sendAdsListWithNumber:(NSString *)number amountType:(NSString *)amountType limitMax:(NSString *)limitMax limitMin:(NSString *)limitMin fixedNumber:(NSString *)fixedNumber price:(NSString *)price type:(NSString *)type pamentWay:(NSString *)pamentWay coinId:(NSString *)coinId coinType:(NSString *)coinType prompt:(NSString *)prompt autoReplyContent:(NSString *)autoReplyContent isIDNumber:(NSString *)isIdNumber isSeniorCertification:(NSString *)isSeniorCertification  transactionPassword:(NSString *)transactionPassword googlesecret:(NSString *)googlesecret ugAdID:(NSString*)ugAdID success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err {
    _listData = [NSMutableArray array];
    NSDictionary* proDic = @{};
    if (![NSString isEmpty:ugAdID]) {
       proDic  = @{
                                @"number": number,
                                @"amountType": amountType,
                                @"limitMaxAmount": limitMax,
                                @"limitMinAmount": limitMin,
                                @"fixedAmount": fixedNumber == nil ? @"" :fixedNumber,
                                @"price": price,
                                @"type": type,
                                @"pamentWay": pamentWay,
                                @"coinId": coinId,
                                @"coinType": coinType,
                                @"prompt": prompt,
                                @"autoReplyContent": autoReplyContent,
                                @"isIdNumber": isIdNumber,
                                @"isSeniorCertification": isSeniorCertification,
                                @"transactionPassword": transactionPassword,
                                @"googlecode": googlesecret,
                                
                                @"advertId":ugAdID
                                };
    }else{
     proDic =@{
                            @"number": number,
                            @"amountType": amountType,
                            @"limitMaxAmount": limitMax,
                            @"limitMinAmount": limitMin,
                            @"fixedAmount": fixedNumber == nil ? @"" :fixedNumber,
                            @"price": price,
                            @"type": type,
                            @"pamentWay": pamentWay,
                            @"coinId": coinId,
                            @"coinType": coinType,
                            @"prompt": prompt,
                            @"autoReplyContent": autoReplyContent,
                            @"isIdNumber": isIdNumber,
                            @"isSeniorCertification": isSeniorCertification,
                            @"transactionPassword": transactionPassword,
                            @"googlecode": googlesecret,
                            };
    }
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:![NSString isEmpty:ugAdID]?ApiType_ModifyAds:ApiType_PostAds] andType:All andWith:proDic success:^(NSDictionary *dic) {
        weakSelf.model = [PostAdsModel mj_objectWithKeyValues:dic];
        [SVProgressHUD dismiss];
        if ([NSString getDataSuccessed:dic]) {
            success(weakSelf.model);
//            [self assembleApiData:weakSelf.model];
//            success(weakSelf.listData);
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

- (void)network_getPostAdsListWithPage:(NSInteger)page WithRequestParams:(id)requestParams success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err {
    
    _requestParams = requestParams;
    _listData = [NSMutableArray array];
    
    NSDictionary* proDic =@{};
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_PostAdsCheck] andType:All andWith:proDic success:^(NSDictionary *dic) {
        weakSelf.model = [PostAdsModel mj_objectWithKeyValues:dic];
        [SVProgressHUD dismiss];
        if ([NSString getDataSuccessed:dic]) {
//            success(weakSelf.model);
            [self assembleApiData:weakSelf.model];
            success(weakSelf.listData);
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

- (void)assembleApiData:(PostAdsModel*)model{
    PostAdsType  postAdsType = PostAdsTypeCreate;
    ModifyAdsModel* modifyAdsModel = nil;
    if ([self.requestParams isKindOfClass:[NSNumber class]]) {
        modifyAdsModel = nil;
        postAdsType = PostAdsTypeCreate;
    }else{
        modifyAdsModel = self.requestParams;
        postAdsType = PostAdsTypeEdit;
    }
    
    
    [self removeContentWithType:IndexSectionZero];
//    if (data.r !=nil && data.r.arr.count>0) {
        [self.listData addObject:@{
                   kIndexSection: @(IndexSectionZero),
                   kIndexRow: @[@"1"]}];//@[data.r]
//    }
    
    [self removeContentWithType:IndexSectionOne];
    
    NSArray  *prices = [NSArray array];
    if ([model.price containsString:@","]) {
        prices = [model.price componentsSeparatedByString:@","];
    }else{
        prices = @[model.price];
    }
    
    NSArray  *optionPrices = [NSArray array];
    if ([model.optionPrice containsString:@","]) {
        optionPrices = [model.optionPrice componentsSeparatedByString:@","];
    }else{
        optionPrices = @[model.optionPrice,@""];
    }
   
    NSArray  *prompt = [NSArray array];
    if ([model.prompt containsString:@","]) {
        prompt = [model.prompt componentsSeparatedByString:@","];
    }else{
        prompt = @[model.prompt,@""];
    }
SetUserDefaultKeyWithObject(kControlNumberInPostAds,model.number);
    SetUserDefaultKeyWithObject(kControlTimeInPostAds,prompt);
//    NSArray* prices = @[@"10",@"200",@"100",@"1000",@"11999"];
    //        NSArray * array = [NSArray arrayWithArray:mutableArray];
    
    if (postAdsType == PostAdsTypeCreate) {
      SetUserDefaultKeyWithObject(kLimitAccountsInPostAds,optionPrices);
        SetUserDefaultKeyWithObject(kFixedAccountsInPostAds,prices);
        SetUserDefaultKeyWithObject(kFixedAccountsSelectedItemInPostAds, @"");
        NSArray* nts = @[@"",@""];
        SetUserDefaultKeyWithObject(kNumberAndTimeInPostAds,nts);
        
        SetUserDefaultKeyWithObject(kPaymentWaysInPostAds, model.paymentWay);
    }else{
        if (modifyAdsModel!=nil) {
            TransactionAmountType amountType = [modifyAdsModel.amountType intValue];
            if (amountType == TransactionAmountTypeLimit) {
               optionPrices = @[modifyAdsModel.limitMinAmount,modifyAdsModel.limitMaxAmount]; SetUserDefaultKeyWithObject(kLimitAccountsInPostAds,optionPrices);
                SetUserDefaultKeyWithObject(kFixedAccountsInPostAds,prices);
                SetUserDefaultKeyWithObject(kFixedAccountsSelectedItemInPostAds, @"");
                NSArray* nts = @[modifyAdsModel.number,modifyAdsModel.prompt];
                SetUserDefaultKeyWithObject(kNumberAndTimeInPostAds,nts);
            }else if (amountType == TransactionAmountTypeFixed){
                SetUserDefaultKeyWithObject(kLimitAccountsInPostAds,optionPrices);
                SetUserDefaultKeyWithObject(kFixedAccountsInPostAds,prices);
                SetUserDefaultKeyWithObject(kFixedAccountsSelectedItemInPostAds, modifyAdsModel.fixedAmount);
                NSArray* nts = @[modifyAdsModel.number,modifyAdsModel.prompt];
                SetUserDefaultKeyWithObject(kNumberAndTimeInPostAds,nts);
            }
        }
    }
    
//    UserDefaultSynchronize;
    
    [self.listData addObject:@{
                               kIndexSection: @(IndexSectionOne),
                               kIndexRow: @[
                                       
                                       @{@(postAdsType) :
                                             (postAdsType == PostAdsTypeEdit&&modifyAdsModel!=nil)?@([modifyAdsModel.amountType intValue]-1) :@(0)
                                             }
//                                    @{kIndexInfo:
//                                      
//                                    @{
//                                     kType:(postAdsType == PostAdsTypeCreate)?@"0":@"1",
//                                      kIsOn:(postAdsType == PostAdsTypeEdit&&modifyAdsModel!=nil)?@"1":@"0",
//                                      kData:modifyAdsModel,
//                                      kArr:prices,
//                                      kTit:optionPrices
//                                      }
//                                     }
                                            ]
                                     
                                     }];
    
    
    [self removeContentWithType:IndexSectionTwo];
    
    NSMutableArray *pays = [NSMutableArray arrayWithCapacity:3];
    
    NSArray* payDics = @[];
    
    NSString* isOnWX = @"";
    NSString* isOnZFB = @"";
    NSString* isOnCard = @"";
    if (postAdsType == PostAdsTypeCreate) {
//        isOnWX = @"0";
//        isOnZFB = @"0";
//        isOnCard = @"0";
        isOnWX = [model.paymentWay containsString:@"1"]?@"1":@"0";
        isOnZFB = [model.paymentWay containsString:@"2"]?@"1":@"0";
        isOnCard = [model.paymentWay containsString:@"3"]?@"1":@"0";
    }else{
        isOnWX = [modifyAdsModel.paymentway containsString:@"1"]?@"1":@"0";
        isOnZFB = [modifyAdsModel.paymentway containsString:@"2"]?@"1":@"0";
        isOnCard = [modifyAdsModel.paymentway containsString:@"3"]?@"1":@"0";
    }
    
    payDics = @[
                @{@"1":isOnWX},
                @{@"2":isOnZFB},
                @{@"3":isOnCard}
                ];
    NSDictionary* dic1 = @{kImg:@"icon_weixin",kTip:@"微信",kType:@"1",kIsOn:isOnWX};
    NSDictionary* dic2 = @{kImg:@"icon_zhifubao",kTip:@"支付宝",kType:@"2",kIsOn:isOnZFB};
    NSDictionary* dic3 = @{kImg:@"icon_bank",kTip:@"银行卡",kType:@"3",kIsOn:isOnCard};
    [pays addObjectsFromArray:@[dic1,dic2,dic3]];
    
    SetUserDefaultKeyWithObject(kPayMethodesInPostAds,payDics);
    
//    NSArray* checkPayDics = @[];
//    NSString* isOnW = [model.paymentWay containsString:@"1"]?@"1":@"0";
//    NSString* isOnZ = [model.paymentWay containsString:@"2"]?@"1":@"0";
//    NSString* isOnC = [model.paymentWay containsString:@"3"]?@"1":@"0";
//    checkPayDics = @[
//                @{@"1":isOnW},
//                @{@"2":isOnZ},
//                @{@"3":isOnC}
//                ];
    
SetUserDefaultKeyWithObject(kCheckNoOpenPayMethodesInPostAds,payDics);
    UserDefaultSynchronize;
    
    
    if (pays !=nil && pays.count>0) {
        [self.listData addObject:@{
                
                kIndexSection: @(IndexSectionTwo),
                kIndexInfo:@[@"支付方式：",@""],
                kIndexRow: pays}//data.t.arr
         ];
    }
    
    [self removeContentWithType:IndexSectionThree];
    
//    [self.listData addObject:@{
//
//                           kIndexSection: @(IndexSectionThree),
//                           kIndexInfo:@[@"快捷回复：",@""],
//                           kIndexRow: @[@{(postAdsType == PostAdsTypeEdit&&modifyAdsModel!=nil)?[NSString stringWithFormat:@"%@",modifyAdsModel.autoReplyContent]:@"":@"用户下单看到的快捷回复，可填写付款要求。"}]}//data.t.arr
//    ];
    
    [self removeContentWithType:IndexSectionFour];

    [self.listData addObject:@{
                               
                               kIndexSection: @(IndexSectionFour),
                               kIndexInfo:@[@"买家限制：",@""],
                               kIndexRow: @[@{kTip:@"需要对方通过实名认证"},@{kTip:@"需要对方通过高级认证"}]}//data.t.arr
     ];
    
    [self sortData];
}
- (void)sortData {
    [self.listData sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSNumber *number1 = [NSNumber numberWithInteger:[[obj1 objectForKey:kIndexSection] integerValue]];
        NSNumber *number2 = [NSNumber numberWithInteger:[[obj2 objectForKey:kIndexSection] integerValue]];
        
        NSComparisonResult result = [number1 compare:number2];
        
        return result == NSOrderedDescending;
    }];
}

- (void)removeContentWithType:(IndexSectionType)type {
    [self.listData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        IndexSectionType contentType = [[(NSDictionary *)obj objectForKey:kIndexSection] integerValue];
        if (contentType == type) {
            *stop = YES;
            [self.listData removeObject:obj];
        }
    }];
}

@end
