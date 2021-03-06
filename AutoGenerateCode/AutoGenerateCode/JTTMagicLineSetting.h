//
//  JTTMagicLineSetting.h
//  JTTMagicLine
//
//  Created by Jymn_Chen on 14-9-8.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JTTMagicLineSetting : NSObject

+ (JTTMagicLineSetting *)defaultSetting;

- (NSString *)triggerString;

- (NSString *)triggerLabelString;

- (NSString *)triggerTableviewString;

- (NSDictionary *)triggerCustomStringDict;

- (BOOL)useDvorakLayout;

@end
