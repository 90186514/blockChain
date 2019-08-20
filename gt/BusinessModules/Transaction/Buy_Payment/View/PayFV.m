//  gtp
//
//  Created by Aalto on 2018/12/23.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "PayFV.h"
#import "iOSPalette.h"
#import "ZXingObjC.h"
@interface PayFV ()
@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, strong) NSMutableArray *tipBtns;
@property (nonatomic, strong) NSMutableArray *bankNumBtns;
@property (nonatomic, strong) NSMutableArray *nameBtns;
@property (nonatomic, strong) NSMutableArray *payNumBtns;
@property (nonatomic, strong) UIButton *ruleButton;
@property (nonatomic, strong) UIImageView *line1;
@property (nonatomic, strong) UIButton *postAdsButton;
@property (nonatomic, copy) TwoDataBlock block;
@property (nonatomic, assign)PaywayType paywayType;
@property (nonatomic, copy) NSArray* dicArray;
@property (nonatomic, strong)UIView * moneyView;

@property (nonatomic, strong) UIButton *timeBtn;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger timeCount;
@property (nonatomic, strong) UIImageView* QRView;
@property (nonatomic, strong) UIButton *bottomTipButton;
@property (nonatomic, strong) UIButton *bottomTipButton2;
@property (nonatomic, copy) NSString *zfbQRCode;
@end

@implementation PayFV

- (instancetype)initWithFrame:(CGRect)frame WithModel:(NSArray*)titleArray WithSec:(NSString*)sec{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(distoryTimer) name:kNotify_IsPayStopTimeRefresh object:nil];
        _dicArray = titleArray;
        _btns = [NSMutableArray array];
        
        self.backgroundColor = kWhiteColor;
        
        _line1 = [[UIImageView alloc]init];
        _line1.backgroundColor = HEXCOLOR(0xf6f5fa);
        [self addSubview:_line1];
        [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@20);
            make.height.equalTo(@5);
            make.leading.trailing.equalTo(@0);
        }];
        
        _ruleButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _ruleButton.tag = EnumActionTag3;
        _ruleButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_ruleButton setTitle:@"支付方式：" forState:UIControlStateNormal];
        [_ruleButton setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
        _ruleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self addSubview:_ruleButton];
        [_ruleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@20);
        make.top.equalTo(self.line1.mas_bottom).offset(15);
            make.height.mas_equalTo(@18);
        }];
        
        for (int i = 0; i < titleArray.count; i++) {
            NSDictionary* dic = titleArray[i];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.adjustsImageWhenHighlighted = NO;
            button.tag = [dic[kType] intValue];
            [button setImage:[UIImage imageNamed:dic[kImg]] forState:UIControlStateNormal];
            [button setTitle:dic[kTip] forState:UIControlStateNormal];
        
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 2;
            button.layer.borderWidth = 1;
            button.layer.borderColor = HEXCOLOR(0xdfdfdf).CGColor;
            [button setTitleColor:HEXCOLOR(0x717171) forState:UIControlStateNormal];
            
            button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [button addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:button];
            [_btns addObject:button];
            [_btns[i] layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:10];
    }
    UIButton* bt0 =_btns[0];
    bt0.selected = YES;
        
    [self infoView];
    [self publicTimePartWithSec:sec];
    [self clickItem:bt0];

        
    if (_btns.count == 1) {
        bt0.userInteractionEnabled = NO;
        [_btns[0] mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(self.ruleButton.mas_bottom).offset(8);
            make.leading.equalTo(@20);
//            make.centerX.equalTo(self);
            //            make.centerY.equalTo(self);
            make.width.mas_equalTo(@112);
            make.height.mas_equalTo(@30);
        }];
        
    }
    else{
        
    [_btns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:25  leadSpacing:20 tailSpacing:20];//withFixedItemLength:112
        
    [_btns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ruleButton.mas_bottom).offset(8);
//            make.centerY.equalTo(self);
//            make.width.mas_equalTo(@20);
            make.height.mas_equalTo(@30);
        }];

    }
        
    }
    return self;
}

- (void)actionBlock:(TwoDataBlock)block
{
    self.block = block;
}

