//
//  AutoGenerateCode.h
//  AutoGenerateCode
//
//  Created by  striveliu on 16/1/4.
//  Copyright © 2016年  striveliu. All rights reserved.
//

#import <AppKit/AppKit.h>

@class AutoGenerateCode;

static AutoGenerateCode *sharedPlugin;

@interface AutoGenerateCode : NSObject

+ (instancetype)sharedPlugin;
- (id)initWithBundle:(NSBundle *)plugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;
@end