//
//  TablePopUpView.m
//  gtp
//
//  Created by Aalto on 2018/12/30.
//  Copyright © 2018 GT. All rights reserved.
//

#import "TablePopUpView.h"
#import "AddAccountCell.h"
#define XHHTuanNumViewHight 283
@interface TablePopUpView()<UIGestureRecognizerDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,assign)NSInteger  selectedRow;
@property (nonatomic,strong)NSArray * dataSource;
@property(nonatomic,strong)UIView *contentView;
@property (nonatomic, strong) UIImageView *line1;

@property (nonatomic, strong) UIButton *postAdsButton;
@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, assign) CGFloat contentViewHeight;
@end

@implementation TablePopUpView

- (id)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setupContent];
    }
    return self;
}

- (void)setupContent {
    self.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT);
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    _contentViewHeight = XHHTuanNumViewHight+[YBFrameTool tabBarHeight];
    if (_contentView == nil) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, MAINSCREEN_HEIGHT - _contentViewHeight, MAINSCREEN_WIDTH, _contentViewHeight)];
        _contentView.userInteractionEnabled = YES;
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_contentView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _contentView.bounds;
        maskLayer.path = maskPath.CGPath;
        _contentView.layer.mask = maskLayer;
        
        // 右上角关闭按钮
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(_contentView.width -  90, 0, 90, 47);
        closeBtn.titleLabel.font = kFontSize(17);
        [closeBtn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
        [closeBtn setTitle:@"取消" forState:UIControlStateNormal];//
//        [closeBtn addTarget:self action:@selector(disMissView) forControlEvents:UIControlEventTouchUpInside];
        [closeBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)]];
        [_contentView addSubview:closeBtn];
        
        // 左上角关闭按钮
        UIButton *saftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        saftBtn.frame = CGRectMake(30, 0, 190, 47);
        saftBtn.titleLabel.font = kFontSize(17);
        [saftBtn setTitleColor:HEXCOLOR(0x232630) forState:UIControlStateNormal];
        [saftBtn setTitle:@"选择收款方式" forState:UIControlStateNormal];
        saftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_contentView addSubview:saftBtn];
//        [saftBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(postAdsAndRuleButtonClickItem:)]];
        
        _line1 = [[UIImageView alloc]init];
        [self.contentView addSubview:_line1];
        _line1.backgroundColor = HEXCOLOR(0xe8e9ed);

        [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@0);
            make.trailing.equalTo(@0);
            make.top.offset(47);
            make.height.equalTo(@.5);
        }];
        
        [self layoutTable];
        
        WS(weakSelf);
        [_contentView bottomSingleButtonInSuperView:_contentView WithButtionTitles:@"确定" leftButtonEvent:^(id data) {
            [weakSelf postAdsAndRuleButtonClickItem];
        }];
    }
}

-(void)layoutTable{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.layer.masksToBounds = YES;
//    self.tableView.layer.cornerRadius = 4;
    self.tableView.backgroundColor = kWhiteColor;
    _selectedRow = EnumActionTag0;
    [self.contentView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(0);
        make.trailing.equalTo(self.contentView).offset(0);
                make.top.equalTo(self.line1.mas_bottom).offset(20);
        make.bottom.equalTo(self.contentView).offset(-48);
//        make.height.equalTo(@(240));
    }];
}

- (void)actionBlock:(ActionBlock)block{
    self.block = block;
}

- (void)richElementsInViewWithModel:(NSArray*)model{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.dataSource = model ;
    [self.tableView reloadData];
}

- (void)postAdsAndRuleButtonClickItem{
    
    if (self.block) {
        self.block(@(_selectedRow));
    }
    [self disMissView];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    return YES;
}
- (void)showInApplicationKeyWindow{
    [self showInView:[UIApplication sharedApplication].keyWindow];
    
    //    [popupView showInView:self.view];
    //
    //    [popupView showInView:[UIApplication sharedApplication].keyWindow];
    //
    //    [[UIApplication sharedApplication].keyWindow addSubview:popupView];
}

- (void)showInView:(UIView *)view {
    if (!view) {
        return;
    }
    
    [view addSubview:self];
    [view addSubview:_contentView];
    
    [_contentView setFrame:CGRectMake(0, MAINSCREEN_HEIGHT, MAINSCREEN_WIDTH, _contentViewHeight)];
    WS(weakSelf);
    [UIView animateWithDuration:0.3 animations:^{
        
        weakSelf.alpha = 1.0;
        
        [weakSelf.contentView setFrame:CGRectMake(0, (MAINSCREEN_HEIGHT - weakSelf.contentViewHeight),MAINSCREEN_WIDTH,weakSelf.contentViewHeight)];
        
    } completion:nil];
}

//移除从上向底部弹下去的UIView（包含遮罩）
- (void)disMissView {
    WS(weakSelf);
    [_contentView setFrame:CGRectMake(0, MAINSCREEN_HEIGHT - _contentViewHeight, MAINSCREEN_WIDTH, _contentViewHeight)];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         weakSelf.alpha = 0.0;
                         [weakSelf.contentView setFrame:CGRectMake(0, MAINSCREEN_HEIGHT, MAINSCREEN_WIDTH, weakSelf.contentViewHeight)];
                     }
                     completion:^(BOOL finished){
                         [weakSelf removeFromSuperview];
                         [weakSelf.contentView removeFromSuperview];
                     }];
}

#pragma mark UITableView DataSource Method 数据源方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [AddAccountCell cellHeightWithModel];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddAccountCell *cell = [AddAccountCell cellWith:tableView];
    NSDictionary* model = _dataSource[indexPath.row];
    [cell richElementsInCellWithModel:model WithIndexRow:indexPath.row SelectedRow:_selectedRow];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectedRow = indexPath.row;
    [_tableView reloadData];
}
@end

