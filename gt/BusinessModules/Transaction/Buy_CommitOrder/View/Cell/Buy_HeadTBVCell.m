//
//  Buy_HeadTBVCell.m
//  gt
//
//  Created by Administrator on 31/03/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "Buy_HeadTBVCell.h"

#define lineColor RGBCOLOR(76, 127, 255)

@interface Buy_HeadTBVCell(){
    
}

@property(nonatomic,strong)NSMutableArray *markLabMutArr;
@property(nonatomic,strong)NSMutableArray *markLabTitleMutArr;
@property(nonatomic,strong)NSMutableArray *progressBarLabLeft_MutArr;
@property(nonatomic,strong)NSMutableArray *progressBarLabRight_MutArr;

@property(nonatomic,strong)NSString *userType;
@property(nonatomic,assign)OrderType orderType;
@property(nonatomic,assign)Schedule schedule;


@end

@implementation Buy_HeadTBVCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style
             reuseIdentifier:(NSString *)reuseIdentifier
                     dataDic:(NSDictionary *)dataDic{

    if ([super initWithStyle:style
             reuseIdentifier:reuseIdentifier]) {
        
        self.userType = dataDic[@"userType"];
        
        self.orderType = [dataDic[@"orderType"] intValue];//

        [self userType:self.userType];//赋值
      
        [self initView];
        
        [self setScheduleData];
        
    }
 
    return self;
}
//
-(void)setScheduleData{
    
    switch (self.orderType) {
            
        case BuyerOrderTypeAllPay://1
            self.schedule = Schedule_1st;
            
            break;
        case BuyerOrderTypeClosed://2
        case BuyerOrderTypeCancel://2
        case BuyerOrderTypeNotYetPay:
        case BuyerOrderTypeAppealing://2 3???
            
        case SellerOrderTypeNotYetPay://2
        case SellerOrderTypeTimeOut://2
        case SellerOrderTypeCancel://2
            
            self.schedule = Schedule_2nd;
            
            break;
        case BuyerOrderTypeHadPaidNotDistribute://3
        case BuyerOrderTypeHadPaidWaitDistribute://3
//        case BuyerOrderTypeAppealing://2 3????
        case SellerOrderTypeWaitDistribute:
        case SellerOrderTypeAppealing:
            
            self.schedule = Schedule_3rd;
            
            break;
        case BuyerOrderTypeFinished:
        case SellerOrderTypeFinished:
            
            self.schedule = Schedule_4th;
            
            break;
        default:
            break;
    }
    
    for (int d = 0; d < self.schedule; d++) {
        
        UILabel *leftProgressBarLab = self.progressBarLabLeft_MutArr[d];
        
        NSLog(@"%@",leftProgressBarLab);
        
        leftProgressBarLab.backgroundColor = lineColor;
        
        UILabel *rightProgressBarLab = self.progressBarLabRight_MutArr[d];
        
        rightProgressBarLab.backgroundColor = lineColor;
        
        UILabel *markLab = self.markLabMutArr[d];
        
        markLab.backgroundColor = lineColor;
    }
}

-(void)userType:(NSString *)userType{
    
    if ([userType isEqualToString:@"1"]) {
        
        [self.markLabTitleMutArr addObject:@"提交订单"];
        [self.markLabTitleMutArr addObject:@"向卖家转账"];
        [self.markLabTitleMutArr addObject:@"等待放行"];
        [self.markLabTitleMutArr addObject:@"交易完成"];
        
    }else if ([userType isEqualToString:@"2"]){
        
        [self.markLabTitleMutArr addObject:@"买家下单"];
        [self.markLabTitleMutArr addObject:@"买家付款"];
        [self.markLabTitleMutArr addObject:@"放行订单"];
        [self.markLabTitleMutArr addObject:@"交易完成"];
    }
}

-(void)initView{

    for (int t = 0; t < 4; t++) {
       //圆圈内套文字
        UILabel *markLab = UILabel.new;
        
        [self.markLabMutArr addObject:markLab];
        
        markLab.text = [NSString stringWithFormat:@"%d",t + 1];
        
        markLab.textColor = kWhiteColor;
        
        [NSObject cornerCutToCircleWithView:markLab
                            AndCornerRadius:20 / 2];
        
        markLab.backgroundColor = RGBCOLOR(221, 221, 221);
        
        markLab.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:markLab];
        
       [markLab mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView).offset(MAINSCREEN_WIDTH * (2 * (t + 1) - 1)/ 8);
            
            make.size.mas_equalTo(CGSizeMake(20, 20));
            
            make.top.equalTo(self.contentView).offset(15);
        }];
        //文字标题
        UILabel *titleLab = UILabel.new;
        
        titleLab.textColor = RGBCOLOR(221, 221, 221);
        
        titleLab.font = [UIFont fontWithName:@"PingFangSC-Medium"
                                        size:14];
        
        titleLab.text = self.markLabTitleMutArr[t];
        
        [self.contentView addSubview:titleLab];
        
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(markLab);
            
            make.top.equalTo(markLab.mas_bottom).offset(5);
        }];
        
        //进度条
        //左
        UILabel *progressBarLab_left = UILabel.new;
        
        [self.progressBarLabLeft_MutArr addObject:progressBarLab_left];
        
        progressBarLab_left.backgroundColor = kGrayColor;
        
        [self.contentView addSubview:progressBarLab_left];
        
        [progressBarLab_left mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(markLab.mas_left);
            
            make.centerY.equalTo(markLab);
            
            make.size.mas_equalTo(CGSizeMake(MAINSCREEN_WIDTH / 8, 2));
        }];
        //右
        UILabel *progressBarLab_right = UILabel.new;
        
        [self.progressBarLabRight_MutArr addObject:progressBarLab_right];
        
        progressBarLab_right.backgroundColor = kGrayColor;
        
        [self.contentView addSubview:progressBarLab_right];
        
        [progressBarLab_right mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(markLab.mas_right);
            
            make.centerY.equalTo(markLab);
            
            make.size.mas_equalTo(CGSizeMake(MAINSCREEN_WIDTH / 8, 2));
        }];
        
        if (t == 0) {
            progressBarLab_left.hidden = YES;
        }
        
        if (t == self.markLabTitleMutArr.count - 1) {

            progressBarLab_right.hidden = YES;
        }
    }
}

#pragma mark —— lazyload
-(NSMutableArray *)markLabMutArr{
    
    if (!_markLabMutArr) {
        
        _markLabMutArr = [NSMutableArray array];
    }
    
    return _markLabMutArr;
}

-(NSMutableArray *)markLabTitleMutArr{
    
    if (!_markLabTitleMutArr) {
        
        _markLabTitleMutArr = [NSMutableArray array];

    }
    
    return _markLabTitleMutArr;
}

-(NSMutableArray *)progressBarLabLeft_MutArr{
    
    if (!_progressBarLabLeft_MutArr) {
        
        _progressBarLabLeft_MutArr = NSMutableArray.array;
    }
    
    return _progressBarLabLeft_MutArr;
}

-(NSMutableArray *)progressBarLabRight_MutArr{
    
    if (!_progressBarLabRight_MutArr) {
        
        _progressBarLabRight_MutArr = NSMutableArray.array;
    }
    
    return _progressBarLabRight_MutArr;
}

#pragma mark —— set
-(void)setOrderDetailModel:(OrderDetailModel *)orderDetailModel{
    
    _orderDetailModel = orderDetailModel;
}

@end
