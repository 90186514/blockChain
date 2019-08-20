//
//  PostAdsVC.m
//  gt
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "PostAppealVC.h"
#import "PostAppealView.h"
#import "PostAppealVM.h"
#import "OrderDetailModel.h"
#import "PostAppealPhotoCell.h"
#import "MWPhoto.h"
#import "PhotoDeleteTipPopUpView.h"
#import "AliyunQuery.h"
#import "LoginVM.h"
#import "AboutUsModel.h"

@interface PostAppealVC () <PostAppealViewDelegate,MWPhotoBrowserDelegate>{
    
}
@property (nonatomic, strong) MWPhotoBrowser *potoBrowesr;
@property (nonatomic, strong) PostAppealView *mainView;
@property (nonatomic, strong) PostAppealVM *postAppealVM;
@property (nonatomic, strong) OrderDetailModel *orderDetailModel;
@property (nonatomic, strong) id requestParams;
@property (nonatomic, copy) DataBlock block;
@property (nonatomic, strong)NSMutableArray *dataMutArr;
@property (nonatomic, assign)OrderType orderType;
@property (nonatomic, strong) UIButton *chooseImageButton;
@property (nonatomic, strong) AboutUsModel* customerServiceModel;

@end

@implementation PostAppealVC

#pragma mark - life cycle
+ (instancetype)pushViewController:(UIViewController *)rootVC
                     requestParams:(id)requestParams
                         orderType:(OrderType)orderType
                           success:(DataBlock)block{
    
    PostAppealVC *vc = [[PostAppealVC alloc] init];
    
    vc.block = block;
    
    vc.orderType = orderType;
    
    vc.requestParams = requestParams;
    
    [rootVC.navigationController pushViewController:vc
                                           animated:YES];
    return vc;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self YBGeneral_baseConfig];
    
    self.title = @"提交申诉";
    
    [self initView];
    [self getcustomerServiceModelData];
}

-(void)getcustomerServiceModelData{
    
    LoginVM *vm = [[LoginVM alloc] init];
    [vm network_helpCentreWithRequestParams:@1 success:^(id data) {
        self.customerServiceModel = data;

    } failed:^(id data) {
        
    } error:^(id data) {
        
    }];
    [SVProgressHUD dismiss];
    
}


- (void)initView {
    
    [self.view addSubview:self.mainView];
    
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
    [self postAppealView:self.mainView requestListWithPage:1];
    kWeakSelf(self);

    [self.mainView actionBlock:^(id data, id data2) {
        
        kStrongSelf(self);
        
        EnumActionTag btnType  = [data integerValue];
        
        switch (btnType) {
            case EnumActionTag0:{
                
                [self.navigationController popViewControllerAnimated:YES];
            }
                break;
            case EnumActionTag1:{
                
                NSArray *dataAr =  (NSArray*)data2;
                NSMutableArray *dataMutableAr = [NSMutableArray arrayWithArray:dataAr];
                [dataMutableAr addObject:(NSString*)self.requestParams];
                
                UIImage *im = [self.chooseImageButton imageForState:UIControlStateNormal];
                if (im  == kIMG(@"icon_add")) {
                    [self submitAppeal:dataMutableAr];
                }else{
                    [self upDataAliyun:im andData:dataMutableAr];
                }
                
            }
                break;
            case EnumActionTag2:{
                UIButton *button = (UIButton*)data2;
                [self photo:button];
            }
                break;
            case EnumActionTag3:{
                if (self.customerServiceModel !=nil) {
                    NSString *sessionId = [NSString stringWithFormat:@"%@",self.customerServiceModel.rongCloudId];
                    NSString *title = [NSString stringWithFormat:@"%@",self.customerServiceModel.rongCloudName];
                    [RongCloudManager updateNickName:title userId:sessionId];
                    [RongCloudManager jumpNewSessionWithSessionId:sessionId title:title navigationVC:self.navigationController];
                }else{
                     [SVProgressHUD showWithStatus:@"获取客服信息失败" maskType:SVProgressHUDMaskTypeBlack];
                }
            }
                break;
            default:
                
                break;
        }
    }];
}

