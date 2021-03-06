//
//  ChatKeyBoardDatas.h
//  gt
//
//  Created by cookie on 2018/12/31.
//  Copyright © 2018 GT. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "Define.h"
#import "UIView+SSAdd.h"

/**
 底部按钮点击的五种状态
 
 - SSChatBottomTypeDefault: 默认在底部的状态
 - SSChatBottomTypeVoice: 准备发语音的状态
 - SSChatBottomTypeEdit: 准备编辑文本的状态
 - SSChatBottomTypeSymbol: 准备发送表情的状态
 - SSChatBottomTypeAdd: 准备发送其他功能的状态
 */
typedef NS_ENUM(NSInteger,ChatKeyBoardStatus) {
    SSChatKeyBoardStatusDefault=1,
    SSChatKeyBoardStatusVoice,
    SSChatKeyBoardStatusEdit,
    SSChatKeyBoardStatusSymbol,
    SSChatKeyBoardStatusAdd,
};



/**
 弹出多功能界面是表情还是其他功能
 
 - KeyBordViewFouctionSymbol: 表情
 - KeyBordViewFouctionAdd: 多功能
 */
typedef NS_ENUM(NSInteger,KeyBordViewFouctionType) {
    KeyBordViewFouctionAdd=1,
    KeyBordViewFouctionSymbol,
};






