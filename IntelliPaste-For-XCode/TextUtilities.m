//
//  TextUtilities.m
//  IntelliPaste
//
//  Created by Robert Gummesson on 24/05/2014.
//

#import "TextUtilities.h"
#import "ProjectUtilities.h"

@implementation TextUtilities

+ (NSString *)colorsFromText:(NSString *)text
{
    NSString *result = [self colorsFromRGBText:text];
    if (!result) {
        result = [self colorsFromHexText:text];
    }
    return result;
}

+ (NSString *)colorsFromRGBText:(NSString *)text
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
    return [NSString stringWithFormat:@"[%@Color colorWithRed:%@./255. green:%@./255. blue:%@./255. alpha:1.]", prefix, rgb[0], rgb[1], rgb[2]];
}

+ (NSString *)colorsFromHexText:(NSString *)text
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
    
    NSString *prefix = [ProjectUtilities projectType] == ProjectTypeMacosx ? @"NS" : @"UI";
    if (a == 255) {
        return [NSString stringWithFormat:@"[%@Color colorWithRed:%u./255. green:%u./255. blue:%u./255. alpha:1.]", prefix, r, g, b];
    }
    return [NSString stringWithFormat:@"[%@Color colorWithRed:%u./255. green:%u./255. blue:%u./255. alpha:%u./255.]", prefix, r, g, b, a];
}

@end
