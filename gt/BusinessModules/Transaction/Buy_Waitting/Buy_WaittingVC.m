//
//  Buy_WaittingVC.m
//  gt
//
//  Created by Administrator on 03/04/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "Buy_WaittingVC.h"
#import "Buy_OrderFinishedVC.h"
#import "OrderDetailVC.h"
#import "PostAppealVC.h"

#import "CancelTipPopUpView.h"
#import "Buy_PaymentPopUpView.h"
#import "SureTipPopUpView.h"

#import "Buy_HeadTBVCell.h"
#import "Buy_Waitting_ContentTBVCell.h"
#import "TipsTBVCell.h"

#import "PayView.h"
#import "PayVM.h"
#import "OrderDetailVM.h"
#import "LoginVM.h"
#import "OrderDetailVM.h"

@interface Buy_WaittingVC ()<UITableViewDelegate,UITableViewDataSource>// <PayViewDelegate>
{
    
    LoginModel *userInfoModel;
    
}
//@property (nonatomic, strong) PayView *mainView;
@property (nonatomic, strong)PayVM *payVM;
@property (nonatomic, strong)id requestParams;
@property (nonatomic, copy)DataBlock block;
@property (nonatomic, strong)PayModel* payModel;
@property (nonatomic, strong)OrderDetailModel* orderDetailModel;
@property (nonatomic, assign)OrderType orderType;

//@property (nonatomic, assign)PaywayType type;
@property (nonatomic, strong)OrderDetailVM *orderDetailvm;
@property (nonatomic, strong)LoginVM *loginVM;

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)Buy_HeadTBVCell *headCell;
@property (nonatomic, strong)TipsTBVCell *tipsTBVCell;
@property (nonatomic, strong)Buy_Waitting_ContentTBVCell *contentCell;
@property (nonatomic, strong)Buy_PaymentPopUpView *buy_PaymentPopUpView;

@end

@implementation Buy_WaittingVC

