//
//  OfficialRemindPopUpView.m
//  gt
//
//  Created by Administrator on 16/04/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "OfficialRemindPopUpView.h"
#define XHHTuanNumViewHight 360
#define XHHTuanNumViewWidth 306

@interface OfficialRemindPopUpView ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *line1;
@property (nonatomic, strong) NSMutableArray* leftLabMutArr;

@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, assign) CGFloat contentViewHeigth;

@property (nonatomic, strong) NSMutableArray *contentLabMutArr;
@property (nonatomic, strong) NSMutableArray *funcBtnMutArr;
@property (nonatomic, strong) UIButton *checkButton;
@property (nonatomic, strong) UIButton *singleSureButton;

@property (nonatomic, strong) NSMutableArray *subBtnTitleContentMutArr;

@end

@implementation OfficialRemindPopUpView

- (id)initWithFrame:(CGRect)frame {
    
    if (self == [super initWithFrame:frame]) {
        
        [self setupContent];
    }
    
    return self;
}

- (void)setupContent {
    
    self.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT);
    
    self.backgroundColor = COLOR_HEX(0x000000, .8);
    
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(disMissView)];
    tap.delegate = self;
    
    [self addGestureRecognizer:tap];
    
    _contentViewHeigth = XHHTuanNumViewHight;
    
    [self addSubview:self.contentView];
    
    UIButton *saftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    saftBtn.frame = CGRectMake(0, 0, self.contentView.width, 47);
    
    saftBtn.titleLabel.font = kFontSize(17);
    
    [saftBtn setTitleColor:HEXCOLOR(0x232630)
                  forState:UIControlStateNormal];
    
    [saftBtn setTitle:@"官方提醒"
             forState:UIControlStateNormal];
    
    saftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [self.contentView addSubview:saftBtn];
    
    _line1 = UILabel.new;
    
    [self.contentView addSubview:_line1];
    
    _line1.backgroundColor = HEXCOLOR(0xe8e9ed);
    
    [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.top.offset(48);
        make.height.equalTo(@3);
    }];
    
    [self layoutAccountPublic];
}

#pragma mark - lazyload

-(NSMutableArray *)subBtnTitleContentMutArr{
    
    if (!_subBtnTitleContentMutArr) {
        
        _subBtnTitleContentMutArr = NSMutableArray.array;
        
        [_subBtnTitleContentMutArr addObject:@"稍后再说"];
        
        [_subBtnTitleContentMutArr addObject:@"取消订单"];
    }
    
    return _subBtnTitleContentMutArr;
}

-(NSMutableArray *)contentLabMutArr{
    
    if (!_contentLabMutArr) {
        
        _contentLabMutArr = NSMutableArray.array;
    }
    
    return _contentLabMutArr;
}

-(NSMutableArray *)leftLabMutArr{
    
    if (!_leftLabMutArr) {
        
        _leftLabMutArr = NSMutableArray.array;
    }
    
    return _leftLabMutArr;
}

-(NSMutableArray *)funcBtnMutArr{
    
    if (!_funcBtnMutArr) {
        
        _funcBtnMutArr = NSMutableArray.array;
    }
    
    return _funcBtnMutArr;
}

-(UIView *)contentView{
    
    if (!_contentView) {
        
        _contentView = [[UIView alloc]initWithFrame:CGRectMake((MAINSCREEN_WIDTH - XHHTuanNumViewWidth)/2, (MAINSCREEN_HEIGHT - _contentViewHeigth)/2, XHHTuanNumViewWidth, _contentViewHeigth)];
        
        _contentView.layer.cornerRadius = 6;
        
        _contentView.layer.masksToBounds = YES;
        
        _contentView.userInteractionEnabled = YES;
        
        _contentView.backgroundColor = kWhiteColor;
    }
    
    return _contentView;
}

