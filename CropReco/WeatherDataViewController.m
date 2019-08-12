//
//  WeatherDataViewController.m
//  CropReco
//
//  Created by Purnima Naik on 8/4/19.
//  Copyright © 2019 Purnima Naik. All rights reserved.
//

#import "WeatherDataViewController.h"

@interface WeatherDataViewController ()

@end

@implementation WeatherDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.searchBarOutlet.delegate=self;
    [self.disclaimerLabel setTextContainerInset:UIEdgeInsetsZero];
    self.disclaimerLabel.textContainer.lineFragmentPadding = 0;
    self.disclaimerLabel.textContainer.lineFragmentPadding = 0;
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchOpenWeatherAPI:searchBar.text];
    [searchBar resignFirstResponder];
}

- (void) searchOpenWeatherAPI:(NSString *)searchText{
    
    NSString *escapedsearchText = [searchText stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@%@%@",
                     @"https://api.openweathermap.org/data/2.5/weather?q=",
                     escapedsearchText,
                     @"&units=metric",
                     @"&appid=",
                     @"4c1aa9e27863af68e069647e446328f3"];
    
    NSLog(@"searchQuery  %@",searchText);
    
    NSString *escapedURL = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"escapedURL: %@", escapedURL);
    
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
                
                NSLog(@"json %@", json);
                NSLog(@"sunrise %@", json[@"sys"][@"sunrise"]);
                NSLog(@"sunset %@", json[@"sys"][@"sunset"]);
                NSLog(@"visibility %@", json[@"visibility"]);
                NSLog(@"weather %@", json[@"weather"]);
                NSLog(@"wind deg %@", json[@"wind"][@"deg"]);
                NSLog(@"wind speed %@", json[@"wind"][@"speed"]);
                
                NSNumber* pressureInHPA=json[@"main"][@"pressure"];
                NSNumber* pressureInINHG= @([pressureInHPA doubleValue]/33.86);
                
                NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
                [fmt setPositiveFormat:@"0.##"];
                NSString* truncatedPressure=[fmt stringFromNumber:pressureInINHG];
                
                NSNumber* visibilityInMeters=json[@"visibility"];
                NSNumber* visibilityInMiles= @(ceil([visibilityInMeters doubleValue]*0.00062137));
                NSString* windDirection=[self checkDirection:[json[@"wind"][@"deg"]doubleValue]];
                
                double offset =  [json[@"timezone"]doubleValue];
                
                //get sunrise time
                double sunriseTimestampval =  [json[@"sys"][@"sunrise"]doubleValue];
                NSTimeInterval sunriseTimestamp = (NSTimeInterval)sunriseTimestampval;
                NSDate* sunriseDate = [NSDate dateWithTimeIntervalSince1970:sunriseTimestamp];
                NSDateFormatter *sunriseDateFormatter = [[NSDateFormatter alloc] init];
                
                //for 12 hr
                [sunriseDateFormatter setDateFormat:@"hh:mm"];
                //local time
                [sunriseDateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:offset]]; // For GMT+1
                NSString *sunriseTime = [sunriseDateFormatter stringFromDate:sunriseDate];
                //end of 12 hr
                
                
                //get sunset time
                double sunsetTimestampval =  [json[@"sys"][@"sunset"]doubleValue];
                NSTimeInterval sunsetTimestamp = (NSTimeInterval)sunsetTimestampval;
                NSDate* sunsetDate = [NSDate dateWithTimeIntervalSince1970:sunsetTimestamp];
                NSDateFormatter *sunsetDateFormatter = [[NSDateFormatter alloc] init];
                
                //for 12 hr
                [sunsetDateFormatter setDateFormat:@"hh:mm"];
                //local time
                [sunsetDateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:offset]]; // For GMT+1
                NSString *sunsetTime = [sunsetDateFormatter stringFromDate:sunsetDate];
                //end of 12 hr
                
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.avgTempLabel.text =[NSString stringWithFormat:@"%@%@", json[@"main"][@"temp"], @"°C" ];
                    self.minTempLabel.text =[NSString stringWithFormat:@"%@%@", json[@"main"][@"temp_min"], @"°C" ];
                    self.maxTempLabel.text =[NSString stringWithFormat:@"%@%@", json[@"main"][@"temp_max"], @"°C" ];
                    self.humidityLabel.text =[NSString stringWithFormat:@"%@%@", json[@"main"][@"humidity"], @"%" ];
                    self.pressureLabel.text =[NSString stringWithFormat:@"%@ %@", truncatedPressure, @"inHg" ];
                    self.visibilityLabel.text =[NSString stringWithFormat:@"%@ %@", visibilityInMiles, @"mi" ];
                    
                    self.sunriseLabel.text =[NSString stringWithFormat:@"%@ %@", sunriseTime, @"AM" ];
                    self.sunsetLabel.text =[NSString stringWithFormat:@"%@ %@", sunsetTime, @"PM" ];
                    
                    self.windLabel.text =[NSString stringWithFormat:@"%@ %@ %@", json[@"wind"][@"speed"], @"mph", windDirection ];
                    
                });
            }
        }
    }];
    [task resume];
}


-(NSString*) checkDirection:(double)degree{
    NSString* direction=@"N";
    if (degree>337.5) {
       return direction=@"N";
    }
    if (degree>292.5){
       return direction=@"NW";
    }
    if(degree>247.5) {
       return direction=@"W";
    }
    if(degree>202.5)  {
       return direction=@"SW";
    }
    if(degree>157.5) {
       return direction=@"S";
    }
    if(degree>122.5){
       return direction=@"SE";
    }
    if(degree>67.5) {
       return direction=@"E";
    }
    if(degree>22.5){
       return direction=@"NE";
    }
    
    return direction;
}

@end

//                NSDateFormatter *sunsetDateFormatter = [[NSDateFormatter alloc] init];
//                [sunsetDateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale currentLocale] localeIdentifier]]];
//                [sunsetDateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
//                     [self.avgTempLabel sizeToFit];
