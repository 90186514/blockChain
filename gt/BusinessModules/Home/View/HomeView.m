
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "HomeView.h"
#import "AccountCell.h"
#import "GridCell.h"

#import "HomeInfoTableViewCell.h"

#import "BaseCell.h"


#import "HomeSectionHeaderView.h"

#import "HomeVM.h"

@interface HomeView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView * networkErrorView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, assign) CFAbsoluteTime start;  //刷新数据时的时间
@property (nonatomic, copy) TwoDataBlock block;
@end

@implementation HomeView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initViews];
        
//        [self.tableView.mj_header beginRefreshing];
        
        //监听程序进入前台
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidBecomeActive:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
    }
    return self;
}
- (void)applicationDidBecomeActive:(NSNotification *)notification {
//    [_tableView reloadData];
}

- (void)initViews {
    [self addSubview:self.tableView];
    self.backgroundColor = [YBGeneralColor themeColor];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    kWeakSelf(self);
    self.networkErrorView = [self setNetworkErrorViewInSuperView:self leftButtonEvent:^(id data) {
        kStrongSelf(self);
        if (self.block) {
            self.block(@(EnumActionTag11), @"");
        }
    }];
}

#pragma mark - public
- (void)requestHomeListSuccessWithArray:(NSArray *)array WithPage:(NSInteger)page{
    self.networkErrorView.hidden = YES;
    self.currentPage = page;
    if (self.currentPage == 1) {
        [self.sections removeAllObjects];
        [self.tableView reloadData];
    }
    if (array.count > 0) {
        [self.sections addObjectsFromArray:array];
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    } else {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    [self.tableView.mj_header endRefreshing];
}

- (void)requestHomeListFailed {
    self.currentPage = 0;
    //    [self.sections removeAllObjects];
    [self.tableView reloadData];
    if (self.sections.count == 2) {
        //第一次安装无网络不隐藏
        self.networkErrorView.hidden = NO;
    }else{
        //有网后，下拉3层数据，关网后，保留数据，用无网的tipLab
        self.networkErrorView.hidden = YES;
    }
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
//    if (section >= _sections.count) {
//        section = _sections.count - 1;
//    }
//
//    IndexSectionType type = [(_sections[section])[kIndexSection] integerValue];
//    switch (type) {
//        case IndexSectionTwo:
//            return [HomeSectionHeaderView viewHeight];
//            break;
//        default:
            return 0.1f;
//            break;
//    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if(section >= _sections.count) {
//        section = _sections.count - 1;
//    }
//    IndexSectionType type = [(_sections[section])[kIndexSection] integerValue];
//
//    switch (type) {
//        case IndexSectionTwo:{
//            NSDictionary* model = (NSDictionary*)(_sections[section]);
//            HomeSectionHeaderView * sectionHeaderView = (HomeSectionHeaderView *)[_tableView dequeueReusableHeaderFooterViewWithIdentifier:HomeSectionHeaderViewReuseIdentifier];
//            [sectionHeaderView richElementsInViewWithModel:model];
//            return  sectionHeaderView;
//        }
//            break;
//
//        default:
            return [UIView new];
//            break;
//    }
}

#pragma mark - SectonFooter
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section >= _sections.count) {
        section = _sections.count - 1;
    }
    
    IndexSectionType type = [(_sections[section])[kIndexSection] integerValue];
    
    switch (type) {
        case IndexSectionZero:
            return .01f;
            break;
        case IndexSectionOne:
            return 12.f;//[HomeSectionHeaderView viewHeight];
            break;
        case IndexSectionTwo:
            return .1f;
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
    
    switch (type) {
        case IndexSectionOne:{
            NSDictionary* model = (NSDictionary*)(_sections[section]);
            HomeSectionHeaderView * sectionHeaderView = (HomeSectionHeaderView *)[_tableView dequeueReusableHeaderFooterViewWithIdentifier:HomeSectionHeaderViewReuseIdentifier];
            [sectionHeaderView richElementsInViewWithModel:model];
            
            UIView* view = [UIView new];
            view.backgroundColor = HEXCOLOR(0xf6f5fa);
            return  view;//sectionHeaderView;
        }
            break;
            
        default:
            return [UIView new];
            break;
            
    }
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
            AccountCell *cell = [AccountCell cellWith:tableView];
            [cell actionBlock:^(id data,id data2) {
                if (self.block) {
                    self.block(data, data2);
                }
            }];
            [cell richElementsInCellWithModel:itemData];
            return cell;
            
        }
            break;
        case IndexSectionOne:
        {
            GridCell *cell = [GridCell cellWith:tableView];
            [cell richElementsInCellWithModel:itemData];
            [cell actionBlock:^(NSDictionary *dataModel) {
                IndexSectionType type = [dataModel[kType] integerValue];
                
                if (weakSelf.block) {
                    self.block(@(type),dataModel);
                }
            }];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }
            break;
        case IndexSectionTwo:
        {
            HomeInfoTableViewCell *cell = [HomeInfoTableViewCell cellWith:tableView];
            
            HomeData* data = (HomeData*)itemData;
            [cell richElementsInCellWithModel:data];
            return cell;
            
        }
            break;
        default:{
//            BaseCell *cell = [BaseCell cellWith:tableView];
//            cell.hideSeparatorLine = YES;
//            cell.frame = CGRectZero;
//            return cell;
            static NSString *name=@"defaultCell";
                    
            UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:name];
                
            if (cell==nil) {
                cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:name];
            }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.frame = CGRectZero;

            return cell;
        }
            break;
    }
}
-(void)actionBlock:(TwoDataBlock)block{
    self.block = block;
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
            return [AccountCell cellHeightWithModel];
            break;
            
        case IndexSectionOne:
            return [GridCell cellHeightWithModel:itemData];
            break;
        case IndexSectionTwo:
        {
            
            return [HomeInfoTableViewCell cellHeightWithModel:itemData];
        }
            break;
        default:
            return 0;
            break;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSInteger section = indexPath.section;
    if(section >= _sections.count)
        section = _sections.count - 1;
    
    IndexSectionType type = [_sections[section][kIndexSection] integerValue];
    id itemData = ((_sections[section])[kIndexRow])[indexPath.row];
    switch (type) {
        
        case IndexSectionTwo:
        {
//            if (self.block) {
//               self.block(@(EnumActionTag4),itemData);
//            }
        }
            break;
        default:
            
            break;
    }
}
#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView YBGeneral_configuration];
//        _tableView.backgroundColor = RGBCOLOR(76, 84, 245);
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [HomeSectionHeaderView sectionHeaderViewWith:_tableView];
//        [_tableView registerClass:[HomeSectionHeaderView class] forHeaderFooterViewReuseIdentifier:@"HomeSectionHeaderView"];
       kWeakSelf(self);
        [_tableView YBGeneral_addRefreshHeader:^{
            kStrongSelf(self);
            self.currentPage = 1;
            [self.delegate homeView:self requestHomeListWithPage:self.currentPage];
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
