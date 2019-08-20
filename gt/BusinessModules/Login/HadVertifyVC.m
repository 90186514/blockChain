//
//  LoginVC.m
//  gtp
//
//  Created by GT on 2019/1/2.
//  Copyright © 2019 GT. All rights reserved.
//

#import "HadVertifyVC.h"
#import "LoginVM.h"
//#import "RegisterVC.h"
@interface HadVertifyVC ()
@property (nonatomic, strong) UIImageView *decorIv;
@property (nonatomic, strong) UILabel *accLab;
@property (nonatomic, strong) NSMutableArray* leftLabs;

@property (nonatomic, strong) NSMutableArray* rightIvs;
@property (nonatomic, strong) UIButton *forgetPWBtn;

@property (nonatomic, strong) UIButton *registerBtn;

@property (nonatomic, strong) UIButton *postAdsButton;
@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, strong) LoginVM* vm;

@property (nonatomic, strong) id requestParams;
@property (nonatomic, copy) DataBlock successBlock;
@end

@implementation HadVertifyVC
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block
{
    HadVertifyVC *vc = [[HadVertifyVC alloc] init];
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
    _rightIvs = [NSMutableArray array];
    
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
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(200, 38, 255, 38));
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
        
        UIButton* leftBtn = [[UIButton alloc]init];
        leftBtn.tag = i;
        leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [leftBtn setTitleColor:HEXCOLOR(0x232630) forState:UIControlStateNormal];
        leftBtn.titleLabel.font = kFontSize(17);
        [leftBtn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
        [sub_view addSubview:leftBtn];
        [_leftLabs addObject:leftBtn];
        

        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(sub_view).offset(0);
//            make.top.equalTo(sub_view).offset(19);
//            make.bottom.equalTo(sub_view).offset(-4);
            make.centerY.equalTo(sub_view);
            make.width.equalTo(sub_view);
        }];
        
        
        UIImageView* arrowIv = [[UIImageView alloc] init];
        arrowIv.image = [UIImage imageNamed:@"btnRight"];
        arrowIv.tag = i;
        [sub_view addSubview:arrowIv];
        [_rightIvs  addObject:arrowIv];
        [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(sub_view).offset(0);
            make.centerY.equalTo(sub_view);
            make.width.height.equalTo(@(18));
        }];
        
        UIImageView* line1 = [[UIImageView alloc]init];
        [sub_view addSubview:line1];
        line1.backgroundColor = HEXCOLOR(0xe8e9ed);
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(@0);
            make.bottom.equalTo(sub_view.mas_bottom).offset(-2);
            make.height.equalTo(@.5);
        }];
        
        [containView addSubview:sub_view];
        
        //        sub_view.layer.cornerRadius = 4;
        //        sub_view.layer.borderWidth = 1;
        //        sub_view.layer.masksToBounds = YES;
        
        [sub_view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.and.right.equalTo(containView);
            
            make.height.mas_equalTo(@(50));//*i
            
            if (lastView)
            {
                make.top.mas_equalTo(lastView.mas_bottom).offset(6);//下个顶对上个底的间距=上个顶对整个视图顶的间距
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
    
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [leftButton setImage:[UIImage imageNamed:@"icon_back_white"] forState:UIControlStateNormal];
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    leftButton.adjustsImageWhenHighlighted = YES;
    leftButton.titleLabel.font  = kFontSize(17);
    [leftButton setTitleColor:kWhiteColor forState:UIControlStateNormal] ;
    leftButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
 leftButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [leftButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [leftButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:9];
    [self.view addSubview:leftButton];
    leftButton.frame = CGRectMake(25, 36, 100, 54);
    
    [self richElementsInViewWithModel];
    
}
- (void)richElementsInViewWithModel{
    _accLab.text = @"密码找回";
    _accLab.textAlignment = NSTextAlignmentCenter;
    _accLab.textColor = HEXCOLOR(0xffffff);
    _accLab.font = kFontSize(30);
    
    UIButton* lab0 = _leftLabs[0];
    [lab0 setTitle:@"在线客服" forState:UIControlStateNormal];
    UIButton* lab1 = _leftLabs[1];
    [lab1 setTitle:@"其他联系方式" forState:UIControlStateNormal];
}

- (void)clickItem:(UIButton*)sender{
    EnumActionTag type = sender.tag;
    switch (type) {
        case EnumActionTag0:
            [self onlineServiceEvent];
            break;
        case EnumActionTag1:
            [self otherContactsEvent];
            break;
        default:
            break;
    }
    
}
- (void)onlineServiceEvent{
    
}
- (void)otherContactsEvent{
    
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


