//
//  StringUtil.h
//  EInsuranceIphone
//
//  Created by sundanlong on 11-5-8.
//  Copyright 2011 上海网达软件有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface StringUtil : NSObject {

}
+ (NSString *) nsDictionaryToString:(NSDictionary *) dict;
+ (NSDate *) getNsDateByHour:(int) hour;
+ (NSString *)md5:(NSString *)str;
+ (NSString *) appendParam2RequestURLString:(NSString *) requestURLString param:(NSString *) param;
+ (NSString *) removeParam2RequestURLString:(NSString *) requestURLString param:(NSString *) param;
+ (NSString *) bytes2CapacitySize:(unsigned long long) byteSize;
+ (NSDate *) dateString2Date:(NSString *) dateString dateFormat:(NSDateFormatter *) dateFormat;
+ (NSString *) date2DateString:(NSDate *) date dateFormat:(NSDateFormatter *) dateFormat;
+ (NSUInteger) stringVersion2IntVersion:(NSString *) stringVersion;

@end
