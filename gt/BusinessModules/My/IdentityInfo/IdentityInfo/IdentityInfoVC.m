
#import "IdentityInfoVC.h"
#import "CertificationView.h"
#import "CerSuccessView.h"
#import "LoginModel.h"
#import "IdentityAuthModel.h"
@interface IdentityInfoVC ()
@property (nonatomic, strong) LoginModel* requestParams;
@property (nonatomic, strong) CerSuccessView *successView;
@property (nonatomic, strong) CertificationView *certificationView;
@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, copy) DataBlock block;
@end

@implementation IdentityInfoVC
#pragma mark - life cycle
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block{
    IdentityInfoVC *vc = [[IdentityInfoVC alloc] init];
    vc.block = block;
    
    vc.requestParams = [LoginModel mj_objectWithKeyValues:GetUserDefaultWithKey(kUserInfo)];//requestParams;
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"认证信息";
//    [self createScrollview];
    [self initViews];
}

-(void)initViews {
    [self.view addSubview:self.certificationView];
    [self.certificationView actionBlock:^(id data) {
        
    IdentityAuthModel *model = data;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"您的信息已提交，审核中...\n\n如有任何疑问请联系客服：%@",model.contact] message:nil preferredStyle:  UIAlertControllerStyleAlert];
        
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
        if (self.block) {
            self.block(data);
        }
    }]];
        
    [self presentViewController:alert animated:true completion:nil];
        
    }];
    [self.certificationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
//        make.left.right.bottom.equalTo(self.view);
    }];
    
    return;
//    0-未审核，1-待审核，2-审核未通过，3-审核通过
    if ([@"3" isEqualToString:_requestParams.userinfo.valiidnumber]) {
        //已通过审核
        self.certificationView.hidden = YES;
        self.scrollview.hidden = NO;
    } else if ([@"2" isEqualToString:_requestParams.userinfo.valiidnumber] || [@"0" isEqualToString:_requestParams.userinfo.valiidnumber]) {
        //未认证
        self.certificationView.hidden = NO;
        self.scrollview.hidden = YES;
    } else if ([@"1" isEqualToString:_requestParams.userinfo.valiidnumber]) {
        //审核中
        self.certificationView.hidden = NO;
        self.scrollview.hidden = YES;
        [self.certificationView setReviewStatu];
    }
}


-(void)createScrollview{
    
    self.successView = [[CerSuccessView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT)];
    self.successView.nickNameLab.text = _requestParams.userinfo.username;
    self.scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT)];
    self.scrollview.showsHorizontalScrollIndicator = NO;//不显示水平拖地的条
    self.scrollview.bounces = NO;//到边了就不能再拖地
    self.scrollview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollview];
    
    [self.scrollview addSubview:self.successView];
    self.scrollview.contentSize = CGSizeMake(MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT);
    
    [self.view bottomSingleButtonInSuperView:self.view WithButtionTitles:@"我要申请认证黑金用户" leftButtonEvent:^(id data) {
        [self onClickApplyBtn];
    }];
}
-(void)onClickApplyBtn {
    
}

-(CertificationView*)certificationView {
    if (!_certificationView) {
        _certificationView = [[CertificationView alloc] init];
    }
    return _certificationView;
}

@end

