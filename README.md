 # JQLocationManager
 
 导入
 #import <CoreLocation/CoreLocation.h>
 
 iOS8 之后 需要获取用户权限
 ![image](https://github.com/seanBoler/JQLocationManager/blob/master/loaction.png)

`Location Always Usage DesCription`           允许在使用期间使用定位功能  
`Location When In Use Usage Description`      允许一直使用定位功能(后台)

 1. Loaction_Manager.h
 ## 开启定位
    `- (void)start_locationManager;`

## 关闭定位
    `-(void)stop_LocationManager;`


2. Loaction_Manager.m
      
`CLPlacemark的字面意思是地标，封装详细的地址位置信息
CLPlacemark的addressDictionary属性 遍历字典数据`      
      
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
        
```
 name                    :   地名
 thoroughfare            :   街道
 ubThoroughfare          :   街道相关信息，例如门牌等
 locality                :   城市
 subLocality             :   城市相关信息，例如标志性建筑
 administrativeArea      :   直辖市
 subAdministrativeArea   :   其他行政区域信息
 postalCode              :   邮编
 ISOcountryCode          :   国家编码
 country;                :   国家
 inlandWater             :   水源、湖泊
 ocean;                  :   海洋
 areasOfInterest         :   关联的或利益相关的地标
```


- #import "Location_Manager.h"
- @property(nonatomic,strong)Location_Manager *location;

      - (void)viewDidLoad {
          [super viewDidLoad];
    
          self.location = [[Location_Manager alloc]init];
          [_location start_locationManager];
      }
      
      -(void)dealloc{
          _location = nil;
      }
      
# 调用   
       [_location latitude_longitude:^(float latitude, float longitude , NSString *addressString) {
            NSLog(@"%@",[NSString stringWithFormat:@"经度:%3.5f\n纬度:%3.5f ---- %@",latitude, longitude,addressString]);

        }];
