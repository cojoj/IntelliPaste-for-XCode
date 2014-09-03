//
//  CodeUtilities_Tests.m
//  IntelliPaste
//
//  Created by Robert Gummesson on 09/06/2014.
//  Copyright (c) 2014 Cane Media Limited. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CodeUtilities.h"

@interface CodeUtilities_Tests : XCTestCase

@property (nonatomic) NSString *testMethods;

@end

@implementation CodeUtilities_Tests

- (void)setUp
{
    [super setUp];
    
    NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
    NSURL *resourceURL = [testBundle URLForResource:@"TestInputData" withExtension:@"txt"];
    self.testMethods = [NSString stringWithContentsOfURL:resourceURL encoding:NSUTF8StringEncoding error:nil];
}

- (void)testStaticMethodParsing
{
    NSString *snippet = [self.testMethods substringWithRange:NSMakeRange(0, 88)];
    NSArray *const expectedResult = @[@"+ (NSString *)basePath"];

    XCTAssertEqualObjects([CodeUtilities methodsFromText:snippet], expectedResult, "Text with initial range should parse correctly");
    
    snippet = [self.testMethods substringWithRange:NSMakeRange(44, 22)];
    XCTAssertEqualObjects([CodeUtilities methodsFromText:snippet], expectedResult, "Text with no curly brackets should parse correctly");
    
    snippet = [self.testMethods substringWithRange:NSMakeRange(44, 24)];
    XCTAssertEqualObjects([CodeUtilities methodsFromText:snippet], expectedResult, "Text with opening curly brackets should parse correctly");
    
    snippet = [self.testMethods substringWithRange:NSMakeRange(45, 22)];
    XCTAssertEqualObjects([CodeUtilities methodsFromText:snippet], @[], "Invalid selection should return empty");
}

- (void)testNonStaticMethodParsing
{
    NSString *snippet = [self.testMethods substringWithRange:NSMakeRange(202, 264)];
    NSArray *const expectedResult = @[@"- (NSString *)colorsFromText:(NSString *)text languageType:(LanguageType)type"];
    
    XCTAssertEqualObjects([CodeUtilities methodsFromText:snippet], expectedResult, "Text with initial range should parse correctly");
    
    snippet = [self.testMethods substringWithRange:NSMakeRange(46, 420)];
    XCTAssertEqualObjects([CodeUtilities methodsFromText:snippet], expectedResult, "Text with partial method should parse correctly");
    
    snippet = [self.testMethods substringWithRange:NSMakeRange(115, 351)];
    XCTAssertEqualObjects([CodeUtilities methodsFromText:snippet], expectedResult, "Text with partial method should parse correctly");
    
    snippet = [self.testMethods substringWithRange:NSMakeRange(203, 77)];
    XCTAssertEqualObjects([CodeUtilities methodsFromText:snippet], expectedResult, "Text with no curly brackets should parse correctly");
}

- (void)testMultipleMethodParsing
{
    NSArray *const expectedResult = @[@"+ (NSString *)basePath", @"- (NSString *)colorsFromText:(NSString *)text languageType:(LanguageType)type"];
    
    NSString *snippet = [self.testMethods substringWithRange:NSMakeRange(0, 466)];
    XCTAssertEqualObjects([CodeUtilities methodsFromText:snippet], expectedResult, "Text should parse correctly");
    
    snippet = [self.testMethods substringWithRange:NSMakeRange(0, 280)];
    XCTAssertEqualObjects([CodeUtilities methodsFromText:snippet], expectedResult, "Text two methods should parse correctly");
}

- (void)testParsingMethodWithPragmaMark
{
    NSArray *const expectedResult = @[@"- (BOOL)tinyMethod"];
    
    NSString *snippet = [self.testMethods substringWithRange:NSMakeRange(466, 49)];
    XCTAssertEqualObjects([CodeUtilities methodsFromText:snippet], expectedResult, "Text with pragma mark should parse correctly");
}

@end
