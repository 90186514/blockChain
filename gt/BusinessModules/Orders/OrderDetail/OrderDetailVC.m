//
//  OrderDetailVC.m
//  gt
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "LoginModel.h"

#import "PayVM.h"
#import "OrderDetailVM.h"

#import "CancelTipPopUpView.h"
#import "SureTipPopUpView.h"
#import "HomeScanView.h"
#import "DistributePopUpView.h"
#import "InputPWPopUpView.h"
//#import "OrderDetailView.h"
#import "Buy_PaymentPopUpView.h"


#import "Buy_HeadTBVCell.h"
#import "OrderDetail_ContentTBVCell.h"
#import "Buy_Payment_TipTBVCell.h"
#import "Buy_Payment_ContentTBVCell.h"
#import "Buy_Payment_QRCodeTBVCell.h"
#import "Buy_Payment_BankCardTBVCell.h"
#import "TipsTBVCell.h"

#import "AssetsVC.h"
#import "ScanCodeVC.h"
#import "PostAppealVC.h"
#import "OrderDetailVC.h"

#import "EventListModel.h"


@interface OrderDetailVC () <UITableViewDelegate,UITableViewDataSource>
{
    LoginModel *userInfoModel;
}

//@property (nonatomic, strong) OrderDetailView *mainView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) Buy_HeadTBVCell *headCell;
@property (nonatomic, strong) OrderDetail_ContentTBVCell *orderDetail_ContentTBVCell;
@property (nonatomic, strong) Buy_Payment_ContentTBVCell *buy_Payment_ContentTBVCell;
@property (nonatomic, strong) Buy_Payment_TipTBVCell *PaymentTipCell;
@property (nonatomic, strong) TipsTBVCell *tipsTBVCell;
@property (nonatomic, strong) Buy_Payment_TipTBVCell *tipCell;
@property (nonatomic, strong)Buy_Payment_QRCodeTBVCell *QRCodeCell;
@property (nonatomic, strong)Buy_Payment_BankCardTBVCell *bankCardCell;
@property (nonatomic, strong)InputPWPopUpView *inputPWPopUpView;
@property (nonatomic, strong)Buy_PaymentPopUpView *buy_PaymentPopUpView;

@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong) NSMutableArray *title_mutArr;
@property (nonatomic, strong) NSMutableArray *titleValue_mutArr;

@property (nonatomic, copy) DataBlock block;

@property (nonatomic, strong) PayVM *payVM;

@property (nonatomic, strong) OrderDetailVM *orderDetailvm;

@property (nonatomic, strong) OrderDetailModel *orderDetailModel;

@property (nonatomic, assign) OrderDetailStyle orderDetailStyle;
@property (nonatomic, assign) PaywayType type;
@property (nonatomic, assign)PaywayType paymentStyle;
@property (nonatomic, assign) OrderType orderType;
@property (nonatomic, assign)Schedule schedule;

@end

@implementation OrderDetailVC

#pragma mark - life cycle

+ (instancetype)pushViewController:(UIViewController *)rootVC
                     requestParams:(id)requestParams
                           success:(DataBlock)block{
    
//    OrderDetailVC *vc = [[OrderDetailVC alloc] initWithRequestParams:requestParams];
    
    OrderDetailVC *vc = OrderDetailVC.new;
    
    vc.block = block;
    
    vc.requestParams = requestParams;
    
    [rootVC.navigationController pushViewController:vc
                                           animated:YES];
    
    return vc;
}

//-(instancetype)initWithRequestParams:(id)requestParams{
//
//    if (self = [super init]) {
//
//        [self netWorkingWithRequestParams:requestParams];
//
//    }
//
//    return self;
//}

#pragma mark —— life cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self YBGeneral_baseConfig];
    
    userInfoModel = [LoginModel mj_objectWithKeyValues:GetUserDefaultWithKey(kUserInfo)];
    
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self netWorkingWithRequestParams:self.requestParams];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [self.buy_PaymentPopUpView disappear];
}

