//
//  PostAdsView.m
//  gtp
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "PostAdsView.h"
#import "PostAdsTypeCell.h"
#import "PostAdsSlideCell.h"
#import "PostAdsPaysCell.h"
#import "PostAdsReplyCell.h"
#import "PostAdsRestrictCell.h"
#import "BaseCell.h"

#import "PostAdsFV.h"

#import "PostAdsSectionHeaderView.h"

#import "HomeVM.h"
#import "InputPWPopUpView.h"
#import "ModifyAdsModel.h"
@interface PostAdsView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong) PostAdsFV* pafv;
@property (nonatomic, copy) EightDataBlock block;


@property (nonatomic, assign) PostAdsType postAdsType;
@property (nonatomic, strong) ModifyAdsModel* modifyAdsModel;

@property (nonatomic, copy) NSArray *sliderArrs;
@property (nonatomic, assign) TransactionAmountType transactionAmountType;

@property (nonatomic, copy) NSString *payString;
@property (nonatomic, copy) NSString *remarkString;

@property (nonatomic, copy) NSArray *selectedLimits;


@property (nonatomic, copy) NSString *ugAdID;
@end

@implementation PostAdsView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.transactionAmountType = TransactionAmountTypeNone;
        self.payString = @"";
        self.remarkString = @"";
//        self.backgroundColor = kWhiteColor;
        [self initViews];
        
        [self.tableView.mj_header beginRefreshing];
        
        
    }
    return self;
}

- (void)initViews {
    [self addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - public
-(void)refeshPayCellInPostAds:(NSArray *)array{
    [self.tableView beginUpdates];
    [self.sections removeAllObjects];
    [self.sections addObjectsFromArray:array];
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:IndexSectionTwo];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    
    
}

- (void)showAletWithTitle:(NSString*)title withMsg:(NSString*)msg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:  UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
    }]];
    [[YBNaviagtionViewController rootNavigationController] presentViewController:alert animated:true completion:nil];
}

