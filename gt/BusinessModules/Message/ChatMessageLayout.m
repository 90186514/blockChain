//
//  ChatMessageLayout.m
//  gt
//
//  Created by cookie on 2018/12/31.
//  Copyright © 2018 GT. All rights reserved.
//

#import "ChatMessageLayout.h"
#import "ChatDatas.h"
#import "NSTimer+SSAdd.h"
#import "UIImage+SSAdd.h"
#import "UIView+SSAdd.h"
#import "NSObject+SSAdd.h"
//#import "SSChatIMEmotionModel.h"

@implementation ChatMessageLayout

//根据模型返回布局
-(instancetype)initWithMessage:(ChatMessage *)message{
    if(self = [super init]){
        self.message = message;
    }
    return self;
}

-(void)setMessage:(ChatMessage *)message{
    _message = message;
    
    switch (_message.messageType ) {
            
        case ChatMessageTypeText:
            [self setText];
            break;
        case ChatMessageTypeImage:
            [self setImage];
            break;
        case ChatMessageTypeVoice:
            [self setVoice];
            break;
        case ChatMessageTypeMap:
            [self setMap];
            break;
        case ChatMessageTypeVideo:
            [self setVideo];
            break;
        case ChatMessageTypeRedEnvelope:
            [self setVideo];
            break;
        case ChatMessageTypeUndo:
            [self setRecallMessage];
            break;
        case ChatMessageTypeDelete:
            [self setRemoveMessage];
            break;
        default:
            break;
    }
}

//显示文字消息 这个自适应计算有误差 用sizeToFit就比较完美 有好办法告诉我
-(void)setText{
    
    UITextView *mTextView = [UITextView new];
    mTextView.bounds = CGRectMake(0, 0, SSChatTextInitWidth, 100);
    mTextView.attributedText = _message.attTextString;
//    mTextView.text = _message.textString;
    mTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [mTextView sizeToFit];
    
    _textLabRect = mTextView.bounds;// [NSObject getRectWith:_message.attTextString width:SSChatTextInitWidth];
    
    CGFloat textWidth  = _textLabRect.size.width;
    CGFloat textHeight = _textLabRect.size.height;
    
    if(_message.messageFrom == ChatMessageFromOther){
        _headerImgRect = CGRectMake(SSChatIconLeft,SSChatCellTop, SSChatIconWH, SSChatIconWH);
        
        _backImgButtonRect = CGRectMake(SSChatIconLeft+SSChatIconWH+SSChatIconRight, self.headerImgRect.origin.y, textWidth+SSChatTextLRB+SSChatTextLRS, textHeight+SSChatTextTop+SSChatTextBottom);
        
        _imageInsets = UIEdgeInsetsMake(SSChatAirTop, SSChatAirLRB, SSChatAirBottom, SSChatAirLRS);
        
        _textLabRect.origin.x = SSChatTextLRB;
        _textLabRect.origin.y = SSChatTextTop;
        
    }else{
        _headerImgRect = CGRectMake(SSChatIcon_RX, SSChatCellTop, SSChatIconWH, SSChatIconWH);
        
        _backImgButtonRect = CGRectMake(SSChatIcon_RX-SSChatDetailRight-SSChatTextLRB-textWidth-SSChatTextLRS, self.headerImgRect.origin.y, textWidth+SSChatTextLRB+SSChatTextLRS, textHeight+SSChatTextTop+SSChatTextBottom);
        
        _imageInsets = UIEdgeInsetsMake(SSChatAirTop, SSChatAirLRS, SSChatAirBottom, SSChatAirLRB);
        
        _textLabRect.origin.x = SSChatTextLRS;
        _textLabRect.origin.y = SSChatTextTop;
    }
    
    
    //判断时间是否显示
    _timeLabRect = CGRectMake(0, 0, 0, 0);
    
    if(_message.showTime==YES){
        
        _timeLabRect = CGRectMake(SCREEN_Width/2-100, SSChatTimeTop, 200, SSChatTimeHeight);
        
        CGRect hRect = self.headerImgRect;
        hRect.origin.y = SSChatTimeTop+SSChatTimeBottom+SSChatTimeHeight;
        self.headerImgRect = hRect;
        
        _backImgButtonRect = CGRectMake(_backImgButtonRect.origin.x, _headerImgRect.origin.y, _backImgButtonRect.size.width, _backImgButtonRect.size.height);
    }
    
    _cellHeight = _backImgButtonRect.size.height + _backImgButtonRect.origin.y + SSChatCellBottom;
    
}