#pragma mark —— 重写该方法以自定义系统导航栏返回按钮点击事件 
- (void)YBGeneral_clickBackItem:(UIBarButtonItem *)item{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)setttingOrderDetailStyle{

    switch (self.orderType) {
            
        case BuyerOrderTypeNotYetPay://买方_订单还未支付 (向卖家转账)
            
            self.orderDetailStyle = OrderDetail_complainWithConfirm_Buyer;//联系卖家&&点击确认付款
            
            break;
        case BuyerOrderTypeHadPaidWaitDistribute://买方_订单已经支付待放行 (等待放行)
        case BuyerOrderTypeHadPaidNotDistribute://买方_订单已经支付不放行 (等待放行)
            
            self.orderDetailStyle = OrderDetail_complainWithCancelOrder_Buyer;//联系卖家&&取消订单&&我要申诉
            break;
        case BuyerOrderTypeFinished://买方_订单结束 (交易已完成)
            
            self.orderDetailStyle = OrderDetail_showMyCapitalAndConsumeNow_Buyer;//联系卖家&&查看我的资产&&现在去消费
            break;
        case BuyerOrderTypeCancel://买方_订单取消 (向卖家转账)
            
            self.orderDetailStyle = OrderDetail_onlyContactSeller_Buyer;//联系卖家
            break;
        case BuyerOrderTypeClosed://买方_订单关闭 (付款已超时 / 已取消)(向卖家转账)  已超时
            
            self.orderDetailStyle = OrderDetail_complainWithoutCancelOrder_Buyer;//联系卖家&&我要申诉
            break;
        case BuyerOrderTypeAppealing://买方_订单申诉 (向卖家转账 提供错误的讯息无法转账导致订单超时 / 等待放行 已付款未放行) 向卖家转账 / 等待放行
            
            self.orderDetailStyle = OrderDetail_cancelComplain_Buyer;//联系卖家&&取消申诉
            break;
        case SellerOrderTypeNotYetPay://卖方_订单还未支付 (买家付款)
            
            self.orderDetailStyle = OrderDetail_onlyContactBuyer_Seller;//联系买家
            break;
            
        case SellerOrderTypeWaitDistribute://卖方_订单等待放行 (放行订单)
            
            self.orderDetailStyle = OrderDetail_complainWithConfirm_Seller;//联系买家&&我要申诉&&确认已收款，放行
            break;
            
        case SellerOrderTypeAppealing://卖方_订单申诉 (放行订单)
            
            self.orderDetailStyle = OrderDetail_cancelComplain_Seller;//联系买家&&取消申诉
            break;
            
        case SellerOrderTypeFinished://卖方_订单完成 (交易完成)
            
            self.orderDetailStyle = OrderDetail_onlyContactBuyer_Seller;//联系买家
            break;
            
        case SellerOrderTypeCancel://卖方_订单取消 (买家付款)
            
            self.orderDetailStyle = OrderDetail_complainWithoutCancelOrder_Seller;//联系买家&&我要申诉
            break;
            
        case SellerOrderTypeTimeOut://卖方_订单超时 (买家付款)
            
            self.orderDetailStyle = OrderDetail_complainWithoutCancelOrder_Seller;//联系买家&&我要申诉
            break;
        default:
            break;
    }
}

- (void)contactEvent{
    
    if (self.orderDetailModel !=nil) {
        
        NSString *sessionId;
        
        NSString *title;
        
        LoginModel *userInfoModel = [LoginModel mj_objectWithKeyValues:GetUserDefaultWithKey(kUserInfo)];
        
        if ([self.orderDetailModel.sellUserId isEqualToString:userInfoModel.userinfo.userid]){
            
            sessionId = self.orderDetailModel.buyUserId;
            
            title = self.orderDetailModel.buyerName;
        }else{
            
            sessionId = self.orderDetailModel.sellUserId;
            
            title = self.orderDetailModel.sellerName;
        }
        [RongCloudManager updateNickName:title
                                  userId:sessionId];
        
        [RongCloudManager jumpNewSessionWithSessionId:sessionId
                                                title:title
                                         navigationVC:self.navigationController];
    }
}