- (void)requestListSuccessWithArray:(NSArray *)array withRequestParams:(id)requestParams{
//    _postAdsType = [requestParams integerValue];
    _postAdsType = PostAdsTypeCreate;
    _modifyAdsModel = nil;
    if ([requestParams isKindOfClass:[NSNumber class]]) {
        _modifyAdsModel = nil;
        _postAdsType = PostAdsTypeCreate;
        
    }else{
        _modifyAdsModel = requestParams;
        _postAdsType = PostAdsTypeEdit;
        
    }
    
    if (array.count > 0) {
        if (self.currentPage == 1) {
            [self.sections removeAllObjects];
        }
        [self.sections addObjectsFromArray:array];
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    } else {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    [self.tableView.mj_header endRefreshing];
    
    if (self.postAdsType == PostAdsTypeEdit&&self.modifyAdsModel!=nil)
    {
        self.transactionAmountType = [self.modifyAdsModel.amountType intValue];
        
        if (self.transactionAmountType ==TransactionAmountTypeLimit) {
            self.sliderArrs = @[self.modifyAdsModel.limitMinAmount,self.modifyAdsModel.limitMaxAmount,self.modifyAdsModel.number,self.modifyAdsModel.prompt];
        }else{
            self.sliderArrs = @[self.modifyAdsModel.fixedAmount,self.modifyAdsModel.number,self.modifyAdsModel.prompt];
        }
        self.payString = self.modifyAdsModel.paymentway;
        self.remarkString = self.modifyAdsModel.autoReplyContent;
        self.selectedLimits = @[self.modifyAdsModel.isIdNumber,self.modifyAdsModel.isSeniorCertification];
//        self.ugAdID = self.modifyAdsModel.ugOtcAdvertId;
    }else{
        self.payString = GetUserDefaultWithKey(kPaymentWaysInPostAds);
    }
    
    
    _pafv = [[PostAdsFV alloc]initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 194) WithModel:@[@"需要对方通过实名认证",@"需要对方通过高级认证",@"我已经阅读和同意"]];
    [_pafv richElementsInHeaderWithModel:requestParams];
    
    kWeakSelf(self);
    [_pafv actionBlock:^(id data,id data2) {
        kStrongSelf(self);
//        if (weakSelf.block) {
//            weakSelf.block(data);
//        }
        NSArray  *optionPrices = GetUserDefaultWithKey(kLimitAccountsInPostAds);
        NSString* minlim = optionPrices[0];
        NSString* maxlim = @"";
        
//        if ([GetUserDefaultWithKey(kControlNumberInPostAds) intValue]>[optionPrices[1] intValue]) {
            maxlim = optionPrices[1];
//        }else{
//            maxlim = GetUserDefaultWithKey(kControlNumberInPostAds);
//        }
        
        NSString* number = GetUserDefaultWithKey(kControlNumberInPostAds);
        NSArray* prompt =  GetUserDefaultWithKey(kControlTimeInPostAds);
        
                
        if (self.transactionAmountType == TransactionAmountTypeNone
            ||self.sliderArrs ==nil) {
            [YKToastView showToastText:@"请规范填写单笔交易"];
            return ;
        }
//        if (self.sliderArrs.count>0) {
//            for (NSString* string in self.sliderArrs) {
//                if ([NSString isEmpty:string]) {
//                    [YKToastView showToastText:@"请规范填写单笔交易"];
//                    return ;
//                }
//            }
//        }
        if (self.transactionAmountType == TransactionAmountTypeLimit) {
            if (self.sliderArrs.count>0) {
                for (int i=0 ;i<self.sliderArrs.count; i++) {
                    if ([self.sliderArrs[2] intValue]<[minlim intValue]) {
                        [self showAletWithTitle:@"卖出数量不能小于最小限额" withMsg:nil];
                        return ;
                    }
                    if ([self.sliderArrs[2] intValue]>[number intValue]) {
                        [self showAletWithTitle:[NSString stringWithFormat:@"*卖出数量已超过您当前的可用余额（%@）",number] withMsg:nil];
                        return ;
                    }
                    if ([self.sliderArrs[3] intValue]<[prompt[0] intValue]) {
                        [self showAletWithTitle:[NSString stringWithFormat:@"*最短期限不得小于%@分钟",prompt[0]] withMsg:nil];
                        return ;
                    }
                    if ([self.sliderArrs[3] intValue]>[prompt[1] intValue]) {
                        [self showAletWithTitle:[NSString stringWithFormat:@"*最长期限不得大于%@分钟",prompt[1]] withMsg:nil];
                        return ;
                    }
                }
            }

        }else{
            if (self.sliderArrs.count>0) {
                for (int i=0 ;i<self.sliderArrs.count; i++) {
                    if ([NSString isEmpty:self.sliderArrs[0]]) {
                        [self showAletWithTitle:@"您的固额还没选" withMsg:nil];
                        return ;
                    }
                    if (![NSString isEmpty:self.sliderArrs[0]]){
                        BOOL isDouble = [NSString judgeIsDoubleStr:self.sliderArrs[0] with:self.sliderArrs[1]];
                        if (!isDouble)
                             [self showAletWithTitle:@"*固额卖出数量必须为所选额度的整数倍" withMsg:nil];
                    }
                    if ([self.sliderArrs[2] intValue]<[prompt[0] intValue]) {
                        [self showAletWithTitle:[NSString stringWithFormat:@"*最短期限不得小于%@分钟",prompt[0]] withMsg:nil];
                        return ;
                    }
                    if ([self.sliderArrs[2] intValue]>[prompt[1] intValue]) {
                        [self showAletWithTitle:[NSString stringWithFormat:@"*最长期限不得大于%@分钟",prompt[1]] withMsg:nil];
                        return ;
                    }
                    
                }
            }
        }
        if ([NSString isEmpty:self.payString]) {
            [self showAletWithTitle:@"至少选择一种支付方式" withMsg:nil];
            return;
        }
        
        
        if (self.postAdsType == PostAdsTypeCreate) {
            self.selectedLimits = data2 !=nil?data2:@[@"2",@"2"];
            self.ugAdID = @"";
            
        }
        else if (self.postAdsType == PostAdsTypeEdit&&self.modifyAdsModel!=nil){
            self.selectedLimits = data2 !=nil?data2:@[@"2",@"2"];
            self.ugAdID = self.modifyAdsModel.ugOtcAdvertId;
        }
        
        EnumActionTag btnType  = [data integerValue];
        switch (btnType) {
                
            case EnumActionTag4:
            {//post
                InputPWPopUpView* popUpView = [[InputPWPopUpView alloc]init];
//                [popUpView richElementsInCellWithModel:nil];
                [popUpView showInApplicationKeyWindow];
                [popUpView actionBlock:^(id data) {
                    if (self.block) {
            self.block(@(btnType),@(self.transactionAmountType),self.sliderArrs,self.payString,self.remarkString,self.selectedLimits,data,self.ugAdID);
                    }

                }];
            }
                break;
                
            default:{
//                if (self.block) {
//                    self.block(data,data2);
//                }
            }
                
                break;
        }
        
    }];

    _tableView.tableFooterView = _pafv;
    _tableView.tableFooterView.backgroundColor = kWhiteColor;
}

