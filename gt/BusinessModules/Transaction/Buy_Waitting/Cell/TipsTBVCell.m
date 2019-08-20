//
//  Buy_Waitting_TipTBVCell.m
//  gt
//
//  Created by Administrator on 03/04/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "TipsTBVCell.h"

@interface TipsTBVCell (){
    
    NSString *time;
    
    UILabel *contentLab;
    
    NSDictionary* contentStyle;
    
    UILabel *timeLab;
}

@property(nonatomic,strong)NSString *userType;

@property(nonatomic,assign)OrderType orderType;

@property(nonatomic,strong)NSTimer *timer;

@property(nonatomic,assign)NSInteger timeCount;

@property(nonatomic,strong)NSString *styleStr;

@end

@implementation TipsTBVCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style
                     dataDic:(NSDictionary *)dataDic
             reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style
                    reuseIdentifier:reuseIdentifier]) {

        self.userType = dataDic[@"userType"];
        
        self.orderType = [dataDic[@"orderType"] intValue];

        time = dataDic[@"restTime"];

        [self initView];
    }
 
    return self;
}

-(void)initView{
    
    if ([self.userType isEqualToString:@"1"]) {//普通用户
        
        [self style3];
        
    }else if ([self.userType isEqualToString:@"2"]){//商家
        
        switch (self.orderType) {
                
            case SellerOrderTypeTimeOut:
            case SellerOrderTypeCancel:
                
                [self style1];
                break;
            case SellerOrderTypeNotYetPay:
                
                [self style2:SellerOrderTypeNotYetPay];
                break;
                
            case SellerOrderTypeWaitDistribute:
                
                [self style2:SellerOrderTypeWaitDistribute];
                
                break;
                
            default:
                break;
        }
    }
}

-(void)style1{
    
    self.styleStr = @"style1";
    
    UILabel *tipsLab = UILabel.new;
    
    tipsLab.textAlignment = NSTextAlignmentCenter;
    
    tipsLab.text = @"对方未在15分钟内支付，订单已关闭";
    
    tipsLab.textColor = RGBCOLOR(76, 127, 255);
    
    tipsLab.font = [UIFont fontWithName:@"PingFangSC-Regular"
                                   size:12];
    
    [self.contentView addSubview:tipsLab];
    
    [tipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.contentView);
    }];
}

-(void)style2:(OrderType)orderType{
    
    self.styleStr = @"style2";
    
    UIImageView *imgView = UIImageView.new;
    
    imgView.backgroundColor = RGBCOLOR(246, 247, 249);
    
    [self.contentView addSubview:imgView];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.contentView).offset(10);
    }];
    
    timeLab = UILabel.new;
    
    timeLab.textAlignment = NSTextAlignmentCenter;

    timeLab.textColor = RGBCOLOR(255, 146, 56);
    
    timeLab.font = kFontSize(40);
    
    [self.contentView addSubview:timeLab];
    
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(imgView);
        
        make.bottom.equalTo(imgView.mas_centerY);
        
        make.top.equalTo(imgView);
    }];
    
    UILabel *tipsLab = UILabel.new;
    
    tipsLab.numberOfLines = 0;

#warning 文字靠左未解决
    
    switch (orderType) {
        case SellerOrderTypeNotYetPay:
            
            tipsLab.text = @"15分钟内对方未确认付款，订单将关闭";
            break;
        case SellerOrderTypeWaitDistribute:
            
            tipsLab.text = @"如确定收到款项，请在倒计时结束前放行，以避免不必要的申诉纠纷";
            break;
            
        default:
            break;
    }

    tipsLab.textAlignment = NSTextAlignmentCenter;
    
    tipsLab.textColor = RGBCOLOR(76, 127, 255);
    
    tipsLab.font = [UIFont fontWithName:@"PingFangSC-Regular"
                                   size:12];
    
    [self.contentView addSubview:tipsLab];
    
    [tipsLab mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(self->timeLab.mas_bottom);
        
        make.left.equalTo(imgView).offset(29);
        
        make.right.equalTo(imgView).offset(-29);
    }];
    
    [self startTimeCount:time];
}

