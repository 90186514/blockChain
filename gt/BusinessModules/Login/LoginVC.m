//
//  LoginVC.m
//  gtp
//
//  Created by GT on 2019/1/2.
//  Copyright © 2019 GT. All rights reserved.
//

#import "LoginVC.h"
#import "LoginVM.h"
#import "FindPWVC.h"
#import "RegisterVC.h"
#import "VertifyVC.h"
#import "RegisterSuccessVC.h"
#import <VerifyCode/NTESVerifyCodeManager.h>

@interface LoginVC ()<NTESVerifyCodeManagerDelegate,UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray* tipLabs;
@property (nonatomic, strong) NSMutableArray* lines;
@property (nonatomic, strong) NSMutableArray*sub_views;
@property (nonatomic, strong) UIButton *eraseBtn;
@property (nonatomic, strong) UIButton *eyeStatusBtn;

@property (nonatomic, strong) UIImageView *decorIv;
@property (nonatomic, strong) UILabel *accLab;
@property (nonatomic, strong) NSMutableArray* leftLabs;

@property (nonatomic, strong) NSMutableArray* rightTfs;
@property (nonatomic, strong) UIButton *forgetPWBtn;

@property (nonatomic, strong) UIButton *onlineCustomerServiceBtn;

@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, strong) LoginVM* vm;
@property (nonatomic, strong)NTESVerifyCodeManager* manager;
@property (nonatomic, strong) id requestParams;
@property (nonatomic, copy) DataBlock successBlock;

@property(nonatomic) NSInteger tagger;

@end

@implementation LoginVC
+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(id )requestParams
                   success:(DataBlock)block
{
    LoginVC *vc = [[LoginVC alloc] init];
    vc.successBlock = block;
    vc.requestParams = requestParams;
//        UINavigationController *reNavCon = [[UINavigationController alloc]initWithRootViewController:vc];
//        [rootVC presentViewController:reNavCon animated:YES completion:nil];
    
//        [[YBNaviagtionViewController rootNavigationController] pushViewController:vc animated:true];
    
    [rootVC presentViewController:vc animated:YES completion:^{
    }];
    return vc;
}

-(void)goBack{
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:false completion:^{
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    [self initView];
}


- (void)initView {
    UIImage* decorImage = kIMG(@"login_top");
    _decorIv = [[UIImageView alloc]init];
    [self.view addSubview:_decorIv];
    [_decorIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX); make.top.leading.trailing.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(decorImage.size.width, 219));
    }];
    [_decorIv setContentMode:UIViewContentModeScaleAspectFill];
    
    _decorIv.clipsToBounds = YES;
    _decorIv.image = decorImage;
    _decorIv.userInteractionEnabled = YES;
    _accLab = [[UILabel alloc]init];
    [_decorIv addSubview:_accLab];
    [_accLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.decorIv.mas_centerX);
        make.top.equalTo(self.decorIv).offset(73);
    }];
    [self layoutAccountPublic];
}

-(void)layoutAccountPublic{
    _leftLabs = [NSMutableArray array];
    _rightTfs = [NSMutableArray array];
    _lines = [NSMutableArray array];
    _tipLabs = [NSMutableArray array];
    _sub_views = [NSMutableArray array];
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.scrollEnabled = NO;
    scrollView.delegate = nil;
    scrollView.delaysContentTouches = NO;
    scrollView.canCancelContentTouches = NO;
    scrollView.userInteractionEnabled = YES;
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.leading.equalTo(self.contentView).offset(30);
        //        make.trailing.equalTo(self.contentView).offset(-30);
        //        make.bottom.equalTo(self.contentView.mas_bottom).offset(-45);
        //        make.top.equalTo(self.contentView).offset(47);
        //        make.height.equalTo(@178);
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(200, 38, 255, 38));//255-2*（34-12）
    }];
    
    UIView *containView = [UIView new];
    containView.backgroundColor = kWhiteColor;
    [scrollView addSubview:containView];
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    
    UIView *lastView = nil;
    for (int i = 0; i < 2; i++) {
        UIView *sub_view = [UIView new];
        [_sub_views addObject:sub_view];
        UILabel* leftLab = [[UILabel alloc]init];
        leftLab.text = @"A";
        leftLab.tag = i;
        leftLab.textAlignment = NSTextAlignmentLeft;
        leftLab.textColor = HEXCOLOR(0x333333);
        leftLab.font = kFontSize(17);
        [sub_view addSubview:leftLab];
        [_leftLabs addObject:leftLab];
        [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(sub_view).offset(0);
            make.top.equalTo(sub_view).offset(12);
            make.bottom.equalTo(sub_view).offset(-33);
        }];
        
        
        UITextField* tf = [[UITextField alloc] init];
        tf.tag = i;
        tf.delegate = self;
        tf.keyboardType = UIKeyboardTypeASCIICapable;
        [tf addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingChanged];
        tf.textAlignment = NSTextAlignmentLeft;
        tf.backgroundColor = kClearColor;
        tf.textColor = [YBGeneralColor themeColor];
        tf.font = kFontSize(15);
        
