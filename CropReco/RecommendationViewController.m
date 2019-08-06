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
    
}

-(void)viewWillAppear:(BOOL)animated{
    locationManager=[[CLLocationManager alloc]init];
    [locationManager requestWhenInUseAuthorization];
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    
    CLGeocoder *geocoder =[[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:locationManager.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//       NSLog(@"locality %@",[placemarks objectAtIndex:0].locality);
//        NSLog(@"ISOcountryCode %@",[placemarks objectAtIndex:0].ISOcountryCode);
     
NSString *searchQuery = [NSString stringWithFormat:@"%@,%@", [placemarks objectAtIndex:0].locality, [placemarks objectAtIndex:0].ISOcountryCode];
        
//        https://api.openweathermap.org/data/2.5/weather?q=London,uk&appid=YOUR_API_KEY
        
     NSString *url = [NSString stringWithFormat:@"%@%@%@%@",
                      @"https://api.openweathermap.org/data/2.5/weather?q=",
                      searchQuery,
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
//    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSError *error = nil;
    NSHTTPURLResponse *responseCode = nil;
    
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
                //works
//                NSError *err = nil;
//                NSArray *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
//                NSLog(@"jsonData %@", jsonData);
                ///<-
                NSError *jsonError;
   NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                             options:NSJSONReadingMutableContainers
                                             error:&jsonError];
                NSLog(@"json %@", json[@"main"]);
                NSLog(@"temp- %@", json[@"main"][@"temp"]);
                NSLog(@"temp_max- %@", json[@"main"][@"temp_max"]);
                NSLog(@"temp_min- %@", json[@"main"][@"temp_min"]);
                NSLog(@"humidity- %@", json[@"main"][@"humidity"]);
                NSLog(@"pressure- %@", json[@"main"][@"pressure"]);
            }
        }
        }];
    [task resume];
    }




                              

@end


