//
//  PostAdsVC.m
//  gt
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "Buy_PaymentVC.h"
#import "OrderDetailVC.h"
#import "Buy_WaittingVC.h"

#import "PayView.h"
#import "CancelTipPopUpView.h"
#import "SureTipPopUpView.h"

#import "OrderDetailVM.h"
#import "PayVM.h"
#import "LoginVM.h"

#import "Buy_HeadTBVCell.h"
#import "Buy_Payment_ContentTBVCell.h"
#import "Buy_Payment_TipTBVCell.h"
#import "Buy_Payment_QRCodeTBVCell.h"
#import "Buy_Payment_BankCardTBVCell.h"
#import "Buy_PaymentPopUpView.h"
#import "InputPWPopUpView.h"
#import "OfficialRemindPopUpView.h"

@interface Buy_PaymentVC ()<UITableViewDelegate,UITableViewDataSource>// <PayViewDelegate>
{

    Buy_PaymentPopUpView *view;
    
    LoginModel *userInfoModel;
}
//@property (nonatomic, strong) PayView *mainView;
@property (nonatomic, strong) PayVM *payVM;
@property (nonatomic, strong)OrderDetailVM *orderDetailvm;
@property (nonatomic, strong)LoginVM *loginVM;
@property (nonatomic, strong) id requestParams;
@property (nonatomic, copy) DataBlock block;
@property (nonatomic, strong) OrderDetailModel* orderDetailModel;
//@property (nonatomic, assign)PaywayType type;
//@property (nonatomic, strong)OrderDetailModel* orderDetailModel;


@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)Buy_HeadTBVCell *headCell;
@property (nonatomic, strong)Buy_Payment_ContentTBVCell *contentCell;
@property (nonatomic, strong)Buy_Payment_TipTBVCell *tipCell;
@property (nonatomic, strong)Buy_Payment_QRCodeTBVCell *QRCodeCell;
@property (nonatomic, strong)Buy_Payment_BankCardTBVCell *bankCardCell;
@property (nonatomic, strong)InputPWPopUpView *inputPWPopUpView;

@property (nonatomic, assign)CGFloat ContentCellHeight;

@property (nonatomic, assign)PaywayType paymentStyle;
@property (nonatomic, assign)OrderType orderType;
//@property (nonatomic, copy) TwoDataBlock block;

@end

@implementation Buy_PaymentVC