//        tf.zw_placeHolderColor = HEXCOLOR(0xb2b2b2);
        
        [sub_view addSubview:tf];
        [_rightTfs  addObject:tf];
        [tf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(sub_view).offset(0);
            make.trailing.equalTo(sub_view).offset(-30);
            make.top.equalTo(sub_view).offset(43);
            make.bottom.equalTo(sub_view).offset(-6);
//            make.width.equalTo(@(MAINSCREEN_WIDTH));
        }];
        
        UIImageView* line1 = [[UIImageView alloc]init];
        [_lines addObject:line1];
        [sub_view addSubview:line1];
        line1.backgroundColor = HEXCOLOR(0xe8e9ed);
        
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(@0);
            make.top.equalTo(sub_view).offset(75);
            make.height.equalTo(@.5);
        }];
        
        UILabel* tipLab = [[UILabel alloc]init];
        tipLab.textAlignment = NSTextAlignmentLeft;
        tipLab.textColor = [UIColor redColor];
        tipLab.font = kFontSize(11);
        [_tipLabs addObject:tipLab];
        [sub_view addSubview:tipLab];
        [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(@0);
            make.top.equalTo(sub_view).offset(90);
            make.height.equalTo(@11);
        }];
        
        [containView addSubview:sub_view];
        
        //        sub_view.layer.cornerRadius = 4;
        //        sub_view.layer.borderWidth = 1;
        //        sub_view.layer.masksToBounds = YES;
        
        [sub_view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.and.right.equalTo(containView);
            
            make.height.mas_equalTo(@(82));//*i
            
            if (lastView)
            {
                make.top.mas_equalTo(lastView.mas_bottom).offset(22);//下个顶对上个底的间距=上个顶对整个视图顶的间距
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
    
//    self.view.multipleTouchEnabled = TRUE;
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.tag = EnumActionTag0;
//    _postAdsButton.adjustsImageWhenHighlighted = NO;
    _loginBtn.titleLabel.font = kFontSize(16);
    [_loginBtn setTitle:@"确认登录" forState:UIControlStateNormal];
    [_loginBtn setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    _loginBtn.layer.masksToBounds = YES;
    _loginBtn.layer.cornerRadius = 20;
    _loginBtn.layer.borderWidth = 0;
    //        _postAdsButton.layer.borderColor = HEXCOLOR(0x9b9b9b).CGColor;
    
    [_loginBtn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0x4c7fff)] forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
    
    _loginBtn.multipleTouchEnabled = YES;
    [self.view addSubview:_loginBtn];
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
        make.top.equalTo(containView.mas_bottom).offset(15);//别用scrollView
        make.centerX.equalTo(self.view);
//        make.leading.equalTo(self.view);
//        make.trailing.equalTo(self.view);
        make.height.mas_equalTo(@40);
        make.width.mas_equalTo(@225);
    }];
    
    _forgetPWBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _forgetPWBtn.tag = EnumActionTag1;
    _forgetPWBtn.adjustsImageWhenHighlighted = NO;
    [_forgetPWBtn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_forgetPWBtn];
    [_forgetPWBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        //        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
//        make.top.equalTo(self.loginBtn.mas_bottom).offset(39.9);//别用scrollView
//        make.leading.offset(38);
//        make.height.mas_equalTo(@21);
//        //        make.width.mas_equalTo(@225);
        
        make.top.equalTo(self.loginBtn.mas_bottom).offset(4);//别用scrollView//24
        //        make.centerX.equalTo(self.view);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        
        make.height.mas_equalTo(@41);
    }];
    
    _onlineCustomerServiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _onlineCustomerServiceBtn.tag = EnumActionTag2;
    _onlineCustomerServiceBtn.adjustsImageWhenHighlighted = NO;
    _onlineCustomerServiceBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    [_onlineCustomerServiceBtn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_onlineCustomerServiceBtn];
    [_onlineCustomerServiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
        make.bottom.equalTo(self.view).offset(-10);//别用scrollView//24
//        make.centerX.equalTo(self.view);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);

        make.height.mas_equalTo(@41);
        //        make.width.mas_equalTo(@225);
    }];
    
    
    UIView* v0 = _sub_views[0];
    UITextField* rtf0 = _rightTfs[0];
    
    _eraseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_eraseBtn setImage:kIMG(@"icon_erase") forState:UIControlStateNormal];
    [_eraseBtn addTarget:self action:@selector(eraseRtf0Action) forControlEvents:UIControlEventTouchUpInside];
    [v0 addSubview:_eraseBtn];
    [_eraseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(v0.mas_right).offset(-8);
        make.centerY.equalTo(rtf0);
        make.width.height.equalTo(@19);
        //            make.width.equalTo(@(MAINSCREEN_WIDTH));
    }];

    UIView* v1 = _sub_views[1];
    UITextField* rtf1 = _rightTfs[1];
    _eyeStatusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_eyeStatusBtn setImage:kIMG(@"icon_eyeclose") forState:UIControlStateNormal];
    [_eyeStatusBtn addTarget:self action:@selector(eyeRtf1Action:) forControlEvents:UIControlEventTouchUpInside];
    [v1 addSubview:_eyeStatusBtn];
    [_eyeStatusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(v1.mas_right).offset(-5);
        make.centerY.equalTo(rtf1);
        make.width.equalTo(@25);
        make.height.equalTo(@21);
    }];
    
    kWeakSelf(self);
    [self.view goBackButtonInSuperView:self.view leftButtonEvent:^(id data) {
        kStrongSelf(self);
        [self goBack];
    }];
    
    [self.view loginRightButtonInSuperView:self.view withTitle:@"去注册" rightButtonEvent:^(id data) {
        kStrongSelf(self);
        [self registerEvent];
    }];
    
    [self richElementsInViewWithModel];
    
}

