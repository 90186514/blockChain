//
//  CertificationView.m
//  OTC
//
//  Created by Terry.c on 2018/11/26.
//  Copyright © 2018 yang peng. All rights reserved.
//

#import "CertificationView.h"
#import "VicFaceAuthManager.h"
#import "LoginModel.h"
#import "IdentityAuthVM.h"
@interface CertificationView ()
@property (nonatomic, copy) DataBlock block;
@property (nonatomic, assign) BOOL isAddFront;

@property (nonatomic, assign) BOOL isAddBack;

@property (nonatomic, assign) BOOL isCommitFrontIdentity;

@property (nonatomic, assign) BOOL isCommitBackIdentity;

@property (nonatomic, copy) NSString *identityNumber;

@property (nonatomic, copy) NSString *identityName;

@property (nonatomic, strong) UITextField *usernameField;
@property (nonatomic, strong) UITextField *userIdField;
@property (nonatomic, strong) UIButton *optionBtn;
@property (nonatomic, strong) UIButton *confirmBtn;
//待上传照片数组
@property (nonatomic, copy) NSArray<UIImage *> *photos;
//待上传照片数组的下标
@property (nonatomic, assign) NSInteger uploadIndex;
@property (nonatomic, strong) IdentityAuthVM* vm;
@end
@implementation CertificationView {
    UIImageView *_leftImageView;
    UIImageView *_rightImageView;
    
    NSString *_aliLeftImageUrl;
    NSString *_aliRightImageUrl;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //        self.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = RGBCOLOR(242, 241, 246);
        [self setupView];
    }
    return self;
}