-(void)layoutAccountPublic{
    
    UILabel *contentLab = UILabel.new;//内容
    
    contentLab.numberOfLines = 0;
    
    [self data:contentLab];
    
    [self.contentView addSubview:contentLab];
    
    [contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).offset(20);
        
        make.right.equalTo(self.contentView).offset(-20);
        
        make.top.equalTo(self.line1.mas_bottom).offset(20);
    }];
    
    //我知道了 按钮
    
    UIButton *iKnownBtn = UIButton.new;
    
    [iKnownBtn setTitle:@"我知道了"
              forState:UIControlStateNormal];
    
    [NSObject cornerCutToCircleWithView:iKnownBtn
                        AndCornerRadius:6];
    
    [iKnownBtn setBackgroundColor:RGBCOLOR(76, 127, 255)];
    
    [iKnownBtn addTarget:self
                  action:@selector(iKnownBtnClickEvent:)
        forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:iKnownBtn];
    
    [iKnownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).offset(56);
        
        make.right.equalTo(self.contentView).offset(-56);
        
        make.top.equalTo(contentLab.mas_bottom).offset(22);
        
        make.height.mas_equalTo(40);
    }];
    
    //下次不再提醒 按钮
    UIButton *notToRemindWhenNextBtn = UIButton.new;
    
    [notToRemindWhenNextBtn.titleLabel sizeToFit];

    [notToRemindWhenNextBtn setTitle:@"下次不再提醒"
                            forState:UIControlStateNormal];

    notToRemindWhenNextBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular"
                                                             size:14];

    [notToRemindWhenNextBtn setTitleColor:RGBCOLOR(154, 154, 154)
                                 forState:UIControlStateNormal];

    [notToRemindWhenNextBtn setImage:kIMG(@"disable_unselected")
                            forState:UIControlStateNormal];

    [notToRemindWhenNextBtn setImage:kIMG(@"disable_selected")
                            forState:UIControlStateSelected];

    [notToRemindWhenNextBtn addTarget:self
                               action:@selector(notToRemindWhenNextBtnClickEvent:)
                     forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:notToRemindWhenNextBtn];

    [notToRemindWhenNextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.contentView);

        make.top.equalTo(iKnownBtn.mas_bottom).offset(15);

        make.bottom.equalTo(self.contentView).offset(-15);
    }];
}

-(void)data:(UILabel *)lab{
    
    NSDictionary* style = @{@"font_1":[UIFont fontWithName:@"PingFangSC-Regular" size:13.0],
                             @"font_2":[UIFont fontWithName:@"PingFangSC-Semibold" size:13.0],
                             @"textColor_1":RGBCOLOR(51, 51, 51),
                             @"textColor_2":RGBCOLOR(76, 127, 255)
                             };
    
    NSString *contentDataStr = @"<font_1><textColor_1>1、请在完成汇款后，点击</textColor_1></font_1><textColor_2><font_2>“我已付款”</font_2></textColor_2><font_1><textColor_1>进行确认;\n\n2、使用微信、支付宝、银行卡转账时，请不要添加\n任何备注内容，否则可能会增加卡款风险;</textColor_1></font_1><font_2><textColor_1>\n\n3、此次交易已由币友平台担保，请放心付款。</textColor_1></font_2>";
    
    lab.attributedText = [contentDataStr attributedStringWithStyleBook:style];
}

#pragma mark —— iKnownBtn 点击事件
-(void)iKnownBtnClickEvent:(UIButton *)sender{
    
    [self disMissView];
}

#pragma mark —— 下次不再提醒 点击事件
-(void)notToRemindWhenNextBtnClickEvent:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    
    SetUserBoolKeyWithObject(KNotToRemindWhenNext, sender.selected);
    
    UserDefaultSynchronize;
}

- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isKindOfClass:[UIButton class]]) return NO;
    
    return YES;
}

- (void)showInApplicationKeyWindow{
    
    [self showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)showInView:(UIView *)view {
    
    if (!view) return;
    
    [view addSubview:self];
    
    [view addSubview:_contentView];
    
    [_contentView setFrame:CGRectMake((MAINSCREEN_WIDTH - XHHTuanNumViewWidth)/2, MAINSCREEN_HEIGHT, XHHTuanNumViewWidth, _contentViewHeigth)];
    
    kWeakSelf(self);
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         
                         kStrongSelf(self);
                         
                         self.alpha = 1.0;
                         
                         [self.contentView setFrame:CGRectMake((MAINSCREEN_WIDTH - XHHTuanNumViewWidth)/2, (MAINSCREEN_HEIGHT - self.contentViewHeigth)/2,XHHTuanNumViewWidth,self.contentViewHeigth)];
                         
                     }
                     completion:nil];
}

//移除从上向底部弹下去的UIView（包含遮罩）
- (void)disMissView {
    
    kWeakSelf(self);
    
    [_contentView setFrame:CGRectMake((MAINSCREEN_WIDTH - XHHTuanNumViewWidth)/2, (MAINSCREEN_HEIGHT - _contentViewHeigth)/2, XHHTuanNumViewWidth, _contentViewHeigth)];
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         kStrongSelf(self);
                         
                         self.alpha = 0.0;
                         
                         [self.contentView setFrame:CGRectMake((MAINSCREEN_WIDTH - XHHTuanNumViewWidth)/2, MAINSCREEN_HEIGHT, XHHTuanNumViewWidth, self.contentViewHeigth)];
                     }
                     completion:^(BOOL finished){
                         
                         [self removeFromSuperview];
                         
                         [self.contentView removeFromSuperview];
                         
                     }];
}

@end
