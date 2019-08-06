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
         NSLog(@"url  %@",url);
    }];
}


//- (NSString *) getDataFrom:(NSString *)url withParams:(NSDictionary*)params{
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setHTTPMethod:@"GET"];
//    [request setURL:[NSURL URLWithString:url]];
//    NSError *error = nil;
//    NSHTTPURLResponse *responseCode = nil;
//
//    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
//
//    if([responseCode statusCode] != 200){
//        NSLog(@"Error getting %@, HTTP status code %i", url, [responseCode statusCode]);
//        return nil;
//    }
//
//    return [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
//}

@end
