//
//  SPCell.m
//  LiNiuYang
//
//  Created by Aalto on 2017/7/25.
//  Copyright © 2017年 LiNiu. All rights reserved.
//

#import "AccountCell.h"
#import "SDCycleScrollView.h"
#import "UICountingLabel.h"
#import "HomeModel.h"
@interface AccountCell ()<SDCycleScrollViewDelegate>
@property (nonatomic, strong) SDCycleScrollView *sdCycleScrollView;

@property (nonatomic, copy) TwoDataBlock block;

@property (nonatomic, strong) NSArray *arr;

@property (nonatomic, strong) UIImageView *decorIv;

@property (nonatomic, strong) UIButton *msgBtn;
@property (nonatomic, strong) UIButton *scanBtn;

@property (nonatomic, strong) UILabel *accLab;
@property (nonatomic, strong) UILabel *aliasLab;

@property (nonatomic, strong) UIButton *loginBtn;

@property (nonatomic, strong) UICountingLabel *rmbLab;

@property (nonatomic, strong) UICountingLabel *exchangeRmbLab;

@property (nonatomic, strong) UIButton *recordBtn;

@property (nonatomic, strong) UIButton *jumpAssetBtn;

@end

@implementation AccountCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self richEles];
    }
    return self;
}

- (void)richEles{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    UIImage* decorImage = kIMG(@"home_top_img");
    _decorIv = [[UIImageView alloc]init];
    [self.contentView addSubview:_decorIv];
    [_decorIv mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.mas_equalTo(self.contentView.mas_centerX); make.top.leading.trailing.equalTo(self.contentView);
        
   make.size.mas_equalTo(CGSizeMake(MAINSCREEN_WIDTH, MAINSCREEN_WIDTH * 259.0 / 375.0));
    }];
   [_decorIv setContentMode:UIViewContentModeScaleAspectFill];
    _decorIv.userInteractionEnabled = YES;
    _decorIv.clipsToBounds = YES;
    _decorIv.image = decorImage;
    
    _accLab = [[UILabel alloc]init];
    [_decorIv addSubview:_accLab];
    [_accLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.decorIv.mas_centerX);
//       make.top.equalTo(self.decorIv).offset(33);
        make.top.equalTo(self.contentView).offset([YBSystemTool isIphoneX]?24+33:0+33);
//        make.height.equalTo(@20);
    }];
//    先调用superView的layoutIfNeeded方法再获取frame
//    [self.contentView layoutIfNeeded];
    
    
    _msgBtn = [[UIButton alloc]init];
    [_decorIv addSubview:_msgBtn];
    [_msgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.accLab.mas_centerY);
        make.leading.offset(24);
        make.width.mas_equalTo(100);
    }];
    
    _scanBtn = [[UIButton alloc]init];
    [_decorIv addSubview:_scanBtn];
    [_scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.accLab.mas_centerY);
        make.trailing.offset(-24);
        make.width.mas_equalTo(100);
    }];
    
    _aliasLab = [[UILabel alloc]init];
    [_decorIv addSubview:_aliasLab];
    [_aliasLab mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.accLab.mas_centerX);
        make.top.equalTo(self.accLab.mas_bottom).offset(23);
