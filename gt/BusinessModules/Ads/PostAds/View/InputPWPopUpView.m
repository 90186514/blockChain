//
//  InputPWPopUpView.m
//  gtp
//
//  Created by Aalto on 2018/12/30.
//  Copyright © 2018 GT. All rights reserved.
//

#import "InputPWPopUpView.h"
#import "LoginModel.h"
#define XHHTuanNumViewHight 288//347 //283+64

@interface InputPWPopUpView()<UIGestureRecognizerDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *line1;
@property (nonatomic, strong) NSMutableArray* leftLabs;
@property (nonatomic, strong) NSMutableArray* lines;
@property (nonatomic, strong) NSMutableArray* rightTfs;
@property (nonatomic, strong) UIButton *postAdsButton;
@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, copy) ActionBlock disMissBlock;
@property (nonatomic, assign) CGFloat contentViewHeigth;
@property (nonatomic, assign) BOOL isShowGoogleCodeField;
@property (nonatomic, assign) BOOL isForceShowGoogleCodeField;

@property (nonatomic, strong) NSMutableArray*sub_views;
@property (nonatomic, strong) UIButton *eyeStatusBtn;
@end

@implementation InputPWPopUpView
- (id)initWithFrame:(CGRect)frame WithIsForceNoShowGoogleCodeField:(BOOL)isForceNoShowGoogleCodeField{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        //        LoginModel* userInfoModel = [LoginModel mj_objectWithKeyValues:GetUserDefaultWithKey(kUserInfo)];
        
        
        _isShowGoogleCodeField = NO;

        [self setupContent];
        
    }
    return self;
}

/*在以后使用的时候可能使用init方法创建，也有可能使用initWithFrame:方法创建，但是无论哪种方式，最后都会调用到initWithFrame:方法。在这个方法中创建子控件，可以保证无论哪种方式都可以成功创建。*/
- (id)initWithFrame:(CGRect)frame WithIsForceShowGoogleCodeField:(BOOL)isForceShowGoogleCodeField{
    self = [super initWithFrame:frame];
    if (self) {
        _isForceShowGoogleCodeField = isForceShowGoogleCodeField;
    }
    return [self initWithFrame:frame];
}


- (id)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        
        LoginModel* userInfoModel = [LoginModel mj_objectWithKeyValues:GetUserDefaultWithKey(kUserInfo)];
        
        
       _isShowGoogleCodeField = ([userInfoModel.userinfo.safeverifyswitch boolValue]==YES)?YES:NO;
        if (_isForceShowGoogleCodeField==YES) {
            _isShowGoogleCodeField = YES;
        }
        
        
        [self setupContent];
    }
    
    return self;
}

- (void)setupContent {
    _leftLabs = [NSMutableArray array];
    _rightTfs = [NSMutableArray array];
    _lines = [NSMutableArray array];
    _sub_views = [NSMutableArray array];
    self.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT);
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
//    _contentViewHeigth = XHHTuanNumViewHight+[YBFrameTool tabBarHeight];
    
    
    _contentViewHeigth =  _isShowGoogleCodeField?XHHTuanNumViewHight:248;
    if (_contentView == nil) {
//        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, MAINSCREEN_HEIGHT - _contentViewHeigth, MAINSCREEN_WIDTH, _contentViewHeigth)];
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, (MAINSCREEN_HEIGHT - _contentViewHeigth)/2, MAINSCREEN_WIDTH, _contentViewHeigth)];
        _contentView.userInteractionEnabled = YES;
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_contentView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _contentView.bounds;
        maskLayer.path = maskPath.CGPath;
        _contentView.layer.mask = maskLayer;
        
        // 右上角关闭按钮
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(_contentView.width -  90, 0, 90, 47);
        closeBtn.titleLabel.font = kFontSize(15);
        [closeBtn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
        [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
//        [closeBtn addTarget:self action:@selector(disMissView) forControlEvents:UIControlEventTouchUpInside];
        [closeBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)]];
        [_contentView addSubview:closeBtn];
        
        // 左上角关闭按钮
        UIButton *saftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        saftBtn.frame = CGRectMake(30, 0, 90, 47);
        saftBtn.titleLabel.font = kFontSize(17);
        [saftBtn setTitleColor:HEXCOLOR(0x232630) forState:UIControlStateNormal];
        [saftBtn setTitle:@"安全验证" forState:UIControlStateNormal];
        saftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_contentView addSubview:saftBtn];
        
        _line1 = [[UIImageView alloc]init];
        [self.contentView addSubview:_line1];
        _line1.backgroundColor = HEXCOLOR(0xe8e9ed);

        [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@0);
            make.trailing.equalTo(@0);
            make.top.offset(47);
            make.height.equalTo(@.5);
        }];
        
        [self layoutAccountPublic];
        
    }
}

