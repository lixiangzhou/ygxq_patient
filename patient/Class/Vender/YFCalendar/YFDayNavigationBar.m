//
//  YFDayNavigationBar.m
//  YFCalendar
//
//  Created by 张艳锋 on 2019/3/6.
//  Copyright © 2019 张艳锋. All rights reserved.
//

#import "YFDayNavigationBar.h"


@interface YFDayNavigationBar ()

@property (strong, nonatomic) UILabel *textLabel;
@property (strong, nonatomic) UIButton *prevButton;
@property (strong, nonatomic) UIButton *nextButton;

@property (readwrite, assign, nonatomic) YFDayNavigationBarCommand lastCommand;

@end

@implementation YFDayNavigationBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.textLabel.textColor = [UIColor colorWithRed:0.29 green:0.29 blue:0.29 alpha:1];
    self.textLabel.font = [UIFont systemFontOfSize:16];
    
    [self addSubview:self.textLabel];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0
                                                      constant:0]];
    
    self.prevButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.prevButton.translatesAutoresizingMaskIntoConstraints = NO;
//    self.prevButton.tintColor = [UIColor grayColor];
    [self.prevButton setImage:[UIImage imageNamed:@"health_input_date_left"] forState:UIControlStateNormal];
    [self.prevButton addTarget:self action:@selector(prevButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.prevButton];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.prevButton
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.prevButton
                                                     attribute:NSLayoutAttributeLeading
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeading
                                                    multiplier:1.0
                                                      constant:16]];
    [self.prevButton addConstraint:[NSLayoutConstraint constraintWithItem:self.prevButton
                                                                attribute:NSLayoutAttributeWidth
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0
                                                                 constant:30]];
    [self.prevButton addConstraint:[NSLayoutConstraint constraintWithItem:self.prevButton
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0
                                                                 constant:30]];
    
    
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextButton.translatesAutoresizingMaskIntoConstraints = NO;
//    self.nextButton.tintColor = [UIColor grayColor];
    [self.nextButton setImage:[UIImage imageNamed:@"health_input_date_right"] forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(nextButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.nextButton];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.nextButton
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.nextButton
                                                     attribute:NSLayoutAttributeTrailing
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTrailing
                                                    multiplier:1.0
                                                      constant:-16]];
    [self.nextButton addConstraint:[NSLayoutConstraint constraintWithItem:self.nextButton
                                                                attribute:NSLayoutAttributeWidth
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0
                                                                 constant:30]];
    [self.nextButton addConstraint:[NSLayoutConstraint constraintWithItem:self.nextButton
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0
                                                                 constant:30]];
}

- (void)prevButtonDidTap:(id)sender {
    self.lastCommand = YFDayNavigationBarCommandPrevious;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)nextButtonDidTap:(id)sender {
    self.lastCommand = YFDayNavigationBarCommandNext;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}


@end