- (void)requestListFailed {
    self.currentPage = 0;
    [self.sections removeAllObjects];
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>
#pragma mark - Sectons
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _sections.count;
}
#pragma mark - Rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section >= _sections.count) {
        section = _sections.count - 1;
    }
//    IndexSectionType type = [(_sections[section])[kIndexSection] integerValue];
    return [(_sections[section])[kIndexRow] count];
}

#pragma mark - SectonHeader
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section >= _sections.count) {
        section = _sections.count - 1;
    }
    
    IndexSectionType type = [(_sections[section])[kIndexSection] integerValue];
    switch (type) {
        case IndexSectionZero:
            return 5;
            break;
        case IndexSectionTwo:
        case IndexSectionThree:
        case IndexSectionFour:
            return [PostAdsSectionHeaderView viewHeight];
            break;
        default:
            return 0.1f;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section >= _sections.count) {
        section = _sections.count - 1;
    }
    IndexSectionType type = [(_sections[section])[kIndexSection] integerValue];
    
    NSString *sectionTitle = @"";
    NSString *sectionSubTitle = @"";
    
//    id sectionData = (_sections[section])[kIndexRow][0];
    
    switch (type) {
        case IndexSectionTwo:
        case IndexSectionThree:
        case IndexSectionFour: {
            NSArray* arr = (NSArray*)(_sections[section])[kIndexInfo];
            sectionTitle =  arr[0];
            sectionSubTitle = arr[1];
            WS(weakSelf) ;
            
            PostAdsSectionHeaderView * sectionHeaderView = (PostAdsSectionHeaderView *)[_tableView dequeueReusableHeaderFooterViewWithIdentifier:PostAdsSectionHeaderReuseIdentifier];
            [sectionHeaderView setDataWithType:type withTitle:sectionTitle withSubTitle:sectionSubTitle];
            sectionHeaderView.clickSectionBlock = ^(NSString* sec){
                [weakSelf sectionHeaderSubBtnClickTag:sec];
            };
            //    sectionHeaderView.delegate =self;
            return sectionHeaderView;
        }
            break;
        
        default:
            return [UIView new];
            break;
            
    }
    
}

- (void)sectionHeaderSubBtnClickTag:(NSString* )sec{
//    HomeMoreVC *moreVc = [[HomeMoreVC alloc] init];
//    moreVc.moreEnterType = Others;
//    moreVc.naviTitle = sec;
//    moreVc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:moreVc animated:YES];
  
}
#pragma mark - SectonFooter
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section >= _sections.count) {
        section = _sections.count - 1;
    }
    
    IndexSectionType type = [(_sections[section])[kIndexSection] integerValue];
    
    switch (type) {
        case IndexSectionZero:
        case IndexSectionOne:
            return 5.f;
            break;
        case IndexSectionTwo:
        case IndexSectionThree:
        case IndexSectionFour:
            return 14.f;
            break;
        default:
            return 0.1f;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section >= _sections.count) {
        section = _sections.count - 1;
    }
    IndexSectionType type = [(_sections[section])[kIndexSection] integerValue];
    
//        NSString *sectionTitle = @"";
//        NSString *sectionSubTitle = @"";
//
    
