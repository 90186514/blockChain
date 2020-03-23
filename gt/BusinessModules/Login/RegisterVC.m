//
//  LoginVC.m
//  gtp
//
//  Created by GT on 2019/1/2.
//  Copyright © 2019 GT. All rights reserved.
//

#import "RegisterVC.h"
#import "LoginVM.h"

#import "RegisterSuccessVC.h"
#import <VerifyCode/NTESVerifyCodeManager.h>
@interface RegisterVC ()<NTESVerifyCodeManagerDelegate,UITextFieldDelegate>
@property (nonatomic, strong) NSMutableArray* tipLabs;
@property (nonatomic, strong) NSMutableArray* lines;
@property (nonatomic, strong) NSMutableArray*sub_views;
@property (nonatomic, strong) UIButton *eraseBtn;
@property (nonatomic, strong) UIButton *eyeStatusBtn;
@property (nonatomic, strong) UIButton *eyeStatusBtn2;

@property (nonatomic, strong) UIImageView *decorIv;
@property (nonatomic, strong) UILabel *accLab;
@property (nonatomic, strong) NSMutableArray* leftLabs;

@property (nonatomic, strong) NSMutableArray* rightTfs;
@property (nonatomic, strong) UIButton *forgetPWBtn;

@property (nonatomic, strong) UIButton *registerBtn;

@property (nonatomic, strong) UIButton *postAdsButton;
@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, strong) LoginVM* vm;
@property (nonatomic, strong)NTESVerifyCodeManager* manager;
@property (nonatomic, strong) id requestParams;
@property (nonatomic, copy) DataBlock successBlock;
@end

@implementation RegisterVC
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block
{
    RegisterVC *vc = [[RegisterVC alloc] init];
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
    scrollView.userInteractionEnabled = YES;
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.leading.equalTo(self.contentView).offset(30);
        //        make.trailing.equalTo(self.contentView).offset(-30);
        //        make.bottom.equalTo(self.contentView.mas_bottom).offset(-45);
        //        make.top.equalTo(self.contentView).offset(47);
        //        make.height.equalTo(@178);
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(150, 38, 185, 38));
    }];
    
    UIView *containView = [UIView new];
    containView.backgroundColor = kClearColor;
    [scrollView addSubview:containView];
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    
    UIView *lastView = nil;
    for (int i = 0; i < 3; i++) {
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
            make.top.equalTo(sub_view).offset(43);
            make.bottom.equalTo(sub_view).offset(-6);
            make.width.equalTo(@(MAINSCREEN_WIDTH));
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
                make.top.mas_equalTo(containView.mas_top).offset(22);//-15多出来scr
                
                
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
    
    
    _postAdsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _postAdsButton.tag = EnumActionTag0;
    _postAdsButton.adjustsImageWhenHighlighted = NO;
    _postAdsButton.titleLabel.font = kFontSize(16);
    [_postAdsButton setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    _postAdsButton.layer.masksToBounds = YES;
    _postAdsButton.layer.cornerRadius = 20;
    _postAdsButton.layer.borderWidth = 0;
    //        _postAdsButton.layer.borderColor = HEXCOLOR(0x9b9b9b).CGColor;
    
    [_postAdsButton setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0x4c7fff)] forState:UIControlStateNormal];
    
    [_postAdsButton addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_postAdsButton];
    [_postAdsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
        make.top.equalTo(containView.mas_bottom).offset(85);//别用scrollView
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(@40);
        make.width.mas_equalTo(@225);
    }];
    
    _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _registerBtn.tag = EnumActionTag1;
    _registerBtn.adjustsImageWhenHighlighted = NO;
    _registerBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    [_registerBtn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerBtn];
    [_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
        make.top.equalTo(self.postAdsButton.mas_bottom).offset(4);//别用scrollView
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
    
    UIView* v2 = _sub_views[2];
    UITextField* rtf2 = _rightTfs[2];
    _eyeStatusBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_eyeStatusBtn2 setImage:kIMG(@"icon_eyeclose") forState:UIControlStateNormal];
    [_eyeStatusBtn2 addTarget:self action:@selector(eyeRtf2Action:) forControlEvents:UIControlEventTouchUpInside];
    [v2 addSubview:_eyeStatusBtn2];
    [_eyeStatusBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(v2.mas_right).offset(-5);
        make.centerY.equalTo(rtf2);
        make.width.equalTo(@25);
        make.height.equalTo(@21);
    }];
    kWeakSelf(self);
    [self.view loginRightButtonInSuperView:self.view withTitle:@"去登录" rightButtonEvent:^(id data) {
        kStrongSelf(self);
        [self goBack];
    }];
    [self.view goBackButtonInSuperView:self.view leftButtonEvent:^(id data) {
        kStrongSelf(self);
        [self goBack];
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

-(void)eyeRtf2Action:(UIButton*)sender{
    UITextField* rtf2 = _rightTfs[2];
    sender.selected = !sender.selected;
    if (sender.selected) {
        [_eyeStatusBtn2 setImage:kIMG(@"icon_eyeopen") forState:UIControlStateNormal];
        [_eyeStatusBtn2 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@25);
            make.height.equalTo(@14);
        }];
        rtf2.secureTextEntry = NO;
        
    }else{
        [_eyeStatusBtn2 setImage:kIMG(@"icon_eyeclose") forState:UIControlStateNormal];
        [_eyeStatusBtn2 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@25);
            make.height.equalTo(@21);
        }];
        rtf2.secureTextEntry = YES;
    }
}

