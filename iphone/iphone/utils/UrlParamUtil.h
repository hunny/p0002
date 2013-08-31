//
//  UrlParamUtil.h
//  EInsuranceIphone
//
//  Created by yang on 13-3-25.
//
//

#import <Foundation/Foundation.h>

@interface UrlParamUtil : NSObject

+ (NSDictionary *)getParamsFromUrl:(NSURL *)url;

@end
