//
//  IntelliPaste.m
//  IntelliPaste-For-XCode
//
//  Created by Robert Gummesson on 16/05/2014.
//

#import "IntelliPaste.h"
#import "NSString+CodeUtilities.h"

@interface IntelliPaste ()

@property (nonatomic) NSTextView *textView;

@end

@implementation IntelliPaste

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static id sharedPlugin;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPlugin = [self new];
    });
}

- (instancetype)init
{
	if (self = [super init]) {
		[[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidFinishLaunching:)
                                                     name:NSApplicationDidFinishLaunchingNotification
                                                   object:nil];
	}
	return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    NSString *const kPaste = @"Paste";
    NSMenuItem *editMenuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];
    
    if (editMenuItem) {
        
        NSUInteger itemIndex = [self menuIndexForMenuItem:editMenuItem withTitle:kPaste];
        NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:@"Paste Methods" action:@selector(pasteMethods) keyEquivalent:@""];
        menuItem.keyEquivalentModifierMask = NSShiftKeyMask | NSCommandKeyMask;
        menuItem.keyEquivalent = @"v";
        menuItem.target = self;
        
        if (itemIndex > 0) {
            [editMenuItem.submenu insertItem:menuItem atIndex:itemIndex];
        } else {
            [editMenuItem.submenu addItem:menuItem];
        }
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectionDidChange:) name:NSTextViewDidChangeSelectionNotification object:nil];
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Menu

- (void)pasteMethods
{
    NSArray *classes = [[NSArray alloc] initWithObjects:[NSString class], nil];
    NSArray *strings = [[NSPasteboard generalPasteboard] readObjectsForClasses:classes options:0];
    if (strings.count == 0) return;
    
    NSString *clipBoardText = strings.firstObject;
    NSArray *methods = [clipBoardText methods];
    if (methods.count == 0) return;
    
    NSString *suffix = [self suffix];
    if (!suffix) return;

    NSMutableArray *mutMethods = [NSMutableArray arrayWithArray:methods];
    [mutMethods enumerateObjectsUsingBlock:^(NSString *method, NSUInteger idx, BOOL *stop) {
        mutMethods[idx] = [method stringByAppendingString:suffix];
    }];
    
    [self.textView insertText:[mutMethods componentsJoinedByString:@"\n"]];
}

#pragma mark - Text Editor

- (void)selectionDidChange:(NSNotification *)notification
{
    self.textView = (NSTextView *)notification.object;
}

#pragma mark - Utilities

- (NSString *)suffix
{
    NSString *suffix;
    NSString *currentFileType = [self currentFileType];
    if ([currentFileType isEqualToString:@"m"]) {
        suffix = @"\n{\n\t\n}\n";
    } else if ([currentFileType isEqualToString:@"h"]) {
        suffix = @";";
    }
    return suffix;
}

- (NSString *)currentFileType
{
    NSWindowController *currentWindowController = [[NSApp mainWindow] windowController];
    
    id editorArea = [currentWindowController valueForKey:@"editorArea"];
    id editorContext = [editorArea valueForKey:@"lastActiveEditorContext"];
    id editor = [editorContext valueForKey:@"editor"];
    
    id sourceCodeDocument;
    if ([editor isKindOfClass:NSClassFromString(@"IDESourceCodeEditor")]) {
        sourceCodeDocument = [editor valueForKey:@"sourceCodeDocument"];
    } else if ([editor isKindOfClass:NSClassFromString(@"IDESourceCodeComparisonEditor")]) {
        id primaryDocument = [editor valueForKey:@"primaryDocument"];
        if ([primaryDocument isKindOfClass:NSClassFromString(@"IDESourceCodeDocument")]) {
            sourceCodeDocument = primaryDocument;
        }
    }
    return sourceCodeDocument ? [[sourceCodeDocument valueForKey:@"fileURL"] pathExtension] : nil;
}

- (NSUInteger)menuIndexForMenuItem:(NSMenuItem *)menuItem withTitle:(NSString *)title
{
    __block NSUInteger insertIndex = 0;
    
    [menuItem.submenu.itemArray enumerateObjectsUsingBlock:^(NSMenuItem *item, NSUInteger idx, BOOL *stop) {
        if (item.title.length >= title.length && [[item.title substringToIndex:title.length] isEqualToString:title]) {
            insertIndex = idx + 1;
        } else if (insertIndex > 0) {
            *stop = YES;
        }
    }];
    
    return insertIndex;
}
@end
