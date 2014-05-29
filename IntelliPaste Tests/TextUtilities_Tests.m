//
//  TextUtilities_Tests.m
//  IntelliPaste
//
//  Created by Robert Gummesson on 28/05/2014.
//  Copyright (c) 2014 Cane Media Limited. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TextUtilities.h"

@interface TextUtilities_Tests : XCTestCase

@end

@implementation TextUtilities_Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testHexStrings
{
    NSString *const expectedResult = @"[UIColor colorWithRed:255./255. green:18./255. blue:52./255. alpha:1.]";
    NSString *const expectedResultAlpha = @"[UIColor colorWithRed:255./255. green:18./255. blue:52./255. alpha:52./255.]";
    
    XCTAssertTrue([[TextUtilities colorsFromText:@"#FF1234"] isEqualToString:expectedResult], @"Hashed hex not parsed correctly");
    XCTAssertTrue([[TextUtilities colorsFromText:@"0xFF1234"] isEqualToString:expectedResult], @"Prefixed hex not parsed correctly");
    XCTAssertTrue([[TextUtilities colorsFromText:@"FF1234"] isEqualToString:expectedResult], @"Uppercase hex not parsed correctly");
    XCTAssertTrue([[TextUtilities colorsFromText:@"ff1234"] isEqualToString:expectedResult], @"Lowercase hex not parsed correctly");
    XCTAssertTrue([[TextUtilities colorsFromText:@"FF1234FF"] isEqualToString:expectedResult], @"Alpha hex with 100%% alpha not parsed correctly");
    XCTAssertTrue([[TextUtilities colorsFromText:@"FF123434"] isEqualToString:expectedResultAlpha], @"Alpha hex with alpha not parsed correctly");
    XCTAssertTrue([[TextUtilities colorsFromText:@" FF1234 "] isEqualToString:expectedResult], @"Hex with space not parsed correctly");
    
    XCTAssertNil([TextUtilities colorsFromText:@"FK1234"], @"Non hex letters should return nil");
    XCTAssertNil([TextUtilities colorsFromText:@"FF123"], @"Invalid length should return nil");
    XCTAssertNil([TextUtilities colorsFromText:@"FF12345"], @"Invalid length should return nil");
    XCTAssertNil([TextUtilities colorsFromText:@"FF12"], @"Missing blue channel should return nil");
}

- (void)testRgbStrings
{
    NSString *const expectedResult = @"[UIColor colorWithRed:255./255. green:18./255. blue:52./255. alpha:1.]";
    
    XCTAssertTrue([[TextUtilities colorsFromText:@"255, 18, 52"] isEqualToString:expectedResult], @"Rgb with spaces not parsed correctly");
    XCTAssertTrue([[TextUtilities colorsFromText:@"255,18,52"] isEqualToString:expectedResult], @"Rgb without spaces not parsed correctly");
    XCTAssertTrue([[TextUtilities colorsFromText:@"255,18, 52"] isEqualToString:expectedResult], @"Rgb with mixed spaces not parsed correctly");
    
    XCTAssertNil([TextUtilities colorsFromText:@"255, 1818, 52"], @"Invalid mid digit length should fail");
    XCTAssertNil([TextUtilities colorsFromText:@"255, 18"], @"Missing blue channel should return nil");
    XCTAssertNil([TextUtilities colorsFromText:@"255, 18,"], @"Missing blue channel should return nil");
}

@end