- (void)clickItem:(UIButton*)button{
    NSString* btnTit = @"";
    button.selected = !button.selected;
    
    if (button.selected) {
        for (UIButton *btn in self.btns) {
            btn.selected = NO;
            btn.layer.borderColor = HEXCOLOR(0xdfdfdf).CGColor;
            [btn setTitleColor:HEXCOLOR(0x717171) forState:UIControlStateNormal];
        }
        button.selected = YES;
        [self changeStyleByButtonImageMainColor:button];

//        UIButton *tagBtn = [self.btns objectAtIndex:button.tag];//tag crush
//        tagBtn.selected = YES;
//        [self changeStyleByButtonImageMainColor:tagBtn];
        
        btnTit = button.titleLabel.text;
        
    } else {
        button.selected = YES;
        [self changeStyleByButtonImageMainColor:button];
        btnTit = button.titleLabel.text;

//        for (UIButton *btn in self.btns) {
//            btn.selected = NO;
//            btn.layer.borderColor = HEXCOLOR(0xdfdfdf).CGColor;
//            [btn setTitleColor:HEXCOLOR(0x717171) forState:UIControlStateNormal];
//        }
//        btnTit = @"";
    }
    _paywayType = button.tag;
    for (int i = 0; i < _dicArray.count; i++) {
        NSDictionary* dic = _dicArray[i];
        if ([dic[kType]intValue] == _paywayType) {
            [self richElementsInHeaderWithModel:dic];
        }
    }
    
    if (self.block) {
        self.block(@(button.tag),button);
    }
}

- (void)infoView{
    UIButton* selectPayBtn =_btns[0];
    _tipBtns = [NSMutableArray array];
    _bankNumBtns = [NSMutableArray array];
    _nameBtns = [NSMutableArray array];
    _payNumBtns = [NSMutableArray array];
    
    self.moneyView = [[UIView alloc]init];
    self.moneyView.backgroundColor = HEXCOLOR(0xf6f5fa);
    self.moneyView.layer.masksToBounds = YES;
    self.moneyView.layer.cornerRadius = 6;
    [self addSubview:self.moneyView];
    [self.moneyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(selectPayBtn.mas_bottom).offset(13);
        make.height.mas_equalTo(241);
    }];
    
    for (int i = 0; i < 2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:HEXCOLOR(0x717171) forState:UIControlStateNormal];
        
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.moneyView addSubview:button];
        [_tipBtns addObject:button];
    }
    [_tipBtns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:30  leadSpacing:20 tailSpacing:20];//withFixedItemLength:112
    
    [_tipBtns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyView.mas_top).offset(11);
        make.height.mas_equalTo(@20);
    }];
    
    for (int i = 0; i < 2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:HEXCOLOR(0x717171) forState:UIControlStateNormal];
        
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.moneyView addSubview:button];
        [_bankNumBtns addObject:button];
    }
    [_bankNumBtns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:30  leadSpacing:20 tailSpacing:20];//withFixedItemLength:112
    
    [_bankNumBtns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyView.mas_top).offset(40);
        make.height.mas_equalTo(@20);
    }];
    
    for (int i = 0; i < 2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:HEXCOLOR(0x717171) forState:UIControlStateNormal];
        
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.moneyView addSubview:button];
        [_nameBtns addObject:button];
    }
    [_nameBtns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:30  leadSpacing:20 tailSpacing:20];//withFixedItemLength:112
    
    [_nameBtns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyView.mas_top).offset(70);
        make.height.mas_equalTo(@20);
    }];
    
    for (int i = 0; i < 2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:HEXCOLOR(0x717171) forState:UIControlStateNormal];
        
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.moneyView addSubview:button];
        [_payNumBtns addObject:button];
    }
    [_payNumBtns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:30  leadSpacing:20 tailSpacing:20];//withFixedItemLength:112
    
    [_payNumBtns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyView.mas_top).offset(100);
        make.height.mas_equalTo(@20);
    }];
    
    self.bottomTipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.moneyView addSubview:self.bottomTipButton];
    self.bottomTipButton.titleLabel.numberOfLines = 0;
    self.bottomTipButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.bottomTipButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [self.bottomTipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerX.mas_equalTo(self.moneyView); make.bottom.mas_equalTo(self.moneyView.mas_bottom).offset(-36);
    }];
    
    self.bottomTipButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.moneyView addSubview:self.bottomTipButton2];
    self.bottomTipButton2.titleLabel.numberOfLines = 0;
    self.bottomTipButton2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.bottomTipButton2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [self.bottomTipButton2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerX.mas_equalTo(self.moneyView); make.bottom.mas_equalTo(self.moneyView.mas_bottom).offset(-10);
    }];
    
    self.QRView = [[UIImageView alloc]init];
    [self.moneyView addSubview:self.QRView];
    [self.QRView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.moneyView.mas_bottom).offset(-85);
        make.centerX.equalTo(self.moneyView);
        //            make.width.mas_equalTo(@20);
        make.width.height.mas_equalTo(@101);
    }];
}