-(void)setupView {
    UIView *view1 = [UIView new];
    [self addSubview:view1];
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(kRealValue(73));
    }];
    view1.backgroundColor = HEXCOLOR(0x4C7FFF);
    
    UILabel *noticeLable = [UILabel new];
    [view1 addSubview:noticeLable];
    [noticeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view1).offset(kRealValue(26));
        make.right.equalTo(view1).offset(-kRealValue(26));
        make.top.equalTo(view1).offset(kRealValue(8));
    }];
    noticeLable.numberOfLines = 0;
    noticeLable.textColor = kWhiteColor;
    noticeLable.font = [UIFont systemFontOfSize:11];
    noticeLable.text = @"您正在进行实名认证，以下个人信息我们将会严格保密，仅作为认证凭证，请放心填写。";
    
    UIView *contentView = [UIView new];
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kRealValue(15));
        make.right.equalTo(self).offset(-kRealValue(15));
        make.top.equalTo(view1.mas_bottom).offset(-kRealValue(25));
        make.bottom.equalTo(self).offset(-kRealValue(100));
    }];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.shadowOpacity = .5f;
    contentView.layer.shadowColor = [UIColor grayColor].CGColor;
    contentView.layer.shadowRadius = 3;
    contentView.layer.shadowOffset= CGSizeMake(1, 1);
    contentView.layer.cornerRadius = 4.f;
    
    //真实姓名
    UILabel *lable1 = [UILabel new];
    [contentView addSubview:lable1];
    [lable1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(kRealValue(31));
        make.top.equalTo(contentView).offset(kRealValue(43));
        make.height.mas_equalTo(kRealValue(21));
    }];
    lable1.textColor = HEXCOLOR(0x232630);
    lable1.font = [UIFont systemFontOfSize:15];
    lable1.text = @"真实姓名";
    
    _usernameField = [UITextField new];
    [contentView addSubview:_usernameField];
    [_usernameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView).offset(-kRealValue(24));
        make.centerY.equalTo(lable1);
        make.height.mas_equalTo(kRealValue(21));
        make.width.mas_equalTo(kRealValue(200));
    }];
    _usernameField.placeholder = @"真实姓名";
    _usernameField.textColor = RGBCOLOR(37.0, 57.0, 77.0);
    _usernameField.font = [UIFont systemFontOfSize:15];
    _usernameField.textAlignment = NSTextAlignmentRight;
    
    UIView *divider1 = [UIView new];
    [contentView addSubview:divider1];
    [divider1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(kRealValue(25));
        make.right.equalTo(contentView).offset(-kRealValue(20));
        make.top.equalTo(self.usernameField.mas_bottom).offset(kRealValue(10));
        make.height.mas_equalTo(kRealValue(1));
    }];
    divider1.backgroundColor = HEXCOLOR(0xF0F1F3);
    
    //身份证号
    UILabel *lable2 = [UILabel new];
    [contentView addSubview:lable2];
    [lable2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(kRealValue(31));
        make.top.equalTo(divider1.mas_bottom).offset(kRealValue(14));
        make.height.mas_equalTo(kRealValue(21));
    }];
    lable2.font = [UIFont systemFontOfSize:15];
    lable2.textColor = HEXCOLOR(0x232630);
    lable2.text = @"身份证号";
    
    _userIdField = [UITextField new];
    [contentView addSubview:_userIdField];
    [_userIdField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView).offset(-kRealValue(24));
        make.centerY.equalTo(lable2);
        make.height.mas_equalTo(kRealValue(21));
        make.width.mas_equalTo(kRealValue(200));
    }];
    _userIdField.placeholder = @"身份证号";
    _userIdField.textColor = RGBCOLOR(37.0, 57.0, 77.0);
    _userIdField.font = [UIFont systemFontOfSize:15];
    _userIdField.textAlignment = NSTextAlignmentRight;
    
    UIView *divider2 = [UIView new];
    [contentView addSubview:divider2];
    [divider2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(kRealValue(25));
        make.right.equalTo(contentView).offset(-kRealValue(20));
        make.top.equalTo(self.userIdField.mas_bottom).offset(kRealValue(10));
        make.height.mas_equalTo(kRealValue(1));
    }];
    divider2.backgroundColor = HEXCOLOR(0xF0F1F3);
    
    //上传 身份证 正反面照片
    UILabel *lable3 = [UILabel new];
    [contentView addSubview:lable3];
    [lable3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(kRealValue(31));
        make.top.equalTo(divider2.mas_bottom).offset(kRealValue(22));
        make.height.mas_equalTo(kRealValue(21));
    }];
    
    lable3.text = @"上传 身份证 正反面照片：";
    lable3.font = [UIFont systemFontOfSize:15];
    lable3.textColor = HEXCOLOR(0x232630);
    UILabel *lable4 = [UILabel new];
    [contentView addSubview:lable4];
    [lable4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(kRealValue(31));
        make.top.equalTo(lable3.mas_bottom).offset(kRealValue(9));
        make.height.mas_equalTo(kRealValue(17));
    }];
    lable4.font = [UIFont systemFontOfSize:12];
    lable4.textColor = HEXCOLOR(0x777777);
    lable4.text = @"请保证照片清晰、且身份证边缘完整";
    
    //身份证照片
    UIView *view2 = [UIView new];
    [contentView addSubview:view2];
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(lable4.mas_bottom).offset(kRealValue(32));
        make.height.mas_equalTo(kRealValue(174));
    }];
    
    //左侧照片
    UIView *leftImageView = [UIView new];
    [view2 addSubview:leftImageView];
    [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view2).offset(kRealValue(30));
        make.top.equalTo(view2);
        make.width.mas_equalTo(kRealValue(100));
        make.height.mas_equalTo(kRealValue(75));
    }];
    leftImageView.layer.masksToBounds = YES;
    leftImageView.layer.cornerRadius = 4.f;
    leftImageView.layer.borderColor = HEXCOLOR(0xD8D8D8).CGColor;
    leftImageView.layer.borderWidth = 1.f;
    UITapGestureRecognizer*tapGesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(alertChooseImage:)];
    [leftImageView addGestureRecognizer:tapGesture1];
    tapGesture1.view.tag =1;
    
    
    UIImageView *leftAddView = [UIImageView new];
    [leftImageView addSubview:leftAddView];
    [leftAddView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kRealValue(25));
        make.top.equalTo(leftImageView).offset(kRealValue(15));
        make.centerX.equalTo(leftImageView);
    }];
    leftAddView.image = [UIImage imageNamed:@"icon_add"];
    
    UILabel *leftImageLable = [UILabel new];
    [leftImageView addSubview:leftImageLable];
    [leftImageLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(leftImageView);
        make.height.mas_equalTo(kRealValue(16));
        make.top.equalTo(leftAddView.mas_bottom).offset(kRealValue(3));
    }];
    leftImageLable.font = [UIFont systemFontOfSize:12];
    leftImageLable.textColor = HEXCOLOR(0xA5A8B3);
    leftImageLable.text = @"8M以内";
    
    _leftImageView = [UIImageView new];
    [leftImageView addSubview:_leftImageView];
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(leftImageView);
    }];
