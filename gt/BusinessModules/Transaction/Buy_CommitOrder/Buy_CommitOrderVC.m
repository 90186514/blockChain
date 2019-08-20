//
//  BuyABViewController.m
//  OTC
//
//  Created by David on 2018/11/17.
//  Copyright © 2018年 yang peng. All rights reserved.
//



//#import "BuyHV.h"

#import "PaymentAccountVM.h"
#import "PayVM.h"

#import "Buy_CommitOrderVC.h"
#import "Buy_PaymentVC.h"
#import "SecuritySettingVC.h"

#import "TransactionModel.h"

#import "Buy_HeadTBVCell.h"
#import "Buy_CommitOrder_ContentTBVCell.h"
#import "Buy_NotifyTBVCell.h"
#import "PostAdsReplyCell.h"
#import "BaseCell.h"
#import "PostAdsSectionHeaderView.h"
#import "SubmitOrderPopView.h"
#import "BuyTipPopUpView.h"

#import "OrderDetailModel.h"

@interface Buy_CommitOrderVC ()<UITableViewDelegate,UITableViewDataSource>{
    
    TransactionData *itemData;
    
    SubmitOrderPopView *submitOrderPopView;
    
    LoginModel *userInfoModel;
}

@property (nonatomic, strong) TransactionData * requestParams;
@property (nonatomic, copy) DataBlock block;
@property (nonatomic, strong) UITableView *tableView;
//@property (nonatomic, strong) BuyHV* buyHV;
@property (nonatomic, copy) NSString* limitNum;
@property (nonatomic, copy) NSString* remark;
@property (nonatomic, strong) PayVM *vm;

@property (nonatomic, strong) NSMutableArray *dataSources;

@property (nonatomic, strong) PaymentAccountVM *vmer;

@property (nonatomic,assign) PaywayType paywayType;
@property (nonatomic,assign) PaywayOccurType paywayOccurType;
@property (nonatomic,copy) NSString *transactionAmountType;

@property (nonatomic, strong)Buy_HeadTBVCell *headCell;
@property (nonatomic, strong)Buy_CommitOrder_ContentTBVCell *contentCell;
@property (nonatomic, strong)Buy_NotifyTBVCell *notifyCell;
@property (nonatomic, strong)OrderDetailModel *orderDetailModel;
@property (nonatomic, assign) OrderType orderType;

@end

@implementation Buy_CommitOrderVC

#pragma mark - life cycle

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(id)requestParams
 withTransactionAmountType:(NSString *)transactionAmountType
           paywayOccurType:(PaywayOccurType)paywayOccurType
                   success:(DataBlock)block{
    
    Buy_CommitOrderVC *vc = [[Buy_CommitOrderVC alloc] init];
    
    vc.block = block;
    
    vc.requestParams = requestParams;//总数据
    
    vc.transactionAmountType = transactionAmountType;//限额 还是 固额
    
    vc.orderDetailModel = requestParams;
    
//    vc.paywayType = paywayType;
    
    vc.paywayOccurType = paywayOccurType;
    
    [rootVC.navigationController pushViewController:vc
                                           animated:true];
    
    return vc;
}

-(void)viewDidLoad{

    [super viewDidLoad];
    
    userInfoModel = [LoginModel mj_objectWithKeyValues:GetUserDefaultWithKey(kUserInfo)];
    
    self.orderType = BuyerOrderTypeAllPay;
    
    SetUserDefaultKeyWithObject(@"orderType", @(self.orderType));
    
    UserDefaultSynchronize;
    
    self.title = @"买币";
    
    [self initView];
}

-(void)initView{

    [self.view addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.edges.equalTo(self.view);
    }];
}

-(TransactionAmountType)choiceTransactionAmountType{
    
    TransactionData* itemData = self.requestParams;
    
    switch ([itemData.amountType intValue]) {//金额类型 : 1、限额 2、固额
        case 1:
            return TransactionAmountTypeLimit;//单笔限额
            break;
        case 2:
            return TransactionAmountTypeFixed;//单笔固额
            break;
            
        default:
            break;
    }
    
    return TransactionAmountTypeNone;
}

