//
//  TextUtilities.m
//  IntelliPaste
//
//  Created by Robert Gummesson on 24/05/2014.
//

#import "TextUtilities.h"

@implementation TextUtilities

//  Modify the below constants if you want to customize the format.
//  Example:
//  For [RGAppearance colorWithRed:123 green:123 blue:123 alpha:1];
//  make the format [%@RGAppearance colorWithRed:%u green:%u blue:%u alpha:1] and set insertPrefix to NO

const BOOL insertPrefix = YES;

NSString *const rgbFormatObjC  = @"[%@Color colorWithRed:%u.0/255.0 green:%u.0/255.0 blue:%u.0/255.0 alpha:1.0]";
NSString *const rgbaFormatObjC = @"[%@Color colorWithRed:%u.0/255.0 green:%u.0/255.0 blue:%u.0/255.0 alpha:%u.0/255.0]";
NSString *const rgbFormatSwift = @"%@Color(red:%u.0/255.0, green:%u.0/255.0, blue:%u.0/255.0, alpha:1.0)";
NSString *const rgbaFormatSwift = @"%@Color(red:%u.0/255.0, green:%u.0/255.0, blue:%u.0/255.0, alpha:%u.0/255.0)";

+ (NSString *)colorsFromText:(NSString *)text languageType:(LanguageType)type
{
    NSString *result = [self colorsFromRGBText:text languageType:type];
    if (!result) {
        result = [self colorsFromHexText:text languageType:type];
    }
    return result;
}

+ (NSString *)colorsFromRGBText:(NSString *)text languageType:(LanguageType)type
{
    if (text.length > 15) {
        return nil;
    }
    
    //TODO: Consider validating the numbers. Currently 999,999,999 is valid.
    NSRegularExpression *const regex = [NSRegularExpression regularExpressionWithPattern:@"(\\d{1,3}),+\\s*(\\d{1,3}),+\\s*(\\d{1,3})" options:0 error:nil];
    
    __block NSArray *rgb = nil;
    [regex enumerateMatchesInString:text options:0 range:NSMakeRange(0, text.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        
        rgb = @[ [text substringWithRange:[result rangeAtIndex:1]],
                 [text substringWithRange:[result rangeAtIndex:2]],
                 [text substringWithRange:[result rangeAtIndex:3]] ];
    }];
    
    if (!rgb) {
        return nil;
    }

    NSString *prefix = [ProjectUtilities projectType] == ProjectTypeMacosx ? @"NS" : @"UI";
    return [NSString stringWithFormat:type == LanguageTypeSwift ? rgbFormatSwift : rgbFormatObjC, prefix, (uint)[rgb[0] integerValue], (uint)[rgb[1] integerValue], (uint)[rgb[2] integerValue]];
}

+ (NSString *)colorsFromHexText:(NSString *)text languageType:(LanguageType)type
{
    static NSCharacterSet *characterSet;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableCharacterSet *mutCharacterSet = [NSMutableCharacterSet whitespaceAndNewlineCharacterSet];
        [mutCharacterSet addCharactersInString:@"#"];
        characterSet = mutCharacterSet;
    });
    
    text = [text stringByTrimmingCharactersInSet:characterSet];
    if (text.length != 6 && text.length != 8) {
        return nil;
    }
    
    //Trim off 0x prefixes if needed
    if (text.length == 8 && [[[text substringToIndex:2] lowercaseString] isEqualToString:@"0x"]) {
        text = [text substringFromIndex:2];
    }
    
    // validate
    NSCharacterSet *const hexCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEFabcdef"] invertedSet];
    if ([text rangeOfCharacterFromSet:hexCharacterSet].location != NSNotFound) {
        return nil;
    }
    
    NSScanner *scanner = [[NSScanner alloc] initWithString:text];
    
    unsigned int result;
    [scanner scanHexInt:&result];
    
    unsigned int additionalShift = text.length == 8 ? 8 : 0;
    
    unsigned int r = result >> (16 + additionalShift);
    unsigned int g = (result >> (8 + additionalShift)) - r * (1 << 8);
    unsigned int b = (result >> additionalShift) - r * (1 << 16) - g * (1 << 8);
    
    unsigned int a = 255;
    if (text.length == 8) {
        a = result - r * (1 << 24) - g * (1 << 16) - b * (1 << 8);
    }
    
    NSString *prefix = insertPrefix ? ([ProjectUtilities projectType] == ProjectTypeMacosx ? @"NS" : @"UI") : @"";
    if (a == 255) {
        return [NSString stringWithFormat:type == LanguageTypeSwift ? rgbFormatSwift : rgbFormatObjC, prefix, r, g, b];
    }
    return [NSString stringWithFormat:type == LanguageTypeSwift ? rgbaFormatSwift : rgbaFormatObjC, prefix, r, g, b, a];
}

@end