//    _leftImageView.image = IMAGE(@"tc_icon_bank");
    
    UILabel *leftNoticeable = [UILabel new];
    [view2 addSubview:leftNoticeable];
    [leftNoticeable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(leftImageView);
        make.height.mas_equalTo(kRealValue(16));
        make.top.equalTo(leftImageView.mas_bottom).offset(kRealValue(6));
    }];
    
    leftNoticeable.font = [UIFont systemFontOfSize:12];
    leftNoticeable.textColor = HEXCOLOR(0x666666);
    leftNoticeable.text = @"有人脸的那一面";
    
    UIButton *leftUploadBtn = [UIButton new];
    [view2 addSubview:leftUploadBtn];
    [leftUploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(leftImageView);
        make.height.mas_equalTo(kRealValue(25));
        make.top.equalTo(leftNoticeable.mas_bottom).offset(kRealValue(18));
        make.width.mas_equalTo(kRealValue(72));
    }];
    leftUploadBtn.backgroundColor = HEXCOLOR(0x4C7FFF);
    leftUploadBtn.layer.masksToBounds = YES;
    leftUploadBtn.layer.cornerRadius = 12.5f;
    [leftUploadBtn setTitle:@"上传" forState:UIControlStateNormal];
    leftUploadBtn.titleLabel.textColor = [UIColor whiteColor];
    leftUploadBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [leftUploadBtn addTarget:self action:@selector(onClickLeftUpload) forControlEvents:UIControlEventTouchUpInside];
    
    
    //右侧照片
    UIView *rightImageView = [UIView new];
    [view2 addSubview:rightImageView];
    [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftImageView.mas_right).offset(kRealValue(26));
        make.top.equalTo(view2);
        make.width.mas_equalTo(kRealValue(100));
        make.height.mas_equalTo(kRealValue(75));
    }];
    rightImageView.layer.masksToBounds = YES;
    rightImageView.layer.cornerRadius = 4.f;
    rightImageView.layer.borderColor = HEXCOLOR(0xD8D8D8).CGColor;
    rightImageView.layer.borderWidth = 1.f;
    UITapGestureRecognizer*tapGesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(alertChooseImage:)];
    [rightImageView addGestureRecognizer:tapGesture2];
    tapGesture2.view.tag =2;
    
    
    UIImageView *rightAddView = [UIImageView new];
    [rightImageView addSubview:rightAddView];
    [rightAddView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kRealValue(25));
        make.top.equalTo(rightImageView).offset(kRealValue(15));
        make.centerX.equalTo(rightImageView);
    }];
    rightAddView.image = [UIImage imageNamed:@"icon_add"];
    
    
    UILabel *rightImageLable = [UILabel new];
    [rightImageView addSubview:rightImageLable];
    [rightImageLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rightImageView);
        make.height.mas_equalTo(kRealValue(16));
        make.top.equalTo(rightAddView.mas_bottom).offset(kRealValue(3));
    }];
    rightImageLable.font = [UIFont systemFontOfSize:12];
    rightImageLable.textColor = HEXCOLOR(0xA5A8B3);
    rightImageLable.text = @"8M以内";
    
    _rightImageView = [UIImageView new];
    [rightImageView addSubview:_rightImageView];
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(rightImageView);
    }];