#pragma mark -- <UITableViewDelegate,UITableViewDataSource>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {

        return MAINSCREEN_HEIGHT / 10;

    }else if (indexPath.section == 1){

        return MAINSCREEN_HEIGHT / 3;

    }else if (indexPath.section == 2){

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
                                      @"orderDetailModel":self.orderDetailModel,
                                      @"orderType":@(self.orderType)
                                      };
            
            _headCell = [[Buy_HeadTBVCell alloc]initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:ReuseIdentifier
                                                      dataDic:dataDic];
        }

        return _headCell;

    }else if (indexPath.section == 1){
        if (!_contentCell) {//
            
            itemData = self.requestParams;

            _contentCell = [[Buy_CommitOrder_ContentTBVCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                                reuseIdentifier:ReuseIdentifier
                                                                     amountType:[self choiceTransactionAmountType]
                                                                     paymentway:itemData.paymentway];

            _contentCell.nameStr = itemData.nickName;
            _contentCell.volumeOfBusinessStr = [NSString stringWithFormat:@"交易量:%@",itemData.orderAllNumber];
            _contentCell.successRateStr = [NSString stringWithFormat:@"成功率:%@",itemData.successRate];
            
//            金额类型 : 1、限额 2、固额
            if ([itemData.amountType isEqualToString:@"1"]) {
                
                _contentCell.surplusPurchasableNumStr = [NSString stringWithFormat:@"%@ BUB",itemData.balance];
                
            }else if ([itemData.amountType isEqualToString:@"2"]){
                
                _contentCell.surplusPurchasableNumStr = [NSString stringWithFormat:@"%@ BUB",itemData.fixedAmount];
            }

            _contentCell.oncePurchasableNumStr = [NSString stringWithFormat:@"¥%@ ~¥%@",itemData.limitMinAmount,itemData.limitMaxAmount];
            _contentCell.unitPriceStr = [NSString stringWithFormat:@"¥%@",itemData.price];

            NSLog(@"itemData.userId = %@",itemData.userId);
        }

        return _contentCell;

    }else if (indexPath.section == 2){

        if (!_notifyCell) {
            
            _notifyCell = [[Buy_NotifyTBVCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:ReuseIdentifier];
            
            kWeakSelf(self);
            
            _notifyCell.myBlock = ^{
                
                kStrongSelf(self);
                //推出弹窗
                if ([self.transactionAmountType isEqualToString:@"1"]) {//限额
                    
                    self->submitOrderPopView = [[SubmitOrderPopView alloc]initWithPaymentWay:self->itemData.paymentway
                                                                                  QuotaStyle:TransactionAmountTypeLimit];
                    
                }else if ([self.transactionAmountType isEqualToString:@"2"]){//固额
                    
                    self->submitOrderPopView = [[SubmitOrderPopView alloc]initWithPaymentWay:self->itemData.paymentway
                                                                                  QuotaStyle:TransactionAmountTypeFixed];
                }
                
                self.paywayType = self->submitOrderPopView.paymentStyle;
                
                self->submitOrderPopView.quotaStr = [NSString stringWithFormat:@"¥%@ ~¥%@",[NSString isEmpty:self->itemData.limitMinAmount]?@"?":self->itemData.limitMinAmount,[NSString isEmpty:self->itemData.limitMaxAmount]?@"?":self->itemData.limitMaxAmount];
                
                self->submitOrderPopView.remainingStr = [NSString stringWithFormat:@"%@ BUB",[NSString isEmpty:self->itemData.balance]?@"?":self->itemData.balance];
                
                self->submitOrderPopView.fixedAmountStr = [NSString isEmpty:self->itemData.fixedAmount]?@"?":self->itemData.fixedAmount;
                
                [self->submitOrderPopView showInApplicationKeyWindow];
                
                kWeakSelf(self);
                
                self->submitOrderPopView.MyBlock = ^{
                    
                    kStrongSelf(self);
                    
                    if ([self->itemData.amountType isEqualToString:@"1"]) {//限额

                        if (![NSString isEmpty:self->submitOrderPopView.leftTextField.text]){
                            
                            int my = [self->submitOrderPopView.leftTextField.text intValue];
                            
                            int minOnce = [self->itemData.limitMinAmount intValue];//单次购买最小值
                            
                            int maxOnce = [self->itemData.limitMaxAmount intValue];//单次购买最大值
                            
                            int remaining = [self->itemData.balance intValue];//剩余可购买数量
                            
                            if (my < minOnce) {
                                
                                //弹出限额标示
                                //小于最小交易额度
                                
                                [self->submitOrderPopView showWarning:MoreOrLessOnce_less];
                                
                            }else if (my > maxOnce){
                                
                                //弹出限额标示
                                //大于最大交易额度
                                
                                [self->submitOrderPopView showWarning:MoreOrLessOnce_more];
                            }else if (my > remaining){
                                //
                                [self->submitOrderPopView showWarning:MoreOrLessRemain];
                            }else{
                                //正常的 可以放行
                                [self->submitOrderPopView resignFirstResponder];
                                
                                //进行网络请求获取订单的情况
                                [self.vm network_postPayListWithPage:nil
                                                   WithRequestParams:@{
                                                                       @"ugOtcAdvertId":self->itemData.ugOtcAdvertId,//广告ID
                                                                       @"number":self->submitOrderPopView.leftTextField.text,//购买数量
                                                                       @"paymentWay":[self paymentWay:self.paywayType],//支付方式 (1、微信;2、支付宝;3、银行卡)
                                                                       @"remark":@""//备注
                                                                       }
                                                             success:^(id data, id data2) {
                                                                 
                                                                 OrderDetailModel *model = data2;
                                                                 
                                                                 NSLog(@"%lu",(unsigned long)self.paywayType);
                                                                 
                                                                 NSLog(@"%@",model.paymentWay.QRCode);
                                                                 
                                                                 //                                                             NSLog(@"%@",self.orderDetailModel.errcode);
                                                                 [self->submitOrderPopView disMissView];
                                                                 
                                                                 [Buy_PaymentVC pushFromVC:self
                                                                             requestParams:data2
                                                                                 withModel:model
                                                                                paymentWay:self->submitOrderPopView.paymentStyle
                                                                                   success:^(id data) {
                                                                                       
                                                                                   }];
                                                             }
                                                              failed:^(id data) {
                                                                  
                                                                  NSLog(@"failed_%@",data);
                                                                  
                                                                  if ([data isKindOfClass:[NSDictionary class]]) {
                                                                      
                                                                      [SVProgressHUD showWithStatus:(NSString *)data[@"msg"]
                                                                                           maskType:SVProgressHUDMaskTypeNone];
                                                                      
                                                                      [self performSelector:@selector(SVProgressHUD_Dismiss)
                                                                                 withObject:nil
                                                                                 afterDelay:1.7];
                                                                  }
                                                              }
                                                               error:^(id data) {
                                                                   
                                                                   NSLog(@"error_%@",data);
                                                               }];
                            }
                        }
                    }else if ([self->itemData.amountType isEqualToString:@"2"]){//固额

                        [self.vm network_postPayListWithPage:nil
                                           WithRequestParams:@{
                                                               @"ugOtcAdvertId":self->itemData.ugOtcAdvertId,//广告ID
                                                               @"number":self->itemData.fixedAmount,//购买数量
                                                               @"paymentWay":[self paymentWay:self.paywayType],//支付方式 (1、微信;2、支付宝;3、银行卡)
                                                               @"remark":@""//备注
                                                               }
                                                     success:^(id data, id data2) {
                                                         
                                                         NSLog(@"%@",data2);
                                                         
                                                         OrderDetailModel *model = data2;
                                                         
                                                         [self->submitOrderPopView disMissView];
                                                         
                                                         [Buy_PaymentVC pushFromVC:self
                                                                     requestParams:data2
                                                                         withModel:model
                                                                        paymentWay:self->submitOrderPopView.paymentStyle
                                                                           success:^(id data) {
                                                                               
                                                                           }];
                                                     }
                                                      failed:^(id data) {
                                                          
                                                          NSLog(@"failed_%@",data);
                                                          
                                                          if ([data isKindOfClass:[NSDictionary class]]) {
                                                              
                                                              self->submitOrderPopView.fixedAmountMsg = data[@"msg"];
                                                          }
                                                      }
                                                       error:^(id data) {
                                                           
                                                           NSLog(@"error_%@",data);
                                                       }];
                    }
                };
                
                [self->submitOrderPopView actionBlock:^(id data) {
                    
//                    kStrongSelf(self);
                }];
            };
        }

        return _notifyCell;
    }

    return Nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = UIView.new;
    
    view.backgroundColor = RGBCOLOR(245, 245, 245);
    
    return view;
}

- (void)requestListWithPage:(NSInteger)page{
    
    kWeakSelf(self);
    
    [self.vmer network_accountListRequestParams:@(page)
                                      success:^(id data) {
                                          kStrongSelf(self);
                                          [self requestListSuccessWithArray:data
                                                                   WithPage:page];
                                      } failed:^(id data) {
                                          kStrongSelf(self);
                                          [self requestListFailed];
                                      } error:^(id data) {
                                          [self requestListFailed];
                                      }];
}

- (void)requestListFailed {
    
    [self.dataSources removeAllObjects];
}

- (void)requestListSuccessWithArray:(NSArray *)array
                           WithPage:(NSInteger)page {
    
    
}

-(NSString *)paymentWay:(PaywayType)paywayType{
    
    switch (paywayType) {
        case PaywayTypeWX:
            return @"1";
            break;
        case PaywayTypeZFB:
            return @"2";
            break;
        case PaywayTypeCard:
            return @"3";
            break;
            
        default:
            break;
    }
    
    return @"";
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
        
        _vm = [PayVM new];
    }
    return _vm;
}

- (NSMutableArray *)dataSources {
    
    if (!_dataSources) {
        
        _dataSources = [NSMutableArray array];
    }
    return _dataSources;
}

-(PaymentAccountVM *)vmer{
    
    if (!_vmer) {
        
        _vmer = PaymentAccountVM.new;
    }
    
    return _vmer;
}

-(void)actionBlock:(ActionBlock)block{
    
    self.block= block;
}

-(void)SVProgressHUD_Dismiss{
    
    [SVProgressHUD dismiss];
}

@end