-(void)setImage{
    
    UIImage *image = _message.image;
    CGFloat imgWidth  = CGImageGetWidth(image.CGImage);
    CGFloat imgHeight = CGImageGetHeight(image.CGImage);
    CGFloat imgActualHeight = SSChatImageMaxSize;
    CGFloat imgActualWidth =  SSChatImageMaxSize * imgWidth/imgHeight;
    
    _message.contentMode =  UIViewContentModeScaleAspectFit;
    
    if(imgActualWidth>SSChatImageMaxSize){
        imgActualWidth = SSChatImageMaxSize;
        imgActualHeight = imgActualWidth * imgHeight/imgWidth;
    }
    if(imgActualWidth<SSChatImageMaxSize*0.25){
        imgActualWidth = SSChatImageMaxSize * 0.25;
        imgActualHeight = SSChatImageMaxSize * 0.8;
        _message.contentMode =  UIViewContentModeScaleAspectFill;
    }
    
    if(_message.messageFrom == ChatMessageFromOther){
        _headerImgRect = CGRectMake(SSChatIconLeft,SSChatCellTop, SSChatIconWH, SSChatIconWH);
        
        _backImgButtonRect = CGRectMake(SSChatIconLeft+SSChatIconWH+SSChatIconRight, self.headerImgRect.origin.y, imgActualWidth, imgActualHeight);
        
        _imageInsets = UIEdgeInsetsMake(SSChatAirTop, SSChatAirLRB, SSChatAirBottom, SSChatAirLRS);
        
    }else{
        _headerImgRect = CGRectMake(SSChatIcon_RX, SSChatCellTop, SSChatIconWH, SSChatIconWH);
        
        _backImgButtonRect = CGRectMake(SSChatIcon_RX-SSChatDetailRight-imgActualWidth, self.headerImgRect.origin.y, imgActualWidth, imgActualHeight);
        
        _imageInsets = UIEdgeInsetsMake(SSChatAirTop, SSChatAirLRS, SSChatAirBottom, SSChatAirLRB);
    }
    
    //判断时间是否显示
    _timeLabRect = CGRectMake(0, 0, 0, 0);
    
    if(_message.showTime==YES){
        
        _timeLabRect = CGRectMake(SCREEN_Width/2-100, SSChatTimeTop, 200, SSChatTimeHeight);
        
        CGRect hRect = self.headerImgRect;
        hRect.origin.y = SSChatTimeTop+SSChatTimeBottom+SSChatTimeHeight;
        self.headerImgRect = hRect;
        
        _backImgButtonRect = CGRectMake(_backImgButtonRect.origin.x, _headerImgRect.origin.y, _backImgButtonRect.size.width, _backImgButtonRect.size.height);
    }
    
    _cellHeight = _backImgButtonRect.size.height + _backImgButtonRect.origin.y + SSChatCellBottom;
    
}