#pragma mark - life cycle

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(id)requestParams
                 withModel:(PayModel *)model
                 orderType:(OrderType)orderType
                   success:(DataBlock)block
{
    Buy_WaittingVC *vc = [[Buy_WaittingVC alloc] init];
    
    vc.block = block;
    
    vc.orderDetailModel = requestParams;
    
    vc.orderType = orderType;
    
    vc.requestParams = requestParams;
    
    vc.payModel = model;

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
        [RongCloudManager updateNickName:title
                                  userId:sessionId];
        
        [RongCloudManager jumpNewSessionWithSessionId:sessionId
                                                title:title
                                         navigationVC:self.navigationController];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    kWeakSelf(self);
    
    if (!self.buy_PaymentPopUpView) {
        
        self.buy_PaymentPopUpView = [[Buy_PaymentPopUpView alloc]initWithOrderDetailStyle:OrderDetail_complainWithCancelOrder_Buyer];

        self.buy_PaymentPopUpView.clickEventBlock = ^(ClickEvent clickEvent) {
            
            kStrongSelf(self);
            
            switch (clickEvent) {
                case ClickEvent_wannaComplain:{//我想投诉
                    
                    OrderDetailModel *orderDetailModel = self.requestParams;
                    
                    [PostAppealVC pushViewController:self
                                       requestParams:orderDetailModel.orderNo
                                           orderType:[orderDetailModel getTransactionOrderType]
                                             success:^(id data) {
                        
                    }];
                }
                    break;
                case ClickEvent_contactSeller:{//联系卖家
                    
                    kStrongSelf(self);
                    
                    [self contactEvent];
                }
                    break;
                case ClickEvent_cancelOrder:{//取消订单
                    
                    CancelTipPopUpView *popupView = [[CancelTipPopUpView alloc]init];
                    
                    [popupView showInApplicationKeyWindow];
                    
                    [popupView richElementsInViewWithModel:@1];
                    
                    [popupView actionBlock:^(id data) {
                        
                        kStrongSelf(self);
                        
                        [self cancelOrderEvent];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_IsPayStopTimeRefresh
                                                                            object:nil];
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

#pragma mark —— 取消订单
- (void)cancelOrderEvent{
    
    kWeakSelf(self);
    
    NSLog(@"%@",self.orderDetailModel.orderNo);
    
    [self.payVM network_canclePayListWithRequestParams:self.orderDetailModel.orderNo
                                               success:^(id data) {
                                               
                                                   kStrongSelf(self);
                                                   PayModel* model = data;           [OrderDetailVC pushViewController:self
                                                                       requestParams:model.orderNo
                                                                             success:^(id data) {
                                                                                 
                                                                             }];
                                               } failed:^(id data) {
                                                   
                                               } error:^(id data) {
                                                   
                                               }];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [self.buy_PaymentPopUpView disappear];
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

        switch (self.orderType) {
             
            case BuyerOrderTypeNotYetPay://买方_订单还未支付
            case BuyerOrderTypeHadPaidNotDistribute://买方_订单已经支付不放行
            case BuyerOrderTypeClosed://超时页面
                
                return MAINSCREEN_HEIGHT / 3.5;
                
                break;
            case BuyerOrderTypeHadPaidWaitDistribute://买方_订单已经支付待放行

                return MAINSCREEN_HEIGHT / 3;
                
                break;
            default:
                break;
        }
    }else if (indexPath.section == 2){
        
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
                                      @"orderType":@(self.orderType)
                                      };
            
            _headCell = [[Buy_HeadTBVCell alloc]initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:ReuseIdentifier
                                                      dataDic:dataDic];

        }
        
        return _headCell;
        
    }else if (indexPath.section == 1){
        if (!_contentCell) {//
            
            _contentCell = [[Buy_Waitting_ContentTBVCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                               requestParams:self.requestParams
                                                             reuseIdentifier:ReuseIdentifier];
        }
        
        return _contentCell;
        
    }else if (indexPath.section == 2){
        
        if (!_tipsTBVCell) {
            
            NSDictionary *dataDic = @{
                                      @"userType":userInfoModel.userinfo.userType,
                                      @"orderType":@(self.orderType),
                                      @"restTime":self.orderDetailModel.restTime
                                      };
            
            _tipsTBVCell = [[TipsTBVCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                           dataDic:dataDic
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
    
    return Nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        
        return 10;
    }
    
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = UIView.new;
    
    view.backgroundColor = RGBCOLOR(245, 245, 245);
    
    return view;
}

#pragma mark - lazyload
-(UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                 style:UITableViewStylePlain];
        
        _tableView.dataSource = self;
        
        _tableView.delegate = self;
        
        _tableView.tableFooterView = UIView.new;
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                refreshingAction:@selector(reloadData)];
        
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    
    return _tableView;
}

#pragma mark —— 下拉刷新
-(void)reloadData{
    
    kWeakSelf(self);
    
    [self.orderDetailvm network_getOrderDetailListWithPage:1
                                         WithRequestParams:self.orderDetailModel.orderId
                                                   success:^(id data, id data2, id data3) {
                                                       kStrongSelf(self);
                                                       
                                                       [self.tableView.mj_header endRefreshing];
                                                       
                                                       //根据状态不同推页面
                                                       OrderDetailModel *model = data2;
                                                       
                                                       switch ([model getTransactionOrderType]) {
                                                               
                                                           case BuyerOrderTypeHadPaidNotDistribute:{//买方_订单已经支付不放行 (等待放行)
                                                               //有问题
                                                               [Buy_OrderFinishedVC pushFromVC:self
                                                                                 requestParams:model
                                                                                  withPayModel:nil
                                                                                       success:^(id data) {
                                                                   
                                                               }];
                                                           }
                                                               break;
                                                           case BuyerOrderTypeAppealing:{//申诉中
                                                               
                                                               [PostAppealVC pushViewController:self
                                                                                  requestParams:model.orderNo
                                                                                      orderType:[model getTransactionOrderType]
                                                                                        success:^(id data) {
                                                                   
                                                               }];
                                                           }
                                                               break;
                                                           case BuyerOrderTypeFinished:{//订单已放行(结束)
                                                               
                                                               [Buy_OrderFinishedVC pushFromVC:self
                                                                                 requestParams:model
                                                                                  withPayModel:nil
                                                                                       success:^(id data) {
                                                                                           
                                                                                       }];
                                                           }
                                                               break;
                                                           default:
                                                               break;
                                                       }
                                                   }
                                                    failed:^(id data) {
                                                        
                                                        NSLog(@"%@",data);
                                                        
                                                        [self.tableView.mj_header endRefreshing];
                                                    }
                                                     error:^(id data) {
                                                         
                                                         NSLog(@"%@",data);
                                                         
                                                         [self.tableView.mj_header endRefreshing];
                                                     }];
    
    
}

-(LoginVM *)loginVM{
    
    if (!_loginVM) {
        
        _loginVM = LoginVM.new;
    }
    
    return _loginVM;
}

- (PayVM *)payVM {
    
    if (!_payVM) {
        
        _payVM = PayVM.new;
    }
    return _payVM;
}

-(OrderDetailVM *)orderDetailvm{
    
    if (!_orderDetailvm) {
        
        _orderDetailvm = OrderDetailVM.new;
    }
    
    return _orderDetailvm;
}

@end
