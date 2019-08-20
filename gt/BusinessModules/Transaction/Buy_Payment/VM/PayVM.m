//
//  YBHomeDataCenter.m
//  Aa
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "PayVM.h"
#import "OrderDetailModel.h"

@interface PayVM()

@property (strong,nonatomic)NSMutableArray   *listData;
@property (nonatomic,strong) PayModel* model;
@property (nonatomic,strong) OrderDetailModel *orderDetailModel;

@end

@implementation PayVM

- (void)network_canclePayListWithRequestParams:(id)requestParams
                                       success:(DataBlock)success
                                        failed:(DataBlock)failed
                                         error:(DataBlock)err{
    
    _listData = [NSMutableArray array];
    
    
    NSDictionary *params = @{
                             @"orderNo": requestParams
//                             @"paymentWay": paymentWay
                             
                             };
    //    [self assembleApiData:nil];
    //    success(self.listData);
    //    return;
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_TransactionCancelPay]
                                                     andType:All
                                                     andWith:params
                                                     success:^(NSDictionary *dic) {
        
        [SVProgressHUD dismiss];
        
        self.model = [PayModel mj_objectWithKeyValues:dic];
        
        if ([NSString getDataSuccessed:dic]) {
            success(weakSelf.model);
        }
        else{
            failed(weakSelf.model);
            [YKToastView showToastText:weakSelf.model.msg];
        }
        
    } error:^(NSError *error) {
        [SVProgressHUD dismiss];
        err(error);
        [YKToastView showToastText:error.description];
        
    }];
}

- (void)network_confirmPayListWithRequestParams:(id)requestParams
                                 WithPaymentWay:(NSString*)paymentWay
                                        success:(DataBlock)success
                                         failed:(DataBlock)failed
                                          error:(DataBlock)err{
    
    _listData = [NSMutableArray array];
    
    NSDictionary *params = @{
                             @"orderNo": requestParams,
                             @"transactionPassword": paymentWay
                             
                             };
    //    [self assembleApiData:nil];
    //    success(self.listData);
    //    return;
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_TransactionComfirmPay]
                                                     andType:All
                                                     andWith:params
                                                     success:^(NSDictionary *dic) {
        
        [SVProgressHUD dismiss];
        
        self.model = [PayModel mj_objectWithKeyValues:dic];
        
        if ([NSString getDataSuccessed:dic]) {
            
            success(weakSelf.model);
        }
        else{
            
            failed(weakSelf.model);
            
            [YKToastView showToastText:weakSelf.model.msg];
        }
    } error:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        
        err(error);
        
        [YKToastView showToastText:error.description];
    }];
}

- (void)network_postPayListWithPage:(NSInteger)page
                  WithRequestParams:(id)requestParams
                            success:(TwoDataBlock)success
                             failed:(DataBlock)failed
                              error:(DataBlock)err{
    
    _listData = [NSMutableArray array];
    
    NSArray* arr = requestParams;
    
//    NSString* ugOtcAdvertId = arr[0];
//
//    NSString* number =  arr[1];
//
//    NSString* remark = arr[2];
//
//    NSDictionary *params = @{
//                             @"ugOtcAdvertId": ugOtcAdvertId,
//                             @"number": number,
//                             @"remark":remark
//                             };
//    [self assembleApiData:nil];
//    success(self.listData);
//    return;
    
    [SVProgressHUD showWithStatus:@"加载中..."
                         maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_TransactionPay]
                                                     andType:All
                                                     andWith:requestParams
                                                     success:^(NSDictionary *dic) {
        
                                                         NSLog(@"%@",dic);
                                                         
                                                         
        [SVProgressHUD dismiss];
        
//        self.model = [PayModel mj_objectWithKeyValues:dic];
                                                         
        self.orderDetailModel = [OrderDetailModel mj_objectWithKeyValues:dic];
        
//        self.orderDetailModel.paymentWay = [OrderDetailData mj_objectWithKeyValues:dic[@"paymentWay"]];
                                                         
//        NSLog(@"%@",self.orderDetailModel.PaymentWay.QRCode);
                                      
        if ([NSString getDataSuccessed:dic]) {
            //success(weakSelf.model);
            
//            [weakSelf assembleApiData:self.model];
            
//            success(weakSelf.listData,self.model);
            
            success(weakSelf.listData,self.orderDetailModel);

        }else{
            
            failed(dic);
        }
        
    } error:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        
        err(error);
        
        [YKToastView showToastText:error.description];
    }];
}

