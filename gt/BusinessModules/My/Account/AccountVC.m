//
//  AccountVC.m
//  gt
//
//  Created by 钢镚儿 on 2018/12/19.
//  Copyright © 2018年 GT. All rights reserved.

#import "AccountVC.h"

#import "AddAccountVC.h"

#import "MyAccountCell.h"

#import "TablePopUpView.h"
#import "AccountDeleteTipPopUpView.h"
#import "PaymentAccountVM.h"
#import "PaymentAccountModel.h"
@interface AccountVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSources;
@property (nonatomic, copy) NSArray *tablePopUpDataSource;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) PaymentAccountVM* vm;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) id requestParams;
@property (nonatomic, copy) DataBlock block;
@property (nonatomic, strong)UIView *backView;
@end

@implementation AccountVC
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block{
    AccountVC *vc = [[AccountVC alloc] init];
    vc.block = block;
    vc.requestParams = requestParams;
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}

#pragma mark —— 重写该方法以自定义系统导航栏返回按钮点击事件 
-(void)YBGeneral_clickBackItem:(UIBarButtonItem *)item{
    //    [self locateTabBar:3];
    [self.navigationController popViewControllerAnimated:YES];
    

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_interactivePopDisabled = YES;
    [self YBGeneral_baseConfig];
    self.title = @"收款账号";
    _tablePopUpDataSource = @[
                    @{@"微信支付":@"icon_weixin"},
                    @{@"支付宝":@"icon_zhifubao"},
                    @{@"银行卡":@"icon_bank"}
                    ];
    [self initView];
    [self.tableView.mj_header beginRefreshing];
    [self setEmptyView];
}