//    _rightImageView.image = IMAGE(@"tc_icon_bank");
    
    UILabel *rightNoticeable = [UILabel new];
    [view2 addSubview:rightNoticeable];
    [rightNoticeable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rightImageView);
        make.height.mas_equalTo(kRealValue(16));
        make.top.equalTo(rightImageView.mas_bottom).offset(kRealValue(6));
    }];
    
    rightNoticeable.font = [UIFont systemFontOfSize:12];
    rightNoticeable.textColor = HEXCOLOR(0x666666);
    rightNoticeable.text = @"有国徽的那一面";
    
    UIButton *rightUploadBtn = [UIButton new];
    [view2 addSubview:rightUploadBtn];
    [rightUploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rightImageView);
        make.height.mas_equalTo(kRealValue(25));
        make.top.equalTo(rightNoticeable.mas_bottom).offset(kRealValue(18));
        make.width.mas_equalTo(kRealValue(72));
    }];
    rightUploadBtn.backgroundColor = HEXCOLOR(0x4C7FFF);
    rightUploadBtn.layer.masksToBounds = YES;
    rightUploadBtn.layer.cornerRadius = 12.5f;
    [rightUploadBtn setTitle:@"上传" forState:UIControlStateNormal];
    rightUploadBtn.titleLabel.textColor = [UIColor whiteColor];
    rightUploadBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [rightUploadBtn addTarget:self action:@selector(onClickRightUpload) forControlEvents:UIControlEventTouchUpInside];
    
    
    //option
    _optionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [contentView addSubview:_optionBtn];
    [_optionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//       make.centerX.equalTo(contentView);
        make.bottom.equalTo(contentView).offset(-kRealValue(45));
        make.left.equalTo(contentView).offset(kRealValue(30));
        make.right.equalTo(contentView).offset(-kRealValue(30));
        make.height.mas_equalTo(kRealValue(16));
    }];
    _optionBtn.titleLabel.numberOfLines = 0;
    _optionBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [_optionBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [_optionBtn setTitle:@"本人确保以上信息真实有效，如有伪造、隐瞒行为，造成的后果本人愿意自行承担。" forState:UIControlStateNormal];
    [_optionBtn setImage:[UIImage imageNamed:@"user_auth_nomal"] forState:UIControlStateNormal];
    [_optionBtn addTarget:self action:@selector(onClickOptionBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_optionBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:8];
    
    [self bottomSingleButtonInSuperView:self WithButtionTitles:@"已确认，提交审核" leftButtonEvent:^(id data) {
        [self onClickConfirmBtn];
    }];
    
}


-(void)onClickLeftUpload {
    //需要上传 _aliLeftImageUrl 图片地址到我们服务端
    
}

-(void)onClickRightUpload {
    //需要上传 _aliRightImageUrl 图片地址到我们服务端
}

-(void)onClickOptionBtn:(UIButton*)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [_optionBtn setImage:[UIImage imageNamed:@"user_auth_checked"] forState:UIControlStateNormal];
    } else {
        [_optionBtn setImage:[UIImage imageNamed:@"user_auth_nomal"] forState:UIControlStateNormal];
    }
}

