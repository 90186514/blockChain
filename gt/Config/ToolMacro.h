//
//  ToolMacro.h
//  Aa
//
//  Created by Aalto on 2018/11/18.
//  Copyright © 2018 Aalto. All rights reserved.
//

#ifndef ToolMacro_h
#define ToolMacro_h

#pragma mark - 其他
#define FaceAuthAutoPhotoCount 3
#define ReuseIdentifier NSStringFromClass ([self class])

#pragma mark - 本地化字符串
/** NSLocalizedString宏做的其实就是在当前bundle中查找资源文件名“Localizable.strings”(参数:键＋注释) */
#define LocalString(x, ...)     NSLocalizedString(x, nil)
/** NSLocalizedStringFromTable宏做的其实就是在当前bundle中查找资源文件名“xxx.strings”(参数:键＋文件名＋注释) */
#define AppLocalString(x, ...)  NSLocalizedStringFromTable(x, @"someName", nil)
#define LRToast(str) [NSString stringWithFormat:@"%@",@#str]

#pragma mark - Keys & OtherConfig
#define PhotoEndPoint @"oss-cn-hongkong.aliyuncs.com"
#define SERVICE_ID @"KEFU155119713095416"
//se
#define JPush_Key  @"d27651c3960383fb99f2a7e6"
#define JPush_Channel @"Publish channel"
//外包的
//#define JPush_Key  @"b07cefbde8fee58c3a22d6aa"
//#define JPush_Channel @"App Store"
#define RongCloud_Key @"qd46yzrfqp0af" //dis
//#define RongCloud_Key @"25wehl3u2gq4w" //外包的dev
#define WYVertifyID_Key @"af45977d53044827af6ee8968a3d550e"
#define AliYun_Key @"LTAIJ02GVyFdCID8"
#define AliYun_Secret @"hkYskQyGqrsvfAqDbTjezR6396OYwu"



#pragma mark -单例模式宏
#define MACRO_SHARED_INSTANCE_INTERFACE +(instancetype)sharedInstance;
#define MACRO_SHARED_INSTANCE_IMPLEMENTATION(CLASS) \
+(instancetype)sharedInstance \
{ \
static CLASS * sharedInstance = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
sharedInstance = [[CLASS alloc] init]; \
}); \
return sharedInstance; \
}

#pragma mark -kAPPDelegate宏
#define kAPPDelegate ((AppDelegate*)[UIApplication sharedApplication].delegate)

#pragma mark - 重写NSLog,Debug模式下打印日志和当前行数
#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

#else
#define NSLog(FORMAT, ...) nil
#endif


#pragma mark - 手机系统\型号相关
#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#define IS_IPHONE4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONE5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONE6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size)) : NO)
#define IS_IPHONE6_PLUS_SCALE ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONE6_PLUS ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

///判断手机是否为iPhone X 及其以上机型（根据屏幕长度来进行判断）
#define isiPhoneX_series ([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.height == 896)

///之前留下的
#define VicNativeHeight [UIScreen mainScreen].nativeBounds.size.height
#define VicScreenScale [UIScreen mainScreen].scale
#define VicNavigationHeight (VicNativeHeight == 812.000000*VicScreenScale ? 84.f : 64.f)
#define VicRateW(value) ([UIScreen mainScreen].nativeBounds.size.width == 375*[UIScreen mainScreen].scale ? value : value*[UIScreen mainScreen].nativeBounds.size.width/(375*[UIScreen mainScreen].scale))
#define VicRateH(value) ([UIScreen mainScreen].nativeBounds.size.height == 667*[UIScreen mainScreen].scale ? value : value*[UIScreen mainScreen].nativeBounds.size.height/(667*[UIScreen mainScreen].scale))

///自读屏宽高
#define MAINSCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define MAINSCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height

