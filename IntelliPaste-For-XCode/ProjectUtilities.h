//
//  ProjectUtilities.h
//  IntelliPaste
//
//  Created by Robert Gummesson on 24/05/2014.
//

#import <Foundation/Foundation.h>

@interface ProjectUtilities : NSObject

typedef NS_ENUM(NSUInteger, ProjectType) {
    ProjectTypeUnknown,
    ProjectTypeIphoneos,
    ProjectTypeMacosx
};

typedef NS_ENUM(NSUInteger, LanguageType) {
    LanguageTypeUnknown,
    LanguageTypeObjectiveC,
    LanguageTypeSwift
};

+ (ProjectType)projectType;
+ (LanguageType)currentLanguage;
+ (NSString *)currentFileType;

@end