- (void)richElementsInHeaderWithModel:(NSDictionary*)data{
    
    NSArray* titleArray = [NSArray array];
    NSArray* titleArray1 = [NSArray array];
    NSArray* titleArray2 = [NSArray array];
    NSArray* titleArray3 = [NSArray array];
    if (_paywayType == PaywayTypeCard) {
        NSDictionary* dic0 = data[kData][0];
        titleArray = @[dic0.allKeys[0],dic0.allValues[0]];
        
        NSDictionary* dic1 = data[kData][1];
        titleArray1 = @[dic1.allKeys[0],dic1.allValues[0]];
        
        NSDictionary* dic2 = data[kData][2];
        titleArray2 = @[dic2.allKeys[0],dic2.allValues[0]];
        
        NSDictionary* dic3 = data[kData][3];
        titleArray3 = @[dic3.allKeys[0],dic3.allValues[0]];
    }else{
        titleArray = data[kData];
    }
    UIButton* bt0 =_tipBtns[0];
    [bt0 setTitle:titleArray[0] forState:UIControlStateNormal];
    [bt0 setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
    bt0.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    UIButton* bt1 =_tipBtns[1];
    [bt1 setTitle:titleArray[1] forState:UIControlStateNormal];
    [bt1 setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [bt1 setImage:[UIImage imageNamed:@"iconCopy"] forState:UIControlStateNormal];
    [bt1 addTarget:self action:@selector(copylinkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    bt1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [bt1 layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:6];
    
    UIButton* bt3 =_bankNumBtns[0];
    [bt3 setTitle:_paywayType == PaywayTypeCard?titleArray1[0]:@"" forState:UIControlStateNormal];
    [bt3 setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
    bt3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    UIButton* bt4 =_bankNumBtns[1];
    [bt4 setTitle:_paywayType == PaywayTypeCard?titleArray1[1]:@"" forState:UIControlStateNormal];
    [bt4 setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [bt4 setImage:[UIImage imageNamed:_paywayType == PaywayTypeCard?@"iconCopy":@""] forState:UIControlStateNormal];
    [bt4 addTarget:self action:@selector(copylinkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    bt4.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [bt4 layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:6];
    
    UIButton* bt5 =_nameBtns[0];
    [bt5 setTitle:_paywayType == PaywayTypeCard?titleArray2[0]:@"" forState:UIControlStateNormal];
    [bt5 setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
    bt5.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    UIButton* bt6 = _nameBtns[1];
    [bt6 setTitle:_paywayType == PaywayTypeCard?titleArray2[1]:@"" forState:UIControlStateNormal];
    [bt6 setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [bt6 setImage:[UIImage imageNamed:_paywayType == PaywayTypeCard?@"iconCopy":@""] forState:UIControlStateNormal];
    [bt6 addTarget:self action:@selector(copylinkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    bt6.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [bt6 layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:6];
    
    
    UIButton* bt7 =_payNumBtns[0];
    [bt7 setTitle:_paywayType == PaywayTypeCard?titleArray3[0]:@"" forState:UIControlStateNormal];
    [bt7 setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
    bt7.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    
    UIButton* bt8 = _payNumBtns[1];
    [bt8 setTitle:_paywayType == PaywayTypeCard?titleArray3[1]:@"" forState:UIControlStateNormal];
    [bt8 setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [bt8 setImage:[UIImage imageNamed:_paywayType == PaywayTypeCard?@"iconCopy":@""] forState:UIControlStateNormal];
    [bt8 addTarget:self action:@selector(copylinkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    bt8.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [bt8 layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:6];
    
    
//    [self.moneyView layoutIfNeeded];
    NSDictionary* subDic = data[kSubTip];
    [self.bottomTipButton setAttributedTitle:[NSString attributedStringWithString:subDic.allKeys[0] stringColor:HEXCOLOR(0x4c7fff) stringFont:kFontSize(12) subString:@"" subStringColor:HEXCOLOR(0x698bfb) subStringFont:kFontSize(15)]  forState:UIControlStateNormal];
    [self.bottomTipButton2 setAttributedTitle:[NSString attributedStringWithString:@"" stringColor:HEXCOLOR(0x4c7fff) stringFont:kFontSize(12) subString:subDic.allValues[0] subStringColor:HEXCOLOR(0x698bfb) subStringFont:kFontSize(15)]  forState:UIControlStateNormal];
    
    if (_paywayType == PaywayTypeZFB) {
        self.bottomTipButton2.tag = EnumActionTag5;
        
    }else if (_paywayType == PaywayTypeWX){
        self.bottomTipButton2.tag = EnumActionTag6;
        
    }else if (_paywayType == PaywayTypeCard){
        self.bottomTipButton2.tag = EnumActionTag7;
    }
    [self.bottomTipButton2 addTarget:self action:@selector(jumpToPayApp:) forControlEvents:UIControlEventTouchUpInside];
    
    if (_paywayType == PaywayTypeCard) {
        [self.moneyView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@179);
        }];
        [self.QRView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(@0);
        }];
        [self.bottomTipButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.moneyView.mas_bottom).offset(-12);
        }];
        [self.timeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.moneyView.mas_bottom).offset(26);
        }];
        
        return;
        
    }else{
        [self.moneyView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@241);
        }];
        [self.QRView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(@101);
        }];
        [self.bottomTipButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.moneyView.mas_bottom).offset(-36);
        }];
        [self.timeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.moneyView.mas_bottom).offset(24);
        }];
    }
    

    _zfbQRCode = ![NSString isEmpty:data[kUrl]]?data[kUrl]:@"";
    if (![NSString isEmpty:_zfbQRCode]) {
        ZXEncodeHints *hints = [ZXEncodeHints hints];
        hints.encoding = NSUTF8StringEncoding;
        hints.margin = @(0);
        ZXQRCodeWriter *writer = [[ZXQRCodeWriter alloc] init];
        ZXBitMatrix *result = [writer encode:_zfbQRCode
                                      format:kBarcodeFormatQRCode
                                       width:200
                                      height:200
                                       hints:hints
                                       error:nil];
        self.QRView.image = [UIImage imageWithCGImage:[[ZXImage imageWithMatrix:result] cgimage]];
    }
}

- (void)publicTimePartWithSec:(NSString*)sec{
    _timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _timeBtn.tag = EnumActionTag4;
    [self addSubview:_timeBtn];
    [_timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
//        make.centerX.mas_equalTo(self); make.top.mas_equalTo(self.mas_top).offset(374);
        make.height.mas_equalTo(50);
    }];
    [self startTimeCount:sec];
}

/**设置倒计时时间，并启动倒计时*/
- (void)startTimeCount:(NSString *)sec
{
    if (sec) {
        self.timeCount = [sec integerValue];
    } else {
        self.timeCount = 60;
    }
    
    [self distoryTimer];
    self.timeBtn.enabled = false;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(_timerAction)
                                                userInfo:nil
                                                 repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

/**停止定时器*/
- (void)distoryTimer
{
    if (self.timer != nil)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark timer
- (void) _timerAction
{
    self.timeCount--;
//    NSString *title = [NSString stringWithFormat:@"%ld",(long)self.timeCount];
    [self.timeBtn setTitle:[NSString timeWithSecond:self.timeCount] forState:UIControlStateNormal];
    [self.timeBtn setTitleColor:HEXCOLOR(0xff9238) forState:UIControlStateNormal];
    if(self.timeCount < 0)
    {
        [self distoryTimer];
        self.timeBtn.enabled = false;
        [self.timeBtn setTitle:@"00:00" forState:UIControlStateNormal];
//        [self.timeBtn setTitleColor:HEXCOLOR(0xf6f5fa) forState:UIControlStateNormal];
        if (self.block) {
            self.block(@(_timeBtn.tag), _timeBtn);
        }
        
    }
}

- (void) removeFromSuperview
{
    [super removeFromSuperview];
    [self distoryTimer];
}

- (void)copylinkBtnClick:(UIButton*)sender {
    if (![NSString isEmpty:sender.titleLabel.text]) {
        [YKToastView showToastText:@"复制成功!"];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = sender.titleLabel.text;
        if (self.block) {
            self.block(@(sender.tag),pasteboard.string);
        }
    }
    
}

- (void)jumpToPayApp:(UIButton*)sender{
    if (self.block) {
        self.block(@(sender.tag), _zfbQRCode);
    }
}
- (void)changeStyleByButtonImageMainColor:(UIButton*)bt0{
    EnumActionTag tag = bt0.tag;
    switch (tag) {
        case EnumActionTag1:
            {
             [bt0 setTitleColor:RGBCOLOR(55, 171, 44) forState:UIControlStateNormal];
             bt0.layer.borderColor = RGBCOLOR(55, 171, 44).CGColor;
            }
            break;
        case EnumActionTag2:
        {
            [bt0 setTitleColor:RGBCOLOR(18, 152, 235) forState:UIControlStateNormal];
            bt0.layer.borderColor = RGBCOLOR(18, 152, 235).CGColor;
        }
            break;
        case EnumActionTag3:
        {
            [bt0 setTitleColor:RGBCOLOR(199, 0, 103) forState:UIControlStateNormal];
            bt0.layer.borderColor = RGBCOLOR(199, 0, 103).CGColor;
        }
            break;
        default:
            break;
    }
//    [bt0.imageView.image getPaletteImageColorWithMode:VIBRANT_PALETTE withCallBack:^(PaletteColorModel *recommendColor, NSDictionary *allModeColorDic,NSError *error) {
//        if (!recommendColor){
//            return;
//        }
//        [bt0 setTitleColor:[UIColor colorWithHexString:recommendColor.imageColorString]  forState:UIControlStateNormal];
//        bt0.layer.borderColor = [UIColor colorWithHexString:recommendColor.imageColorString].CGColor;
//
//    }];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNotify_IsPayStopTimeRefresh object:nil];
}
@end