-(void)layoutAccountPublic{
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.scrollEnabled = NO;
    scrollView.delegate = nil;
    scrollView.backgroundColor = kWhiteColor;
    [self.contentView addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.contentView).offset(30);
//        make.trailing.equalTo(self.contentView).offset(-30);
//        make.bottom.equalTo(self.contentView.mas_bottom).offset(-45);
//        make.top.equalTo(self.contentView).offset(47);
//        make.height.equalTo(@178);
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(47.5, 30, 55, 30));
    }];
    
    UIView *containView = [UIView new];
    containView.backgroundColor = kWhiteColor;
    [scrollView addSubview:containView];
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
//    return;
    UIView *lastView = nil;
    for (int i = 0; i < 2; i++) {
        UIView *sub_view = [UIView new];
        UILabel* leftLab = [[UILabel alloc]init];
        leftLab.text = @"A";
        leftLab.tag = i;
        leftLab.textAlignment = NSTextAlignmentLeft;
        leftLab.textColor = HEXCOLOR(0x232630);
        leftLab.font = kFontSize(17);
        [sub_view addSubview:leftLab];
        [_leftLabs addObject:leftLab];
        [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(sub_view).offset(0);
            make.top.equalTo(sub_view).offset(12);
            make.bottom.equalTo(sub_view).offset(-37);
        }];
        
        
        UITextField* tf = [[UITextField alloc] init];
        tf.tag = i;
        tf.delegate = self;
//        tf.keyboardType = UIKeyboardTypeNumberPad;
        tf.textAlignment = NSTextAlignmentLeft;
        tf.backgroundColor = kClearColor;
        tf.textColor = [YBGeneralColor themeColor];
        tf.font = kFontSize(15);

//        tf.zw_placeHolderColor = HEXCOLOR(0xb2b2b2);
        tf.secureTextEntry = YES;

        [sub_view addSubview:tf];
        [_rightTfs  addObject:tf];
        [tf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(sub_view).offset(0);
            make.top.equalTo(sub_view).offset(46);
            make.bottom.equalTo(sub_view).offset(-6);
            make.width.equalTo(@(MAINSCREEN_WIDTH));
        }];

        UIImageView* line1 = [[UIImageView alloc]init];
        [sub_view addSubview:line1];
        [_lines addObject:line1];
        line1.backgroundColor = HEXCOLOR(0xe8e9ed);

        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(@0);
            make.top.equalTo(sub_view).offset(73);
            make.height.equalTo(@.5);
        }];
        
        [_sub_views addObject:sub_view];
        [containView addSubview:sub_view];
        
//        sub_view.layer.cornerRadius = 4;
//        sub_view.layer.borderWidth = 1;
//        sub_view.layer.masksToBounds = YES;
        
        [sub_view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.and.right.equalTo(containView);
            
            make.height.mas_equalTo(@(89));//*i
            
            if (lastView)
            {
                make.top.mas_equalTo(lastView.mas_bottom).offset(-12);//下个顶对上个底的间距=上个顶对整个视图顶的间距
                //                //上1个
                //                lastView.backgroundColor = HEXCOLOR(0xf2f1f6);
                //                lastView.layer.borderColor = HEXCOLOR(0xf2f1f6).CGColor;
            }else
            {
                make.top.mas_equalTo(containView.mas_top);//-15多出来scr
                
                
            }
            
        }];
        //最后一个
//        sub_view.backgroundColor = kWhiteColor;
//        sub_view.layer.borderColor = HEXCOLOR(0xf2f1f6).CGColor;
        
        lastView = sub_view;
        
    }
    // 最后更新containView
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastView.mas_bottom).offset(0);
    }];
    
    
    UITextField* rtf1 = _rightTfs[1];
    UIView* subView1 = _sub_views[1];
    _eyeStatusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_eyeStatusBtn setTitle:@"粘贴" forState:UIControlStateNormal];
    [_eyeStatusBtn addTarget:self action:@selector(eyeRtf1Action:) forControlEvents:UIControlEventTouchUpInside];
    _eyeStatusBtn.titleLabel.font = kFontSize(15);
    [_eyeStatusBtn setTitleColor:[YBGeneralColor themeColor] forState:UIControlStateNormal];
    [subView1 addSubview:_eyeStatusBtn];
    [_eyeStatusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(subView1.mas_right).offset(-5);
        make.centerY.equalTo(rtf1);
        make.width.equalTo(@50);
        make.height.equalTo(@21);
    }];
    
    _postAdsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _postAdsButton.tag = EnumActionTag4;
    _postAdsButton.adjustsImageWhenHighlighted = NO;
    _postAdsButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_postAdsButton setTitle:@"确定" forState:UIControlStateNormal];
    [_postAdsButton setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    _postAdsButton.layer.masksToBounds = YES;
    _postAdsButton.layer.cornerRadius = 4;
    _postAdsButton.layer.borderWidth = 0;
    //        _postAdsButton.layer.borderColor = HEXCOLOR(0x9b9b9b).CGColor;
    
    [_postAdsButton setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0x4c7fff)] forState:UIControlStateNormal];
    _postAdsButton.userInteractionEnabled = YES;
