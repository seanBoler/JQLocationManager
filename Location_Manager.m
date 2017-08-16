//
//  Location_Manager.m
//  CoreLocationManger
//
//  Created by zhangjiaqi on 2017/7/20.
//  Copyright © 2017年 zhangjiaqi. All rights reserved.
//

#import "Location_Manager.h"

@implementation Location_Manager
{
    float _latitude;
    float _longitude;
    NSString *_addressString;
}

- (void)start_locationManager{
    
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {
        
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.desiredAccuracy  =  kCLLocationAccuracyBest;       //最精确模式
        [_locationManager requestAlwaysAuthorization];                      //iOS8需要加上，不然定位失败
        _locationManager.delegate = self;                                   //代理
        _locationManager.distanceFilter = 5.0f;                             //至少5米才请求一次数据
        [_locationManager startUpdatingLocation];                           //开始定位
        
    }else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted){
        kTipAlert(@"请打开定位才能使用，否则你将无法上传信息");
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"定位失败");
    [_locationManager stopUpdatingLocation];//关闭定位
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    NSLog(@"定位成功");
    
    CLLocation *newLocation = locations[0];
    NSLog(@"%@",[NSString stringWithFormat:@"经度:%3.5f\n纬度:%3.5f",newLocation.coordinate.latitude, newLocation.coordinate.longitude]);
    
    _latitude = newLocation.coordinate.latitude;
    _longitude = newLocation.coordinate.longitude;
    // 强制 成 简体中文
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-hans", nil] forKey:@"AppleLanguages"];
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            NSDictionary *test = [placemark addressDictionary];
            // Country(国家) State(城市) SubLocality(区)
            NSArray *cityArr = [test objectForKey:@"FormattedAddressLines"];
            NSLog(@"%@", cityArr[0]);
            _addressString = cityArr[0];
        }
    }];
}


-(void)latitude_longitude:(void (^)(float, float, NSString *))manager{
    [self stop_LocationManager];
    if (manager) {
        manager(_latitude,_longitude,_addressString);
    }
}

- (void)stop_LocationManager{
    [_locationManager stopUpdatingLocation];//关闭定位

}

@end