-(void)upDataAliyun:(UIImage*)im andData:(id)data{
    [SVProgressHUD showWithStatus:@"图片上传中..." maskType:SVProgressHUDMaskTypeBlack];
    [AliyunQuery uploadImageToAlyun:im title:@"appeal" completion:^(NSString *imgUrl) {
        [NSThread sleepForTimeInterval:1.0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            if (self && ![NSString isEmpty:imgUrl]) {
//                 NSLog(@"UPLOAD SUCCESS index:%ld ----- %@", self.uploadIndex, imgUrl);
                NSArray *dataAr =  (NSArray*)data;
                NSMutableArray *ar = [NSMutableArray arrayWithArray:dataAr];
                [ar addObject:imgUrl];
                [self submitAppeal:ar];
                [SVProgressHUD dismiss];
                
//
//                [self dealWithUploadFile:imgUrl needUploadImage:needUploadImage index:index];
            } else {
                [SVProgressHUD showErrorWithStatus:@"上传凭证图片失败,请稍后再试"];
            }
        });
    }];
}



- (void)submitAppeal:(id)data{

    [self.postAppealVM network_submitAppealWithRequestParams:data
                                                     success:^(id data) {
                    [self.navigationController popViewControllerAnimated:YES];
                                           } failed:^(id data) { } error:^(id data) {}];
}

-(void)photo:(UIButton*)button{
    
    
    self.chooseImageButton = button;
    UIImage *im = [button imageForState:UIControlStateNormal];
    if (im  == kIMG(@"icon_add")) {
        // 没有图片
        [self pickImageWithCompletionHandler:^(NSData *imageData, UIImage *image) {
            [button setImage:image forState:UIControlStateNormal ];
            
        }];
        
    }else{
        
        NSArray *potoAr = @[[MWPhoto photoWithImage:im]];
        self.potoBrowesr = [[MWPhotoBrowser alloc] initWithPhotos:potoAr];
        self.potoBrowesr.displayActionButton = NO;
        self.potoBrowesr.title = @"提交申诉";
        [self.navigationController pushViewController:self.potoBrowesr animated:YES];
        
        UIButton *detele = [[UIButton alloc]init];
        [detele setImage:[UIImage imageNamed:@"iconClosed"] forState:UIControlStateNormal];
        [self.potoBrowesr.view addSubview:detele];
        [detele mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.equalTo(self.potoBrowesr.view.mas_bottom).offset(-26);
        }];
        [detele addTarget:self
                          action:@selector(deteleClickItem)
                forControlEvents:UIControlEventTouchUpInside];
        [self performSelector:@selector(toChengColer) withObject:nil afterDelay:0.5];
    }
}


-(void)toChengColer{
    if (self.potoBrowesr) {
        self.potoBrowesr.title = @"提交申诉";
    self.potoBrowesr.navigationController.navigationBar.barTintColor = kWhiteColor;
    }
}


-(void)deteleClickItem{
    
    PhotoDeleteTipPopUpView* popupView = [[PhotoDeleteTipPopUpView alloc]init];
    [popupView showInApplicationKeyWindow];
    [popupView richElementsInViewWithModel:@"确定删除该照片?"];
    [popupView actionBlock:^(id data) {
        [self.navigationController popViewControllerAnimated:YES];
        [self.chooseImageButton setImage:kIMG(@"icon_add") forState:UIControlStateNormal];
    }];
}

#pragma mark - HomeViewDelegate

- (void)postAppealView:(PostAppealView *)view requestListWithPage:(NSInteger)page {

    
    kWeakSelf(self);
    
    [self.postAppealVM network_getPostAppealListWithPage:page
                                       WithRequestParams:self.requestParams
                                               orderType:self.orderType
                                                 success:^(NSArray * _Nonnull dataArray) {
                                                     kStrongSelf(self);
                                                     
                                                     [self.mainView requestListSuccessWithArray:dataArray];
                                                 } failed:^{
                                                     kStrongSelf(self);
                                                     
                                                     [self.mainView requestListFailed];
                                                 }];
}

#pragma mark - lazyLoad

- (PostAppealView *)mainView {
    
    if (!_mainView) {
        
        _mainView = [[PostAppealView alloc]initWithFrame:CGRectZero
                                           requestParams:self.requestParams];
        
        _mainView.delegate = self;
    }
    
    return _mainView;
}

- (PostAppealVM *)postAppealVM {
    
    if (!_postAppealVM) {
        
        _postAppealVM = [PostAppealVM new];
    }
    return _postAppealVM;
}

-(NSMutableArray *)dataMutArr{
    
    if (!_dataMutArr) {
        
        _dataMutArr = NSMutableArray.array;
    }
    
    return _dataMutArr;
}

@end
