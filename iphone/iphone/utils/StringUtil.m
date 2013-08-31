//
//  StringUtil.m
//  EInsuranceIphone
//
//  Created by sundanlong on 11-5-8.
//  Copyright 2011 上海网达软件有限公司. All rights reserved.
//

#import "StringUtil.h"
#import "ValidateUtil.h"
#import <CommonCrypto/CommonDigest.h> // Need to import for CC_MD5 access

@implementation StringUtil

+ (NSString *) nsDictionaryToString:(NSDictionary *) dict
{
    NSMutableString *muStr=[NSMutableString new];
    NSArray * arrKeys=[dict allKeys];
    for (int i=0; i<[arrKeys count]; i++) {
        [muStr appendFormat:@"%@=%@ ",[arrKeys objectAtIndex:i],(NSString *)[dict valueForKey:[arrKeys objectAtIndex:i]]];
    }
    return (NSString *)muStr;
}

+ (NSDate *) getNsDateByHour:(int) hour
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    NSDate *date = [NSDate date];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    
    comps = [calendar components:unitFlags fromDate:date];
    
    comps.hour=hour;
    comps.minute=0;
    comps.second=0;
    
    return [comps date];
}

+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    
    unsigned char result[16];
    
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            
            result[0], result[1], result[2], result[3],
            
            result[4], result[5], result[6], result[7],
            
            result[8], result[9], result[10], result[11],
            
            result[12], result[13], result[14], result[15]
            
            ]; 
    
}

/**
 *     功能：在请求的URL后拼接参数
 *     参数：
 *         requestURLString :请求URL字符串
 *         param            :参数对，格式：userName=admin
 *     返回：拼接后的URL字符串
 */
+(NSString*)appendParam2RequestURLString:(NSString*)requestURLString param:(NSString*) param{
	if (requestURLString == nil || [requestURLString isEqual:@""] || 
		param == nil || [param isEqual:@""] || [param hasPrefix:@"="]
		|| [param rangeOfString:@"="].location == NSNotFound
		|| [requestURLString rangeOfString:@"http://"].location == NSNotFound) {
		return requestURLString;
	}
	if ([requestURLString rangeOfString:@"?"].location != NSNotFound){
		if ([requestURLString hasSuffix:@"?"]) {
			requestURLString = [requestURLString stringByAppendingString:param];
		} else {
			requestURLString = [requestURLString stringByAppendingFormat:@"&%@", param];
		}
	} else {
		requestURLString = [requestURLString stringByAppendingFormat:@"?%@", param];
	}
	return requestURLString;
}

/**
 *     功能：在请求的URL中移去参数
 *     参数：
 *         requestURLString :请求URL字符串
 *         param            :参数对，格式：userName=admin
 *     返回：移去参数后的URL字符串
 */
