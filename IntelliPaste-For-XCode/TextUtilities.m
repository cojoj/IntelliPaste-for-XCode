//
//  TextUtilities.m
//  IntelliPaste
//
//  Created by Robert Gummesson on 24/05/2014.
//

#import "TextUtilities.h"

@implementation TextUtilities

+ (NSString *)colorsFromText:(NSString *)text
{
    if (text.length > 15) {
        return nil;
    }
    
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
    return [NSString stringWithFormat:@"[UIColor colorWithRed:%@./255. green:%@./255. blue:%@/255. alpha:1.]", rgb[0], rgb[1], rgb[2]];
}

@end