#pragma mark - life cycle

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(id)requestParams
                 withModel:(OrderDetailModel *)model
                paymentWay:(PaywayType)paymentWay
                   success:(DataBlock)block
{
    Buy_PaymentVC *vc = [[Buy_PaymentVC alloc] init];
    
    vc.block = block;
    
    vc.requestParams = requestParams;
    
    vc.orderDetailModel = model;

    vc.paymentStyle = paymentWay;
    
    vc.orderType = BuyerOrderTypeNotYetPay;

    [rootVC.navigationController pushViewController:vc
                                           animated:true];
    return vc;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self YBGeneral_baseConfig];
    
    userInfoModel = [LoginModel mj_objectWithKeyValues:GetUserDefaultWithKey(kUserInfo)];
    
    SetUserDefaultKeyWithObject(@"orderType", @(self.orderType));
    
    UserDefaultSynchronize;
    
    self.title = @"买币";
    
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    kWeakSelf(self);
    
    if (!GetUserDefaultBoolWithKey(KNotToRemindWhenNext)) {
        
        //进入就弹出
        OfficialRemindPopUpView *officialRemindPopUpView = OfficialRemindPopUpView.new;
        
        [officialRemindPopUpView showInApplicationKeyWindow];
        
        [officialRemindPopUpView actionBlock:^(id data) {
            
            kStrongSelf(self);
            
        }];
    }
    ////
    [self.view bottomTripleButtonInSuperView:self.view leftLittleButtonEvent:^(id data) {
        
        kStrongSelf(self);
        
        [self contactEvent];
    } leftButtonEvent:^(id data) {
        
        kStrongSelf(self);
        
        CancelTipPopUpView *popupView = [[CancelTipPopUpView alloc]init];
        
//        [popupView richElementsInViewWithModel:Nil];
        
        [popupView showInApplicationKeyWindow];

        [popupView actionBlock:^(id data) {
            
            kStrongSelf(self);
            
            [self cancelOrderEvent];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_IsPayStopTimeRefresh
                                                                object:nil];
        }];
    } rightButtonEvent:^(id data) {
        
        kStrongSelf(self);
        
        //我已付款
            
            self.inputPWPopUpView = [[InputPWPopUpView alloc]initWithFrame:CGRectZero
                                           WithIsForceNoShowGoogleCodeField:YES];
            
            [self.inputPWPopUpView showInApplicationKeyWindow];
            
            [self.inputPWPopUpView actionBlock:^(id data) {
                
                NSLog(@"%@",data);
                
                NSDictionary *dic = data;
                
                kWeakSelf(self);
                
                [self.payVM network_confirmPayListWithRequestParams:self.orderDetailModel.orderNo//订单号
                                                     WithPaymentWay:dic.allKeys[0]//支付密码
                                                            success:^(id data) {
                                                                
                                                                kStrongSelf(self);
                                                                
                                                                NSLog(@"success_%@",data);
                                                                
                                                                PayModel *payModel = data;
                                                                
                                                                NSLog(@"%@",payModel.orderNo);
                                                                
                                                                [self.orderDetailvm network_getOrderDetailListWithPage:Nil
                                                                                                     WithRequestParams:payModel.orderNo
                                                                                                               success:^(id data, id data2, id data3) {
                                                                                                                   
                                                                                                                   kStrongSelf(self);
                                                                                                                   
                                                                                                                   NSLog(@"%@",data3);
                                                                                                                   
                                                                                                                   OrderType orderType = [data3 intValue];
                                                                                              
                                                                                                                   NSLog(@"%lu",orderType);
                                                                                                                   
                                                                                                                   switch (orderType) {
                                                                                                                           
                                                                                                                       case BuyerOrderTypeNotYetPay:{//买方_订单还未支付
                                                                                                                           
                                                                                                                           [Buy_WaittingVC pushFromVC:self
                                                                                                                                        requestParams:data2
                                                                                                                                            withModel:payModel
                                                                                                                                            orderType:BuyerOrderTypeNotYetPay
                                                                                                                                              success:^(id data) {
                                                                                                                                                  
                                                                                                                                              }];
                                                                                                                       }
                                                                                                                           break;
                                                                                                                       case BuyerOrderTypeHadPaidWaitDistribute:{//买方_订单已经支付待放行
                                                                                                                           
                                                                                                                           [Buy_WaittingVC pushFromVC:self
                                                                                                                                        requestParams:data2
                                                                                                                                            withModel:payModel
                                                                                                                                            orderType:BuyerOrderTypeHadPaidWaitDistribute
                                                                                                                                              success:^(id data) {
                                                                                                                                                  
                                                                                                                                              }];
                                                                                                                       }
                                                                                                                           break;
                                                                                                                       case BuyerOrderTypeHadPaidNotDistribute:{//买方_订单已经支付不放行
                                                                                                                           
                                                                                                                           [Buy_WaittingVC pushFromVC:self
                                                                                                                                        requestParams:data2
                                                                                                                                            withModel:payModel
                                                                                                                                            orderType:BuyerOrderTypeHadPaidNotDistribute
                                                                                                                                              success:^(id data) {
                                                                                                                                                  
                                                                                                                                              }];
                                                                                                                       }
                                                                                                                           break;
                                                                                                                       case BuyerOrderTypeClosed:{//超时页面
                                                                                                                           
                                                                                                                           [Buy_WaittingVC pushFromVC:self
                                                                                                                                        requestParams:data2
                                                                                                                                            withModel:payModel
                                                                                                                                            orderType:BuyerOrderTypeClosed
                                                                                                                                              success:^(id data) {
                                                                                                                                                  
                                                                                                                                              }];
                                                                                                                       }
                                                                                                                           break;
                                                                                                                       default:
                                                                                                                           break;
                                                                                                                   }
                                                                                                                   
                                                                                                                   
                                                                                                               } failed:^(id data) {
                                                                                                                   
                                                                                                                   NSLog(@"%@",data);
                                                                                                               }
                                                                                                                 error:^(id data) {
                                                                                                                     
                                                                                                                     NSLog(@"%@",data);
                                                                                                                 }];
                                                                
                                                                
                                                            }
                                                             failed:^(id data) {
                                                                 NSLog(@"failed_%@",data);
                                                             }
                                                              error:^(id data) {
                                                                  
                                                                  NSLog(@"error_%@",data);
                                                              }];
            }];
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [view disappear];
}