-(void)eraseRtf0Action{
    UITextField* rtf0 = _rightTfs[0];
    rtf0.text = @"";
}

-(void)eyeRtf1Action:(UIButton*)sender{
    UITextField* rtf1 = _rightTfs[1];
    sender.selected = !sender.selected;
    if (sender.selected) {
        [_eyeStatusBtn setImage:kIMG(@"icon_eyeopen") forState:UIControlStateNormal];
        [_eyeStatusBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@25);
            make.height.equalTo(@14);
        }];
        rtf1.secureTextEntry = NO;
        
    }else{
        [_eyeStatusBtn setImage:kIMG(@"icon_eyeclose") forState:UIControlStateNormal];
        [_eyeStatusBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@25);
            make.height.equalTo(@21);
        }];
        rtf1.secureTextEntry = YES;
    }
}

- (void)richElementsInViewWithModel{
    _accLab.text = @"欢迎登录";
    _accLab.textAlignment = NSTextAlignmentCenter;
    _accLab.textColor = HEXCOLOR(0xffffff);
    _accLab.font = kFontSize(30);
    
    UILabel* lab0 = _leftLabs[0];
    lab0.text = @"请输入账号名";
    UILabel* lab1 = _leftLabs[1];
    lab1.text = @"请输入账号密码";
    
    UITextField* rtf0 = _rightTfs[0];
    rtf0.placeholder = @"请输入账号名";
    //    [self textViewDidBeginEditing:rtf0];
    
    UITextField* rtf1 = _rightTfs[1];
    rtf1.secureTextEntry = YES;
    rtf1.placeholder = @"请输入账号密码";
    
    [_forgetPWBtn setAttributedTitle:[NSString attributedStringWithString:@"忘记密码？" stringColor:HEXCOLOR(0x666666) stringFont:kFontSize(15) subString:@"点此找回" subStringColor:HEXCOLOR(0x4c7fff) subStringFont:kFontSize(15) subStringUnderlineColor:HEXCOLOR(0x4c7fff)] forState:UIControlStateNormal  ];
    
    [_onlineCustomerServiceBtn setAttributedTitle:[NSString attributedStringWithString:@"如有任何疑问，请联系" stringColor:HEXCOLOR(0x666666) stringFont:kFontSize(15) subString:@"在线客服" subStringColor:HEXCOLOR(0x4c7fff) subStringFont:kFontSize(15) ] forState:UIControlStateNormal];
}