//    [_postAdsButton addTarget:self action:@selector(postAdsAndRuleButtonClickItem) forControlEvents:UIControlEventTouchUpInside];
    [_postAdsButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(postAdsAndRuleButtonClickItem:)]];
    [self.contentView addSubview:_postAdsButton];
    [_postAdsButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
        make.top.equalTo(containView.mas_bottom).offset(self.isShowGoogleCodeField? 10:-49);//别用scrollView
        make.centerX.equalTo(self.contentView);
        make.height.mas_equalTo(@42);
        make.width.mas_equalTo(@327);
    }];

    [self richElementsInViewWithModel];
    
}

- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}

- (void)disMissActionBlock:(ActionBlock)disMissBlock
{
    self.disMissBlock  = disMissBlock;
}

- (void)richElementsInViewWithModel{
    UILabel* lab0 = _leftLabs[0];
    lab0.text = @"支付密码";
    
    
    UITextField* rtf0 = _rightTfs[0];
    rtf0.placeholder = @"请输入支付密码";
//    [self textViewDidBeginEditing:rtf0];
    
    UILabel* lab1 = _leftLabs[1];
    lab1.text = @"谷歌验证码";
    
    UIImageView* line1 = _lines[1];
    
    UITextField* rtf1 = _rightTfs[1];
    rtf1.placeholder = @"请输入谷歌验证码";
    
    if (_isShowGoogleCodeField) {
        lab1.hidden = NO;
        line1.hidden = NO;
        rtf1.hidden = NO;
        _eyeStatusBtn.hidden = NO;
    }else{
        lab1.hidden = YES;
        line1.hidden = YES;
        rtf1.hidden = YES;
        _eyeStatusBtn.hidden = YES;
    }
    
}

-(void)eyeRtf1Action:(UIButton*)sender{
    UITextView* rtf1 = _rightTfs[1];
    if (![NSString isEmpty:[[UIPasteboard generalPasteboard]string]]) {
        rtf1.text = [NSString stringWithFormat:@"%@",[[UIPasteboard generalPasteboard]string]];
    }
}

- (void)postAdsAndRuleButtonClickItem:(UITapGestureRecognizer*)sender{
    UITextField* rtf0 = _rightTfs[0];
    UITextField* rtf1 = _rightTfs[1];
    if (_isShowGoogleCodeField) {
        if ([NSString isEmpty:rtf0.text]
            &&[NSString isEmpty:rtf1.text]) {
            [YKToastView showToastText:@"请输入支付密码和谷歌验证码"];
            return;
        }
        else if (![NSString isEmpty:rtf0.text]
                 &&[NSString isEmpty:rtf1.text]) {
            [YKToastView showToastText:@"请输入谷歌验证码"];
            return;
        }
        else if ([NSString isEmpty:rtf0.text]
                 &&![NSString isEmpty:rtf1.text]) {
            [YKToastView showToastText:@"请输入支付密码"];
            return;
        }
        
        if (self.block) {
            self.block(@{rtf0.text:rtf1.text});
        }
    }else{
        if ([NSString isEmpty:rtf0.text]) {
            [YKToastView showToastText:@"请输入支付密码"];
            return;
        }
        
        if (self.block) {
            
            self.block(@{rtf0.text:@""});
        }
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
    
    [_contentView setFrame:CGRectMake(0, MAINSCREEN_HEIGHT, MAINSCREEN_WIDTH, _contentViewHeigth)];
    WS(weakSelf);
    [UIView animateWithDuration:0.3 animations:^{
        
        weakSelf.alpha = 1.0;
        
//        [weakSelf.contentView setFrame:CGRectMake(0, (MAINSCREEN_HEIGHT - weakSelf.contentViewHeigth),MAINSCREEN_WIDTH,weakSelf.contentViewHeigth)];
        [weakSelf.contentView setFrame:CGRectMake(0, (MAINSCREEN_HEIGHT - weakSelf.contentViewHeigth)/2,MAINSCREEN_WIDTH,weakSelf.contentViewHeigth)];
        
    } completion:nil];
}

//移除从上向底部弹下去的UIView（包含遮罩）
- (void)disMissView {
    WS(weakSelf);
//    [_contentView setFrame:CGRectMake(0, MAINSCREEN_HEIGHT - _contentViewHeigth, MAINSCREEN_WIDTH, _contentViewHeigth)];
    [_contentView setFrame:CGRectMake(0, (MAINSCREEN_HEIGHT - _contentViewHeigth)/2, MAINSCREEN_WIDTH, _contentViewHeigth)];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         weakSelf.alpha = 0.0;
                         [weakSelf.contentView setFrame:CGRectMake(0, MAINSCREEN_HEIGHT, MAINSCREEN_WIDTH, weakSelf.contentViewHeigth)];
                     }
                     completion:^(BOOL finished){
                         [weakSelf removeFromSuperview];
                         [weakSelf.contentView removeFromSuperview];
                         if (self.disMissBlock) {
                             self.disMissBlock(@1);
                         }
                     }];
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    int offset = self.contentView.frame.origin.y -(YBSystemTool.isIphoneX? 150: 33.0);//216iPhone键盘高
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.transform = CGAffineTransformMakeTranslation(0, -offset);
    }];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.transform = CGAffineTransformIdentity;
    }];
}

@end

