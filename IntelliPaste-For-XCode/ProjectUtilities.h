//
//  ProjectUtilities.h
//  IntelliPaste
//
//  Created by Robert Gummesson on 24/05/2014.
//  Copyright (c) 2014 Cane Media Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectUtilities : NSObject

typedef NS_ENUM(NSUInteger, ProjectType) {
    ProjectTypeUnknown,
    ProjectTypeIphoneos,
    ProjectTypeMacosx
};

+ (ProjectType)projectType;

@end
