//
//  Location_Manager.h
//  CoreLocationManger
//
//  Created by zhangjiaqi on 2017/7/20.
//  Copyright © 2017年 zhangjiaqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Location_Manager : NSObject <CLLocationManagerDelegate>


@property (nonatomic,strong)CLLocationManager *locationManager;

///开启定位
- (void)start_locationManager;

///关闭定位
-(void)stop_LocationManager;
- (void)latitude_longitude:(void (^)(float latitude, float longitude , NSString *addressString))manager;


@end
