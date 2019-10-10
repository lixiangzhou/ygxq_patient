//
//  YFDayIndicatorView.m
//  YFCalendar
//
//  Created by 张艳锋 on 2019/3/6.
//  Copyright © 2019 张艳锋. All rights reserved.
//

#import "YFDayIndicatorView.h"

@interface YFDayIndicatorView ()

@property (strong, nonatomic) CAShapeLayer *ellipseLayer;

@end
@implementation YFDayIndicatorView


- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    self.ellipseLayer = [CAShapeLayer layer];
    self.ellipseLayer.fillColor = self.color.CGColor;
    [self.layer addSublayer:self.ellipseLayer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.ellipseLayer.path = CGPathCreateWithEllipseInRect(self.bounds, nil);
    self.ellipseLayer.frame = self.bounds;
}

- (void)setColor:(UIColor *)color {
    self->_color = color;
    self.ellipseLayer.fillColor = color.CGColor;
}


@end
