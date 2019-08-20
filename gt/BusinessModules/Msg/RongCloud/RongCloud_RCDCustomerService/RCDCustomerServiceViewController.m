//
//  RCDCustomerServiceViewController.m
//  RCloudMessage
//
//  Created by litao on 16/2/23.
//  Copyright © 2016年 RongCloud. All rights reserved.
//

#import "RCDCustomerServiceViewController.h"
#import "RCDCSAnnounceView.h"
#import "RCDCSEvaluateView.h"
#import "RCDCSEvaluateModel.h"
#import "RCDCommonDefine.h"
#import "OrderDetailModel.h"

@interface RCDCustomerServiceViewController ()<RCDCSEvaluateViewDelegate,RCChatSessionInputBarControlDelegate>
//＊＊＊＊＊＊＊＊＊应用自定义评价界面开始1＊＊＊＊＊＊＊＊＊＊＊＊＊
@property (nonatomic, strong)NSString *commentId;
@property (nonatomic)RCCustomerServiceStatus serviceStatus;
@property (nonatomic)BOOL quitAfterComment;
//＊＊＊＊＊＊＊＊＊应用自定义评价界面结束1＊＊＊＊＊＊＊＊＊＊＊＊＊

@property (nonatomic,copy) NSString *announceClickUrl;

@property (nonatomic,strong) RCDCSEvaluateView *evaluateView;
//key为星级；value为RCDCSEvaluateModel对象
@property (nonatomic,strong)NSMutableDictionary *evaStarDic;
@property (nonatomic,strong) RCDCSAnnounceView *announceView;

@property (nonatomic, copy) DataBlock successBlock;

@property (nonatomic, strong) UIImageView *decorIv;
@property (nonatomic, strong) UILabel *accLab;
@property (nonatomic, strong)OrderDetailModel *orderDetailModel;


@end

@implementation RCDCustomerServiceViewController

+ (instancetype)presentFromVC:(UIViewController *)rootVC
             requestParams:(id)requestParams
                   success:(DataBlock)block{

    //登陆 Token userId
    RCDCustomerServiceViewController *chatService;

    if (!chatService) {

        chatService = [[RCDCustomerServiceViewController alloc] init];
        
        [[RCIM sharedRCIM] initWithAppKey:RongCloud_Key];
        
        [[RCIM sharedRCIM] connectWithToken:requestParams
                                    success:nil
                                      error:nil
                             tokenIncorrect:nil];
        
        //测试的token会在官网的我的应用->api调试 然后往下翻，在页面底部 里面有，创建一个就好了，上线了之后使用生产环境。
        [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
        [[RCIM sharedRCIM] setReceiveMessageDelegate:self];
        
        chatService.successBlock = block;
        chatService.requestParams = requestParams;
        chatService.userName = RCDLocalizedString(@"客服");
        chatService.conversationType = ConversationType_CUSTOMERSERVICE;
        chatService.targetId = SERVICE_ID;
        chatService.title = chatService.userName;
        
        [rootVC presentViewController:chatService
                             animated:YES
                           completion:^{
        }];
    }

    return chatService;
}

-(void)dealloc{
    
    NSLog(@"Running %@ '%@' %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

- (void)viewDidLoad {
  [super viewDidLoad];
    
  self.chatSessionInputBarControl.delegate = self;
  
  self.evaStarDic = [NSMutableDictionary dictionary];
  
  [[RCIMClient sharedRCIMClient] getHumanEvaluateCustomerServiceConfig:^(NSDictionary *evaConfig) {
    NSArray *array = [evaConfig valueForKey:@"evaConfig"];
      dispatch_async(dispatch_get_main_queue(), ^{
          if (array) {
              for (NSDictionary *dic in array) {
                  RCDCSEvaluateModel *model = [RCDCSEvaluateModel modelWithDictionary:dic];
                  [self.evaStarDic setObject:model forKey:[NSString stringWithFormat:@"%d",model.score]];
              }
          }
      });
  }];
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self createNavLeftBarButtonItem];
    self.navigationItem.rightBarButtonItems = nil;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGRect collectionViewFrame = self.conversationMessageCollectionView.frame;
    CGRect frame = CGRectMake(0, collectionViewFrame.origin.y, self.view.frame.size.width, 44);
    if (RCDIsIPad) {
        frame.origin.y += 20;
        collectionViewFrame.origin.y += 64;
        collectionViewFrame.size.height -= 64;
        self.conversationMessageCollectionView.frame = collectionViewFrame;
    }
    self.announceView.frame = frame;
    
    self.announceView.hidden = YES;
    
    //
    UIImage* decorImage = kIMG(@"");
    _decorIv = [[UIImageView alloc]init];
    [self.view addSubview:_decorIv];
    [_decorIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.leading.trailing.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(decorImage.size.width, 64+19));//219
    }];
    [_decorIv setContentMode:UIViewContentModeScaleAspectFill];
    
    _decorIv.clipsToBounds = YES;
    _decorIv.image = decorImage;
    _decorIv.backgroundColor = kWhiteColor;
    
    _accLab = UILabel.new;
    _accLab.text = @"客服";
    [_decorIv addSubview:_accLab];
    [_accLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.decorIv.mas_centerX);
        make.top.equalTo(self.decorIv).offset(73-19);
    }];
    
    kWeakSelf(self);
    [self.view goBackBlackButtonInSuperView:self.view
                            leftButtonEvent:^(id data) {
                                kStrongSelf(self);
                                
                                [self goBack];
                            }];
}