-(void)setVoice{
    
    //计算时间
    CGRect rect = [NSObject getRectWith:_message.voiceTime width:150 font:[UIFont systemFontOfSize:SSChatVoiceTimeFont] spacing:0 Row:0];
    CGFloat timeWidth  = rect.size.width;
    CGFloat timeHeight = rect.size.height;
    
    //根据时间设置按钮实际长度
    CGFloat timeLength = SSChatVoiceMaxWidth - SSChatVoiceMinWidth;
    CGFloat changeLength = timeLength/60;
    CGFloat currentLength = changeLength*_message.voiceDuration+SSChatVoiceMinWidth;
    
    if(_message.messageFrom == ChatMessageFromOther){
        
        _headerImgRect = CGRectMake(SSChatIcon_RX, SSChatCellTop, SSChatIconWH, SSChatIconWH);
        
        _backImgButtonRect = CGRectMake(SSChatIconLeft+SSChatIconWH+SSChatIconRight, self.headerImgRect.origin.y, currentLength, SSChatVoiceHeight);
        
        _imageInsets = UIEdgeInsetsMake(SSChatAirTop, SSChatAirLRB, SSChatAirBottom, SSChatAirLRS);
        
        _voiceTimeLabRect = CGRectMake(_backImgButtonRect.size.width-timeWidth-10, (_backImgButtonRect.size.height-timeHeight)/2, timeWidth, timeHeight);
        
        _voiceImgRect = CGRectMake(20, (_backImgButtonRect.size.height-SSChatVoiceImgSize)/2, SSChatVoiceImgSize, SSChatVoiceImgSize);
        
    }else{
        
        _headerImgRect = CGRectMake(SSChatIcon_RX, SSChatCellTop, SSChatIconWH, SSChatIconWH);
        _backImgButtonRect = CGRectMake(SSChatIcon_RX-SSChatDetailRight-currentLength, self.headerImgRect.origin.y, currentLength, SSChatVoiceHeight);
        _imageInsets = UIEdgeInsetsMake(SSChatAirTop, SSChatAirLRS, SSChatAirBottom, SSChatAirLRB);
        
        _voiceTimeLabRect = CGRectMake(10, (_backImgButtonRect.size.height-timeHeight)/2, timeWidth, timeHeight);
        
        _voiceImgRect = CGRectMake(_backImgButtonRect.size.width-SSChatVoiceImgSize-20, (_backImgButtonRect.size.height-SSChatVoiceImgSize)/2, SSChatVoiceImgSize, SSChatVoiceImgSize);
    }
    
    //判断时间是否显示
    _timeLabRect = CGRectMake(0, 0, 0, 0);
    
    if(_message.showTime==YES){
        
        _timeLabRect = CGRectMake(SCREEN_Width/2-100, SSChatTimeTop, 200, SSChatTimeHeight);
        
        CGRect hRect = self.headerImgRect;
        hRect.origin.y = SSChatTimeTop+SSChatTimeBottom+SSChatTimeHeight;
        self.headerImgRect = hRect;
        
        _backImgButtonRect = CGRectMake(_backImgButtonRect.origin.x, _headerImgRect.origin.y, _backImgButtonRect.size.width, _backImgButtonRect.size.height);
    }
    
    _cellHeight = _backImgButtonRect.size.height + _backImgButtonRect.origin.y + SSChatCellBottom;
    
}


