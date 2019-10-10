//
//  YFDayUnits.m
//  YFCalendar
//
//  Created by 张艳锋 on 2019/3/6.
//  Copyright © 2019 张艳锋. All rights reserved.
//

#import "YFDayUnits.h"

@implementation YFDayUnits

+ (NSCalendar *)localCalendar {
    static NSCalendar *Instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Instance = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    });
    return Instance;
}

+ (NSDate *)dateWithMonth:(NSUInteger)month year:(NSUInteger)year {
    return [self dateWithMonth:month day:1 year:year];
}

+ (NSDate *)dateWithMonth:(NSUInteger)month day:(NSUInteger)day year:(NSUInteger)year {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps.year = year;
    comps.month = month;
    comps.day = day;
    
    return [self dateFromDateComponents:comps];
}

+ (NSDate *)dateFromDateComponents:(NSDateComponents *)components {
    return [[self localCalendar] dateFromComponents:components];
}

+ (NSUInteger)daysInMonth:(NSUInteger)month ofYear:(NSUInteger)year {
    NSDate *date = [self dateWithMonth:month year:year];
    return [[self localCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
}

+ (NSUInteger)firstWeekdayInMonth:(NSUInteger)month ofYear:(NSUInteger)year {
    NSDate *date = [self dateWithMonth:month year:year];
    return [[self localCalendar] component:NSCalendarUnitWeekday fromDate:date];
}

+ (NSString *)stringOfWeekdayInEnglish:(NSUInteger)weekday {
    NSAssert(weekday >= 1 && weekday <= 7, @"Invalid weekday: %lu", (unsigned long) weekday);
    static NSArray *Strings;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Strings = @[@"Sun", @"Mon", @"Tues", @"Wed", @"Thur", @"Fri", @"Sat"];
    });
    
    return Strings[weekday - 1];
}

+ (NSString *)stringOfWeekdayInChinese:(NSUInteger)weekday {
    NSAssert(weekday >= 1 && weekday <= 7, @"Invalid weekday: %lu", (unsigned long) weekday);
    static NSArray *Strings;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Strings = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    });
    
    return Strings[weekday - 1];
}

+ (NSString *)stringOfMonthInEnglish:(NSUInteger)month {
    NSAssert(month >= 1 && month <= 12, @"Invalid month: %lu", (unsigned long) month);
    static NSArray *Strings;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Strings = @[@"Jan.", @"Feb.", @"Mar.", @"Apr.", @"May.", @"Jun.", @"Jul.", @"Aug.", @"Sept.", @"Oct.", @"Nov.", @"Dec."];
    });
    
    return Strings[month - 1];
}

+ (NSDateComponents *)dateComponentsFromDate:(NSDate *)date {
    return [[self localCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
}

+ (BOOL)isDateTodayWithDateComponents:(NSDateComponents *)dateComponents {
    NSDateComponents *todayComps = [self dateComponentsFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    
    return todayComps.year == dateComponents.year && todayComps.month == dateComponents.month && todayComps.day == dateComponents.day;
}

@end