- (void)clickItem:(UIButton*)sender{
    EnumActionTag type = sender.tag;
    
    self.tagger = sender.tag;
    
    switch (type) {
        case EnumActionTag0:
        {
            [NSObject cancelPreviousPerformRequestsWithTarget:self
                                                     selector:@selector(loginEventAction)
                                                       object:sender];
            
            [self performSelector:@selector(loginEventAction)
                       withObject:sender
                       afterDelay:-1];
            
            [self loginEvent];
        }
            break;
        case EnumActionTag1:
            [self findPWEvent];
            break;
        case EnumActionTag2:
            [self onlineCustomerServiceBtnClickEvent];
            break;
        default:
            break;
    }
}

-(void)onlineCustomerServiceBtnClickEvent{
    
    //网易云盾
    [self openWYVertifyCodeView];
}

- (void)findPWEvent{
     [FindPWVC pushFromVC:self
            requestParams:@(1)
                  success:^(id data) {
        
    }];
}

- (void)registerEvent{
//    [RegisterSuccessVC pushFromVC:self requestParams:nil success:^(id data) {//test
//        [self goBack];
//    }];
    kWeakSelf(self);
    [RegisterVC pushFromVC:self
             requestParams:@(1)
                   success:^(id data) {//0 绑定 1 跳过
        kStrongSelf(self);
        LoginModel* loginModel = data;
        [RegisterSuccessVC pushFromVC:self
                        requestParams:loginModel
                              success:^(id data) {
            [self goBack];

//            UIButton* btn = data;
//            if (btn.tag == EnumActionTag0) {
//                if (self.successBlock) {//成功页绑定 diss登入页
//                    self.successBlock(btn);
//                }
//            }
        }];
//        UIButton* btn = data;
//        if (btn.tag == EnumActionTag0) {
//            [self goBack];
//
//        }
    }];
}