///系统控件高度
#define rectOfStatusbar [[UIApplication sharedApplication] statusBarFrame].size.height//获取状态栏的高
#define rectOfNavigationbar self.navigationController.navigationBar.frame.size.height//获取导航栏的高
///根据ip6的屏幕来拉伸
#define kRealValue(with)((with)*(([[UIScreen mainScreen] bounds].size.width)/375.0f))
///缩放比例
#define SCALING_RATIO ([[UIScreen mainScreen] bounds].size.width)/375
#define kGETVALUE_HEIGHT(width,height,limit_width) ((limit_width)*(height)/(width))

#define kHeightForListHeaderInSections 5

#pragma mark - 色彩相关
#define kTableViewBackgroundColor HEXCOLOR(0xf6f5fa)
///RGB颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue)\
\
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]
///常见颜色
#define kClearColor     [UIColor clearColor]
#define kBlackColor     [UIColor blackColor]
#define kWhiteColor     [UIColor whiteColor]
#define kGrayColor      [UIColor grayColor]
#define kOrangeColor    [UIColor orangeColor]
#define kRedColor       [UIColor redColor]


///RGB颜色
#define RGBSAMECOLOR(x) [UIColor colorWithRed:(x)/255.0 green:(x)/255.0 blue:(x)/255.0 alpha:1]
#define COLOR_RGB(r,g,b,a)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define RANDOMRGBCOLOR RGBCOLOR((arc4random() % 256), (arc4random() % 256), (arc4random() % 256))
#define RGBCOLOR(r,g,b)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
///随机颜色
#define RandomColor [UIColor colorWithRed:arc4random_uniform(256) / 255.0 \
green:arc4random_uniform(256) / 255.0 \
blue:arc4random_uniform(256) / 255.0 \
alpha:1] \
///十六进制颜色
#define HEXCOLOR(hexValue)  [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1]
#define COLOR_HEX(hexValue, al)  [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:al]

#pragma mark - 字体
#define kFontSize(x) [UIFont systemFontOfSize:x]

#pragma mark - 图片
#define kIMG(imgName) [UIImage imageNamed:imgName]

#pragma mark - 时间相关
/** 时间间隔 */
#define kHUDDuration            (1.f)
/** 一天的秒数 */
#define SecondsOfDay            (24.f * 60.f * 60.f)
/** 秒数 */
#define Seconds(Days)           (24.f * 60.f * 60.f * (Days))
/** 一天的毫秒数 */
#define MillisecondsOfDay       (24.f * 60.f * 60.f * 1000.f)
/** 毫秒数 */
#define Milliseconds(Days)      (24.f * 60.f * 60.f * 1000.f * (Days))

#pragma mark - 队列相关
///异步获取某个队列
#define GET_QUEUE_ASYNC(queue, block)\
if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(queue)) == 0) {\
block();\
} else {\
dispatch_async(queue, block);\
}
///获取主队列
#define GET_MAIN_QUEUE_ASYNC(block) GET_QUEUE_ASYNC(dispatch_get_main_queue(), block)

#pragma mark - UserDefault
#define SetUserDefaultKeyWithObject(key,object) [[NSUserDefaults standardUserDefaults] setObject:object forKey:key]
#define SetUserBoolKeyWithObject(key,object) [[NSUserDefaults standardUserDefaults] setBool:object forKey:key]
#define GetUserDefaultWithKey(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define GetUserDefaultBoolWithKey(key) [[NSUserDefaults standardUserDefaults] boolForKey:key]
#define DeleUserDefaultWithKey(key) [[NSUserDefaults standardUserDefaults] removeObjectForKey:key]
#define UserDefaultSynchronize  [[NSUserDefaults standardUserDefaults] synchronize]

#pragma mark - 沙盒路径
#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#pragma mark - 强弱引用
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self
#define kWeakSelf(type)  __weak typeof(type) weak##type = type
#define kStrongSelf(type)  __strong typeof(type) type = weak##type

#pragma mark - 融云
#define RCDLocalizedString(key) NSLocalizedStringFromTable(key, @"SealTalk", nil)

#endif /* ToolMacro_h */
