//
//  UrlParamUtil.m
//  EInsuranceIphone
//
//  Created by yang on 13-3-25.
//
//

#import "UrlParamUtil.h"
#define MAIN_FOLDER_NAME @"www"

@implementation UrlParamUtil

+ (NSDictionary *)getParamsFromUrl:(NSURL *)url
{
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    
    NSString *requestURLString = [NSString stringWithFormat:@"%@",url];
    
    NSArray *urlArray = [requestURLString componentsSeparatedByString:@"?"];
    
    if (urlArray.count < 2) {
        return paramsDict;
    }
    
    NSArray *paramArray = [[urlArray objectAtIndex:1] componentsSeparatedByString:@"&"];

    for (int i = 0; i < paramArray.count; i++) {
        NSString *paramOne = [paramArray objectAtIndex:i];
        NSArray *keyValue = [paramOne componentsSeparatedByString:@"="];
        
        if (keyValue.count == 2) {
            //CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2
            NSString * _dataString = [[[keyValue objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [paramsDict setObject:_dataString forKey:[keyValue objectAtIndex:0]];
        }
    }
    
    return paramsDict;
}

- (NSString*)pathForResource:(NSString*)resourcepath
{
    return [self pathForResource:resourcepath andType:@""];
}

- (NSString*)pathForResource:(NSString*)resourcepath andType:(NSString*)type
{
    NSBundle* mainBundle = [NSBundle mainBundle];
    NSMutableArray* directoryParts = [NSMutableArray arrayWithArray:[resourcepath componentsSeparatedByString:@"/"]];
    NSString* filename = [directoryParts lastObject];
    [directoryParts removeLastObject];
    
    NSString* directoryPartsJoined = [directoryParts componentsJoinedByString:@"/"];
    NSString* directoryStr = MAIN_FOLDER_NAME;
    
    if ([directoryPartsJoined length] > 0) {
        directoryStr = [NSString stringWithFormat:@"%@/%@", MAIN_FOLDER_NAME, [directoryParts componentsJoinedByString:@"/"]];
    }
    
    return [mainBundle pathForResource:filename ofType:type inDirectory:directoryStr];
}

@end