//        id sectionData = (_sections[section])[kIndexRow][0];
    
    switch (type) {
        case IndexSectionTwo:
        case IndexSectionThree:
        case IndexSectionFour:
        {
            UIView* sectionFooterView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 14.f)];
        sectionFooterView.backgroundColor = kWhiteColor;

            return sectionFooterView;
        }
            break;
        default:{

            return nil;
        }
            break;

    }
    
    return nil;
}
#pragma mark - cellForRow
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WS(weakSelf);
    
    NSInteger section = indexPath.section;
    if(section >= _sections.count)
    section = _sections.count - 1;
    
    IndexSectionType type = [_sections[section][kIndexSection] integerValue];
    id itemData = ((_sections[section])[kIndexRow])[indexPath.row];
    switch (type) {
        case IndexSectionZero:
        {
            PostAdsTypeCell *cell = [PostAdsTypeCell cellWith:tableView];
            [cell richElementsInCellWithModel:itemData];
            return cell;
            
        }
            break;
        case IndexSectionOne:
        {
            PostAdsSlideCell *cell = [PostAdsSlideCell cellWith:tableView];
            [cell richElementsInCellWithModel:itemData];
            [cell actionBlock:^(id data, id data2) {
                NSLog(@"%@   %@",data,data2);
                self.transactionAmountType = [data intValue];
                self.sliderArrs = data2;
                
            }];
            return cell;
            
        }
            break;
        case IndexSectionTwo:
        {
            PostAdsPaysCell *cell = [PostAdsPaysCell cellWith:tableView];
            
            NSDictionary* paysDic = (NSDictionary*)itemData;
//            WData* wData = (WData*)itemData;
            [cell richElementsInCellWithModel:paysDic];
            [cell actionBlock:^(id data) {
                NSLog(@"seletedSwitchs %@",data);
                self.payString = data;
            }];

            return cell;
            
        }
            break;
        case IndexSectionThree:
        {
            PostAdsReplyCell *cell = [PostAdsReplyCell cellWith:tableView];
    
            NSDictionary* paysDic = (NSDictionary*)itemData;
            //            WData* wData = (WData*)itemData;
            [cell richElementsInCellWithModel:paysDic];
            [cell actionBlock:^(id data) {
                self.remarkString = data;
            }];
            return cell;
            
        }
            break;
        case IndexSectionFour:
        {
            PostAdsRestrictCell *cell = [PostAdsRestrictCell cellWith:tableView];
            
            NSDictionary* paysDic = (NSDictionary*)itemData;
            //            WData* wData = (WData*)itemData;
            [cell richElementsInCellWithModel:paysDic];
            
            return cell;
            
        }
            break;
        default:{
            BaseCell *cell = [BaseCell cellWith:tableView];
            cell.hideSeparatorLine = YES;
            cell.frame = CGRectZero;
            return cell;
        }
            break;
    }
}

#pragma mark - heightForRow
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if(section >= _sections.count)
    section = _sections.count - 1;
    
    IndexSectionType type = [_sections[section][kIndexSection] integerValue];
    id itemData = ((_sections[section])[kIndexRow])[indexPath.row];
    switch (type) {
        case IndexSectionZero:
            return [PostAdsTypeCell cellHeightWithModel];
            break;
            
        case IndexSectionOne:
            return [PostAdsSlideCell cellHeightWithModel];
            break;
        case IndexSectionTwo:
        {
            return [PostAdsPaysCell cellHeightWithModel:itemData];
        }
            break;
        case IndexSectionThree:
        {
            return [PostAdsReplyCell cellHeightWithModel:itemData];
        }
            break;
        case IndexSectionFour:
        {
            return [PostAdsRestrictCell cellHeightWithModel:itemData];
        }
            break;
        default:
            return 0;
            break;
    }
}
- (void)actionBlock:(EightDataBlock)block
{
    self.block = block;
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//        [_tableView YBGeneral_configuration];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [PostAdsSectionHeaderView sectionHeaderViewWith:_tableView];
        
       kWeakSelf(self);
        [_tableView YBGeneral_addRefreshHeader:^{
            kStrongSelf(self);
            self.currentPage = 1;
            [self.delegate postAdsView:self requestListWithPage:self.currentPage];
        }
//                                        footer:^{
//            kStrongSelf(self);
//            ++self.currentPage;
//            [self.delegate homeView:self requestHomeListWithPage:self.currentPage];
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

- (NSMutableArray *)sections {
    if (!_sections) {
        _sections = [NSMutableArray array];
    }
    return _sections;
}

@end