-(void)onClickConfirmBtn {
    NSString *name = _usernameField.text;
    NSString *cardId = _userIdField.text;
    
    if ([NSString isEmpty:name]) {
        [YKToastView showToastText:@"请输入姓名"];
        return;
    }
    if ([NSString isEmpty:cardId]) {
        [YKToastView showToastText:@"请输入身份证号码"];
        return;
    }
    
    
    
    if (!_optionBtn.selected) {
        [YKToastView showToastText:@"请确认信息真实有效"];
        
        return;
    }
    
    if(!self.isAddFront){
        [YKToastView showToastText:@"请上传您的身份证头像面"];
        return;
    }
    if(!self.isAddBack){
        [YKToastView showToastText:@"请上传您的身份证国徽面"];
        return;
    }
    
    if(!self.isCommitFrontIdentity){
        [YKToastView showToastText:@"请上传正确的身份证头像面"];
        return;
    }
    
    if(!self.isCommitBackIdentity){
        [YKToastView showToastText:@"请上传正确的身份证国徽面"];
        return;
    }
    
    if(![self.identityName isEqualToString:_usernameField.text]){
        [YKToastView showToastText:@"您上传的身份证头像照片与您的姓名不匹配"];
        return;
    }
    
    if(![[self.identityNumber lowercaseString] isEqualToString:[_userIdField.text lowercaseString]]){
        [YKToastView showToastText:@"您上传的身份证头像照片与您的身份证号不匹配"];
        return;
    }
    
    kWeakSelf(self);
    [self.vm postIdentityApplyWithPage:1 WithRequestParams:name certificateno:cardId idCardFont:_aliLeftImageUrl idCardReverse:_aliRightImageUrl success:^(id data) {
        kStrongSelf(self);
        if (self.block) {
            self.block(data);
        }
    } failed:^(id data) {
        
    } error:^(id data) {
        
    }];
}

-(void)actionBlock:(DataBlock)block{
    self.block = block;
}

-(void)setReviewStatu {
//    UserInfoModel *model = [UserManager defaultCenter].getUserInfo;
    
//    LoginModel* userInfoModel = [LoginModel mj_objectWithKeyValues:GetUserDefaultWithKey(kUserInfo)];
//    if (userInfoModel) {
//        _usernameField.userInteractionEnabled = NO;
//        _userIdField.userInteractionEnabled = NO;
//        _usernameField.text = userInfoModel.userinfo.realname;
//        _userIdField.text = userInfoModel.userinfo.userid;
//
//        _confirmBtn.userInteractionEnabled = NO;
//        [_confirmBtn setTitle:@"您的信息已提交，审核中…" forState:UIControlStateNormal];
//    }
}

-(void)alertChooseImage:(UITapGestureRecognizer*)tap {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        //        _selectedPhotos = [NSMutableArray arrayWithArray:photos];
        //        _selectedAssets = [NSMutableArray arrayWithArray:assets];
        //        _isSelectOriginalPhoto = isSelectOriginalPhoto;
        //        [_collectionView reloadData];
        //        _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
        if (photos && photos.count >0) {
            self.photos = photos;
            self.uploadIndex = 0;
            [self startUpload:tap.view.tag];
        }
    }];
    [self.currentViewController presentViewController:imagePickerVc animated:YES completion:nil];
    
    
}

- (UIViewController *)currentViewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

