//
//  ProjectUtilities.m
//  IntelliPaste
//
//  Created by Robert Gummesson on 24/05/2014.
//

#import "ProjectUtilities.h"

@implementation ProjectUtilities

+ (NSURL *)workspaceURL
{
    for (NSDocument *document in [NSApp orderedDocuments]) {
        if (document.fileURL) {
            return document.fileURL;
        }
    }
    return nil;
}

+ (NSString *)projectPath
{
    NSString *basePath = [self basePath];
    if (!basePath) {
        return nil;
    }
    
    NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:basePath error:nil];
    NSArray *projectFile = [dirContents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.xcodeproj'"]];
    
    NSString *projectPath = [self basePath];
    if ([dirContents indexOfObject:@"project.pbxproj"] != NSNotFound) {
        projectPath = basePath;
    } else {
        if (projectFile.count == 0) {
            return nil;
        }
        projectPath = [NSString stringWithFormat:@"%@/%@", projectPath, projectFile.firstObject];
    }
    return [NSString stringWithFormat:@"%@/%@", projectPath, @"project.pbxproj"];
}

+ (NSString *)basePath
{
    NSURL *workspaceURL = [self workspaceURL];
    return workspaceURL ? [workspaceURL URLByDeletingLastPathComponent].path : nil;
}

+ (ProjectType)projectType
{
    NSString *projectFile = [self projectPath];
    NSString *projectStr = [NSString stringWithContentsOfFile:projectFile encoding:NSUTF8StringEncoding error:nil];
    
    if (!projectStr) {
        return ProjectTypeUnknown;
    }
    
    NSRegularExpression *const regex = [NSRegularExpression regularExpressionWithPattern:@"SDKROOT = +([^;]+)" options:0 error:nil];
    
    __block NSString *type = nil;
    [regex enumerateMatchesInString:projectStr options:0 range:NSMakeRange(0, projectStr.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        type = [projectStr substringWithRange:[result rangeAtIndex:1]];
    }];
    
    if ([type isEqualToString:@"iphoneos"]) {
        return ProjectTypeIphoneos;
    } else if ([type isEqualToString:@"macosx"]) {
        return ProjectTypeMacosx;
    }
    return ProjectTypeUnknown;
}

+ (NSString *)currentFileType
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

+ (LanguageType)currentLanguage
{
    NSString *fileType = [self currentFileType];
    if ([fileType isEqualToString:@"h"] || [fileType isEqualToString:@"m"]) {
        return LanguageTypeObjectiveC;
    } else if ([fileType isEqualToString:@"swift"]) {
        return LanguageTypeSwift;
    }
    return LanguageTypeUnknown;
}

@end
