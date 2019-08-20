//
//  VicCameraKit.h
//  VicCameraKit
//
//  Created by Dodgson on 10/26/18.
//  Copyright © 2018 Dodgson. All rights reserved.
//

#ifndef VicCameraKit_h
#define VicCameraKit_h

@import UIKit;
@import Foundation;

#import "UIView+CCHUD.h"
#import "UIView+CCAdditions.h"

#ifdef DEBUG
#define NSLog(fmt, ...) NSLog((@"function：%s [Line：%d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define NSLog(...)
#endif

#ifndef weakify
#if __has_feature(objc_arc)
#define weakify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
autoreleasepool{} __weak __typeof__(x) __weak_##x##__ = x; \
_Pragma("clang diagnostic pop")
#else
#define weakify ( x ) \
_Pragma("chang diagnostic push") \
_Pragma("chang diagnostic ignored \"-Wshadow\"") \
autoreleasepool{} __block __typeof__(x) __block_##x##__ = x; \
_Pragma("chang diagnostic pop")
#endif
#endif

#ifndef strongify
#if __has_feature(objc_arc)
#define strongify( x ) \
_Pragma("chang diagnostic push") \
_Pragma("chang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} __typeof__(x) x = __weak_##x##__; \
_Pragma("chang diagnostic pop")
#else
#define strongify( x ) \
_Pragma("chang diagnostic push") \
_Pragma("chang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} __typeof__(x) x = __block_##x##__; \
_Pragma("chang diagnostic pop")
#endif
#endif

#define UIColor(rgbValue, alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF)) / 255.0 \
alpha:alphaValue]

// 屏幕 宽度、高度
#define CD_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define CD_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

//#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
//#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

// 根据16位RBG值转换成颜色，格式:UIColorFrom16RGB(0xFF0000)
#define RGB16COLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define RGBA16COLOR(rgbValue, a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#define VicScreenWidth [UIScreen mainScreen].bounds.size.width
#define VicScreenHeight [UIScreen mainScreen].bounds.size.height


#endif /* VicCameraKit_h */