//        make.height.equalTo(@40);
    }];
    
    _loginBtn = [[UIButton alloc]init];
    [_decorIv addSubview:_loginBtn];
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.aliasLab.mas_centerX);
        make.top.equalTo(self.aliasLab.mas_bottom).offset(17);
        make.size.mas_equalTo(CGSizeMake(100,28));
    }];
    
    
    
    _rmbLab = [[UICountingLabel alloc]init];
    [_decorIv addSubview:_rmbLab];
    [_rmbLab mas_makeConstraints:^(MASConstraintMaker *make) {
       make.centerX.equalTo(self.accLab.mas_centerX); make.top.equalTo(self.accLab.mas_bottom).offset(11);
//        make.height.equalTo(@17);
    }];
    
    
    
    _exchangeRmbLab = [[UICountingLabel alloc]init];
    [_decorIv addSubview:_exchangeRmbLab];
    [_exchangeRmbLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.rmbLab.mas_centerX); make.top.equalTo(self.rmbLab.mas_bottom).offset(4);
        //        make.height.equalTo(@17);
    }];
    
    _recordBtn = [[UIButton alloc]init];
    [_decorIv addSubview:_recordBtn];
    [_recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.exchangeRmbLab.mas_centerY);
       make.trailing.equalTo(self.decorIv).offset(-33);
        
    }];
    
    
    
    _sdCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake( 20, [AccountCell cellHeightWithModel] - kGETVALUE_HEIGHT(335, 120, MAINSCREEN_WIDTH), MAINSCREEN_WIDTH-40, kGETVALUE_HEIGHT(335, 120, MAINSCREEN_WIDTH))  placeholderImage:[UIImage imageNamed:@"bub_LONG_PLACEDHOLDER_IMG"]];
    _sdCycleScrollView.autoScrollTimeInterval = 2.0;
    _sdCycleScrollView.autoScroll = YES;
    _sdCycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _sdCycleScrollView.currentPageDotColor = HEXCOLOR(0xc6c6c6); // 自定义分页控件小圆标颜色
    _sdCycleScrollView.layer.masksToBounds = YES;
    _sdCycleScrollView.layer.cornerRadius = 4;
    [self.contentView addSubview:_sdCycleScrollView];
    [self.contentView layoutIfNeeded];
    
    _jumpAssetBtn= [[UIButton alloc]init];
    _jumpAssetBtn.tag = EnumActionTag12;
    _jumpAssetBtn.backgroundColor = kClearColor;
    [_decorIv addSubview:_jumpAssetBtn];
    [_jumpAssetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.centerY.equalTo(self.exchangeRmbLab.mas_centerY);
        make.top.equalTo(self.decorIv.mas_top).offset(0);
        make.left.equalTo(self.msgBtn.mas_right).offset(0);
        make.right.equalTo(self.recordBtn.mas_left).offset(0);
        make.bottom.equalTo(self.sdCycleScrollView.mas_top).offset(0);
    }];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    _accLab.textAlignment = NSTextAlignmentCenter;
    _accLab.font = kFontSize(20);
    _accLab.textColor = HEXCOLOR(0xffffff);
    
    _aliasLab.textAlignment = NSTextAlignmentCenter;
    _aliasLab.font = [UIFont systemFontOfSize:14];
    _aliasLab.textColor = HEXCOLOR(0xffffff);
    
    _loginBtn.tag = EnumActionTag8;
    _loginBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _loginBtn.layer.masksToBounds = YES;
    _loginBtn.layer.cornerRadius = 14;
    [_loginBtn setBackgroundImage:[UIImage imageWithColor:kWhiteColor] forState:UIControlStateNormal];
    [_loginBtn setTitleColor:HEXCOLOR(0x4c7fff) forState:UIControlStateNormal];
    _loginBtn.adjustsImageWhenHighlighted = NO;
    _loginBtn.titleLabel.font = kFontSize(15);
    
    _msgBtn.tag = EnumActionTag6;
    _msgBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _msgBtn.adjustsImageWhenHighlighted = NO;
    [_msgBtn setImage:[UIImage imageNamed:@"icon_remind"] forState:UIControlStateNormal];
    [_msgBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _scanBtn.tag = EnumActionTag7;
    _scanBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _scanBtn.adjustsImageWhenHighlighted = NO;
    [_scanBtn setImage:[UIImage imageNamed:@"icon_scan"] forState:UIControlStateNormal];
    [_scanBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _rmbLab.textAlignment = NSTextAlignmentCenter;
//    _rmbLab.font = kFontSize(12);
    _rmbLab.numberOfLines = 0;
//    _rmbLab.textColor = HEXCOLOR(0xffffff);
    
    _exchangeRmbLab.textAlignment = NSTextAlignmentCenter;
    _exchangeRmbLab.font = kFontSize(12);
    _exchangeRmbLab.numberOfLines = 0;
    _exchangeRmbLab.textColor = HEXCOLOR(0xffffff);
    
    _recordBtn.tag = EnumActionTag9;
    _recordBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_recordBtn setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    _recordBtn.adjustsImageWhenHighlighted = NO;
    _recordBtn.titleLabel.font = kFontSize(12);
}


+(instancetype)cellWith:(UITableView*)tabelView{
    AccountCell *cell = (AccountCell *)[tabelView dequeueReusableCellWithIdentifier:@"AccountCell"];
    if (!cell) {
        cell = [[AccountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AccountCell"];
    }
    return cell;
}

+ (CGFloat)cellHeightWithModel{
    return [YBSystemTool isIphoneX]?
    24+(MAINSCREEN_WIDTH * 259.0 / 375.0)+53:
    (MAINSCREEN_WIDTH * 259.0 / 375.0)+53;
}

- (void)actionBlock:(TwoDataBlock)block
{
    self.block = block;
}

- (void)clickBtn:(UIButton*)sender{
    if (self.block) {
        self.block(@(sender.tag),sender);
    }
}
- (void)richElementsInCellWithModel:(NSDictionary*)model{
    BOOL isLogin = GetUserDefaultBoolWithKey(kIsLogin);
    
    _accLab.text = [NSString stringWithFormat:@"%@钱包",model[kTip]];
    if (!isLogin) {
        _aliasLab.hidden = NO;
        _loginBtn.hidden = NO;
        
        _aliasLab.text = @"账号余额：";
        [_loginBtn setTitle:@"请先登录" forState:UIControlStateNormal];
        [_loginBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        _jumpAssetBtn.hidden = YES;
        _rmbLab.hidden = YES;
        _exchangeRmbLab.hidden = YES;
        _recordBtn.hidden = YES;
    }else{
        _aliasLab.hidden = YES;
        _loginBtn.hidden = YES;
        
        _rmbLab.hidden = NO;
        _exchangeRmbLab.hidden = NO;
        _recordBtn.hidden = NO;
        
        _jumpAssetBtn.hidden = NO;
        [_jumpAssetBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        if (![model[kIndexInfo] isEqual:@""]) {
            
        UserAssertModel* usModel = model[kIndexInfo];
//        _rmbLab.attributedText = [NSString attributedStringWithString:[NSString stringWithFormat:@"%@",model[kTit]] stringColor:HEXCOLOR(0xffffff) stringFont:kFontSize(14) subString:[NSString stringWithFormat:@"\n%@",usModel.amount] subStringColor:HEXCOLOR(0xffffff) subStringFont:kFontSize(37)];
            
            CGFloat toValue = [usModel.amount floatValue];//123989.22;
            _rmbLab.attributedFormatBlock = ^NSAttributedString* (CGFloat value)
            {
                NSDictionary* normal = @{ NSFontAttributeName: kFontSize(14),NSForegroundColorAttributeName:HEXCOLOR(0xffffff) };
                NSDictionary* highlight = @{ NSFontAttributeName: kFontSize(37),NSForegroundColorAttributeName:HEXCOLOR(0xffffff) };

                NSString* prefix = [NSString stringWithFormat:@"%@\n",model[kTip]];
                
                
                NSString* postfix
                = [NSString stringWithFormat:@"%.2f", (float)value];
                
//                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
//                formatter.numberStyle = kCFNumberFormatterDecimalStyle;//%.3f
//                postfix = [formatter stringFromNumber:@((float)value)];
                

                NSMutableAttributedString* prefixAttr = [[NSMutableAttributedString alloc] initWithString: prefix
                                                                                               attributes: normal];
                NSAttributedString* postfixAttr = [[NSAttributedString alloc] initWithString: postfix
                                                                                  attributes:highlight];
                [prefixAttr appendAttributedString: postfixAttr];

                return prefixAttr;
            };
            [_rmbLab countFrom:0.0 to:toValue withDuration:2.];
        
            
//            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
//            formatter.numberStyle = kCFNumberFormatterCurrencyStyle;
            _exchangeRmbLab.formatBlock = ^NSString* (CGFloat value)
            {
//                NSString* formatted = [formatter stringFromNumber:@((float)value)];
//                return [NSString stringWithFormat:@"折合人民币    %@",formatted];
                return [NSString stringWithFormat:@"折合人民币    RMB%.2f", (float)value];
            };
            _exchangeRmbLab.method = UILabelCountingMethodEaseOut;
            [_exchangeRmbLab countFrom:0.0 to:[usModel.convertRmb floatValue] withDuration:2.5];
//        _exchangeRmbLab.text = [NSString stringWithFormat:@"折合人民币   %@",usModel.convertRmb];
            
        [_recordBtn setTitle:@"转账记录 >" forState:UIControlStateNormal];
        [_recordBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
        }
    }
    NSArray* imagesModels = model[kArr];
    
    NSMutableArray* imageURLStrings = [NSMutableArray array];
//    NSMutableArray* imageTitles = [NSMutableArray array];
    
    if (imagesModels.count>0) {
        for (int i=0; i<imagesModels.count; i++) {
            HomeBannerData *bData = imagesModels[i];
            [imageURLStrings addObject:bData.imageUrl];
//            [imageTitles addObject:bData.imageUrl];
//            NSDictionary *model = imagesModels[i];
//            [imageURLStrings addObject:model[kImg]];
//            [imageTitles addObject:model[kTit]];
        }
    }
    
    _sdCycleScrollView.imageURLStringsGroup = imageURLStrings;
    if (imagesModels.count==1) {
        _sdCycleScrollView.autoScroll = NO;
    }else{
        _sdCycleScrollView.autoScroll = YES;
    }
    
    WS(weakSelf);
    _sdCycleScrollView.clickItemOperationBlock = ^(NSInteger index) {
        HomeBannerData *model = imagesModels[index];
        if (model!=nil) {
            //        NSDictionary *model = imagesModels[index];
            if (weakSelf.block) {
                weakSelf.block(@(EnumActionTag10),model);
            }
        }

    };
}

@end