-(void)goBack{
    //    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:false completion:^{
        [super customerServiceLeftCurrentViewController];
    }];
}

#pragma mark - RCChatSessionInputBarControlDelegate

/*!
 点击键盘Return按钮的回调
 
 @param inputTextView 文本输入框
 */
- (void)inputTextViewDidTouchSendKey:(UITextView *)inputTextView{
    
    NSLog(@"%@",self.chatSessionInputBarControl.inputTextView.text);
    
    RCTextMessage *contentText = [RCTextMessage messageWithContent:self.chatSessionInputBarControl.inputTextView.text];
    
    [[RCIM sharedRCIM] sendMessage:ConversationType_CUSTOMERSERVICE
                          targetId:SERVICE_ID
                           content:contentText
                       pushContent:Nil
                          pushData:Nil
                           success:^(long messageId) {
                               
                               NSLog(@"messageId = %ld",messageId);
                               
        
    } error:^(RCErrorCode nErrorCode, long messageId) {
        
        NSLog(@"nErrorCode = %ld,messageId = %ld",(long)nErrorCode,messageId);
    }];
}

//客服VC左按键注册的selector是customerServiceLeftCurrentViewController，
//这个函数是基类的函数，他会根据当前服务时间来决定是否弹出评价，根据服务的类型来决定弹出评价类型。
//弹出评价的函数是commentCustomerServiceAndQuit，应用可以根据这个函数内的注释来自定义评价界面。
//等待用户评价结束后调用如下函数离开当前VC。
- (void)clickLeftBarButtonItem:(id)sender {
    [super customerServiceLeftCurrentViewController];
}

//评价客服，并离开当前会话
//如果您需要自定义客服评价界面，请把本函数注释掉，并打开“应用自定义评价界面开始1/2”到“应用自定义评价界面结束”部分的代码，然后根据您的需求进行修改。
//如果您需要去掉客服评价界面，请把本函数注释掉，并打开下面“应用去掉评价界面开始”到“应用去掉评价界面结束”部分的代码，然后根据您的需求进行修改。
//- (void)commentCustomerServiceWithStatus:(RCCustomerServiceStatus)serviceStatus
//                               commentId:(NSString *)commentId
//                        quitAfterComment:(BOOL)isQuit {
//  [super commentCustomerServiceWithStatus:serviceStatus
//                                commentId:commentId
//                         quitAfterComment:isQuit];
//}

//＊＊＊＊＊＊＊＊＊应用去掉评价界面开始＊＊＊＊＊＊＊＊＊＊＊＊＊
//-
//(void)commentCustomerServiceWithStatus:(RCCustomerServiceStatus)serviceStatus
//commentId:(NSString *)commentId quitAfterComment:(BOOL)isQuit {
//    if (isQuit) {
//        [super customerServiceLeftCurrentViewController];;
//    }
//}
//＊＊＊＊＊＊＊＊＊应用去掉评价界面结束＊＊＊＊＊＊＊＊＊＊＊＊＊

//＊＊＊＊＊＊＊＊＊应用自定义评价界面开始2＊＊＊＊＊＊＊＊＊＊＊＊＊
-(void)commentCustomerServiceWithStatus:(RCCustomerServiceStatus)serviceStatus
commentId:(NSString *)commentId quitAfterComment:(BOOL)isQuit {
    if (self.evaStarDic.count == 0) {
        [super commentCustomerServiceWithStatus:serviceStatus commentId:commentId quitAfterComment:isQuit];
        return;
    }
    self.serviceStatus = serviceStatus;
    self.commentId = commentId;
    self.quitAfterComment = isQuit;
    if (serviceStatus == 0) {
        [super customerServiceLeftCurrentViewController];;
    } else if (serviceStatus == 1) {
        //人工评价结果
        [self.evaluateView show];
    } else if (serviceStatus == 2) {
        //机器人评价结果
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:RCDLocalizedString(@"remark_rebot_service")
                              message:RCDLocalizedString(@"satisfaction") delegate:self
                              cancelButtonTitle:RCDLocalizedString(@"yes") otherButtonTitles:RCDLocalizedString(@"no"), nil];
        [alert show];
    }
}
- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    //(1)调用evaluateCustomerService将评价结果传给融云sdk。
    if (self.serviceStatus == RCCustomerService_RobotService)
    {//机器人评价结果
        if (buttonIndex == 0) {
            [[RCIMClient sharedRCIMClient]
             evaluateCustomerService:self.targetId knownledgeId:self.commentId
             robotValue:YES suggest:nil];
        } else if (buttonIndex == 1) {
            [[RCIMClient sharedRCIMClient]
             evaluateCustomerService:self.targetId knownledgeId:self.commentId
             robotValue:NO suggest:nil];
        }
    }
    //(2)离开当前客服VC
    if (self.quitAfterComment) {
        [super customerServiceLeftCurrentViewController];;
    }
}

