//
//  Buy_FinishedVC.m
//  gt
//
//  Created by Administrator on 04/04/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "Buy_OrderFinishedVC.h"

#import "PayView.h"
#import "PayVM.h"
#import "LoginVM.h"

#import "CancelTipPopUpView.h"
#import "SureTipPopUpView.h"
#import "OrderDetailVC.h"
#import "AssetsVC.h"
#import "ScanCodeVC.h"

#import "OrderDetailVM.h"

#import "Buy_HeadTBVCell.h"
//#import "Buy_Waitting_ContentTBVCell.h"
#import "Buy_OrderFinished_ContentTBVCell.h"

#import "Buy_PaymentPopUpView.h"

@interface Buy_OrderFinishedVC ()<UITableViewDelegate,UITableViewDataSource>// <PayViewDelegate>
{
    
    Buy_PaymentPopUpView *view;
    
    LoginModel *userInfoModel;
}
//@property (nonatomic, strong) PayView *mainView;
@property (nonatomic, strong) PayVM *vm;
@property (nonatomic, strong) id requestParams;
@property (nonatomic, copy) DataBlock block;
@property (nonatomic, strong) PayModel* model;

//@property (nonatomic, strong)OrderDetailVM *orderDetailvm;
@property (nonatomic, strong)LoginVM *loginVM;

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)Buy_HeadTBVCell *headCell;
@property (nonatomic, strong)Buy_OrderFinished_ContentTBVCell *contentCell;

@property (nonatomic, assign) OrderType orderType;

@property (nonatomic, strong)OrderDetailModel *orderDetailModel;

@end

@implementation Buy_OrderFinishedVC

#pragma mark - life cycle

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(id)requestParams
              withPayModel:(PayModel *)model
                   success:(DataBlock)block
{
    Buy_OrderFinishedVC *vc = [[Buy_OrderFinishedVC alloc] init];
    
    vc.block = block;
    
    vc.requestParams = requestParams;
    
    vc.orderDetailModel = requestParams;
    
    vc.model = model;
    
    vc.orderType = [requestParams getTransactionOrderType];
    
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
    
    if (!view) {
        
        view = [[Buy_PaymentPopUpView alloc]initWithOrderDetailStyle:OrderDetail_showMyCapitalAndConsumeNow_Buyer];
        
        view.clickEventBlock = ^(ClickEvent clickEvent) {
            kStrongSelf(self);
            
            switch (clickEvent) {
                case ClickEvent_contactSeller:{//联系卖家

                    [self contactEvent];

                }
                    break;
                case ClickEvent_showMyProperty:{//查看我的资产
                    
                    [AssetsVC pushFromVC:self
                           requestParams:Nil
                                 success:^(id data) {
                               
                           }];
                }
                    break;
                case ClickEvent_nowToConsume:{//现在去消费
                    
                    [ScanCodeVC pushFromVC:self];
                }
                    break;
                    
                default:
                    break;
            }
        };
    }
    
    [view showInApplicationKeyWindow];
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
        
        return MAINSCREEN_HEIGHT / 2;
        
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

            _contentCell = [[Buy_OrderFinished_ContentTBVCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                                    requestParams:self.orderDetailModel
                                                                  reuseIdentifier:ReuseIdentifier];

        }

        return _contentCell;
    }
    
    return Nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
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
        
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    
    return _tableView;
}

- (PayVM *)vm {
    
    if (!_vm) {
        
        _vm = PayVM.new;
    }
    return _vm;
}



@end