-(void)popUpViewAndReloadData{
    
    kWeakSelf(self);
    
    if (!self.buy_PaymentPopUpView) {
        
        self.buy_PaymentPopUpView = [[Buy_PaymentPopUpView alloc]initWithOrderDetailStyle:self.orderDetailStyle];
        
        self.buy_PaymentPopUpView.clickEventBlock = ^(ClickEvent clickEvent) {
            
            kStrongSelf(self);
            
            switch (clickEvent) {
                case ClickEvent_contactSeller:{//联系卖家
                    
                    [self contactEvent];
                }
                    break;
                case ClickEvent_havePaid:{//我已付款
                    
                    kStrongSelf(self);
                    
                    //我已付款
                    
                    self.inputPWPopUpView = [[InputPWPopUpView alloc]initWithFrame:CGRectZero WithIsForceNoShowGoogleCodeField:YES];
                    
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
                                                                                                                                   
//                                                                                                                                   //买方_订单已经支付待放行 (等待放行)
//                                                                                                                               case BuyerOrderTypeHadPaidNotDistribute://买方_订单已经支付不放行 (等待放行)
                                                                                                                                   
                                                                                                                                   self.orderDetailStyle = OrderDetail_complainWithCancelOrder_Buyer;//联系卖家&&取消订单&&我要申诉
                                                                                                                                   
//                                                                                                                                   [Buy_WaittingVC pushFromVC:self
//                                                                                                                                                requestParams:data2
//                                                                                                                                                    withModel:payModel
//                                                                                                                                                    orderType:BuyerOrderTypeNotYetPay
//                                                                                                                                                      success:^(id data) {
//
//                                                                                                                                                      }];
                                                                                                                               }
                                                                                                                                   break;
                                                                                                                               case BuyerOrderTypeHadPaidWaitDistribute:{//买方_订单已经支付待放行
                                                                                                                                   
//                                                                                                                                   [Buy_WaittingVC pushFromVC:self
//                                                                                                                                                requestParams:data2
//                                                                                                                                                    withModel:payModel
//                                                                                                                                                    orderType:BuyerOrderTypeHadPaidWaitDistribute
//                                                                                                                                                      success:^(id data) {
//
//                                                                                                                                                      }];
                                                                                                                               }
                                                                                                                                   break;
                                                                                                                               case BuyerOrderTypeHadPaidNotDistribute:{//买方_订单已经支付不放行
                                                                                                                                   
//                                                                                                                                   [Buy_WaittingVC pushFromVC:self
//                                                                                                                                                requestParams:data2
//                                                                                                                                                    withModel:payModel
//                                                                                                                                                    orderType:BuyerOrderTypeHadPaidNotDistribute
//                                                                                                                                                      success:^(id data) {
//
//                                                                                                                                                      }];
                                                                                                                               }
                                                                                                                                   break;
                                                                                                                               case BuyerOrderTypeClosed:{//超时页面
                                                                                                                                   
//                                                                                                                                   [Buy_WaittingVC pushFromVC:self
//                                                                                                                                                requestParams:data2
//                                                                                                                                                    withModel:payModel
//                                                                                                                                                    orderType:BuyerOrderTypeClosed
//                                                                                                                                                      success:^(id data) {
//
//                                                                                                                                                      }];
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
                }
                    break;
                case ClickEvent_nowToConsume:{//现在去消费
                    
                    [ScanCodeVC pushFromVC:self];
                }
                    break;
                case ClickEvent_showMyProperty:{//查看我的资产
                    
                    [AssetsVC pushFromVC:self
                           requestParams:Nil
                                 success:^(id data) {
                                     
                                 }];
                }
                    break;
                case ClickEvent_contactBuyer:{//联系买家
                    
                     [self contactEvent];
                    
                }
                    break;
                case ClickEvent_wannaComplain:{//我想投诉
                    
                    [PostAppealVC pushViewController:self
                                       requestParams:self.orderDetailModel.orderNo
                                           orderType:[self.orderDetailModel getTransactionOrderType]
                                             success:^(id data) {
                                                 
                                             }];
                }
                    break;
                case ClickEvent_confirm:{//确认收款放行
                    
                    
                    kStrongSelf(self);
                    
                    //我已付款
                    
//                    self.inputPWPopUpView = [[InputPWPopUpView alloc]initWithFrame:CGRectZero
//                                                  WithIsForceNoShowGoogleCodeField:YES];
                    
                    self.inputPWPopUpView = [[InputPWPopUpView alloc]initWithFrame:CGRectZero
                                                    WithIsForceShowGoogleCodeField:YES];
                    
                    [self.inputPWPopUpView showInApplicationKeyWindow];
                    
                    [self.inputPWPopUpView actionBlock:^(id data) {
                        
                        kWeakSelf(self);
                        
                        [self.orderDetailvm network_transactionOrderSureDistributeWithCodeDic:data
                                                                            WithRequestParams:self.orderDetailModel.orderNo
                                                                                      success:^(id data) {

                                                                                          ////  ces
                                                                                          kStrongSelf(self);

                                                                                          [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_IsStopTimeRefresh
                                                                                                                                              object:nil];

                                                                                          //                                                                           [self orderDetailView:self.mainView requestListWithPage:1];
                                                                                      } failed:^(id data) {

                                                                                      } error:^(id data) {

                                                                                      }];
                        
                    }];
                }
                    break;
                case ClickEvent_cancelComplain:{//取消申诉
                    
                    
                }
                    break;
                case ClickEvent_cancelOrder:{//取消订单
                    
                    [self.payVM network_canclePayListWithRequestParams:self.orderDetailModel.orderNo
                                                               success:^(id data) {
                                                                   
                                                                   //                                                                   NSLog(@"%@",data);
                                                                   
                                                                   PayModel *model = data;
                                                                   
                                                                   NSLog(@"%@",model.msg);
                                                                   
                                                                   [SVProgressHUD showWithStatus:model.msg
                                                                                        maskType:SVProgressHUDMaskTypeNone];
                                                                   
                                                                   [self performSelector:@selector(SVProgressHUD_Dismiss)
                                                                              withObject:nil
                                                                              afterDelay:1.7];
                                                                   
                                                                   //退回主页面
                                                                   UIViewController *vc = self.navigationController.viewControllers[1];

                                                                   [self.navigationController popToViewController:vc
                                                                                                         animated:YES];
                                                               } failed:^(id data) {
                                                                   
                                                               } error:^(id data) {
                                                                   
                                                               }];
                }
                    break;
                default:
                    break;
            }
        };
    }
    
    [self.buy_PaymentPopUpView showInApplicationKeyWindow];
}