-(void)style3{
    
    self.styleStr = @"style3";
    
    UILabel *titleLab = UILabel.new;
    
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    titleLab.backgroundColor = RGBCOLOR(246, 247, 249);
    
    NSDictionary *titleStyle = @{
                                 @"title_font":[UIFont fontWithName:@"PingFangSC-Regular" size:17],
                                 @"title_color":RGBCOLOR(0, 0, 0)
                                 };
    
    titleLab.attributedText = [@"<title_color><title_font>官方提醒</title_font></title_color>" attributedStringWithStyleBook:titleStyle];
    
    [self.contentView addSubview:titleLab];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(self.contentView).offset(21);
        
        make.right.equalTo(self.contentView).offset(-21);
        
        make.height.mas_equalTo(MAINSCREEN_HEIGHT / 17);
    }];
    
    //建立此view的目的:让文字和上一层容器有一定间距
    UIView *view = UIView.new;
    
    view.backgroundColor = RGBCOLOR(246, 247, 249);
    
    [self.contentView addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.bottom.equalTo(self.contentView).offset(-21);
        
        make.left.equalTo(self.contentView).offset(21);
        
        make.top.equalTo(titleLab.mas_bottom);
    }];
    
    //
    contentLab = UILabel.new;
    
    contentLab.numberOfLines = 0;
    
    contentLab.backgroundColor = kClearColor;
    
    [view addSubview:contentLab];
    
    [contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.bottom.equalTo(view).offset(-15);
        
        make.left.equalTo(view).offset(15);
        
        make.top.equalTo(titleLab.mas_bottom);
    }];
    
    contentStyle = @{
                             @"detailDescribe_font":[UIFont fontWithName:@"PingFangSC-Regular" size:13],
                             @"time_font":[UIFont fontWithName:@"PingFangSC-Medium" size:15],
                             
                             @"detailDescribe_color":RGBCOLOR(51, 51, 51),
                             @"time_color":kOrangeColor//RGBCOLOR(255, 146, 56)
                             };
    
    [self startTimeCount:time];
}

/**设置倒计时时间，并启动倒计时*/
- (void)startTimeCount:(NSString *)sec
{
    if (sec) {
        self.timeCount = [sec integerValue];
    } else {
        self.timeCount = 60;
    }
    
    [self distoryTimer];
//    self.timeBtn.enabled = false;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(_timerAction)
                                                userInfo:nil
                                                 repeats:YES];
    //    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

/**停止定时器*/
- (void)distoryTimer{
    
    if (self.timer != nil){
        
        [self.timer invalidate];
        
        if (self.MyBlock) {
            
            self.MyBlock();
        }
        
        self.timer = nil;
    }
}

#pragma mark —— timer
- (void) _timerAction
{
    self.timeCount--;
    
    time = [NSString timeWithSecond:self.timeCount];
    
    if(self.timeCount < 0)
    {
        [self distoryTimer];
        
        time = @"00:00";
    }
    
    if ([self.styleStr isEqualToString:@"style3"]) {
        
        contentLab.attributedText = [[NSString stringWithFormat:@"<detailDescribe_font><detailDescribe_color>1、您可向卖家说明您的付款账号，让卖家确认您的身份，以加快卖家的放行速度;\n\n2、若卖方<time_font><time_color>%@</time_color></time_font>时间内未放行，您可以发起申诉，一经核实，系统会自动放行此次交易。</detailDescribe_color></detailDescribe_font>",time] attributedStringWithStyleBook:contentStyle];
    }else if ([self.styleStr isEqualToString:@"style2"]){
        
        timeLab.text = time;
    }
}

- (void) removeFromSuperview
{
    [super removeFromSuperview];
    [self distoryTimer];
}

#pragma mark —— set
//-(void)setOrderDetailModel:(OrderDetailModel *)orderDetailModel{
//    
//    _orderDetailModel = orderDetailModel;
//}

@end
