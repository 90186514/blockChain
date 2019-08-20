//
//  PostAdsView.m
//  gtp
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "PayView.h"

#import "PayStatusCell.h"
#import "BaseCell.h"

#import "PaySectionHeaderView.h"

#import "PayVM.h"
#import "PayFV.h"

@interface PayView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong) PayFV *payFV;
@property (nonatomic, copy) TwoDataBlock block;
@end

@implementation PayView
#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kWhiteColor;
        [self initViews];
        
        [self.tableView.mj_header beginRefreshing];
        
        
    }
    return self;
}

- (void)initViews {
    [self addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self);
        make.top.left.right.mas_equalTo(self).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset([YBSystemTool isIphoneX]? -[YBFrameTool tabBarHeight]-48.5:-48.5);
    }];
    
}

#pragma mark - public
- (void)requestListSuccessWithArray:(NSArray *)array WithPage:(NSInteger)page WithSec:(NSString*)sec{
    self.currentPage = page;
    if (self.currentPage == 1) {
        [self.sections removeAllObjects];
    }
    if (array.count > 0) {
        [self.sections addObjectsFromArray:array];
        
        [self.tableView.mj_footer endRefreshing];
    } else {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];
//    NSString* sec = (NSString*)(_sections[0])[kData];
    
    NSDictionary* data = (NSDictionary*)(_sections[0])[kIndexInfo];
    NSArray* pays = data[kData];
    
    if (data[kData] ==nil ||pays.count==0) {
        return;
    }
    _payFV = [[PayFV alloc]initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 424) WithModel:pays WithSec:sec];
    WS(weakSelf);
    [_payFV actionBlock:^(id data,id data2) {
        EnumActionTag btnType  = [data integerValue];
        switch (btnType) {
            case EnumActionTag4:
            case EnumActionTag5:
            case EnumActionTag6:
            {
                if (weakSelf.block) {
                    weakSelf.block(data,data2);
                }
            }
                break;
            default:{
                
            }
                
                break;
        }
        
    }];
    
    _tableView.tableFooterView = _payFV;
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
            return [PaySectionHeaderView viewHeight];
            break;
        default:
            return 0.1f;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    IndexSectionType type = [(_sections[section])[kIndexSection] integerValue];
    
    //    id sectionData = (_sections[section])[kIndexRow][0];
    
    switch (type) {
        case IndexSectionZero: {
            NSDictionary* data = (NSDictionary*)(_sections[section])[kIndexInfo];
        
            PaySectionHeaderView * sectionHeaderView = (PaySectionHeaderView *)[_tableView dequeueReusableHeaderFooterViewWithIdentifier:PaySectionHeaderReuseIdentifier];
            [sectionHeaderView richElementsInViewWithModel:data];
            
            return sectionHeaderView;
        }
            break;
            
        default:
            return [UIView new];
            break;
            
    }

}
#pragma mark - SectonFooter
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return nil;
}
#pragma mark - cellForRow
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    WS(weakSelf);
    
    NSInteger section = indexPath.section;
    if(section >= _sections.count)
    section = _sections.count - 1;
    
    IndexSectionType type = [_sections[section][kIndexSection] integerValue];
    id itemData = ((_sections[section])[kIndexRow])[indexPath.row];
    switch (type) {
        case IndexSectionZero:
        {
            PayStatusCell *cell = [PayStatusCell cellWith:tableView];
            [cell richElementsInCellWithModel:itemData WithArr:_sections[0][kIndexRow] WithIndexPath:indexPath];
            
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
            return [PayStatusCell cellHeightWithModel:itemData];
            break;
            
        default:
            return 0;
            break;
    }
}

-(void)actionBlock:(TwoDataBlock)block{
    self.block= block;
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
        [PaySectionHeaderView sectionHeaderViewWith:_tableView];
        
//       kWeakSelf(self);
//       [_tableView YBGeneral_addRefreshHeader:^{
//            kStrongSelf(self);
//            self.currentPage = 1;
//            [self.delegate payView:self requestListWithPage:self.currentPage];
//        }
//        footer:^{
//            kStrongSelf(self);
//            ++self.currentPage;
//            [self.delegate exchangeView:self requestListWithPage:self.currentPage];
//        }
//        ];
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
