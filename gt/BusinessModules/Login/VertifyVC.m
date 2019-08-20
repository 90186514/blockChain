//
//  VertifyVC.m
//  gt
//
//  Created by GT on 2019/1/18.
//  Copyright © 2019 GT. All rights reserved.
//

#import "VertifyVC.h"
#import "LoginVM.h"
@interface VertifyVC ()
@property (nonatomic, strong) UIImageView *decorIv;
@property (nonatomic, strong) UILabel *accLab;
@property (nonatomic, strong) NSMutableArray* leftLabs;

@property (nonatomic, strong) NSMutableArray* rightTfs;
@property (nonatomic, strong) UIButton *postAdsButton;
@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, strong) id requestParams;
@property (nonatomic, copy) DataBlock successBlock;
@property (nonatomic, strong) LoginVM* vm;
@property (nonatomic, strong) UIButton *eyeStatusBtn;

@end

@implementation VertifyVC
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block
{
    VertifyVC *vc = [[VertifyVC alloc] init];
    vc.successBlock = block;
    vc.requestParams = requestParams;
    //    UINavigationController *reNavCon = [[UINavigationController alloc]initWithRootViewController:vc];
    //    [rootVC presentViewController:reNavCon animated:YES completion:nil];
    
    //    [[YBNaviagtionViewController rootNavigationController] pushViewController:vc animated:true];
    
    [rootVC presentViewController:vc animated:YES completion:^{
    }];
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    [self initView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
}

-(void)goBack{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
    
    UIButton *backItem = [UIButton  customButton:self actionMethod:@selector(goBack) Image:[UIImage imageNamed:@"icon_back_white"] Title:@"返回" TitleColor:kWhiteColor];
    [backItem layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:9];
    [self.view addSubview:backItem];
    backItem.frame = CGRectMake(25, 36, 100, 54);
    
    [self layoutAccountPublic];
}

-(void)layoutAccountPublic{
    _leftLabs = [NSMutableArray array];
    _rightTfs = [NSMutableArray array];
    
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.scrollEnabled = NO;
    scrollView.delegate = nil;
    scrollView.backgroundColor = kWhiteColor;
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.leading.equalTo(self.contentView).offset(30);
        //        make.trailing.equalTo(self.contentView).offset(-30);
        //        make.bottom.equalTo(self.contentView.mas_bottom).offset(-45);
        //        make.top.equalTo(self.contentView).offset(47);
        //        make.height.equalTo(@178);
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(200, 38, 155, 38));
    }];
    
    UIView *containView = [UIView new];
    containView.backgroundColor = kWhiteColor;
    [scrollView addSubview:containView];
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    
    UIView *lastView = nil;
    for (int i = 0; i < 1; i++) {
        UIView *sub_view = [UIView new];
        
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
        
        
        UITextView* tf = [[UITextView alloc] init];
        tf.tag = i;
        //        tf.delegate = self;
        //        tf.keyboardType = UIKeyboardTypeNumberPad;
        tf.textAlignment = NSTextAlignmentLeft;
        tf.backgroundColor = kClearColor;
        tf.textColor = [YBGeneralColor themeColor];
        tf.font = kFontSize(15);
        
        tf.zw_placeHolderColor = HEXCOLOR(0xb2b2b2);
        
        [sub_view addSubview:tf];
        [_rightTfs  addObject:tf];
        [tf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(sub_view).offset(-4);
            make.top.equalTo(sub_view).offset(43);
            make.bottom.equalTo(sub_view).offset(-6);
            make.width.equalTo(@(MAINSCREEN_WIDTH));
        }];
        
        UIImageView* line1 = [[UIImageView alloc]init];
        [sub_view addSubview:line1];
        line1.backgroundColor = HEXCOLOR(0xe8e9ed);
        
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(@0);
            make.top.equalTo(sub_view).offset(75);
            make.height.equalTo(@.5);
        }];
        
        _eyeStatusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_eyeStatusBtn setTitle:@"粘贴" forState:UIControlStateNormal];
        [_eyeStatusBtn addTarget:self action:@selector(eyeRtf1Action:) forControlEvents:UIControlEventTouchUpInside];
        _eyeStatusBtn.titleLabel.font = kFontSize(15);
        [_eyeStatusBtn setTitleColor:[YBGeneralColor themeColor] forState:UIControlStateNormal];
        [sub_view addSubview:_eyeStatusBtn];
        [_eyeStatusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(sub_view.mas_right).offset(-5);
            make.centerY.equalTo(tf);
            make.width.equalTo(@50);
            make.height.equalTo(@21);
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
    
    
    _postAdsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _postAdsButton.tag = EnumActionTag0;
    _postAdsButton.adjustsImageWhenHighlighted = NO;
    _postAdsButton.titleLabel.font = kFontSize(16);
    [_postAdsButton setTitle:@"确认登录" forState:UIControlStateNormal];
    [_postAdsButton setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    _postAdsButton.layer.masksToBounds = YES;
    _postAdsButton.layer.cornerRadius = 20;
    _postAdsButton.layer.borderWidth = 0;
    //        _postAdsButton.layer.borderColor = HEXCOLOR(0x9b9b9b).CGColor;
    
    [_postAdsButton setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0x4c7fff)] forState:UIControlStateNormal];
    _postAdsButton.userInteractionEnabled = YES;
    [_postAdsButton addTarget:self action:@selector(postAdsAndRuleButtonClickItem:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_postAdsButton];
    [_postAdsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
        make.top.equalTo(containView.mas_bottom).offset(155);//别用scrollView
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(@40);
        make.width.mas_equalTo(@225);
    }];
    
    
    
    
    [self richElementsInViewWithModel];
    
}

-(void)eyeRtf1Action:(UIButton*)sender{
    UITextView* rtf0 = _rightTfs[0];
    if (![NSString isEmpty:[[UIPasteboard generalPasteboard]string]]) {
        rtf0.text = [NSString stringWithFormat:@"%@",[[UIPasteboard generalPasteboard]string]];
    }
}

- (void)richElementsInViewWithModel{
    _accLab.text = @"二次验证";
    _accLab.textAlignment = NSTextAlignmentCenter;
    _accLab.textColor = HEXCOLOR(0xffffff);
    _accLab.font = kFontSize(30);
    
    UILabel* lab0 = _leftLabs[0];
    lab0.text = @"谷歌验证码";
    
    
    UITextView* rtf0 = _rightTfs[0];
    rtf0.placeholder = @"请输入谷歌验证码";
    
}
- (void)postAdsAndRuleButtonClickItem:(UIButton*)sender{
    UITextView* rtf0 = _rightTfs[0];
    
    
    if ([NSString isEmpty:rtf0.text]) {
        [YKToastView showToastText:@"请输入谷歌验证码"];
        return;
    }
    
    kWeakSelf(self);
    [self.vm network_getLoginVertifyWithRequestParams:@{rtf0.text:self.requestParams}
                       success:^(id model) {
                           kStrongSelf(self);
                           //                                           if (self.block) {
                           //                                               self.block(model);
                           //                                           }
                           if (self.successBlock) {
                               [weakself goBack];
                               //befor block set userStatus
                               self.successBlock(model);
                       }
                       }
                    failed:^(id model){
                    }
                     error:^(id model){
                     }];
    
    [rtf0 resignFirstResponder];
    
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
