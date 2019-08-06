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
                NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                NSError *err = nil;
                NSArray *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
                NSLog(@"jsonData %@", jsonData);
                
                [self parseChildrenArray:jsonData];
                
//
//                NSMutableArray *arrResult = [NSMutableArray array];
//                for (NSDictionary *dict in jsonData) {
//                  NSString* dictString=[NSString stringWithFormat:@"%@", dict];
//                    if([dictString isEqual:@"wind"] ||
//                       [dictString isEqual:@"main"] ||
//                       [dictString isEqual:@"timezone"] ||
//                       [dictString isEqual:@"weather"]){
//                         [arrResult addObject:dict];
//                    }
//                }
//                 NSLog(@"arrResult %@", arrResult);
            }
        }
        }];
    [task resume];
    }

- (void) parseChildrenArray : (NSArray *) arr {

    for(NSDictionary *child in arr) {
//        CategoryChild *createdChild = [self createCategory:child];
//        [self.childrenArray addObject:child];
//        if ([child[@"child"] count] > 0) {
//            [self parseChildrenArray:child[@"child"]];
//        }
         NSLog(@"child %@", child);
    }
    
}

//-(CategoryChild *)createCategory: (NSDictionary *)child {
//    CategoryChild *ch = [[CategoryChild alloc] init];
//    ch.id = child[@"id"];
//    //parse other property
//    return ch;
//}


//    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
//    if([responseCode statusCode] != 200){
//        NSLog(@"Error getting %@, HTTP status code %i", url, [responseCode statusCode]);
//        return nil;
//    }
//    return [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
                              

@end