-(void)initView{
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
}

#pragma mark -- <UITableViewDelegate,UITableViewDataSource>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        return MAINSCREEN_HEIGHT / 10;
        
    }else if (indexPath.section == 1){

        return MAINSCREEN_HEIGHT / 4.5;
        
    }else if (indexPath.section == 2){
        
        return MAINSCREEN_HEIGHT / 15;
        
    }else if (indexPath.section == 3){
        
        return MAINSCREEN_HEIGHT / 3;
    }
    
    return 0.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    //    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    //    cell.selected = NO;
    [tableView deselectRowAtIndexPath:indexPath
                             animated:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        if (!_headCell) {
            
            NSDictionary *dataDic = @{
                                      @"userType":userInfoModel.userinfo.userType,
//                                      @"orderDetailModel":self.orderDetailModel,
                                      @"orderType":@(self.orderType)
                                      };
            
            _headCell = [[Buy_HeadTBVCell alloc]initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:ReuseIdentifier
                                                      dataDic:dataDic];
            
//            _headCell.backgroundColor = kRedColor;
        }
        
        return _headCell;
        
    }else if (indexPath.section == 1){
        if (!_contentCell) {//
      
            NSDictionary *dataDic = @{
                                      @"name":[NSString isEmpty:self.orderDetailModel.paymentWay.name]?@"?":self.orderDetailModel.paymentWay.name,//名
                                      @"orderNo":[NSString isEmpty:self.orderDetailModel.orderNo]?@"?":self.orderDetailModel.orderNo,//订单号
                                      @"orderPrice":[NSString isEmpty:self.orderDetailModel.orderPrice]?@"?":self.orderDetailModel.orderPrice,//单价
                                      @"orderAmount":[NSString isEmpty:self.orderDetailModel.orderAmount]?@"?":[NSString stringWithFormat:@"¥%@",self.orderDetailModel.orderAmount],//订单金额
                                      @"orderNumber":[NSString isEmpty:self.orderDetailModel.orderNumber]?@"?":self.orderDetailModel.orderNumber//订单数量
                                      };
            
            _contentCell = [[Buy_Payment_ContentTBVCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                            reuseIdentifier:ReuseIdentifier
                                                                    dataDic:dataDic];
        }
        
        return _contentCell;
        
    }else if (indexPath.section == 2){
        
        if (!_tipCell) {
            
            NSDictionary *dataDic = @{
                                      @"restTime":[NSString isEmpty:self.orderDetailModel.restTime]?@([self.orderDetailModel.prompt intValue]*60):self.orderDetailModel.restTime
                                      
                                      };

            _tipCell = [[Buy_Payment_TipTBVCell alloc]initWithStyle:UITableViewCellStyleValue1
                                                            dataDic:dataDic
                                                    reuseIdentifier:ReuseIdentifier];
        }

        return _tipCell;
        
    }else if (indexPath.section == 3){
        
        NSDictionary *dataDic_01 = @{
                                  @"QRCode":[NSString isEmpty:self.orderDetailModel.paymentWay.QRCode]?@"？":self.orderDetailModel.paymentWay.QRCode,//收款二维码
                                  @"paymentNumber":[NSString isEmpty:self.orderDetailModel.paymentNumber]?@"？":self.orderDetailModel.paymentNumber//付款参考号
                                  
                                  };
        
        NSDictionary *dataDic_02 = @{
                                  @"paymentNumber":[NSString isEmpty:self.orderDetailModel.paymentNumber]?@"？":self.orderDetailModel.paymentNumber,//付款参考号
                                  @"name":[NSString isEmpty:self.orderDetailModel.paymentWay.name]?@"？":self.orderDetailModel.paymentWay.name,//收款人
                                  @"accountOpenBranch":[NSString isEmpty:self.orderDetailModel.paymentWay.accountOpenBranch]?@"？":self.orderDetailModel.paymentWay.accountOpenBranch,//支行信息
                                  @"accountOpenBank":[NSString isEmpty:self.orderDetailModel.paymentWay.accountOpenBank]?@"？":self.orderDetailModel.paymentWay.accountOpenBank,//开户银行
                                  @"accountBankCard":[NSString isEmpty:self.orderDetailModel.paymentWay.accountBankCard]?@"？":self.orderDetailModel.paymentWay.accountBankCard//卡号
                                  
                                  };
        
        //根据值判断进银行卡？微信/支付宝？
        
        kWeakSelf(self);
        
        switch (self.paymentStyle) {
            case PaywayTypeZFB:{//支付宝支付

                if (!_QRCodeCell) {
                    
                    _QRCodeCell = [[Buy_Payment_QRCodeTBVCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                                     paymentStyle:PaywayTypeZFB
                                                                  reuseIdentifier:ReuseIdentifier
                                                                        orderType:@"1"
                                                                          dataDic:dataDic_01];
                    
                    _QRCodeCell.MyBlock = ^(PaywayType t) {
                        
                        kStrongSelf(self);
                        
                        NSString *zfbcode = self.orderDetailModel.paymentWay.QRCode;
                        
                        NSURL *url = [NSURL URLWithString:@"alipay://"];
                        
                        NSURL *openurl = [NSURL URLWithString:[NSString stringWithFormat:@"alipayqr://platformapi/startapp?saId=10000007&&qrcode=%@",zfbcode]];
                        //先判断是否能打开该url
                        if ([[UIApplication sharedApplication] canOpenURL:url]) {
                            
                            [[UIApplication sharedApplication] openURL:openurl
                                                               options:@{}
                                                     completionHandler:^(BOOL success) {
                                
                            }];
                        }else {
                            
                            [YKToastView showToastText:@"没安装支付宝，怎么打开啊！"];
                        }
                        
                        
                    };
                }
                
                return _QRCodeCell;

                
            }
                break;
            case PaywayTypeWX:{//微信支付
                
                if (!_QRCodeCell) {
                    
                    _QRCodeCell = [[Buy_Payment_QRCodeTBVCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                                     paymentStyle:PaywayTypeWX
                                                                  reuseIdentifier:ReuseIdentifier
                                                                        orderType:@"1" 
                                                                          dataDic:dataDic_01];
                    
                    _QRCodeCell.MyBlock = ^(PaywayType t) {
                        
                        kStrongSelf(self);
                        
                        NSURL *url = [NSURL URLWithString:@"weixin://"];
                        //先判断是否能打开该url
                        if ([[UIApplication sharedApplication] canOpenURL:url]) {
                            //                    [[UIApplication sharedApplication] openURL:url];
                            [[UIApplication sharedApplication] openURL:url
                                                               options:@{}
                                                     completionHandler:^(BOOL success) {
                                
                            }];
                        }else {
                            [YKToastView showToastText:@"没安装微信，怎么打开啊！"];
                        }

                    };
                }
                
                return _QRCodeCell;

                
            }
                break;
            case PaywayTypeCard:{//银行卡支付
                
                if (!_bankCardCell) {
                    
                    _bankCardCell = [[Buy_Payment_BankCardTBVCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                                      reuseIdentifier:ReuseIdentifier
                                                                            orderType:@"1"
                                                                              dataDic:dataDic_02];
                }
                
                return _bankCardCell;
                
            }
                break;
                
            default:
                break;
        }
    }
    
    return Nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 0.0f;
    }
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = UIView.new;
    
    view.backgroundColor = RGBCOLOR(245, 245, 245);
    
    return view;
}

#pragma mark —— 取消订单
- (void)cancelOrderEvent{
    
    kWeakSelf(self);
    //网络请求取消订单
    //成功后推页面
    [self.payVM network_canclePayListWithRequestParams:_orderDetailModel.orderNo
                                            success:^(id data) {
                                                
                                                kStrongSelf(self);
                                                
                                                [OrderDetailVC pushViewController:self
                                                                    requestParams:self.orderDetailModel.orderId
                                                                          success:^(id data) {
                                                                              
                                                                              
                                                                              
                                                                          }];
    } failed:^(id data) {
        
    } error:^(id data) {
        
    }];
}

- (void)contactEvent{
    if (self.orderDetailModel !=nil) {
        
        NSString *sessionId;
        NSString *title;
        LoginModel* userInfoModel = [LoginModel mj_objectWithKeyValues:GetUserDefaultWithKey(kUserInfo)];
        if ([self.orderDetailModel.sellUserId isEqualToString:userInfoModel.userinfo.userid]){
            sessionId = self.orderDetailModel.buyUserId;
            title = self.orderDetailModel.buyerName;
        }else{
            sessionId = self.orderDetailModel.sellUserId;
            title = self.orderDetailModel.sellerName;
        }
        [RongCloudManager updateNickName:title userId:sessionId];
        [RongCloudManager jumpNewSessionWithSessionId:sessionId title:title navigationVC:self.navigationController];
        
    }
}

#pragma mark —— 重写该方法以自定义系统导航栏返回按钮点击事件 
- (void)YBGeneral_clickBackItem:(UIBarButtonItem *)item{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - lazyload
-(UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                 style:UITableViewStylePlain];
        
        _tableView.dataSource = self;
        
        _tableView.delegate = self;
        
        _tableView.tableFooterView = UIView.new;
        
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    
    return _tableView;
}

-(LoginVM *)loginVM{
    
    if (!_loginVM) {
        
        _loginVM = LoginVM.new;
    }
    
    return _loginVM;
}

-(OrderDetailVM *)orderDetailvm{
    
    if (!_orderDetailvm) {
        
        _orderDetailvm = OrderDetailVM.new;
    }
    
    return _orderDetailvm;
}

- (PayVM *)payVM {
    
    if (!_payVM) {
        
        _payVM = PayVM.new;
    }
    return _payVM;
}

//- (void)initView {
//    [self.view addSubview:self.mainView];
//    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
//    [self submitOrderEvent];
////    NSArray * dataArray = self.requestParams;
////    [self.mainView requestListSuccessWithArray:dataArray WithPage:1];
//
//    WS(weakSelf);
//    [self.mainView actionBlock:^(id data,id data2) {
//        EnumActionTag btnType  = [data integerValue];
//        switch (btnType) {
//            case EnumActionTag4:
//                {
//                    [weakSelf outTimeOrderEvent];
//                }
//                break;
//            case EnumActionTag5:
//            {
//                if (data2!=nil) {
//                    if ([data2 isKindOfClass:[NSString class]]) {
//                        NSString* zfbcode =data2;
//                        NSURL *url = [NSURL URLWithString:@"alipay://"];
//                        NSURL *openurl = [NSURL URLWithString:[NSString stringWithFormat:@"alipayqr://platformapi/startapp?saId=10000007&&qrcode=%@",zfbcode]];
//                        //先判断是否能打开该url
//                        if ([[UIApplication sharedApplication] canOpenURL:url]) {
//                            [[UIApplication sharedApplication] openURL:openurl options:@{} completionHandler:^(BOOL success) {
//
//                            }];//asdfzxcvsadf
//                        }else {
//                            [YKToastView showToastText:@"没安装支付宝，怎么打开啊！"];
//                        }
//                    }
//                } 
//            }
//                break;
//            case EnumActionTag6:
//            {
//                 NSURL *url = [NSURL URLWithString:@"weixin://"];
//                //先判断是否能打开该url
//                if ([[UIApplication sharedApplication] canOpenURL:url]) {
////                    [[UIApplication sharedApplication] openURL:url];
//                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
//
//                    }];
//                }else {
//                    [YKToastView showToastText:@"没安装微信，怎么打开啊！"];
//                }
//            }
//                break;
//            case EnumActionTag7:
//            {
//                return ;
//            }
//                break;
//            default:
//                break;
//        }
//
//    }];
//    [self.view bottomTripleButtonInSuperView:self.view leftLittleButtonEvent:^(id data) {
//        [self contactEvent];
//    } leftButtonEvent:^(id data) {
//        CancelTipPopUpView* popupView = [[CancelTipPopUpView alloc]init];
//        [popupView showInApplicationKeyWindow];
//        [popupView richElementsInViewWithModel:@2];
//        [popupView actionBlock:^(id data) {
//            [weakSelf cancelOrderEvent];
//            [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_IsPayStopTimeRefresh object:nil];
//        }];
//
//    } rightButtonEvent:^(id data) {
//        if (weakSelf.model.paymentWay ==nil||weakSelf.model.paymentWay.count ==0) {
//            [YKToastView showToastText:@"暂无可用支付方式"];
//            return ;
//        }
//
//        SureTipPopUpView* popupView = [[SureTipPopUpView alloc]init];
//        [popupView showInApplicationKeyWindow];
//        [popupView richElementsInViewWithModel:[weakSelf.model getPaywayAppendingDicArr]];
//        [popupView actionBlock:^(id data) {
//            weakSelf.type = [data integerValue];
//            [weakSelf surePayOrderEvent];
//            [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_IsPayStopTimeRefresh object:nil];
//        }];
//    } ];
//}
//- (void)contactEvent{
//    if (self.orderDetailModel !=nil) {
//
//        NSString *sessionId;
//        NSString *title;
//        LoginModel* userInfoModel = [LoginModel mj_objectWithKeyValues:GetUserDefaultWithKey(kUserInfo)];
//        if ([self.orderDetailModel.sellUserId isEqualToString:userInfoModel.userinfo.userid]){
//            sessionId = self.orderDetailModel.buyUserId;
//            title = self.orderDetailModel.buyerName;
//        }else{
//            sessionId = self.orderDetailModel.sellUserId;
//            title = self.orderDetailModel.sellerName;
//        }
//        [RongCloudManager updateNickName:title userId:sessionId];
//        [RongCloudManager jumpNewSessionWithSessionId:sessionId title:title navigationVC:self.navigationController];
//
//    }
//}
//- (void)submitOrderEvent{
//    kWeakSelf(self);
//    [self.orderDetailvm network_getOrderDetailListWithPage:1 WithRequestParams:self.model.orderId success:^(id data) {
//        kStrongSelf(self);
//        NSArray* orderDetailArr = data;
//        NSDictionary* orderDetailDic = orderDetailArr[0];
//        self.orderDetailModel = orderDetailDic[kData];
//
//        NSArray * dataArray = self.requestParams;
//        [self.mainView requestListSuccessWithArray:dataArray WithPage:1 WithSec:self.orderDetailModel.restTime];
//
//    } failed:^(id data) {
//    } error:^(id data) {
//    }];
//}
//- (OrderDetailVM *)orderDetailvm {
//    if (!_orderDetailvm) {
//        _orderDetailvm = [OrderDetailVM new];
//    }
//    return _orderDetailvm;
//}
//
//- (void)outTimeOrderEvent{
//    [OrderDetailVC pushViewController:self requestParams:self.model.orderId success:^(id data) {
//
//    }];
//}
//
//- (void)cancelOrderEvent{
//    [self.vm network_canclePayListWithRequestParams:_model.orderNo success:^(id data) {
//        [OrderDetailVC pushViewController:self requestParams:self.model.orderId success:^(id data) {
//
//        }];
//    } failed:^(id data) {
//
//    } error:^(id data) {
//
//    }];
//}
//
//- (void)surePayOrderEvent{
//    kWeakSelf(self);
//    [self.vm network_confirmPayListWithRequestParams:_model.orderNo WithPaymentWay:[NSString stringWithFormat:@"%lu",(unsigned long)self.type] success:^(id data) {
//        kStrongSelf(self);
//        [OrderDetailVC pushViewController:self requestParams:self.model.orderId success:^(id data) {
//
//        }];
//
//    } failed:^(id data) {
//
//    } error:^(id data) {
//
//    }];
//}
//#pragma mark - PayViewDelegate NO
//- (void)payView:(PayView *)view requestListWithPage:(NSInteger)page {
//   kWeakSelf(self);
//    [self.vm network_postPayListWithPage:page WithRequestParams:self.requestParams success:^(id data,id data2) {
//        NSArray * dataArray = data;
//        kStrongSelf(self);
//        [self.mainView requestListSuccessWithArray:dataArray WithPage:page WithSec:@"60"];
//    } failed:^(id data){
//        kStrongSelf(self);
//        [self.mainView requestListFailed];
//        [self.navigationController popViewControllerAnimated:YES];
//    } error:^(id data){
//        kStrongSelf(self);
//        [self.mainView requestListFailed];
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//     ];
//}
//
//#pragma mark - getter
//- (PayView *)mainView {
//    if (!_mainView) {
//        _mainView = [PayView new];
//        _mainView.delegate = self;
//    }
//    return _mainView;
//}
//
//- (PayVM *)vm {
//    if (!_vm) {
//        _vm = [PayVM new];
//    }
//    return _vm;
//}

@end