//＊＊＊＊＊＊＊＊＊应用自定义客服通告＊＊＊＊＊＊＊＊＊＊＊＊＊

- (void)announceViewWillShow:(NSString *)announceMsg announceClickUrl:(NSString *)announceClickUrl{
    self.announceClickUrl = announceClickUrl;
    
    self.announceView.content.text = announceMsg;
    if (announceClickUrl.length == 0) {
        self.announceView.hiddenArrowIcon = YES;
    }
}

#pragma mark -- RCDCSAnnounceViewDelegate
- (void)didTapViewAction{
    if (self.announceClickUrl.length > 0) {
        [RCKitUtility openURLInSafariViewOrWebView:self.announceClickUrl base:self];
    }
}
//＊＊＊＊＊＊＊＊＊应用自定义客服通告＊＊＊＊＊＊＊＊＊＊＊＊＊

#pragma mark -- RCDCSEvaluateViewDelegate

- (void)didSubmitEvaluate:(RCCSResolveStatus)solveStatus star:(int)star tagString:(NSString *)tagString suggest:(NSString *)suggest{
    [[RCIMClient sharedRCIMClient] evaluateCustomerService:self.targetId dialogId:nil starValue:star suggest:suggest resolveStatus:solveStatus tagText:tagString extra:nil];
    if (self.quitAfterComment) {
        [super customerServiceLeftCurrentViewController];;
    }
}

- (void)dismissEvaluateView{
    [self.evaluateView hide];
    if (self.quitAfterComment) {
        [super customerServiceLeftCurrentViewController];;
    }
}

- (RCDCSEvaluateView *)evaluateView{
    if (!_evaluateView) {
        _evaluateView = [[RCDCSEvaluateView alloc] initWithEvaStarDic:self.evaStarDic];
        _evaluateView.delegate = self;
    }
    return _evaluateView;
}

- (RCDCSAnnounceView *)announceView{
    if (!_announceView) {
        CGRect rect = self.conversationMessageCollectionView.frame;
        rect.origin.y += 44;
        rect.size.height -= 44;
        self.conversationMessageCollectionView.frame = rect;
        _announceView = [[RCDCSAnnounceView alloc] initWithFrame:CGRectMake(0,rect.origin.y-44, self.view.frame.size.width,44)];
        _announceView.delegate = self;
        [self.view addSubview:_announceView];
    }
    return _announceView;
}

#pragma mark Navigation Setting
- (void) createNavLeftBarButtonItem {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 6, 72, 23);
    UILabel *backText = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 70, 22)];
    backText.text = RCDLocalizedString(@"back");
    backText.font = [UIFont systemFontOfSize:17];
    [backText setBackgroundColor:[UIColor clearColor]];
    [backText setTextColor:[RCIM sharedRCIM].globalNavigationBarTintColor];
    [backBtn addSubview:backText];
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back"]];
    backImg.frame = CGRectMake(-8, 0, 15, 22);
    [backBtn addSubview:backImg];
    [backBtn addTarget:self action:@selector(clickLeftBarButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationItem setLeftBarButtonItem:leftButton];
}

//- (void)presentViewController:(UIViewController *)viewController functionTag:(NSInteger)functionTag {
//    <#code#>
//}

//
//- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    <#code#>
//}
//
//- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    <#code#>
//}
//
//- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
//    <#code#>
//}
//
//- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
//    <#code#>
//}
//
//- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
//    <#code#>
//}
//
//- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
//    <#code#>
//}
//
//- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
//    <#code#>
//}
//
//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
//    <#code#>
//}
//
//- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
//    <#code#>
//}
//
//- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {
//    <#code#>
//}
//
//- (void)setNeedsFocusUpdate {
//    <#code#>
//}
//
//- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context {
//    <#code#>
//}
//
//- (void)updateFocusIfNeeded {
//    <#code#>
//}




@end