+(NSString*)removeParam2RequestURLString:(NSString*)requestURLString param:(NSString*) param {
	if (requestURLString == nil || [requestURLString isEqual:@""] || 
		param == nil || [param isEqual:@""] || [param hasPrefix:@"="]
		|| [param rangeOfString:@"="].location == NSNotFound
		|| [requestURLString rangeOfString:@"http://"].location == NSNotFound) {
		return requestURLString;
	}
	if ([requestURLString rangeOfString:[NSString stringWithFormat:@"?%@", param]].location != NSNotFound){
		if ([requestURLString hasSuffix:[NSString stringWithFormat:@"?%@", param]]) {
            
			requestURLString = [[NSString stringWithFormat:@"%@",[[requestURLString componentsSeparatedByString:[NSString stringWithFormat:@"?%@", param]] objectAtIndex:0]] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                            
		} else {
			requestURLString = [[NSString stringWithFormat:@"%@",[[requestURLString componentsSeparatedByString:[NSString stringWithFormat:@"%@&", param]] objectAtIndex:0]] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		}
	} else if ([requestURLString rangeOfString:[NSString stringWithFormat:@"&%@", param]].location != NSNotFound) {
		requestURLString = [[NSString stringWithFormat:@"%@",[[requestURLString componentsSeparatedByString:[NSString stringWithFormat:@"&%@", param]] objectAtIndex:0]] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	}
	return requestURLString;
}

/**
 *     功能：字节数换算
 *     参数：
 *         byteSize :字节大小
 *     返回：换算后拼接的字节大小字符串信息
 */
+(NSString*)bytes2CapacitySize:(unsigned long long)byteSize {
    if (byteSize < 1024) {
        return [NSString stringWithFormat:@"%qi K", byteSize];
    }
    byteSize = byteSize/1024;
    if (byteSize < 1024) {
        return [NSString stringWithFormat:@"%qi KB", byteSize];
    }
    byteSize = byteSize/1024;
    if (byteSize < 1024) {
        return [NSString stringWithFormat:@"%qi MB", byteSize];
    }
    byteSize = byteSize/1024;
    if (byteSize < 1024) {
        return [NSString stringWithFormat:@"%qi GB", byteSize];
    }
    byteSize = byteSize/1024;
    return [NSString stringWithFormat:@"%qi TB", byteSize];
}

/**
 *     功能：日期转换（日期字符串转换为日期）
 *     参数：
 *         dateString :日期字符串
 *         dateFormat :日期格式
 *     返回：转换后的日期
 */
+ (NSDate *) dateString2Date:(NSString *) dateString dateFormat:(NSDateFormatter *) dateFormat {
    if ([ValidateUtil isNULLString:dateString]) {
        return nil;
    }
    
    if(dateFormat == nil) {
        dateFormat = [[NSDateFormatter alloc] init];
    }
    if ([ValidateUtil isNULLString:[dateFormat dateFormat]]) {//默认日期字符串格式为：yyyy-MM-dd
        [dateFormat setDateFormat: @"yyyy-MM-dd"];
    }
    return [dateFormat dateFromString:dateString];
}

/**
 *     功能：日期转换（日期转换为日期字符串）
 *     参数：
 *         date       :日期
 *         dateFormat :日期格式
 *     返回：转换后的日期字符串
 */
+ (NSString *) date2DateString:(NSDate *) date dateFormat:(NSDateFormatter *) dateFormat {
    if (!date) {
        return nil;
    }
    if(dateFormat == nil) {
        dateFormat = [[NSDateFormatter alloc] init];
    }
    if ([ValidateUtil isNULLString:[dateFormat dateFormat]]) {
        [dateFormat setDateFormat: @"yyyy-MM-dd"];
    }
    return [dateFormat stringFromDate:date];
}

/**
 *     功能：将以“.”分隔的字符串版本号转成数值，以便进行版本比较
 *     转换规则：以“.”分隔的字符串版本号的前两位，每位权值100
 *     参数：
 *         date       :字符串版本号
 *     返回：字符串版本号数值
 */
+ (NSUInteger) stringVersion2IntVersion:(NSString *) stringVersion {    
//    NSLog(@"current os version  = %@", [UIDevice currentDevice].systemVersion);
//    NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"3.1.3" options: NSNumericSearch];
//    if (order == NSOrderedSame || order == NSOrderedDescending) {
//        // OS version >= 3.1.3
//        
//        NSLog(@"OS version >= 3.1.3");
//    } else {
//        // OS version < 3.1.3
//        NSLog(@"OS version < 3.1.3");
//    }
    NSUInteger intVersion = 0;
    if (stringVersion == NULL || [@"" isEqualToString:stringVersion]) {
        return intVersion;
    }
    NSArray *array = [stringVersion componentsSeparatedByString:@"."];
    intVersion += [[array objectAtIndex:0] intValue] * 10000;
    intVersion += [[array objectAtIndex:1] intValue] * 100;
    return intVersion;
}

@end
