//
//  AIEcgCollectViewController.h
//  AIEcgSDK
//
//  Created by 胡东 on 2018/12/24.
//  Copyright © 2018年 胡东. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//采集的心电数据
typedef void (^Block_EcgData)(NSArray *ecgDataArray);
//错误信息
typedef void (^RegisterBlock)(NSError *error);

@interface AIEcgCollectViewController : UIViewController

/**
 心电图采集+上传
 @param device_mac_list     心电设备mac地址(传空数组将扫描周边设备)
 @param ecgInfo             用户相关信息
 @param ecg_card_no         服务卡标识
 @param ecg_card_key        服务卡秘钥
 @param msgBlock            心电图采集失败信息
 */
- (instancetype)initWithDeviceMac:(NSArray *)device_mac_list ecgInfo:(NSDictionary *)ecgInfo ecgCardNo:(NSString *)ecg_card_no ecgCardKey:(NSString *)ecg_card_key  ecgDataBlock:(Block_EcgData)ecgDataArray errorBlock:(RegisterBlock)msgBlock;



@end

NS_ASSUME_NONNULL_END
