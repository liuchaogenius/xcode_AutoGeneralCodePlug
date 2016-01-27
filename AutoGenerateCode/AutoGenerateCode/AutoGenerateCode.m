//
//  AutoGenerateCode.m
//  AutoGenerateCode
//
//  Created by  striveliu on 16/1/4.
//  Copyright © 2016年  striveliu. All rights reserved.
//

#import "AutoGenerateCode.h"
#import "JTTTextResult.h"
#import "NSTextView+JTTTextGetter.h"
#import "JTTKeyboardEventSender.h"
#import "JTTMagicLineSetting.h"
#import "JTTMagicLine.h"
#import "SettingWindowController.h"

@interface AutoGenerateCode()

@property (nonatomic, strong, readwrite) NSBundle *bundle;

@property (nonatomic, strong) id eventMonitor;

@property (nonatomic, strong) SettingWindowController *settingPanel;
@end

@implementation AutoGenerateCode

+ (instancetype)sharedPlugin
{
    return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)plugin
{
    if (self = [super init]) {
        // reference to plugin's bundle, for resource access
        self.bundle = plugin;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didApplicationFinishLaunchingNotification:)
                                                     name:NSApplicationDidFinishLaunchingNotification
                                                   object:nil];
    }
    return self;
}

- (void)didApplicationFinishLaunchingNotification:(NSNotification*)noti
{
    //removeObserver
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textStorageDidChange:)
                                                 name:NSTextDidChangeNotification
                                               object:nil];

    // Create menu items, initialize UI, etc.
    // Sample Menu Item:
    NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"Window"];
    if (menuItem) {
        [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
        NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"AutoGenerateCode" action:@selector(doMenuAction) keyEquivalent:@"F"];
        //[actionMenuItem setKeyEquivalentModifierMask:NSAlphaShiftKeyMask | NSControlKeyMask];
        [actionMenuItem setTarget:self];
        [[menuItem submenu] addItem:actionMenuItem];
    }
}


- (void)textStorageDidChange:(NSNotification *)aNotification
{
    if ([[aNotification object] isKindOfClass:[NSTextView class]])
    {
        NSTextView *textView = (NSTextView *)[aNotification object];
        JTTTextResult *currentLineResult = [textView jtt_textResultOfCurrentLine];
        if (!currentLineResult) {
            return;
        }

        NSString *triggerButtonString = [[JTTMagicLineSetting defaultSetting] triggerString];
        NSString *triggerLabelString = [[JTTMagicLineSetting defaultSetting] triggerLabelString];
        NSString *triggerTableviewString = [[JTTMagicLineSetting defaultSetting] triggerTableviewString];
        NSDictionary *triggerKeyDict = [[JTTMagicLineSetting defaultSetting] triggerCustomStringDict];
        //NSMutableArray *patternArry = [NSMutableArray arrayWithCapacity:0];
        NSError *error = nil;
        //NSMutableArray *regexArry = [NSMutableArray arrayWithCapacity:0];
        for(NSString *key in [triggerKeyDict allKeys])
        {
            error = nil;
            NSString *pattern = [NSString stringWithFormat:@"\\s*%@", key];
            
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionAllowCommentsAndWhitespace error:&error];
            if(error)
            {
                continue;
            }
            NSUInteger matches = [regex numberOfMatchesInString:currentLineResult.string options:0 range:NSMakeRange(0, currentLineResult.string.length)];
            if(matches > 0)
            {
                [self autoGenerateControlCode:currentLineResult trig:key type:5];
            }
        }
        
        
        NSString *pattern_button = [NSString stringWithFormat:@"\\s*%@", triggerButtonString];
        NSString *pattern_label = [NSString stringWithFormat:@"\\s*%@", triggerLabelString];
        NSString *pattern_tableview = [NSString stringWithFormat:@"\\s*%@", triggerTableviewString];
        
        NSRegularExpression *regex_button = [NSRegularExpression regularExpressionWithPattern:pattern_button options:NSRegularExpressionAllowCommentsAndWhitespace error:&error];
        NSRegularExpression *regex_label = [NSRegularExpression regularExpressionWithPattern:pattern_label options:NSRegularExpressionAllowCommentsAndWhitespace error:&error];
        
        NSRegularExpression *regex_tableview = [NSRegularExpression regularExpressionWithPattern:pattern_tableview options:NSRegularExpressionAllowCommentsAndWhitespace error:&error];
        if (error) {
            return;
        }
        
        NSUInteger matches_button = [regex_button numberOfMatchesInString:currentLineResult.string options:0 range:NSMakeRange(0, currentLineResult.string.length)];
        NSUInteger matches_label = [regex_label numberOfMatchesInString:currentLineResult.string options:0 range:NSMakeRange(0, currentLineResult.string.length)];
        NSUInteger matches_tableview = [regex_tableview numberOfMatchesInString:currentLineResult.string options:0 range:NSMakeRange(0, currentLineResult.string.length)];
        if (matches_button > 0) {
            [self autoGenerateControlCode:currentLineResult trig:triggerButtonString type:0];
        }
        else if(matches_label > 0)
        {
            [self autoGenerateControlCode:currentLineResult trig:triggerLabelString type:1];
        }
        else if(matches_tableview > 0)
        {
            [self autoGenerateControlCode:currentLineResult trig:triggerTableviewString type:3];
        }
    }

}