- (void)assembleApiData:(PayModel*)model{
    [self removeContentWithType:IndexSectionZero];
    
        [self.listData addObject:@{//from orderDe
//                                   kData:model.prompt,
                                   
               kIndexInfo:@{
                       kTip:@{@"购买BUB":@"未付款"},
                       kSubTip:@"商户已缴保证金，平台担保交易",
                       kData:[model getPayways],
                               
                       },
               kIndexSection: @(IndexSectionZero),
               
               kIndexRow: @[
                       @{@"订单号：":[NSString stringWithFormat:@"%@",model.orderNo]},
                       @{@"订单金额：":[NSString stringWithFormat:@"%@",model.orderAmount]},
                       @{@"单价：":@"1 CNY = 1 BUB"},
                       @{@"数量：":[NSString stringWithFormat:@"%@ BUB",model.orderNumber]},
                       @{@"订单时间：":[NSString stringWithFormat:@"%@",model.createdTime]}
                       ]
                               
               }];
    
    
    
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

//-(NSArray*)getPayways{
//    NSMutableArray *pays = [NSMutableArray arrayWithCapacity:3];
//    NSDictionary* dicWX = @{kImg:@"icon_weixin",kTit:@"微信支付",kType:@(PaywayTypeWX),kIsOn:@"1",
//                            kSubTit:@{[NSString stringWithFormat:@"请在 %@ 分钟内向以上收款信息支付 %@ 元，超时将自动取消订单",@"15",@"5900 "]:@"\n点击打开微信App付款"}
//                            ,
//                            kUrl:@"998673068",
//                            kData:@[
//                                    
//                                    @"付款参考号：",@"989765"
//                                    ]
//                            
//                            };
//    
//    NSDictionary* dicZFB = @{kImg:@"icon_zhifubao",kTit:@"支付宝",kType:@(PaywayTypeZFB),kIsOn:@"1",
//                             kSubTit:@{[NSString stringWithFormat:@"请在 %@ 分钟内向以上收款信息支付 %@ 元，超时将自动取消订单",@"15",@"5900 "]:@"\n点击打开支付宝App付款"},
//                             kUrl:@"498673068",
//                             kData:@[
//                                     @"付款参考号：",@"999765"
//                                     ]
//                             
//                             };
//    
//    NSDictionary* dicCard = @{kImg:@"icon_bank",kTit:@"银行卡",kType:@(PaywayTypeCard),kIsOn:@"1",
//                              kSubTit:@{[NSString stringWithFormat:@"请在 %@ 分钟内向以上收款信息支付 %@ 元，超时将自动取消订单",@"15",@"5900 "]:@""},
//                              kData:@[
//                                      @{@"开户行：":@"招商银行"},
//                                      @{@"银行账号：":@"4986730968"},
//                                      @{@"收款人姓名：":@"Link"},
//                                      @{@"付款参考号：":@"589765"}
//                                      ]
//                              
//                              };
//    
//    //    NSMutableArray* payArr = [NSMutableArray new];
//    //    for (PayData * data in self.paymentWay) {
//    //        [payArr addObject:data.paymentWay];
//    //    }
//    //    NSString* p = [payArr componentsJoinedByString:@","];
//    //
//    //    if ([p containsString:@"1"]) {
//    //        [pays addObject:dicWX];
//    //    }
//    //    if ([p containsString:@"2"]) {
//    //        [pays addObject:dicZFB];
//    //    }
//    //    if ([p containsString:@"3"]) {
//    //        [pays addObject:dicCard];
//    //    }
//    
//    [pays addObjectsFromArray:@[dicWX,dicZFB,dicCard]];
//    return [pays mutableCopy];
//    
//}
@end
