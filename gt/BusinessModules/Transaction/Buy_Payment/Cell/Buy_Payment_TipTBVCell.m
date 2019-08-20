//
//  Buy_Payment_TipTBVCell.m
//  gt
//
//  Created by Administrator on 03/04/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "Buy_Payment_TipTBVCell.h"

@interface Buy_Payment_TipTBVCell (){
    
    
}

@property (nonatomic, assign) NSInteger timeCount;
@property (nonatomic, strong) UIButton *timeBtn;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, copy) TwoDataBlock block;

@end

@implementation Buy_Payment_TipTBVCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style
                     dataDic:(NSDictionary *)dataDic
             reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style
                    reuseIdentifier:reuseIdentifier]) {
        
        [self initView:dataDic];
    }
    
    return self;
}

-(void)initView:(NSDictionary *)dataDic{
    
    self.textLabel.text = @"请在付款期限内向卖方转账";
    
    self.textLabel.textColor = RGBCOLOR(51, 51, 51);
    
    self.textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular"
                                          size:13];
    
    self.timeBtn = UIButton.new;
    
    [self.timeBtn setTitleColor:RGBCOLOR(255, 146, 56)
                       forState:UIControlStateNormal];
    
    [self.timeBtn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Semibold"
                                                     size:15]];
    
    [self.contentView addSubview:self.timeBtn];
    
    [self.timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.contentView);
        
        make.right.equalTo(self.contentView).offset(-22);
    }];

    
    [self startTimeCount:dataDic[@"restTime"]];
}

- (void)actionBlock:(TwoDataBlock)block{
    
    self.block = block;
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
    self.timeBtn.enabled = false;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(_timerAction)
                                                userInfo:nil
                                                 repeats:YES];
    //    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

/**停止定时器*/
- (void)distoryTimer
{
    if (self.timer != nil)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark timer
- (void) _timerAction
{
    self.timeCount--;
    //    NSString *title = [NSString stringWithFormat:@"%ld",(long)self.timeCount];
    [self.timeBtn setTitle:[NSString timeWithSecond:self.timeCount] forState:UIControlStateNormal];
    [self.timeBtn setTitleColor:HEXCOLOR(0xff9238) forState:UIControlStateNormal];
    if(self.timeCount < 0)
    {
        [self distoryTimer];
        self.timeBtn.enabled = false;
        [self.timeBtn setTitle:@"00:00" forState:UIControlStateNormal];
        //        [self.timeBtn setTitleColor:HEXCOLOR(0xf6f5fa) forState:UIControlStateNormal];
        if (self.block) {
            self.block(@(_timeBtn.tag), _timeBtn);
        }
        
    }
}

- (void) removeFromSuperview
{
    [super removeFromSuperview];
    
    [self distoryTimer];
}


@end
