//
//  JTTMagicLine.m
//  JTTMagicLine
//
//  Created by Jymn_Chen on 14-9-8.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "JTTMagicLine.h"
#import "JTTMagicLineSetting.h"

@implementation JTTMagicLine

/* 获取Magic Line: 91个"/" */
+ (NSString *)magicButton:(NSString *)aObjceName {
    NSMutableString *magicLine = [NSMutableString string];
    NSString *seperator = [NSString stringWithFormat:@"UIButton *%@ = [[UIButton alloc] init];\n %@.backgroundColor = [UIColor clearColor];\n[%@ setTitle:@"" forState:UIControlStateNormal];\n[%@ setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];\n[%@ setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];\n[%@ setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];\%@.titleLabel.font = [UIFont systemFontOfSize:14];\n[%@ addTarget:self action:@selector() forControlEvents:UIControlEventTouchUpInside];\n[self addSubview:%@];",aObjceName,aObjceName,aObjceName,aObjceName,aObjceName,aObjceName,aObjceName,aObjceName,aObjceName];//;
    //for (NSInteger i = 0; i < 91; i++) {
        [magicLine appendString:seperator];
    //}
    return [magicLine copy];
}


+ (NSString *)magicLabel:(NSString *)aObjceName
{
    NSMutableString *magicLine = [NSMutableString string];
    NSString *seperator = [NSString stringWithFormat:@"UILabel *%@ = [[UILabel alloc] init];\n %@.backgroundColor = [UIColor clearColor];\n%@.textColor = [UIColor blackColor];\n%@.font = [UIFont systemFontOfSize:14];\n%@.text = @"";\n%@.textAlignment = NSTextAlignmentLeft;\n[self addSubview:%@];",aObjceName,aObjceName,aObjceName,aObjceName,aObjceName,aObjceName,aObjceName];//;
    //for (NSInteger i = 0; i < 91; i++) {
    [magicLine appendString:seperator];
    //}
    return [magicLine copy];
}

+ (NSString *)magictableview:(NSString *)aObjceName
{
    NSMutableString *magicLine = [NSMutableString string];
    NSString *seperator = [NSString stringWithFormat:@"UITableView *%@ = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 10)];\n%@.delegate = self;\n%@.dataSource = self;\n%@.backgroundColor = [UIColor clearColor];\n//%@.tableHeaderView = [self createTableviewHeadview];\n%@.separatorStyle = UITableViewCellSeparatorStyleNone;\n[self addSubview:%@];",aObjceName,aObjceName,aObjceName,aObjceName,aObjceName,aObjceName,aObjceName];//;
    //for (NSInteger i = 0; i < 91; i++) {
    [magicLine appendString:seperator];
    //}
    return [magicLine copy];
}

+ (NSString *)magicCustomCode:(NSString *)aObjceName key:(NSString *)aKey
{
    NSMutableString *magicLine = [NSMutableString string];
    NSDictionary *dict = [[JTTMagicLineSetting defaultSetting] triggerCustomStringDict];
    NSString *seperator = [dict objectForKey:aKey];//;
    //for (NSInteger i = 0; i < 91; i++) {
    [magicLine appendString:seperator];
    //}
    return [magicLine copy];
}
@end
