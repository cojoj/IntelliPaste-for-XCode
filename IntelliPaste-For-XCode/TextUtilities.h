//
//  TextUtilities.h
//  IntelliPaste
//
//  Created by Robert Gummesson on 24/05/2014.
//

#import <Foundation/Foundation.h>
#import "ProjectUtilities.h"

@interface TextUtilities : NSObject

+ (NSString *)colorsFromText:(NSString *)text languageType:(LanguageType)type;

@end