#pragma mark -TextFieldDelegate
-(void)textField1TextChange:(UITextField *)textField{
    UITextField* rtf0 = _rightTfs[0];
    UITextField* rtf1 = _rightTfs[1];
    UIView* line0 = _lines[0];
    UIView* line1 = _lines[1];
    
    UILabel* tipLab0 = _tipLabs[0];
    UILabel* tipLab1 = _tipLabs[1];
    if (textField == rtf0) {
        
        line0.backgroundColor = HEXCOLOR(0xe8e9ed);
        tipLab0.text = @"";
        
    }else if (textField == rtf1){
        
        line1.backgroundColor = HEXCOLOR(0xe8e9ed);
        tipLab1.text = @"";
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    UITextField* rtf0 = _rightTfs[0];
    UITextField* rtf1 = _rightTfs[1];
    UIView* line0 = _lines[0];
    UIView* line1 = _lines[1];
    UILabel* tipLab0 = _tipLabs[0];
    UILabel* tipLab1 = _tipLabs[1];
    if (textField == rtf0) {
        if (rtf0.text.length<4) {
            line0.backgroundColor = [UIColor redColor];
            tipLab0.text = @"*您输入的字符过短，至少4位数哦";
            return;
        }
        if (rtf0.text.length>16) {
            line0.backgroundColor = [UIColor redColor];
            tipLab0.text =  @"*您输入的字符过长，最长不超过16位哦";
            return;
        }
        if (![NSString isContainAllCharType:rtf0.text]) {
            line0.backgroundColor = [UIColor redColor];
            tipLab0.text =  @"*请重新输入账号：必须要包含大写及小写字母与数字";
            return;
        }
        
    }else if (textField == rtf1){
        if (rtf1.text.length<8) {
            line1.backgroundColor = [UIColor redColor];
            tipLab1.text = @"*您输入的字符过短，至少8位数哦";
            return;
        }
        if (rtf1.text.length>16) {
            line1.backgroundColor = [UIColor redColor];
            tipLab1.text = @"*您输入的字符过长，最长不超过16位哦";
            return;
        }
        if (![NSString isContainAllCharType:rtf1.text]) {
            line1.backgroundColor = [UIColor redColor];
            tipLab1.text = @"*请重新输入密码：必须要包含大写及小写字母与数字";
            return;
        }
    }
}

#pragma mark -LoginAction
- (void)loginEventAction{
    
    UITextField* rtf0 = _rightTfs[0];
    UITextField* rtf1 = _rightTfs[1];
    
    if ([NSString isEmpty:rtf0.text]
        &&[NSString isEmpty:rtf1.text]) {
        [YKToastView showToastText:@"请填写账号和账号密码"];
        return;
    }
    else if (![NSString isEmpty:rtf0.text]
             &&[NSString isEmpty:rtf1.text]) {
        [YKToastView showToastText:@"请填写账号密码"];
        return;
    }
    else if ([NSString isEmpty:rtf0.text]
             &&![NSString isEmpty:rtf1.text]) {
        [YKToastView showToastText:@"请填写账号"];
        return;
    }
    if (rtf0.text.length<4) {
        [YKToastView showToastText:@"您输入的字符过短，至少4位数哦"];
        return;
    }
    if (rtf1.text.length<8) {
        [YKToastView showToastText:@"您输入的字符过短，至少8位数哦"];
        return;
    }
    if (rtf0.text.length>16||rtf1.text.length>16) {
        [YKToastView showToastText:@"您输入的字符过长，最长不超过16位哦"];
        return;
    }
    if (![NSString isContainAllCharType:rtf0.text]) {
        [YKToastView showToastText:@"请重新输入账号：必须要包含大写及小写字母与数字"];
        return;
    }
    if (![NSString isContainAllCharType:rtf1.text]) {
        [YKToastView showToastText:@"请重新输入密码：必须要包含大写及小写字母与数字"];
        return;
    }
    
//    InputCharType charType = [NSString getInputCharType:rtf0.text];
//    switch (charType) {
//        case InputCharOnlyNumber:
//        {
//            [YKToastView showToastText:@"请重新输入账号：必须要包含大写及小写字母"];
//            return;
//        }
//            break;
//        case InputCharOnlyUpperEnglish:
//        {
//            [YKToastView showToastText:@"请重新输入账号：必须要包含小写字母及数字"];
//            return;
//        }
//            break;
//        case InputCharOnlyLowerEnglish:
//        {
//            [YKToastView showToastText:@"请重新输入账号：必须要包含大写字母及数字"];
//            return;
//        }
//            break;
//        case InputCharLoseNumber:
//        {
//            [YKToastView showToastText:@"请重新输入账号：必须要包含数字"];
//            return;
//        }
//            break;
//        case InputCharLoseUpperEnglish:
//        {
//            [YKToastView showToastText:@"请重新输入账号：必须要包含大写字母"];
//            return;
//        }
//            break;
//        case InputCharLoseLowerEnglish:
//        {
//            [YKToastView showToastText:@"请重新输入账号：必须要包含小写字母"];
//            return;
//        }
//            break;
//        default:
//            break;
//    }
}

- (void)loginEvent{
    
    UITextField* rtf0 = _rightTfs[0];
    UITextField* rtf1 = _rightTfs[1];
    
    if ([NSString isEmpty:rtf0.text]
        &&[NSString isEmpty:rtf1.text]) {
        [YKToastView showToastText:@"请填写账号和账号密码"];
        return;
    }
    else if (![NSString isEmpty:rtf0.text]
             &&[NSString isEmpty:rtf1.text]) {
        [YKToastView showToastText:@"请填写账号密码"];
        return;
    }
    else if ([NSString isEmpty:rtf0.text]
             &&![NSString isEmpty:rtf1.text]) {
        [YKToastView showToastText:@"请填写账号"];
        return;
    }
    if (rtf0.text.length<4) {
        [YKToastView showToastText:@"您输入的字符过短，至少4位数哦"];
        return;
    }
    if (rtf1.text.length<8) {
        [YKToastView showToastText:@"您输入的字符过短，至少8位数哦"];
        return;
    }
    if (rtf0.text.length>16||rtf1.text.length>16) {
        [YKToastView showToastText:@"您输入的字符过长，最长不超过16位哦"];
        return;
    }
    if (![NSString isContainAllCharType:rtf0.text]) {
        [YKToastView showToastText:@"请重新输入账号：必须要包含大写及小写字母与数字"];
        return;
    }
    if (![NSString isContainAllCharType:rtf1.text]) {
        [YKToastView showToastText:@"请重新输入密码：必须要包含大写及小写字母与数字"];
        return;
    }
    
//    InputCharType charType = [NSString getInputCharType:rtf0.text];
//    switch (charType) {
//        case InputCharOnlyNumber:
//        {
//            [YKToastView showToastText:@"请重新输入账号：必须要包含大写及小写字母"];
//            return;
//        }
//            break;
//        case InputCharOnlyUpperEnglish:
//        {
//            [YKToastView showToastText:@"请重新输入账号：必须要包含小写字母及数字"];
//            return;
//        }
//            break;
//        case InputCharOnlyLowerEnglish:
//        {
//            [YKToastView showToastText:@"请重新输入账号：必须要包含大写字母及数字"];
//            return;
//        }
//            break;
//        case InputCharLoseNumber:
//        {
//            [YKToastView showToastText:@"请重新输入账号：必须要包含数字"];
//            return;
//        }
//            break;
//        case InputCharLoseUpperEnglish:
//        {
//            [YKToastView showToastText:@"请重新输入账号：必须要包含大写字母"];
//            return;
//        }
//            break;
//        case InputCharLoseLowerEnglish:
//        {
//            [YKToastView showToastText:@"请重新输入账号：必须要包含小写字母"];
//            return;
//        }
//        default:
//            break;
//    }
    
    [self openWYVertifyCodeView];
}

- (void)openWYVertifyCodeView{
    
    self.manager =  [[NTESVerifyCodeManager alloc]init];
    
    [self.view endEditing:YES];
    
    if (self.manager) {
        
        // 如果需要了解组件的执行情况,则实现回调
        self.manager.delegate = self;
        
        // 无感知验证码
        NSString *captchaid = WYVertifyID_Key;
        self.manager.mode = NTESVerifyCodeBind;
        //self.manager.mode = NTESVerifyCodeNormal;
        
        [self.manager configureVerifyCode:captchaid
                                  timeout:10.0];
        
        // 设置语言
        self.manager.lang = NTESVerifyCodeLangCN;
        
        // 设置透明度
        self.manager.alpha = 0.3;
        
        // 设置颜色
        self.manager.color = [UIColor blackColor];
        
        // 设置frame
        self.manager.frame = CGRectNull;

        // 显示验证码
        [self.manager openVerifyCodeView:nil];
    }
}

#pragma mark - NTESVerifyCodeManagerDelegate
/**
 * 验证码组件初始化完成
 */
- (void)verifyCodeInitFinish{
    NSLog(@"收到初始化完成的回调");
}

/**
 * 验证码组件初始化出错
 *
 * @param message 错误信息
 */
- (void)verifyCodeInitFailed:(NSString *)message{
    NSLog(@"收到初始化失败的回调:%@",message);
}

/**
 * 完成验证之后的回调
 *
 * @param result 验证结果 BOOL:YES/NO
 * @param validate 二次校验数据，如果验证结果为false，validate返回空
 * @param message 结果描述信息
 *
 */
- (void)verifyCodeValidateFinish:(BOOL)result
                        validate:(NSString *)validate
                         message:(NSString *)message{
    kWeakSelf(self);
    
    NSLog(@"收到验证结果的回调:(%d,%@,%@)", result, validate, message);
    
    if (result == YES) {

        EnumActionTag type = self.tagger;
        
        switch (type) {
            case EnumActionTag0:
                
                [self postLoginValidate:![NSString isEmpty:validate]?validate:@""];
                
                break;
            case EnumActionTag2:
            {
                [self.vm network_rongCloudTemporaryTokenWithRequestParams:![NSString isEmpty:validate]?validate:@""//融云的临时token
                                                                success:^(id data) {
                                                                    
                                                                    kStrongSelf(self);
                                                                    
                                                                    LoginModel *model = data;
                                                                 
                                                                    [RCDCustomerServiceViewController presentFromVC:self
                                                                                                      requestParams:model.rytoken
                                                                                                            success:^(id data) {
                                                                        
                                                                    }];
                                                                } 
                                                                 failed:^(id data) {
                                                                     
                                                                     NSLog(@"faile%@",data);
                                                                     
                                                                 }
                                                                  error:^(id data) {
                                                                      
                                                                      NSLog(@"%@",data);
                                                                      
                                                                  }];
                
//                vc.successBlock = block;
            }
                
            default:
                break;
        }
        
        
        
        
    }else{
        
        [YKToastView showToastText:message];
    }
}

/**
 * 关闭验证码窗口后的回调
 */
- (void)verifyCodeCloseWindow{
    //用户关闭验证后执行的方法
    NSLog(@"收到关闭验证码视图的回调");
}

/**
 * 网络错误
 *
 * @param error 网络错误信息
 */
- (void)verifyCodeNetError:(NSError *)error{
    //用户关闭验证后执行的方法
    NSLog(@"收到网络错误的回调:%@(%ld)", [error localizedDescription], (long)error.code);
}

-(void)postLoginValidate:(NSString *)validate{
    UITextField* rtf0 = _rightTfs[0];
    UITextField* rtf1 = _rightTfs[1];
    kWeakSelf(self);
    [self.vm network_getLoginWithRequestParams:@[rtf0.text,rtf1.text,validate]
                                       success:^(id model) {
                                           LoginModel* loginModel = model;
                                           kStrongSelf(self);
                                           //                                           if (self.block) {
                                           //                                               self.block(model);
                                           //                                           }
                                           if (self.successBlock) {
                                               
                                               if ([loginModel.userinfo.valigooglesecret boolValue]==YES&&
                                                   [loginModel.userinfo.safeverifyswitch boolValue]==YES) {
                                                   [VertifyVC pushFromVC:self requestParams:@"1" success:^(id data) {
                                                       
                                                       [weakself goBack];
                                                       SetUserBoolKeyWithObject(kIsLogin, YES);
                                                       SetUserDefaultKeyWithObject(kUserInfo, [loginModel mj_keyValues]);
                                                       UserDefaultSynchronize;
                                                   }];
                                               }
                                               else{
                                                   [weakself goBack];
                                                   SetUserBoolKeyWithObject(kIsLogin, YES);
                                                   SetUserDefaultKeyWithObject(kUserInfo, [loginModel mj_keyValues]);
                                                   UserDefaultSynchronize;
                                               }
                                               
                                               //befor block set userStatus
                                               self.successBlock(model);
                                           }
                                           
                                       }
                                        failed:^(id model){
                                        }
                                         error:^(id model){
                                         }];
}



- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}

- (LoginVM *)vm {
    if (!_vm) {
        _vm = [LoginVM new];
    }
    return _vm;
}
@end