- (void)requestListWithPage:(NSInteger)page{
    kWeakSelf(self);
    [self.vm network_accountListRequestParams:@(page)
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

#pragma mark - public
- (void)requestListSuccessWithArray:(NSArray *)array
                           WithPage:(NSInteger)page {
    
    self.currentPage = page;
    if (self.currentPage == 1) {
        [self.dataSources removeAllObjects];
        [self.tableView reloadData];
    }
    if (page == 1&&array.count==0) {
        _backView.hidden = NO;
        [self.tableView.mj_header endRefreshing];
        return;
    }
    if (array.count > 0) {
        _backView.hidden =YES;
        [self.dataSources addObjectsFromArray:array];
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    } else {
        _backView.hidden = NO;
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    [self.tableView.mj_header endRefreshing];
}

- (void)requestListFailed {
    self.currentPage = 0;
    [self.dataSources removeAllObjects];
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}
-(void)setEmptyView{
    UIView *backView = [[UIView alloc]init];
    self.backView = backView;
    backView.backgroundColor = kTableViewBackgroundColor;
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    //上传图片大按钮
    UIButton* uploadImgBtn = [[UIButton alloc] init];
    [backView addSubview:uploadImgBtn];
    [uploadImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(118);
        make.top.equalTo(backView.mas_top).offset(46);
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.centerX.mas_equalTo(backView);
    }];
    
    [uploadImgBtn.layer setCornerRadius:5];
    uploadImgBtn.layer.masksToBounds = YES;
    [uploadImgBtn.layer setBorderColor:[UIColor colorWithRed:216.0/256 green:216.0/256 blue:216.0/256 alpha:1].CGColor];
    [uploadImgBtn.layer setBorderWidth:1.0];
    uploadImgBtn.backgroundColor = [UIColor colorWithRed:247.0/256 green:248.0/256 blue:249.0/256 alpha:1];
    [uploadImgBtn addTarget:self action:@selector(addButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [uploadImgBtn.imageView setContentMode:UIViewContentModeScaleAspectFill];
    [uploadImgBtn setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
    uploadImgBtn.contentVerticalAlignment =UIControlContentVerticalAlignmentCenter;
    uploadImgBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    UILabel * titleLb = [[UILabel alloc] init];
    titleLb.text = @"添加收款账号";
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.font = [UIFont systemFontOfSize:15];
    titleLb.textColor = HEXCOLOR(0x9B9B9B);
    [uploadImgBtn addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(21);
        make.bottom.mas_equalTo(uploadImgBtn.mas_bottom).offset(-15);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.centerX.mas_equalTo(uploadImgBtn);
    }];
}

-(void)initView{
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeSystem];
    addButton.frame = CGRectMake(0, 0, 80, 40);
    [addButton setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
    addButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.view.backgroundColor = [UIColor colorWithRed:248.0/256 green:248.0/256 blue:250.0/256 alpha:1];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

-(void)addButtonClicked{
    TablePopUpView* popupView = [[TablePopUpView alloc]init];
    [popupView richElementsInViewWithModel:_tablePopUpDataSource];
    [popupView showInApplicationKeyWindow];
    [popupView actionBlock:^(id data) {
        
        PaywayType tag = [data integerValue];
        
        [AddAccountVC pushFromVC:self
                  withPaywayType:tag+1
                 paywayOccurType:PaywayOccurTypeCreate
                         success:^(id data) {
                     
            [self requestListWithPage:1];
        }];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSources.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [MyAccountCell cellHeightWithModel];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyAccountCell* cell = [MyAccountCell cellWith:tableView];
    PaymentAccountData* accdata = self.dataSources[indexPath.row];
    [cell richElementsInCellWithModel:accdata];
    kWeakSelf(self);
    [cell actionBlock:^(id data) {
        UISwitch* switchFunc = data;
        [self.vm network_switchAccountRequestParams:accdata.paymentWayId withOpenStatus:switchFunc.isOn ==YES?@"1":@"2" success:^(id data) {
            kStrongSelf(self);
            [self requestListWithPage:1];
            
        } failed:^(id data) {
            [self requestListWithPage:1];
            
        } error:^(id data) {
            [self requestListWithPage:1];
        }];
    }];
    [cell deleteActionBlock:^(id data) {
        PaymentAccountData* accdata = self.dataSources[indexPath.row];
        NSDictionary* dic = [accdata getPaymentAccountTypeName];
        AccountDeleteTipPopUpView* popupView = [[AccountDeleteTipPopUpView alloc]init];
        [popupView showInApplicationKeyWindow];
        [popupView richElementsInViewWithModel:dic.allKeys[0]];
        [popupView actionBlock:^(id data) {
            
            [self.vm network_deleteAccountRequestParams:accdata.paymentWayId success:^(id data) {
                [tableView beginUpdates];
                [self.dataSources removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationLeft];
                if (self.dataSources.count==0) {
                    [self setEmptyView];
                }
                [tableView reloadData];
                
                [tableView endUpdates];
            } failed:^(id data) {
                
            } error:^(id data) {
                
            }];
        }];
    }];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
//
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//
//-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return  UITableViewCellEditingStyleDelete;
//}
//
////进入编辑（删除）模式
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //出现alterView隐藏删除按钮
//    [tableView setEditing:NO animated:YES];
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        
//        PaymentAccountData* accdata = self.dataSources[indexPath.row];
//        NSDictionary* dic = [accdata getPaymentAccountTypeName];
//        AccountDeleteTipPopUpView* popupView = [[AccountDeleteTipPopUpView alloc]init];
//        [popupView showInApplicationKeyWindow];
//        [popupView richElementsInViewWithModel:dic.allKeys[0]];
//        [popupView actionBlock:^(id data) {
//            
//            [self.vm network_deleteAccountRequestParams:accdata.paymentWayId success:^(id data) {
//                [tableView beginUpdates];
//                [self.dataSources removeObjectAtIndex:indexPath.row];
//                [tableView deleteRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationLeft];
//                [tableView reloadData];
//                
//                [tableView endUpdates];
//            } failed:^(id data) {
//                
//            } error:^(id data) {
//                
//            }];
//            
//            
//        }];
//    }
//}
//
////修改编辑按钮文字
//-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return @"删除";
//}
////设置进入编辑状态时，Cell不会缩进
//- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return NO;
//}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        //        [_tableView YBGeneral_configuration];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = kTableViewBackgroundColor;
        
        kWeakSelf(self);
        [_tableView YBGeneral_addRefreshHeader:^{
            kStrongSelf(self);
            self.currentPage = 1;
            [self  requestListWithPage:self.currentPage];
        }
//        footer:^{
//            kStrongSelf(self);
//            ++self.currentPage;
//            [self requestListWithPage:self.currentPage];
//        }
         ];
    }
    return _tableView;
}

- (NSUInteger)currentPage {
    if (!_currentPage) {
        _currentPage = 0;
    }
    return _currentPage;
}

- (NSMutableArray *)dataSources {
    if (!_dataSources) {
        _dataSources = [NSMutableArray array];
    }
    return _dataSources;
}

- (PaymentAccountVM *)vm {
    if (!_vm) {
        _vm = [PaymentAccountVM new];
    }
    return _vm;
}

@end
