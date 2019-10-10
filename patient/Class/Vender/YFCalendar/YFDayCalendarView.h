//
//  YFDayCalendarView.h
//  YFCalendar
//
//  Created by 张艳锋 on 2019/3/6.
//  Copyright © 2019 张艳锋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YFDayCalendarView : UIControl

@property (copy, nonatomic) NSDate *selectedDate;

@property (copy, nonatomic) NSArray<NSString *> *localizedStringsOfWeekday;

// Appearance settings:
@property (copy, nonatomic) UIColor *weekdayHeaderTextColor;
@property (copy, nonatomic) UIColor *weekdayHeaderWeekendTextColor;
@property (copy, nonatomic) UIColor *componentTextColor;
@property (copy, nonatomic) UIColor *highlightedComponentTextColor;
@property (copy, nonatomic) UIColor *selectedIndicatorColor;
@property (copy, nonatomic) UIColor *todayIndicatorColor;
@property (assign, nonatomic) CGFloat indicatorRadius;
@property (assign, nonatomic) BOOL boldPrimaryComponentText;
@property (assign, nonatomic) BOOL singleRowMode;

// Additional features:
@property (assign, nonatomic) BOOL showUserEvents;

- (void)reloadViewAnimated:(BOOL)animated;   // Invalidate the original view, use it after changing the appearance settings.

- (void)jumpToNextMonth;
- (void)jumpToPreviousMonth;
- (void)jumpToMonth:(NSUInteger)month year:(NSUInteger)year;


@end

NS_ASSUME_NONNULL_END
