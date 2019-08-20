//
//  AddAccountVC.m
//  gt
//
//  Created by cookie on 2018/12/21.
//  Copyright © 2018 GT. All rights reserved.
//

#import "NotYetVertifyVC.h"
#import "UpLoadImageHV.h"
#import "MyInputCell.h"

#import "LoginModel.h"
#import "LoginVM.h"

#import "AuthSuccessVC.h"

#import "ZXingObjC.h"
#import "AliyunQuery.h"
@interface NotYetVertifyVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) UIImageView *decorIv;
@property (nonatomic, strong) UILabel *accLab;

@property (nonatomic, copy)NSString * imageUrl;
@property (nonatomic, copy)NSString * imageCordString;
@property (nonatomic, strong) UpLoadImageHV* uploadImageHV;

@property (nonatomic , copy) NSArray *dataSource;
@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic, strong) LoginVM* vm;

@property (nonatomic, copy) NSString * text0;
@property (nonatomic, copy) NSString * text1;
@property (nonatomic, copy) NSString * text2;
@property (nonatomic, copy) NSString * text3;
@property (nonatomic, copy) NSString * text4;
@property (nonatomic, copy) NSString * text5;
@property (nonatomic, copy) NSString * text6;

@property (nonatomic, strong) id requestParams;
@property (nonatomic, copy) DataBlock block;
@end

@implementation NotYetVertifyVC
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block
{
    NotYetVertifyVC *vc = [[NotYetVertifyVC alloc] init];
    vc.block = block;
    vc.requestParams = requestParams;
    [rootVC presentViewController:vc animated:YES completion:^{
    }];
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    self.text0 = @"";
    self.text1 = @"";
    self.text2 = @"";
    self.text3 = @"";
    self.text4 = @"";
    self.text5 = @"";
    self.text6 = @"";
    
    self.imageUrl = @"";
    self.imageCordString = @"";
    
//    self.title = @"添加银行卡";
    self.dataSource = @[@{@"姓名":@"请输入您的姓名"},
                        @{@"身份证号码":@"请输入您的身份证号码"},
                        @{@"邮箱":@"请留下您的邮箱，用于接收密码找回结果"}
                        ];

    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view).offset(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset([YBSystemTool isIphoneX]? -[YBFrameTool tabBarHeight]:-48.5);
    }];
    
    [self initHeaderView];
    [self initFooterView];
    
    [self.view bottomSingleButtonInSuperView:self.view WithButtionTitles:@"下一步" leftButtonEvent:^(id data) {
        [self nextBtnClick];
    }];
    
}
-(void)goBack{
    //    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:false completion:^{
        
    }];
}
- (void)initHeaderView{
    UIImage* decorImage = kIMG(@"login_top");
    _decorIv = [[UIImageView alloc]init];
    _decorIv.userInteractionEnabled = YES;
    _decorIv.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, 200);
    _tableView.tableHeaderView = _decorIv;
    [_decorIv setContentMode:UIViewContentModeScaleAspectFill];
    
    _decorIv.clipsToBounds = YES;
    _decorIv.image = decorImage;
    
    _accLab = [[UILabel alloc]init];
    [_decorIv addSubview:_accLab];
    [_accLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.decorIv.mas_centerX);
        make.top.equalTo(self.decorIv).offset(73);
    }];
    _accLab.text = @"实名认证";
    _accLab.textAlignment = NSTextAlignmentCenter;
    _accLab.textColor = HEXCOLOR(0xffffff);
    _accLab.font = kFontSize(30);
    
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
    [self.decorIv addSubview:leftButton];
    leftButton.frame = CGRectMake(25, 36, 100, 54);
}

