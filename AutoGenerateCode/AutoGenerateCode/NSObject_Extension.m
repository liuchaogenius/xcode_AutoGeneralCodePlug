//
//  NSObject_Extension.m
//  AutoGenerateCode
//
//  Created by  striveliu on 16/1/4.
//  Copyright © 2016年  striveliu. All rights reserved.
//


#import "NSObject_Extension.h"
#import "AutoGenerateCode.h"

@implementation NSObject (Xcode_Plugin_Template_Extension)

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[AutoGenerateCode alloc] initWithBundle:plugin];
        });
    }
}
@end
