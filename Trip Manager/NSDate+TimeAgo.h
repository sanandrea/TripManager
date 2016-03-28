// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
// 
//
//  Copyright © 2016 Andi Palo
//  This file is part of project: TripManager
//
#import <Foundation/Foundation.h>

@interface NSDate (TimeAgo)
- (NSString *) timeAgoSimple;
- (NSString *) timeAgo;
- (NSString *) timeAgoWithLimit:(NSTimeInterval)limit;
- (NSString *) timeAgoWithLimit:(NSTimeInterval)limit dateFormat:(NSDateFormatterStyle)dFormatter andTimeFormat:(NSDateFormatterStyle)tFormatter;
- (NSString *) timeAgoWithLimit:(NSTimeInterval)limit dateFormatter:(NSDateFormatter *)formatter;


// this method only returns "{value} {unit} ago" strings and no "yesterday"/"last month" strings
- (NSString *)dateTimeAgo;

// this method gives when possible the date compared to the current calendar date: "this morning"/"yesterday"/"last week"/..
// when more precision is needed (= less than 6 hours ago) it returns the same output as dateTimeAgo
- (NSString *)dateTimeUntilNow;

@end

