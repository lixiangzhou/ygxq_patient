//
//  YFDayComponentView.h
//  YFCalendar
//
//  Created by 张艳锋 on 2019/3/6.
//  Copyright © 2019 张艳锋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YFDayComponentView : UIControl

@property (readonly) UILabel *textLabel;
@property (copy, nonatomic) UIColor *textColor;
@property (copy, nonatomic) UIColor *highlightTextColor;
@property (strong, nonatomic, nullable) EKEvent *containingEvent;
@property (strong, nonatomic) id representedObject;

@end

NS_ASSUME_NONNULL_END