- (void)richElementsInViewWithModel{
    _accLab.text = @"欢迎注册";
    _accLab.textAlignment = NSTextAlignmentCenter;
    _accLab.textColor = HEXCOLOR(0xffffff);
    _accLab.font = kFontSize(30);
    
    UILabel* lab0 = _leftLabs[0];
    lab0.text = @"请设置账号名";
    UILabel* lab1 = _leftLabs[1];
    lab1.text = @"请设置账号密码";
    UILabel* lab2 = _leftLabs[2];
    lab2.text = @"请确认账号密码";
    
    UITextField* rtf0 = _rightTfs[0];
    rtf0.placeholder = @"必须包含数字、大小写英文，4-16位数";
    //    [self textViewDidBeginEditing:rtf0];
    
    UITextField* rtf1 = _rightTfs[1];
    rtf1.secureTextEntry = YES;
    rtf1.placeholder = @"必须包含数字、大小写英文，8-16位数";
    UITextField* rtf2 = _rightTfs[2];
    rtf2.secureTextEntry = YES;
    rtf2.placeholder = @"必须包含数字、大小写英文，8-16位数";
    
    
    [_postAdsButton setTitle:@"下一步" forState:UIControlStateNormal];
    
    [_registerBtn setAttributedTitle:[NSString attributedStringWithString:@"已有 BUB 账号" stringColor:HEXCOLOR(0x666666) stringFont:kFontSize(15) subString:@"去登录" subStringColor:HEXCOLOR(0x4c7fff) subStringFont:kFontSize(15) ] forState:UIControlStateNormal];
}

- (void)clickItem:(UIButton*)sender{
    EnumActionTag type = sender.tag;
    switch (type) {
        case EnumActionTag0:
        {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(registerEventAction) object:sender];
            [self performSelector:@selector(registerEventAction) withObject:sender afterDelay:-1];
            [self registerEvent];
        }
//            [self registerEvent];
            break;
        case EnumActionTag1:
            [self goBack];
            break;
            
        default:
            break;
    }
    
    
}
- (void)registerSuccessEvent:(id) model{
    LoginModel* loginModel = model;
    SetUserBoolKeyWithObject(kIsLogin, YES);
    SetUserDefaultKeyWithObject(kUserInfo, [loginModel mj_keyValues]);
    UserDefaultSynchronize;
    [self goBack];
    if (self.successBlock) {//成功页绑定 diss登入页
        self.successBlock(loginModel);
    }
//    [RegisterSuccessVC pushFromVC:self requestParams:model success:^(id data) {
//        
//        
//        UIButton* btn = data;
//        if (btn.tag == EnumActionTag0) {
//            if (self.successBlock) {//成功页绑定 diss登入页
//                self.successBlock(btn);
//            }
//        }
//    }];
}

#pragma mark -TextFieldDelegate
-(void)textField1TextChange:(UITextField *)textField{
    UITextField* rtf0 = _rightTfs[0];
    UITextField* rtf1 = _rightTfs[1];
    UITextField* rtf2 = _rightTfs[2];
    UIView* line0 = _lines[0];
    UIView* line1 = _lines[1];
    UIView* line2 = _lines[2];
    
    UILabel* tipLab0 = _tipLabs[0];
    UILabel* tipLab1 = _tipLabs[1];
    UILabel* tipLab2 = _tipLabs[2];
    if (textField == rtf0) {
        
        line0.backgroundColor = HEXCOLOR(0xe8e9ed);
        tipLab0.text = @"";
        
    }else if (textField == rtf1){
        
        line1.backgroundColor = HEXCOLOR(0xe8e9ed);
        tipLab1.text = @"";
    }else if (textField == rtf2){
        
        line2.backgroundColor = HEXCOLOR(0xe8e9ed);
        tipLab2.text = @"";
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    UITextField* rtf0 = _rightTfs[0];
    UITextField* rtf1 = _rightTfs[1];
    UITextField* rtf2 = _rightTfs[2];
    UIView* line0 = _lines[0];
    UIView* line1 = _lines[1];
    UIView* line2 = _lines[2];
    
    UILabel* tipLab0 = _tipLabs[0];
    UILabel* tipLab1 = _tipLabs[1];
    UILabel* tipLab2 = _tipLabs[2];
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
    }else if (textField == rtf2){
        if (rtf2.text.length<8) {
            line2.backgroundColor = [UIColor redColor];
            tipLab2.text = @"*您输入的字符过短，至少8位数哦";
            return;
        }
        if (rtf2.text.length>16) {
            line2.backgroundColor = [UIColor redColor];
            tipLab2.text = @"*您输入的字符过长，最长不超过16位哦";
            return;
        }
        if (![NSString isContainAllCharType:rtf2.text]) {
            line2.backgroundColor = [UIColor redColor];
            tipLab2.text = @"*请重新输入密码：必须要包含大写及小写字母与数字";
            return;
        }
    }
}
#pragma mark -LoginAction

