//
//  NSString+YBCodec.h
//  Aa
//
//  Created by Aalto on 2018/11/20.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger,InputCharType){
    InputCharNone = 0 ,
    InputCharChinese  ,
    InputCharOnlyUpperEnglish  ,
    InputCharOnlyLowerEnglish ,
    InputCharOnlyNumber ,
    
    InputCharLoseUpperEnglish  ,
    InputCharLoseLowerEnglish ,
    InputCharLoseNumber ,
    
    InputCharAll  ,
};

@interface NSString (Extras)
+(BOOL)judgeIsDoubleStr:(NSString *)str1 with:(NSString *)str2;
+(BOOL)isContainAllCharType:(NSString*)originString;
+(InputCharType)getInputCharType:(NSString*)originString;
+(NSString*)getPaywayAppendingString:(NSString*)payString;

- (NSString *)yb_encodingUTF8;

- (NSString *)yb_MD5;

- (BOOL)match:(NSString *)express;

+ (BOOL)isPureInt:(NSString *)string;

+(BOOL)isHaveWhiteSpace:(NSString *)text;
+(NSString* )getTimeString:(NSString *)timeStampString;
+ (BOOL)isEmpty:(NSString *)text;
+ (id)isValueNSStringWith:(NSString *)str;
+ (BOOL)getDataSuccessed:(NSDictionary *)dic;
+(BOOL)getLNDataSuccessed:(NSDictionary *)dic;
+ (BOOL)isAllZeroInString:(NSString*)originString;
+ (NSString*)getAnonymousString:(NSString* )originString;
+ (NSString *)timeWithSecond:(NSInteger)second;
- (NSString *)subStringFrom:(NSString *)startString to:(NSString *)endString;
+ (NSMutableAttributedString *)attributedReverseStringWithString:(NSString *)string stringColor:(UIColor*)scolor stringFont:(UIFont*)sFont subString:(NSString *)subString subStringColor:(UIColor*)subStringcolor subStringFont:(UIFont*)subStringFont numInSubColor:(UIColor*)numInSubColor numInSubFont:(UIFont*)numInSubFont;
+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)string stringColor:(UIColor*)scolor stringFont:(UIFont*)sFont subString:(NSString *)subString subStringColor:(UIColor*)subStringcolor subStringFont:(UIFont*)subStringFont numInSubColor:(UIColor*)numInSubColor numInSubFont:(UIFont*)numInSubFont;

+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)string stringColor:(UIColor*)scolor stringFont:(UIFont*)sFont subString:(NSString *)subString subStringColor:(UIColor*)subStringcolor subStringFont:(UIFont*)subStringFont;
+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)string stringColor:(UIColor*)scolor stringFont:(UIFont*)sFont subString:(NSString *)subString subStringColor:(UIColor*)subStringcolor subStringFont:(UIFont*)subStringFont subStringUnderlineColor:(UIColor*)underlineColor;
+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)string stringColor:(UIColor*)scolor image:(UIImage *)image;

+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)string stringColor:(UIColor*)scolor image:(UIImage *)image isImgPositionOnlyLeft:(BOOL)isOnlyLeft;

+ (CGFloat)getAttributeContentHeightWithAttributeString:(NSAttributedString*)atributedString withFontSize:(float)fontSize boundingRectWithWidth:(CGFloat)width;
+ (CGFloat)getContentHeightWithParagraphStyleLineSpacing:(CGFloat)lineSpacing fontWithString:(NSString*)fontWithString fontOfSize:(CGFloat)fontOfSize boundingRectWithWidth:(CGFloat)width;

+(CGFloat)getTextWidth:(NSString *)string withFontSize:(UIFont *)font withHeight:(CGFloat)height;

+(CGFloat)calculateTextWidth:(NSString *)string withFontSize:(float)fontSize withWidth:(float)width;
+(CGFloat)calculateAttributeTextWidth:(NSAttributedString *)atributedString withFontSize:(float)fontSize withWidth:(float)width;
+(NSString *)convertToJsonData:(NSDictionary *)dict;


//判断是否含有表情符号 yes-有 no-没有
+ (BOOL)stringContainsEmoji:(NSString *)string ;
//是否是系统自带九宫格输入 yes-是 no-不是
+ (BOOL)isNineKeyBoard:(NSString *)string;
//判断第三方键盘中的表情
+ (BOOL)hasEmoji:(NSString*)string;
//去除表情
+ (NSString *)disableEmoji:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