- (void)autoGenerateControlCode:(JTTTextResult*)currentLineResult
                        trig:(NSString *)triggerString
                        type:(int)aType
{

    NSMutableString *objcName = [[NSMutableString alloc] initWithString:currentLineResult.string];
    [objcName replaceOccurrencesOfString:triggerString
                              withString:@""
                                 options:NSLiteralSearch
                                   range:NSMakeRange(0, [objcName length])];
    
    NSString *magicLine = nil;
    if(aType == 0)
    {
        magicLine = [JTTMagicLine magicButton:objcName];
    }
    else if(aType == 1)
    {
        magicLine = [JTTMagicLine magicLabel:objcName];
    }
    else if(aType == 3)
    {
        magicLine = [JTTMagicLine magictableview:objcName];
    }
    else if(aType == 5)
    {
        magicLine = [JTTMagicLine magicCustomCode:objcName key:triggerString];
    }
    if (!magicLine) {
        return;
    }
    
    NSPasteboard *pasteBoard = [NSPasteboard generalPasteboard];
    NSString *originPBString = [pasteBoard stringForType:NSPasteboardTypeString];
    
    // Set the magic line in it
    [pasteBoard declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:nil];
    [pasteBoard setString:magicLine forType:NSStringPboardType];
    
    JTTKeyboardEventSender *simKeyboard = [[JTTKeyboardEventSender alloc] init];
    [simKeyboard beginKeyBoradEvents];
    // Command + delete: delete current line
    [simKeyboard sendKeyCode:kVK_Delete withModifierCommand:YES alt:NO shift:NO control:NO];
    
    NSInteger kKeyVCode = [[JTTMagicLineSetting defaultSetting] useDvorakLayout] ? kVK_ANSI_Period : kVK_ANSI_V;
    [simKeyboard sendKeyCode:kKeyVCode withModifierCommand:YES alt:NO shift:NO control:NO];
    
    [simKeyboard sendKeyCode:kVK_Return];
    [simKeyboard sendKeyCode:kVK_Return];
    
    [simKeyboard sendKeyCode:kVK_F20];
    
    
    self.eventMonitor = [NSEvent addLocalMonitorForEventsMatchingMask:NSKeyDownMask
                                                              handler:^NSEvent *(NSEvent *incomingEvent) {
                                                                  if ([incomingEvent type] == NSKeyDown && [incomingEvent keyCode] == kVK_F20) {
                                                                      // Finish signal arrived, no need to observe the event
                                                                      [NSEvent removeMonitor:_eventMonitor];
                                                                      self.eventMonitor = nil;
                                                                      
                                                                      // Restore previois patse board content
                                                                      [pasteBoard declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:nil];
                                                                      [pasteBoard setString:originPBString forType:NSStringPboardType];
                                                                      [simKeyboard endKeyBoradEvents];
                                                                      return nil;
                                                                  }
                                                                  else if ([incomingEvent type] == NSKeyDown && [incomingEvent keyCode] == kKeyVCode) {
                                                    
                                                                      return incomingEvent;
                                                                  }
                                                                  else {
                                                                      return incomingEvent;
                                                                  }
                                                              }];
}
// Sample Action, for menu item:
- (void)doMenuAction
{
    self.settingPanel = [[SettingWindowController alloc]initWithWindowNibName:@"SettingWindowController"];
//    self.settingPanel.window =
//    [[NSWindow alloc] initWithContentRect:NSMakeRect(0,0,1000,1000)
//                                styleMask:(NSTitledWindowMask |
//                                           NSClosableWindowMask |
//                                           NSMiniaturizableWindowMask)
//                                  backing:NSBackingStoreBuffered
//                                    defer:YES];;
//    [self.settingPanel.window setContentSize:NSMakeSize(1000, 800)];
    [self.settingPanel.window makeKeyAndOrderFront:self];
    [self.settingPanel showWindow:self.settingPanel.window];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