-(void)setMap{
    
    if(_message.messageFrom == ChatMessageFromOther){
        _headerImgRect = CGRectMake(SSChatIconLeft,SSChatCellTop, SSChatIconWH, SSChatIconWH);
        
        _backImgButtonRect = CGRectMake(SSChatIconLeft+SSChatIconWH+SSChatIconRight, self.headerImgRect.origin.y, SSChatMapWidth, SSChatMapHeight);
        
        _imageInsets = UIEdgeInsetsMake(SSChatAirTop, SSChatAirLRB, SSChatAirBottom, SSChatAirLRS);
        
        
    }else{
        _headerImgRect = CGRectMake(SSChatIcon_RX, SSChatCellTop, SSChatIconWH, SSChatIconWH);
        
        _backImgButtonRect = CGRectMake(SSChatIcon_RX-SSChatDetailRight-SSChatMapWidth, self.headerImgRect.origin.y, SSChatMapWidth, SSChatMapHeight);
        
        _imageInsets = UIEdgeInsetsMake(SSChatAirTop, SSChatAirLRS, SSChatAirBottom, SSChatAirLRB);
        
    }
    
    //判断时间是否显示
    _timeLabRect = CGRectMake(0, 0, 0, 0);
    
    if(_message.showTime==YES){
        
        _timeLabRect = CGRectMake(SCREEN_Width/2-100, SSChatTimeTop, 200, SSChatTimeHeight);
        
        CGRect hRect = self.headerImgRect;
        hRect.origin.y = SSChatTimeTop+SSChatTimeBottom+SSChatTimeHeight;
        self.headerImgRect = hRect;
        
        _backImgButtonRect = CGRectMake(_backImgButtonRect.origin.x, _headerImgRect.origin.y, _backImgButtonRect.size.width, _backImgButtonRect.size.height);
    }
    
    _cellHeight = _backImgButtonRect.size.height + _backImgButtonRect.origin.y + SSChatCellBottom;
    
}

//短视频
-(void)setVideo{
    
    CGFloat imgWidth  = CGImageGetWidth(_message.videoImage.CGImage);
    CGFloat imgHeight = CGImageGetHeight(_message.videoImage.CGImage);
    CGFloat imgActualHeight = SSChatImageMaxSize;
    CGFloat imgActualWidth =  SSChatImageMaxSize * imgWidth/imgHeight;
    
    if(imgActualWidth>SSChatImageMaxSize){
        imgActualWidth = SSChatImageMaxSize;
        imgActualHeight = imgActualWidth * imgHeight/imgWidth;
    }
    
    if(_message.messageFrom == ChatMessageFromOther){
        _headerImgRect = CGRectMake(SSChatIconLeft,SSChatCellTop, SSChatIconWH, SSChatIconWH);
        
        _backImgButtonRect = CGRectMake(SSChatIconLeft+SSChatIconWH+SSChatIconRight, self.headerImgRect.origin.y, imgActualHeight, imgActualWidth);
        
        _imageInsets = UIEdgeInsetsMake(SSChatAirTop, SSChatAirLRB, SSChatAirBottom, SSChatAirLRS);
        
    }else{
        _headerImgRect = CGRectMake(SSChatIcon_RX, SSChatCellTop, SSChatIconWH, SSChatIconWH);
        
        _backImgButtonRect = CGRectMake(SSChatIcon_RX-SSChatDetailRight-imgActualWidth, self.headerImgRect.origin.y, imgActualWidth, imgActualHeight);
        
        _imageInsets = UIEdgeInsetsMake(SSChatAirTop, SSChatAirLRS, SSChatAirBottom, SSChatAirLRB);
    }
    
    //判断时间是否显示
    _timeLabRect = CGRectMake(0, 0, 0, 0);
    
    if(_message.showTime==YES){
        
        _timeLabRect = CGRectMake(SCREEN_Width/2-100, SSChatTimeTop, 200, SSChatTimeHeight);
        
        CGRect hRect = self.headerImgRect;
        hRect.origin.y = SSChatTimeTop+SSChatTimeBottom+SSChatTimeHeight;
        self.headerImgRect = hRect;
        
        _backImgButtonRect = CGRectMake(_backImgButtonRect.origin.x, _headerImgRect.origin.y, _backImgButtonRect.size.width, _backImgButtonRect.size.height);
    }
    
    _cellHeight = _backImgButtonRect.size.height + _backImgButtonRect.origin.y + SSChatCellBottom;
    
}


//显示支付定金订单信息
-(void)setOrderValue1{
    
    
}

//显示直接购买订单信息
-(void)setOrderValue2{
    
    
}


//撤销的消息
-(void)setRecallMessage{
    
    
}


//删除的消息
-(void)setRemoveMessage{
    
    
    
}






@end