-(void)startUpload:(NSInteger)index {
    if(index == 2){
        self.isAddBack = YES;
    }
    if(index == 1){
        self.isAddFront = YES;
    }
    
    UIImage *needUploadImage = _photos[_uploadIndex];
    kWeakSelf(self);
    [SVProgressHUD showWithStatus:@"上传中..." maskType:SVProgressHUDMaskTypeBlack];
    
    [VicFaceAuthManager authIdentityCardWithImage:needUploadImage legality:YES successCompletion:^(id  _Nonnull data) {
        kStrongSelf(self);
        if([data isKindOfClass:[NSDictionary class]]){
            NSDictionary *dict = (NSDictionary *)data;
            if([[dict objectOrNilForKey:@"cards"] count] > 0){
                NSDictionary *cardDict = [[dict objectOrNilForKey:@"cards"] firstObject];
                NSDictionary *legalityDict = [cardDict objectOrNilForKey:@"legality"];
                
                NSDictionary *idcardParam = @{};
                
                if(self.uploadIndex == 0){
                    idcardParam = [idcardParam vic_appendKey:@"type" value:[cardDict objectOrNilForKey:@"type"]];
                    idcardParam = [idcardParam vic_appendKey:@"address" value:[cardDict objectOrNilForKey:@"address"]];
                    idcardParam = [idcardParam vic_appendKey:@"gender" value:[cardDict objectOrNilForKey:@"gender"]];
                    idcardParam = [idcardParam vic_appendKey:@"idCardNumber" value:[cardDict objectOrNilForKey:@"id_card_number"]];
                    idcardParam = [idcardParam vic_appendKey:@"name" value:[cardDict objectOrNilForKey:@"name"]];
                    idcardParam = [idcardParam vic_appendKey:@"race" value:[cardDict objectOrNilForKey:@"race"]];
                }else{
                    idcardParam = [idcardParam vic_appendKey:@"issuedBy" value:[cardDict objectOrNilForKey:@"issuedBy"]];
                    idcardParam = [idcardParam vic_appendKey:@"validDate" value:[cardDict objectOrNilForKey:@"validDate"]];
                }
                
                idcardParam = [idcardParam vic_appendKey:@"side" value:[cardDict objectOrNilForKey:@"side"]];
                idcardParam = [idcardParam vic_appendKey:@"idPhoto" value:[legalityDict objectOrNilForKey:@"ID Photo"]];
                idcardParam = [idcardParam vic_appendKey:@"temporaryIdPhoto" value:[legalityDict objectOrNilForKey:@"Temporary ID Photo"]];
                idcardParam = [idcardParam vic_appendKey:@"photoCopy" value:[legalityDict objectOrNilForKey:@"Photocopy"]];
                idcardParam = [idcardParam vic_appendKey:@"screen" value:[legalityDict objectOrNilForKey:@"Screen"]];
                idcardParam = [idcardParam vic_appendKey:@"edited" value:[legalityDict objectOrNilForKey:@"Edited"]];
                if([[cardDict objectOrNilForKey:@"side"] isEqualToString:@"front"]){
                    self.isCommitFrontIdentity = YES;
                    self.identityName = [cardDict objectOrNilForKey:@"name"];
                    self.identityNumber = [cardDict objectOrNilForKey:@"id_card_number"];
                }
                if([[cardDict objectOrNilForKey:@"side"] isEqualToString:@"back"]){
                    self.isCommitBackIdentity = YES;
                }
                
                [self.vm postIdentitySaveFacePlusResultWithRequestParams:idcardParam success:^(id data) {
                    
                } failed:^(id data) {
                    
                } error:^(id data) {
                    
                }];
                
                
                
            }
        }
    } errorCompletion:^(NSError * _Nonnull error) {
        
    }];
    
    
    
    
    [AliyunQuery uploadImageToAlyun:needUploadImage title:@"auth" completion:^(NSString *imgUrl) {
        kStrongSelf(self);
        [NSThread sleepForTimeInterval:1.0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            if (self && ![NSString isEmpty:imgUrl]) {
                [YKToastView showToastText:@"上传成功"];
                NSLog(@"UPLOAD SUCCESS index:%ld ----- %@", self.uploadIndex, imgUrl);
                [self dealWithUploadFile:imgUrl needUploadImage:needUploadImage index:index];
            } else {
                [YKToastView showToastText:@"上传失败,请稍后再试"];
            }
        });
        
    }];
}

-(void)dealWithUploadFile:(NSString*)imgUrl needUploadImage:(UIImage*)needUploadImage index:(NSInteger)index{
    switch (index) {
        case 1:
        {
            _aliLeftImageUrl = imgUrl;
            [_leftImageView setImageWithURL:[NSURL URLWithString:_aliLeftImageUrl]
                          placeholderImage:nil];
        }
            break;
        case 2:
        {
            _aliRightImageUrl = imgUrl;
            [_rightImageView setImageWithURL:[NSURL URLWithString:_aliRightImageUrl]
                              placeholderImage:nil];
        }
            break;
        default:
            break;
    }
}

- (IdentityAuthVM *)vm {
    if (!_vm) {
        _vm = [IdentityAuthVM new];
    }
    return _vm;
}
@end