-(void)SVProgressHUD_Dismiss{
    
    [SVProgressHUD dismiss];
}

-(void)initView{

    [self.view addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.edges.equalTo(self.view);
    }];

    if ([userInfoModel.userinfo.userType isEqualToString:@"1"]) {
        
        self.title = @"买币";
        
    }else if ([userInfoModel.userinfo.userType isEqualToString:@"2"]){
        
        self.title = @"卖币";
    }
}

#pragma mark -- <UITableViewDelegate,UITableViewDataSource>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {

        return MAINSCREEN_HEIGHT / 10;
    }
    
    OrderType orderType = [GetUserDefaultWithKey(@"orderType")?GetUserDefaultWithKey(@"orderType"):@(self.orderType) intValue];
    
    switch (orderType) {
        case BuyerOrderTypeNotYetPay:{
            
            if (indexPath.section == 1){
                
                return MAINSCREEN_HEIGHT / 4.5;
            }else if (indexPath.section == 2){
                
                return MAINSCREEN_HEIGHT / 15;
            }else if (indexPath.section == 3){
                
                return MAINSCREEN_HEIGHT / 3;
            }
        }
            break;
        default:{
            
            if (indexPath.section == 1){
                
                switch (self.orderType) {
                    case BuyerOrderTypeAppealing:
                    case SellerOrderTypeAppealing:
                        
                        return MAINSCREEN_HEIGHT / 2;
                        break;
                    case BuyerOrderTypeFinished:
                    case SellerOrderTypeFinished:
                    case SellerOrderTypeWaitDistribute://
                        
                        return MAINSCREEN_HEIGHT / 2.5;
                        break;
                    default:
                        
                        return MAINSCREEN_HEIGHT / 3.5;
                        break;
                }
            }else if (indexPath.section == 2){
                
                switch (self.orderType) {
                    case BuyerOrderTypeHadPaidWaitDistribute:
                    case SellerOrderTypeNotYetPay:
                    case SellerOrderTypeWaitDistribute:
                    case SellerOrderTypeAppealing:
                    case SellerOrderTypeFinished:
                        
                        return MAINSCREEN_HEIGHT / 3.5;
                        break;
                        
                    case BuyerOrderTypeNotYetPay:
                    case SellerOrderTypeTimeOut:
                    case SellerOrderTypeCancel:
                        
                        return MAINSCREEN_HEIGHT / 20;
                        break;
                        
                    default:
                        return 0.00f;
                        break;
                }
            }
        }
            break;
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

    if ([userInfoModel.userinfo.userType isEqualToString:@"1"]) {//普通用户
        
        if (indexPath.section == 0) {
            
            if (!_headCell) {
                
//                NSLog(@"%@",GetUserDefaultWithKey(@"orderType"));
#warning KKK
                NSDictionary *dataDic = @{
                                          @"userType":userInfoModel.userinfo.userType,
//                                          @"orderDetailModel":self.orderDetailModel,
                                          @"orderType":GetUserDefaultWithKey(@"orderType")?GetUserDefaultWithKey(@"orderType"):@(self.orderType)
                                          };
                
                _headCell = [[Buy_HeadTBVCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:ReuseIdentifier
                                                          dataDic:dataDic];
            }
            
            return _headCell;
        }

        OrderType orderType = [GetUserDefaultWithKey(@"orderType")?GetUserDefaultWithKey(@"orderType"):@(self.orderType) intValue];
        
        switch (orderType) {
            case BuyerOrderTypeNotYetPay:{
                
                if (indexPath.section == 1){
                    if (!_buy_Payment_ContentTBVCell) {//
                        
                        NSDictionary *dataDic = @{
                                                  @"name":[NSString isEmpty:self.orderDetailModel.paymentWay.name]?self.orderDetailModel.sellerName:self.orderDetailModel.paymentWay.name,//名
                                                  @"orderNo":[NSString isEmpty:self.orderDetailModel.orderNo]?@"?":self.orderDetailModel.orderNo,//订单号
                                                  @"orderPrice":[NSString isEmpty:self.orderDetailModel.orderPrice]?self.orderDetailModel.price:self.orderDetailModel.orderPrice,//单价//
                                                  @"orderAmount":[NSString isEmpty:self.orderDetailModel.orderAmount]?@"?":[NSString stringWithFormat:@"¥%@",self.orderDetailModel.orderAmount],//订单金额
                                                  @"orderNumber":[NSString isEmpty:self.orderDetailModel.orderNumber]?self.orderDetailModel.orderAmount:self.orderDetailModel.orderNumber//订单数量
                                                  };//
                        
                        _buy_Payment_ContentTBVCell = [[Buy_Payment_ContentTBVCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                                        reuseIdentifier:ReuseIdentifier
                                                                                dataDic:dataDic];
                    }
                    
                    return _buy_Payment_ContentTBVCell;
                    
                }else if (indexPath.section == 2){
                    
                    if (!_tipCell) {
                        
                        NSDictionary *dataDic = @{
                                                  @"restTime":[NSString isEmpty:self.orderDetailModel.restTime]?@"?":self.orderDetailModel.restTime
                                                  
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
                   
                    switch (self.paymentStyle) {
          
                        case PaywayTypeZFB:{//支付宝支付
                            
                            if (!_QRCodeCell) {
                                
                                _QRCodeCell = [[Buy_Payment_QRCodeTBVCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                                                 paymentStyle:PaywayTypeZFB
                                                                              reuseIdentifier:ReuseIdentifier
                                                                                    orderType:@"1"
                                                                                      dataDic:dataDic_01];
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
            }
                break;
            default:{
                
                if (indexPath.section == 1){
                    
                    if (!_orderDetail_ContentTBVCell) {
                        
                        NSDictionary *dataDic = @{
                                                  @"title_mutArr":self.title_mutArr,
                                                  @"titleValue_mutArr":self.titleValue_mutArr,
                                                  @"orderDetailModel":self.orderDetailModel
                                                  };
                        
                        _orderDetail_ContentTBVCell = [[OrderDetail_ContentTBVCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                                             requestParams:dataDic
                                                                           reuseIdentifier:ReuseIdentifier];
                    }
                    
                    return _orderDetail_ContentTBVCell;
                }else if(indexPath.section == 2){
                    
                    NSDictionary *dataDic = @{
                                              @"userType":userInfoModel.userinfo.userType,
                                              @"orderType":@(self.orderType),
                                              @"restTime":self.orderDetailModel.restTime
                                              };
                    
                    if (!_tipsTBVCell) {//官方提醒
                        
                        _tipsTBVCell = [[TipsTBVCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                                 dataDic:dataDic//@"1"
                                                         reuseIdentifier:ReuseIdentifier];
                    }
                    
                    kWeakSelf(self);
                    
                    _tipsTBVCell.MyBlock = ^{
                        
                        kStrongSelf(self);
                        
                        self.buy_PaymentPopUpView.blueBtn.backgroundColor = RGBCOLOR(76, 127, 255);
                        
                        self.buy_PaymentPopUpView.blueBtn.userInteractionEnabled = YES;
                    };
                    
                    return _tipsTBVCell;
                }
            }
                break;
        }
    }else if ([userInfoModel.userinfo.userType isEqualToString:@"2"]){//商家
        
        if (indexPath.section == 0) {
            
            if (!_headCell) {
                
                NSDictionary *dataDic = @{
                                          @"userType":userInfoModel.userinfo.userType,
//                                          @"orderDetailModel":self.orderDetailModel,
                                          @"orderType":@(self.orderType)
                                          };
                
                _headCell = [[Buy_HeadTBVCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:ReuseIdentifier
                                                          dataDic:dataDic];
            }
            
            return _headCell;
        }else if (indexPath.section == 1){
            
            if (!_orderDetail_ContentTBVCell) {
                
                NSDictionary *dataDic = @{
                                          @"orderDetailModel":self.orderDetailModel
                                          };
                
                _orderDetail_ContentTBVCell = [[OrderDetail_ContentTBVCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                                     requestParams:dataDic
                                                                   reuseIdentifier:ReuseIdentifier];
            }
            
            return _orderDetail_ContentTBVCell;
        }else if(indexPath.section == 2){
            
            NSDictionary *dataDic = @{
                                      @"userType":userInfoModel.userinfo.userType,
                                      @"orderType":@(self.orderType),
                                      @"restTime":self.orderDetailModel.restTime
                                      };
            
            if (!_tipsTBVCell) {//官方提醒
                
                _tipsTBVCell = [[TipsTBVCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                         dataDic:dataDic//@"1"
                                                 reuseIdentifier:ReuseIdentifier];
            }
            
            return _tipsTBVCell;
        }
    }
    
    return Nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    switch ([GetUserDefaultWithKey(@"orderType") intValue]) {
        case BuyerOrderTypeNotYetPay:

            return 4;
            break;

        default:{

            return 3;
        }
            break;
    }

    return 0;
    
//    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        
        return 10;
    }
    
    return 0.00f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *view = UIView.new;

    view.backgroundColor = RGBCOLOR(245, 245, 245);

    return view;
}

#pragma mark - lazyLoad

- (PayVM *)payVM {
    
    if (!_payVM) {
        
        _payVM = PayVM.new;
    }
    return _payVM;
}

- (NSMutableArray *)sections {
    
    if (!_sections) {
        
        _sections = NSMutableArray.array;
    }
    return _sections;
}

-(NSMutableArray *)title_mutArr{
    
    if (!_title_mutArr) {
        
        _title_mutArr = NSMutableArray.array;
    }
    
    return _title_mutArr;
}

-(NSMutableArray *)titleValue_mutArr{
    
    if (!_titleValue_mutArr) {
        
        _titleValue_mutArr = NSMutableArray.array;
    }
    
    return _titleValue_mutArr;
}

- (OrderDetailVM *)orderDetailvm {
    
    if (!_orderDetailvm) {
        
        _orderDetailvm = OrderDetailVM.new;
    }
    
    return _orderDetailvm;
}

-(UITableView *)tableView{

    if (!_tableView) {

        _tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                 style:UITableViewStylePlain];

//        _tableView.dataSource = self;
//
//        _tableView.delegate = self;

        _tableView.tableFooterView = UIView.new;
        
        [_tableView YBGeneral_addRefreshHeader:^{
            
            [self netWorkingWithRequestParams:self.requestParams];
        }];

        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }

    return _tableView;
}

-(void)netWorkingWithRequestParams:(id)requestParams{

    kWeakSelf(self);

    [self.orderDetailvm network_getOrderDetailListWithPage:1
                                         WithRequestParams:requestParams
                                                   success:^(id data, id data2, id data3) {

                                                       kStrongSelf(self);
                                                       
                                                       [self.tableView.mj_header endRefreshing];
                                                       
                                                       //1、未付款 2、已付款 3、已完成 4、已取消 5、已关闭(自动) 6、申诉中

                                                       NSLog(@"%@",data);

                                                       NSLog(@"%@",data2);//
                                                       
                                                       NSLog(@"%@",data3);
                                                       
                                                       self.orderDetailModel = data2;
                                                       
                                                       self.paymentStyle = [self.orderDetailModel.paymentWay.paymentWay intValue];
                                                       
                                                       self.orderType = [data3 intValue];
                                     
                                                       [self setttingOrderDetailStyle];
                                                       
                                                       [self popUpViewAndReloadData];
                                                       
                                                       SetUserDefaultKeyWithObject(@"orderType", @(self.orderType));
                                                       
                                                       UserDefaultSynchronize;
                                                       
                                                       NSArray *dataArr = data[0][@"kIndexRow"];

                                                       NSMutableArray *title_mutArr = NSMutableArray.array;

                                                       NSMutableArray *titleValue_mutArr = NSMutableArray.array;

                                                       for (int r = 0; r < dataArr.count; r++) {

                                                           NSDictionary *dic = dataArr[r];

                                                           [title_mutArr addObject:dic.allKeys];

                                                           [titleValue_mutArr addObject:dic.allValues];
                                                       }

                                                       for (int u = 0; u < title_mutArr.count; u++) {

                                                           [self.title_mutArr addObject:title_mutArr[u][0]];
                                                       }

                                                       for (int u = 0; u < titleValue_mutArr.count; u++) {

                                                           [self.titleValue_mutArr addObject:titleValue_mutArr[u][0]];
                                                       }

                                                       self.tableView.dataSource = self;
                                                       
                                                       self.tableView.delegate = self;
                                                       
                                                       [self.tableView reloadData];
                                                       
                                                       NSArray* model = data;
                                                       NSDictionary* dic = model[0];
                                                       self.orderDetailModel = dic[kData];

                                                       NSArray *array = data;

                                                       if (array.count > 0) {

                                                           [self.tableView.mj_footer endRefreshing];
                                                       } else {

                                                           [self.tableView.mj_footer endRefreshingWithNoMoreData];
                                                       }

                                                       [self.tableView.mj_header endRefreshing];

                                                       self->_tableView.tableFooterView.backgroundColor = kWhiteColor;

                                                   } failed:^(id data) {

                                                       NSLog(@"%@",data);

                                                       kStrongSelf(self);
                                                       [self requestListFailed];
                                                   } error:^(id data) {

                                                       NSLog(@"%@",data);

                                                       kStrongSelf(self);
                                                       [self requestListFailed];
                                                   }];
}



-(void)requestListFailed{
    
//    self.currentPage = 0;
    [self.sections removeAllObjects];
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}


//#pragma mark —— 重写该方法以自定义系统导航栏返回按钮点击事件
//-(void)YBGeneral_clickBackItem:(UIBarButtonItem *)item{
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}
//
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self orderDetailView:self.mainView requestListWithPage:1];
////    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
//}
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
////    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
//}
//
//- (void)initViewq {
//    [self.view addSubview:self.mainView];
//    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
//    WS(weakSelf);
//    [self.mainView actionBlock:^(id data,id data2) {
//        EnumActionTag btnType  = [data integerValue];
//
//        switch (btnType) {
//            case EnumActionTag0:
//            {
//                OrderType orderType = [data2 integerValue];
//                if (orderType ==SellerOrderTypeWaitDistribute) {
//                    DistributePopUpView* popupView = [[DistributePopUpView alloc]init];
//                    [popupView richElementsInViewWithModel:weakSelf.orderDetailModel];
//                    [popupView showInApplicationKeyWindow];
//                    [popupView actionBlock:^(id data) {
//                        //post
//                        InputPWPopUpView* popupView = [[InputPWPopUpView alloc]init];
//                        [popupView showInApplicationKeyWindow];
//                        [popupView actionBlock:^(id data) {
////                            [YKToastView showToastText:@"已放行"];
//                            [weakSelf distributeOrder:data];
//                        }];
//                    }];
//                }
//                else if(orderType ==BuyerOrderTypeNotYetPay){
//                    NSLog(@"买方 已完成付款");
//                    SureTipPopUpView* popupView = [[SureTipPopUpView alloc]init];
//                    [popupView showInApplicationKeyWindow];
////                    [popupView richElementsInViewWithModel:[weakSelf.orderDetailModel getPaywayAppendingDicArr]];
//                    [popupView actionBlock:^(id data) {
//                        weakSelf.type = [data integerValue];
//                        [weakSelf surePayOrderEvent];
//                    }];
//                }
//
//                else if(orderType ==BuyerOrderTypeHadPaidNotDistribute){
//                    NSLog(@"买方 我要申诉");
//                    [PostAppealVC pushViewController:self requestParams:self.orderDetailModel.orderNo success:^(id data) {
//                        [self submitAppeal:data];
//                    }];
//                }
//                else if(orderType ==BuyerOrderTypeAppealing
//                        ||
//                    orderType ==SellerOrderTypeAppealing){
//                    NSLog(@"买方、卖方 取消申诉");
//                    [self cancelAppeal];
//                }
//                else if (orderType ==BuyerOrderTypeFinished){
//                    NSLog(@"买方 查看资产");
//                    [AssetsVC pushFromVC:self requestParams:@1 success:^(id data) {
////                        [self.navigationController popToRootViewControllerAnimated:YES];
//                    }];
////                    [self locateTabBar:3];
////                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_jumpAssetVC object:nil];
//                }
//            }
//                break;
//            case EnumActionTag1:
//            {
//                OrderType orderType = [data2 integerValue];
//                if (orderType ==SellerOrderTypeWaitDistribute) {
//                    [PostAppealVC pushViewController:self requestParams:self.orderDetailModel.orderNo success:^(id data) {
//                        [self submitAppeal:data];
//                    }];
//                }
//                else if(orderType ==BuyerOrderTypeNotYetPay){
//                    NSLog(@"买方 取消订单");
//                    CancelTipPopUpView* popupView = [[CancelTipPopUpView alloc]init];
//                    [popupView showInApplicationKeyWindow];
//                    [popupView richElementsInViewWithModel:@2];
//                    [popupView actionBlock:^(id data) {
//                        [self cancelOrderEvent];
//                    }];
//                }
//                else if (orderType ==BuyerOrderTypeFinished){
//                    NSLog(@"买方 扫码转账");
//                    if (GetUserDefaultBoolWithKey(kIsScanTip)) {
//                        [ScanCodeVC pushFromVC:self];
//                    }else{
//                        HomeScanView* scanView = [[HomeScanView alloc]initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT)];
//                        scanView.scanBlock = ^{
//                            [ScanCodeVC pushFromVC:self];
//                        };
//                        scanView.buyBlock = ^{
//
//
//                        };
//                        scanView.helpBlock = ^{
//
//
//                        };
//                        scanView.cancelBlock = ^{
//                        };
//                        //                    [self.tabBarController.view addSubview:scanView];
//                        [[UIApplication sharedApplication].keyWindow addSubview:scanView];
//                    }
//                }
//            }
//                break;
//            case EnumActionTag2:
//            {
//                [self contactEvent];
//
//            }
//                break;
//            case EnumActionTag3:
//            {
//                [self orderDetailView:self.mainView requestListWithPage:1];
//            }
//                break;
//            default:
//                break;
//        }
//    }] ;
//}
//
//- (void)cancelOrderEvent{
//
//    [self.payvm network_canclePayListWithRequestParams:self.orderDetailModel.orderNo success:^(id data) {
//        [self orderDetailView:self.mainView requestListWithPage:1];
//    } failed:^(id data) {
//
//    } error:^(id data) {
//
//    }];
//}
//
//- (void)surePayOrderEvent{
//
//    kWeakSelf(self);
//    [self.payvm network_confirmPayListWithRequestParams:self.orderDetailModel.orderNo WithPaymentWay:[NSString stringWithFormat:@"%lu",(unsigned long)self.type] success:^(id data) {
//        kStrongSelf(self);
//        [self orderDetailView:self.mainView requestListWithPage:1];
//
//    } failed:^(id data) {
//
//    } error:^(id data) {
//
//    }];
//}
//
//- (void)submitAppeal:(id)data{
//
//    kWeakSelf(self);
//    [self.vm network_submitAppealWithRequestParams:data
//                                           success:^(id data) {
//        kStrongSelf(self);
//        [self orderDetailView:self.mainView
//          requestListWithPage:1];
//
//    } failed:^(id data) {
//
//    } error:^(id data) {
//
//    }];
//}
//
//- (void)cancelAppeal{
//
//    kWeakSelf(self);
//    [self.vm network_cancelAppealWithRequestParams:self.orderDetailModel.appealId
//                                           success:^(id data) {
//
//        kStrongSelf(self);
//        [self orderDetailView:self.mainView
//          requestListWithPage:1];
//
//    } failed:^(id data) {
//
//    } error:^(id data) {
//
//    }];
//}
//
//
//- (void)distributeOrder:(id)data{
//    kWeakSelf(self);
//    [self.vm network_transactionOrderSureDistributeWithCodeDic:data WithRequestParams:self.orderDetailModel.orderNo
//    success:^(id data) {
//        kStrongSelf(self);
//        [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_IsStopTimeRefresh object:nil];
//        [self orderDetailView:self.mainView requestListWithPage:1];
//    } failed:^(id data) {
//
//    } error:^(id data) {
//
//    }];
//}
//
//- (void)contactEvent{
//
//    if (self.orderDetailModel!=nil) {
//
//    NSString *sessionId;
//
//    NSString *title;
//
//    LoginModel* userInfoModel = [LoginModel mj_objectWithKeyValues:GetUserDefaultWithKey(kUserInfo)];
//
//    if ([self.orderDetailModel.sellUserId isEqualToString:userInfoModel.userinfo.userid]){
//
//        sessionId = self.orderDetailModel.buyUserId;
//
//        title = self.orderDetailModel.buyerName;
//    }else{
//        sessionId = self.orderDetailModel.sellUserId;
//        title = self.orderDetailModel.sellerName;
//    }
//
//    [RongCloudManager updateNickName:title
//                              userId:sessionId];
//
//    [RongCloudManager jumpNewSessionWithSessionId:sessionId
//                                            title:title
//                                     navigationVC:self.navigationController];
//    }
//}
//
//



@end
