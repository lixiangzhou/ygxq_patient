//
//  YFDayNavigationBar.h
//  YFCalendar
//
//  Created by 张艳锋 on 2019/3/6.
//  Copyright © 2019 张艳锋. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef NS_ENUM(NSUInteger,YFDayNavigationBarCommand) {
    
    YFDayNavigationBarCommandNoCommand = 0,
    YFDayNavigationBarCommandPrevious,
    YFDayNavigationBarCommandNext
    
};
NS_ASSUME_NONNULL_BEGIN
@interface YFDayNavigationBar : UIControl

@property (readonly) UILabel *textLabel;

@property (readonly) YFDayNavigationBarCommand lastCommand;

@end
NS_ASSUME_NONNULL_END
