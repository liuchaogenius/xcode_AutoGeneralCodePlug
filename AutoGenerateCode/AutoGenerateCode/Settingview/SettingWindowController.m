//
//  SettingWindowController.m
//  AutoGenerateCode
//
//  Created by  striveliu on 16/1/20.
//  Copyright © 2016年  striveliu. All rights reserved.
//

#import "SettingWindowController.h"

@interface SettingWindowController ()
@property (strong) IBOutlet NSButton *saveButton;
@property (strong) IBOutlet NSTextField *keyTextField;
@property (strong) IBOutlet NSTextView *valueTextview;
@property (strong) IBOutlet NSButtonCell *removeKeysButton;

@end

@implementation SettingWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    [self.saveButton setTarget:self];
    [self.saveButton setAction:@selector(saveContentItem)];
    [self.removeKeysButton setTarget:self];
    [self.removeKeysButton setAction:@selector(removeAllkeys)];
}

- (void)saveContentItem
{
    NSMutableDictionary *saveDict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *strkey = self.keyTextField.stringValue;
    NSString *strvalue = self.valueTextview.string;
    [saveDict setObject:strvalue forKey:strkey];
    [[NSUserDefaults standardUserDefaults] setObject:saveDict forKey:@"autogeneratecode"];
}

- (void)removeAllkeys
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"autogeneratecode"];
}
@end
