 # JQLocationManager
 
 1. Loaction_Manager.h
 ## 开启定位
    - (void)start_locationManager;

## 关闭定位
    -(void)stop_LocationManager;


2. Loaction_Manager.m
      
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