- (void)initFooterView {
    _uploadImageHV = [[UpLoadImageHV alloc]initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 218) WithNotYetVertifyModel:@1];
    _tableView.tableFooterView = _uploadImageHV;
    [_uploadImageHV actionBlock:^(id data) {
        UIButton* uploadImgBtn = data;
        
        [self pickImageWithCompletionHandler:^(NSData *imageData, UIImage *image) {
            [uploadImgBtn setImage:image forState:UIControlStateNormal];
            [SVProgressHUD showWithStatus:@"上传中..." maskType:SVProgressHUDMaskTypeBlack];
            kWeakSelf(self);
            [AliyunQuery uploadImageToAlyun:image title:@"IDcard" completion:^(NSString *imgUrl) {
                kStrongSelf(self);
                [NSThread sleepForTimeInterval:1.0];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    if (self && ![NSString isEmpty:imgUrl]) {
                        self.imageUrl = imgUrl;
                        CGImageRef imageRef = image.CGImage;
                        ZXCGImageLuminanceSource * source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:imageRef];
                        ZXBinaryBitmap * bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];
                        NSError * error = nil;
                        ZXDecodeHints * hints = [ZXDecodeHints hints];
                        ZXMultiFormatReader * reader = [ZXMultiFormatReader reader];
                        ZXResult * result = [reader decode:bitmap hints:hints error:&error];
                        if (result) {
                            self.imageCordString = result.text;
//                        NSLog(@".....imageCordString=%@",self.imageCordString);
//                            [uploadImgBtn setImage:image forState:UIControlStateNormal];
                        }else{
//                            [SVProgressHUD showErrorWithStatus:@"图片非正规二维码，请重新添加二维码"];
//                            [uploadImgBtn setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
                        }
                    }else{
                        [uploadImgBtn setImage:[UIImage imageNamed:@"handIdentity"] forState:UIControlStateNormal];
                        [SVProgressHUD showErrorWithStatus:@"二维码上传失败，请重新添加二维码"];
                    }
                });
            }];
        }];
    }];
}

-(void)nextBtnClick{
    if ([NSString isEmpty:self.text0]) {
        
        [YKToastView showToastText:@"请输入您的姓名"];
        return;
    }
    if ([NSString isEmpty:self.text1]) {
        
        [YKToastView showToastText:@"请输入您的身份证号码"];
        return;
    }
    if ([NSString isEmpty:self.text2]) {
        
        [YKToastView showToastText:@"请留下您的邮箱，用于接收密码找回结果"];
        return;
    }
    if ([NSString isEmpty:self.imageUrl]) {
        
        [YKToastView showToastText:@"请上传手持身份证照片"];
        return;
    }

    kWeakSelf(self);
    [self.vm network_identityVertifyWithRequestParams:self.text0
             idNumber:self.text1
              email:self.text2
              idPhoto:self.imageUrl
                 success:^(id data) {
                     kStrongSelf(self);
                     [AuthSuccessVC pushFromVC:self requestParams:@(2) success:^(id data) {
                         
                     }];
                     if (self.block) {
                         self.block(data);
                     }
                     
                 } failed:^(id data) {
                     
                 } error:^(id data) {
                     
                 }];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView YBGeneral_configuration];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.tableHeaderView = [UIView new];
//        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 5.1f;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 5.f;
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [MyInputCell cellHeightWithModel];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyInputCell *cell = [MyInputCell cellWith:tableView];
    NSDictionary* model = self.dataSource[indexPath.row];
    [cell richElementsInNotYetVertifyCellWithModel:model WithIndexRow:indexPath.row];
//    WS(weakSelf);
    [cell actionBlock:^(id data,id data2) {
        UITextField * textField = data;
        EnumActionTag tag = textField.tag;
            switch (tag) {
                case EnumActionTag0:
                    self.text0 = data2;
                    break;
                case EnumActionTag1:
                    self.text1 = data2;
                    break;
                case EnumActionTag2:
                    self.text2 = data2;
                    break;
                default:
                    break;
            }
    }];
    return cell;
}

- (LoginVM *)vm {
    if (!_vm) {
        _vm = [LoginVM new];
    }
    return _vm;
}
@end
