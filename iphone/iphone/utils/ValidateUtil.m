//
//  ValidateUtil.m
//  EInsuranceIphone
//
//  Created by sundanlong on 11-3-14.
//  Copyright 2011 上海网达软件有限公司. All rights reserved.
//

#import "ValidateUtil.h"

@implementation ValidateUtil

/**
 *     功能：验证手机号码，验证规则：以1开头的11位数字
 *     参数：
 *         userName        :手机号码
 *     返回：验证手机号码的结果
 */
+(BOOL)validatePhoneMobileNum:(NSString*)userNum {
    int length = [userNum length];
	if (length!=11 || ![userNum hasPrefix:@"1"]) {
		return NO;
	}
    int index = 0;
    for (index = 0; index < length; index++) {
        unichar endCharacter = [userNum characterAtIndex:index];
        if (endCharacter >= '0' && endCharacter <= '9') 
            continue;
        else
            return NO;
    }
    return YES;
}

/**
 *     功能：验证特殊字符，验证规则：非0～9、a～z、A～Z、@、-、_、.的字符
 *     参数：
 *         characters        :待验证的字符串
 *     返回：验证字符串的结果
 */
+(BOOL)verifyCharacters:(NSString*)characters {
    int length = [characters length];
    int index = 0;
    for (index = 0; index < length; index++) {
        unichar endCharacter = [characters characterAtIndex:index];
        if (endCharacter >= '0' && endCharacter <= '9' || endCharacter >= 'a' && endCharacter <= 'z' || endCharacter >= 'A' && endCharacter <= 'Z' || endCharacter == '@' || endCharacter == '-' || endCharacter == '_' || endCharacter == '.') 
            continue;
        else
            return NO;
    }
    return YES;
}

/**
 *     功能：验证必须包含6～16位字母加数字
 *     参数：
 *         characters        :待验证的字符串
 *     返回：验证字符串的结果
 */
+(BOOL)verifyCharactersOrNum:(NSString*)characters {
    int length = [characters length];
    if (length < 6 || length > 16) {
		return NO;
	}
    int index = 0;
    for (index = 0; index < length; index++) {
        unichar endCharacter = [characters characterAtIndex:index];
        if (endCharacter >= '0' && endCharacter <= '9' || endCharacter >= 'a' && endCharacter <= 'z' || endCharacter >= 'A' && endCharacter <= 'Z' || endCharacter == '@' || endCharacter == '-' || endCharacter == '_' || endCharacter == '.') 
            continue;
        else
            return NO;
    }
    
    for (index = 0; index < length; index++) {//
        unichar endCharacter = [characters characterAtIndex:index];
        if ((endCharacter >= '0' && endCharacter <= '9') || endCharacter == '@' || endCharacter == '-' || endCharacter == '_' || endCharacter == '.' ) {
            continue;
        } else {
            break;
        }
    }    
    if(index == length) return NO;
    
    for (index = 0; index < length; index++) {
        unichar endCharacter = [characters characterAtIndex:index];
        if (!(endCharacter >= 'a' && endCharacter <= 'z' || endCharacter >= 'A' && endCharacter <= 'Z'))  break;
    }
    if(index == length) return NO;
    return YES;
}

/**
 *     功能：验证密码，验证规则：0～9、a～z、A～Z组合的6～16位字符串
 *     参数：
 *         password        :待验证的字符串
 *     返回：验证密码的结果
 */
+(BOOL)validatePassword:(NSString*)password {
    int length = [password length];
	if (length < 6 || length > 16) {
		return NO;
	}
    int index = 0;
    for (index = 0; index < length; index++) {
        unichar endCharacter = [password characterAtIndex:index];
        if (endCharacter >= '0' && endCharacter <= '9' || endCharacter >= 'a' && endCharacter <= 'z' || endCharacter >= 'A' && endCharacter <= 'Z') 
            continue;
        else
            return NO;
    }
    return YES;
}

/**
 *     功能：验证验证码，验证规则：0～9组合的4位字符串
 *     参数：
 *         validateCode        :待验证的字符串
 *     返回：验证验证码的结果
 */
+(BOOL)validateValidateCode:(NSString*)validateCode {
    int length = [validateCode length];
	if (length != 4) {
		return NO;
	}
    int index = 0;
    for (index = 0; index < length; index++) {
        unichar endCharacter = [validateCode characterAtIndex:index];
        if (endCharacter >= '0' && endCharacter <= '9') 
            continue;
        else
            return NO;
    }
    return YES;
}

/**
 *     功能：保存用户信息至本地
 *     参数：
 *         userInfoDic        :用户信息Dictionary
 *     返回：void
 */
+(void)saveUserInfoToUserDefaults:(NSMutableDictionary *)userInfoDic{
	NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
	[userDefault setValuesForKeysWithDictionary:userInfoDic];	
	[userDefault synchronize];
}

+ (BOOL) isNULLString:(NSString *) str {
    if (!str) {
        return YES;
    }
    return [@"" isEqual:str] || [@"(null)" isEqual:str] || [@"<null>" isEqual:str];
}

@end
