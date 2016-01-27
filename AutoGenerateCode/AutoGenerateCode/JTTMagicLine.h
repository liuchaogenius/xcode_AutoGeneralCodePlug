//
//  JTTMagicLine.h
//  JTTMagicLine
//
//  Created by Jymn_Chen on 14-9-8.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JTTMagicLine : NSObject

+ (NSString *)magicButton:(NSString *)aObjceName;

+ (NSString *)magicLabel:(NSString *)aObjceName;

+ (NSString *)magictableview:(NSString *)aObjceName;

+ (NSString *)magicCustomCode:(NSString *)aObjceName key:(NSString *)aKey;
@end
