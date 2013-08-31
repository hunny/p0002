//
//  ValidateUtil.h
//  EInsuranceIphone
//
//  Created by sundanlong on 11-3-14.
//  Copyright 2011 上海网达软件有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ValidateUtil : NSObject {

}

+(BOOL)validatePassword:(NSString*)password;
+(BOOL)verifyCharacters:(NSString*)characters;
+(BOOL)verifyCharactersOrNum:(NSString*)characters;
+(BOOL)validatePhoneMobileNum:(NSString*)userNum;
+(BOOL)validateValidateCode:(NSString*)validateCode;
+(void)saveUserInfoToUserDefaults:(NSMutableDictionary *)userInfoDic;
+ (BOOL) isNULLString:(NSString *) str;
@end
