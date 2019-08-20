//
//  PostAdsVC.m
//  gt
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "PostAdsVC.h"
#import "PostAdsView.h"
#import "PostAdsVM.h"

#import "SlideTabBarVC.h"
#import "PostAdsDetailVC.h"

#import "IQKeyboardManager.h"
@interface PostAdsVC () <PostAdsViewDelegate>
@property (nonatomic, strong) PostAdsView *mainView;
@property (nonatomic, strong) PostAdsVM *vm;
@property (nonatomic, strong) id requestParams;
@property (nonatomic, copy) DataBlock block;
@end

@implementation PostAdsVC

#pragma mark - life cycle
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block
{
    PostAdsVC *vc = [[PostAdsVC alloc] init];
    vc.block = block;
    vc.requestParams = requestParams;
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    if ([self.requestParams isKindOfClass:[NSNumber class]]) {
        self.title = @"发布广告";
        
    }else{
        self.title = @"修改广告";
    }
    
    [self initView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refeshPayCellInPostAds) name:kNotify_IsPayCellInPostAdsRefresh object:nil];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //slideBottomTableView.scrollEnabled =NO;
    IQKeyboardManager *keyboardManager =  [IQKeyboardManager sharedManager];
    keyboardManager.enable = NO;
}

-(void)refeshPayCellInPostAds{
    kWeakSelf(self);
    [self.vm network_getPostAdsListWithPage:1 WithRequestParams:self.requestParams success:^(id data) {
        kStrongSelf(self);
        [self.mainView refeshPayCellInPostAds:data];
    } failed:^(id data) {
        //        kStrongSelf(self);
        //        [self.mainView requestListFailed];
    } error:^(id data) {
        //        kStrongSelf(self);
        //        [self.mainView requestListFailed];
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    //slideBottomTableView.scrollEnabled =NO;
    IQKeyboardManager *keyboardManager =  [IQKeyboardManager sharedManager];
    keyboardManager.enable = YES;
    
}
- (void)initView {
    [self.view addSubview:self.mainView];
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    NSArray  *optionPrices = GetUserDefaultWithKey(kLimitAccountsInPostAds);
    if ([GetUserDefaultWithKey(kControlNumberInPostAds) intValue]<[optionPrices[0] intValue]) {//o[0]<//[optionPrices[0] intValue]
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"您的可用余额小于%@，暂时不能发布任何广告，请及时去后台充值",optionPrices[0]]  message:nil preferredStyle:  UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        [self presentViewController:alert animated:true completion:nil];
    }
    
    
    WS(weakSelf);
    
    [self.mainView actionBlock:^(id data,id data2,id data3,id data4,id data5,id data6,id data7,id data8) {
        EnumActionTag btnType  = [data integerValue];
        switch (btnType) {
            case EnumActionTag3:
            {//web
//                SlideTabBarVC *moreVc = [[SlideTabBarVC alloc] init];
//                [weakSelf.navigationController pushViewController:moreVc animated:YES];
            }
                break;
            case EnumActionTag4:
            {//post
                TransactionAmountType transactionAmountType = [data2 intValue];
                if (transactionAmountType == TransactionAmountTypeLimit) {
                    NSArray* sliderArrs = data3;
                    NSString* payString = data4;
                    NSString* remarkString = data5;
                    NSArray* selectedLimits = data6;
                    NSDictionary* codeDic = data7;
                    NSString* ugAdID = data8;
                    
                    NSString* coinId = @"BUB";
                    NSString* number = sliderArrs[2];
                    NSString* price = @"1 CNY = 1 BUB";
                    NSString* paymentWay = [NSString getPaywayAppendingString:payString];
                    NSString* amount = [NSString stringWithFormat:@"%@ ~ %@",sliderArrs[0],sliderArrs[1]];
                    
                    NSDictionary* dic1 = @{kType:@(PostAdsDetailTypeSuccess),kImg:@"iconSucc",kTip:@"发布成功",kSubTip:[NSString stringWithFormat:@"%@",@"请确认收到款项后再放行"], kIndexSection:@{kTip:[NSString stringWithFormat:@"%@",@"00:30"],kSubTip:[NSString stringWithFormat:@"%@",@"请在 15 分钟内处理，超时将影响卖家信誉"]},
                                           kIndexRow:
                                               @[
                                                   @{@"币种：":coinId},
                                                   @{@"数量：":[NSString stringWithFormat:@"%@ BUB",number]},
                                                   @{@"单价：":price},
                                                   @{@"收款方式：":paymentWay},
                                                   @{@"单笔限额：":amount}
                                                   ]
                                           };
                    
                    [self.vm network_sendAdsListWithNumber:sliderArrs[2] amountType:[NSString stringWithFormat:@"%lu",(unsigned long)transactionAmountType]  limitMax:sliderArrs[1] limitMin:sliderArrs[0] fixedNumber:@"" price:@"1" type:@"2" pamentWay:payString coinId:coinId coinType:@"人民币" prompt:sliderArrs[3] autoReplyContent:remarkString isIDNumber:selectedLimits[0]
                        isSeniorCertification:selectedLimits[1]  transactionPassword:codeDic.allKeys[0] googlesecret:codeDic.allValues[0] ugAdID:ugAdID success:^(id data) {
                        PostAdsModel* model =data;
                        [PostAdsDetailVC pushFromVC:self requestParams:dic1 withAdId:model.ugOtcAdvertId success:^(id data) {
                            
                        }];
                        
                    } failed:^(id data) {
                        
                    } error:^(id data) {
                        
                    }];
                }else{
                    NSArray* sliderArrs = data3;
                    NSString* payString = data4;
                    NSString* remarkString = data5;
                    NSArray* selectedLimits = data6;
                    NSDictionary* codeDic = data7;
                    NSString* ugAdID = data8;
                    
                    NSString* coinId = @"BUB";
                    NSString* number = sliderArrs[1];
                    NSString* price = @"1 CNY = 1 BUB";
                    NSString* paymentWay = [NSString getPaywayAppendingString:payString];
                    NSString* amount = [NSString stringWithFormat:@"%@",sliderArrs[0]];
                    
                    NSDictionary* dic1 = @{kType:@(PostAdsDetailTypeSuccess),kImg:@"iconSucc",kTip:@"发布成功",kSubTip:[NSString stringWithFormat:@"%@",@"请确认收到款项后再放行"], kIndexSection:@{kTip:[NSString stringWithFormat:@"%@",@"00:30"],kSubTip:[NSString stringWithFormat:@"%@",@"请在 15 分钟内处理，超时将影响卖家信誉"]},
                                           kIndexRow:
                                               @[
                                                   @{@"币种：":coinId},
                                                   @{@"数量：":[NSString stringWithFormat:@"%@ BUB",number]},
                                                   @{@"单价：":price},
                                                   @{@"收款方式：":paymentWay},
                                                   @{@"单笔固额：":amount}
                                                   ]
                                           };
                    
                    [self.vm network_sendAdsListWithNumber:sliderArrs[1] amountType:[NSString stringWithFormat:@"%lu",(unsigned long)transactionAmountType]  limitMax:@"" limitMin:@"" fixedNumber:sliderArrs[0] price:@"1" type:@"2" pamentWay:payString coinId:coinId coinType:@"人民币" prompt:sliderArrs[2] autoReplyContent:remarkString
                        isIDNumber:selectedLimits[0]
                        isSeniorCertification:selectedLimits[1]  transactionPassword:codeDic.allKeys[0] googlesecret:codeDic.allValues[0] ugAdID:ugAdID success:^(id data) {
                        PostAdsModel* model =data;
                        [PostAdsDetailVC pushFromVC:self requestParams:dic1 withAdId:model.ugOtcAdvertId success:^(id data) {
                            
                        }];
                    } failed:^(id data) {
                        
                    } error:^(id data) {
                        
                    }];
                }
                
            }
                break;
                
            default:
                
                break;
        }
    }];
}



#pragma mark - PostAdsViewDelegate

- (void)postAdsView:(PostAdsView *)view requestListWithPage:(NSInteger)page {
   kWeakSelf(self);
    [self.vm network_getPostAdsListWithPage:page WithRequestParams:self.requestParams success:^(id data) {
        kStrongSelf(self);
        [self.mainView requestListSuccessWithArray:data withRequestParams:self.requestParams];
    } failed:^(id data) {
        kStrongSelf(self);
        [self.mainView requestListFailed];
    } error:^(id data) {
        kStrongSelf(self);
        [self.mainView requestListFailed];
    }];
}

#pragma mark - getter

- (PostAdsView *)mainView {
    if (!_mainView) {
        _mainView = [PostAdsView new];
        _mainView.delegate = self;
    }
    return _mainView;
}

- (PostAdsVM *)vm {
    if (!_vm) {
        _vm = [PostAdsVM new];
    }
    return _vm;
}

@end
