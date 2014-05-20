//
//  NSString+CodeUtilities.m
//  IntelliPaste-For-XCode
//
//  Created by Robert Gummesson on 16/05/2014.
//

#import "NSString+CodeUtilities.h"

@implementation NSString (CodeUtilities)

- (NSArray *)methods
{
    NSCharacterSet *const characterSetMethods = [NSCharacterSet characterSetWithCharactersInString:@"+-{}"];
    NSCharacterSet *const characterSetHeaders = [NSCharacterSet characterSetWithCharactersInString:@"+-;"];
    
    NSRange range = NSMakeRange(0, self.length);
    NSArray *methods = [self methodsWithRange:&range characterSet:characterSetMethods isRoot:YES];
    
    if (methods.count == 0) {
        methods = [self methodsWithRange:&range characterSet:characterSetHeaders isRoot:YES];;
    }
    return methods;
}

- (NSArray *)methodsWithRange:(NSRangePointer)rangePointer characterSet:(NSCharacterSet *)characterSet isRoot:(BOOL)isRoot
{
    NSRange range = NSMakeRange(rangePointer->location, rangePointer->length);
    NSUInteger previousLocation = range.location;
    
    NSMutableArray *methods = [NSMutableArray array];
    NSCharacterSet *const characterSetDefault = [NSCharacterSet characterSetWithCharactersInString:@"{}"];
    
    BOOL isMethod = NO;
    
    range.location = [self rangeOfCharacterFromSet:characterSet options:0 range:range].location;
    while (range.location != NSNotFound) {
        range.length = self.length - range.location;
        
        char token = [self characterAtIndex:range.location];
        switch (token) {
            case '+':
            case '-':
                isMethod = YES;
                break;
                
            case '{':
            case ';':
            {
                if (!isMethod) {
                    break;
                }
                isMethod = NO;
                
                if (isRoot) {
                    previousLocation--;
                    NSString *method =[self substringWithRange:NSMakeRange(previousLocation, range.location - previousLocation)];
                    [methods addObject:[method stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
                }
                range.location++;
                range.length--;
                [self methodsWithRange:&range characterSet:characterSetDefault isRoot:NO];
                break;
            }
                
            case '}':
                if (isRoot) {
                    break;
                }
                rangePointer->location = ++range.location;
                rangePointer->length = --range.length;
                return methods;
        }
        if (!range.length) break;
        
        previousLocation = ++range.location;
        range.length--;
        range.location = [self rangeOfCharacterFromSet:characterSet options:0 range:range].location;
    }
    return methods;
}

@end