- (void)registerEventAction{
    UITextView* rtf0 = _rightTfs[0];
    UITextView* rtf1 = _rightTfs[1];
    UITextView* rtf2 = _rightTfs[2];
    
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
    if (rtf2.text.length<8) {
        [YKToastView showToastText:@"您输入的字符过短，至少8位数哦"];
        return;
    }
    if (rtf0.text.length>16||rtf1.text.length>16||rtf2.text.length>16) {
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
    if (![NSString isContainAllCharType:rtf2.text]) {
        [YKToastView showToastText:@"请重新输入密码：必须要包含大写及小写字母与数字"];
        return;
    }
    else if (![NSString isEmpty:rtf1.text]
             &&![NSString isEmpty:rtf2.text]) {
        if (![rtf1.text isEqualToString:rtf2.text]) {
            [YKToastView showToastText:@"创建失败：两次输入的密码不一致，请重新输入"];
            return;
        }
        
    }
}

- (void)registerEvent{
    UITextView* rtf0 = _rightTfs[0];
    UITextView* rtf1 = _rightTfs[1];
    UITextView* rtf2 = _rightTfs[2];
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
    if (rtf2.text.length<8) {
        [YKToastView showToastText:@"您输入的字符过短，至少8位数哦"];
        return;
    }
    if (rtf0.text.length>16||rtf1.text.length>16||rtf2.text.length>16) {
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
    if (![NSString isContainAllCharType:rtf2.text]) {
        [YKToastView showToastText:@"请重新输入密码：必须要包含大写及小写字母与数字"];
        return;
    }
    else if (![NSString isEmpty:rtf1.text]
             &&![NSString isEmpty:rtf2.text]) {
        if (![rtf1.text isEqualToString:rtf2.text]) {
            [YKToastView showToastText:@"创建失败：两次输入的密码不一致，请重新输入"];
            return;
        }
        
    }
    [self openWYVertifyCodeView];
}

- (void)openWYVertifyCodeView{
    
    self.manager =  [[NTESVerifyCodeManager alloc ]init];
    
    [self.view endEditing:YES];
    
    if (self.manager) {
        
        // 如果需要了解组件的执行情况,则实现回调
        self.manager.delegate = self;

        // 无感知验证码
        NSString *captchaid = WYVertifyID_Key;
        self.manager.mode = NTESVerifyCodeBind;
        //self.manager.mode = NTESVerifyCodeNormal;
        
        [self.manager configureVerifyCode:captchaid timeout:10.0];
        
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
- (void)verifyCodeValidateFinish:(BOOL)result validate:(NSString *)validate message:(NSString *)message{
    NSLog(@"收到验证结果的回调:(%d,%@,%@)", result, validate, message);
    if (result ==YES) {
        [self postRegisterValidate:![NSString isEmpty:validate]?validate:@""];
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

-(void)postRegisterValidate:(NSString *)validate{
    //test
    //    [self registerSuccessEvent:nil];
    //    return;
    UITextView* rtf0 = _rightTfs[0];
    UITextView* rtf1 = _rightTfs[1];
    UITextView* rtf2 = _rightTfs[2];
    kWeakSelf(self);
    [self.vm network_getRegisterWithRequestParams:@[rtf0.text,rtf1.text,rtf2.text,validate]
                                          success:^(id model) {
                                              //        kStrongSelf(self);
                                              //        if (self.block) {
                                              //            self.block(model);
                                              //        }
                                              
                                              //        if (self.successBlock) {//注册成功去成功页
                                              //            self.successBlock(model);
                                              //        }
                                              
                                              [weakself registerSuccessEvent:model];
                                          }
                                           failed:^(id model){
                                               //        kStrongSelf(self);
                                               //        if (self.block) {
                                               //            self.block(model);
                                               //        }
                                           }
                                            error:^(id model){
                                                //        kStrongSelf(self);
                                                //        NSError* m = model;
                                                //        if (self.block) {
                                                //            self.block(m.description);
                                                //        }
                                            }];
    
    //    [self disMissView];
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


