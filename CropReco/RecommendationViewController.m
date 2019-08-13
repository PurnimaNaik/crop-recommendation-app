//
//  RecommendationViewController.m
//  CropReco
//
//  Created by Purnima Naik on 8/4/19.
//  Copyright © 2019 Purnima Naik. All rights reserved.
//

#import "RecommendationViewController.h"

@interface RecommendationViewController (){
}
@end

@implementation RecommendationViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestPermission];
    
//        self.recommendationTabIcon.image=[[UIImage imageNamed:@"recommendationTabIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

-(void)requestPermission{
    locationManager=[[CLLocationManager alloc]init];
    [locationManager requestWhenInUseAuthorization];
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    
    CLGeocoder *geocoder =[[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:locationManager.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        NSString *searchQuery = [NSString stringWithFormat:@"%@,%@", [placemarks objectAtIndex:0].locality, [placemarks objectAtIndex:0].ISOcountryCode];
        
        //        https://api.openweathermap.org/data/2.5/weather?q=London,uk&appid=YOUR_API_KEY
        
        NSString *url = [NSString stringWithFormat:@"%@%@%@%@%@",
                         @"https://api.openweathermap.org/data/2.5/weather?q=",
                         searchQuery,
                         @"&units=metric",
                         @"&appid=",
                @"4c1aa9e27863af68e069647e446328f3"];
        
        NSLog(@"searchQuery  %@",searchQuery);
        
        
        NSString *escapedURL = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSLog(@"escapedURL: %@", escapedURL);
        
        [self getDataFrom:escapedURL];
    }];
}


- (void) getDataFrom:(NSString *)url{
    NSLog(@"url  %@",url);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"dataTaskWithRequest error: %@", error);
        }
        
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            if (statusCode != 200) {
                NSLog(@"Expected responseCode == 200; received %ld", (long)statusCode);
                
            }
            else{
                
                NSError *jsonError;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:&jsonError];
                NSLog(@"json %@", json);
                NSLog(@"sunrise %@", json[@"sys"][@"sunrise"]);
                NSLog(@"sunset %@", json[@"sys"][@"sunset"]);
                NSLog(@"visibility %@", json[@"visibility"]);
                NSLog(@"weather %@", json[@"weather"]);
                NSLog(@"wind deg %@", json[@"wind"][@"deg"]);
                NSLog(@"wind speed %@", json[@"wind"][@"speed"]);
              

                NSNumber* pressureInHPA=json[@"main"][@"pressure"];
//              NSNumber *divider = @([loadTempValue doubleValue] * 0.420);
                NSNumber* pressureInINHG= @([pressureInHPA doubleValue]/33.86);
              
                NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
                [fmt setPositiveFormat:@"0.##"];
                NSString* truncatedPressure=[fmt stringFromNumber:pressureInINHG];

                
                dispatch_async(dispatch_get_main_queue(), ^{
                self.avgTempLabel.text =[NSString stringWithFormat:@"%@", json[@"main"][@"temp"] ];
                self.minTempLabel.text =[NSString stringWithFormat:@"%@", json[@"main"][@"temp_min"] ];
                self.maxTempLabel.text =[NSString stringWithFormat:@"%@", json[@"main"][@"temp_max"] ];
                self.humidityLabel.text =[NSString stringWithFormat:@"%@", json[@"main"][@"humidity"] ];
                    self.pressureLabel.text =truncatedPressure;
                });
            }
        }
    }];
    [task resume];
}



@end


