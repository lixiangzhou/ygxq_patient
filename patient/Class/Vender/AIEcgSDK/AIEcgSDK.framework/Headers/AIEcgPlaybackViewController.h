//
//  AIEcgPlaybackViewController.h
//  AIEcgSDK
//
//  Created by 王超 on 2017/10/16.
//  Copyright © 2017年 chaors. All rights reserved.
//

#import <UIKit/UIKit.h>

//错误信息
typedef void (^RegisterBlock)(NSError *error);

@interface AIEcgPlaybackViewController : UIViewController

@property(nonatomic, strong) NSString *string_title;

/**
 心电图回放
 @param parameter           {@"ecg_id":@"爱心电心电标识"}
 @param msgBlock            失败信息
 */
- (instancetype)initWithParameter:(NSDictionary *)parameter errorBlock:(RegisterBlock)msgBlock;

@end
