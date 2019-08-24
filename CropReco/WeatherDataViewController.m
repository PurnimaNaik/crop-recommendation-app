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
NSString* weatherDescripionVar;
NSString* weatherIconImage;
NSString* weatherBackgroundImage;
NSString* dayNightIndicator;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestPermission];
    // Do any additional setup after loading the view, typically from a nib.
    self.searchBarOutlet.delegate=self;
    [self.disclaimerLabel setTextContainerInset:UIEdgeInsetsZero];
    [self.weatherDescription sizeToFit];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)]];
    
    [self.searchBarOutlet setBackgroundColor:[UIColor clearColor]];
    [self.searchBarOutlet setBackgroundImage:[UIImage new]];
    [self.searchBarOutlet setTranslucent:YES];
    
    for (UIView *subView in _searchBarWeatherTab.subviews) {
        for(id field in subView.subviews){
            if ([field isKindOfClass:[UITextField class]]) {
                UITextField *textField = (UITextField *)field;
                [textField setBackgroundColor:[UIColor colorWithRed:250.0f/255.0f
                                                              green:250.0f/255.0f
                                                               blue:250.0f/255.0f
                                                              alpha:1.0f]];
                [textField setFont:[UIFont fontWithName:@"Optima" size:20]];
            }
        }
    }
    
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
        
        //        NSLog(@"searchQuery  %@",searchQuery);
        
        
        NSString *escapedURL = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        //        NSLog(@"escapedURL: %@", escapedURL);
        
        [self getDataFrom:escapedURL];
    }];
}

- (void) getDataFrom:(NSString *)url{
    //    NSLog(@"url  %@",url);
    [self.loader startAnimating];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"dataTaskWithRequest error: %@", error);
            
            NSString *getErrorMessage = error.localizedDescription;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.searchedPlaceLabel.text=@"...";
                self.weatherDescription.text=getErrorMessage;
                 [self.loader stopAnimating];
            });
            [self clearLabels];
        }
        
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            if (statusCode != 200) {
                NSLog(@"Expected responseCode == 200; received %ld", (long)statusCode);
                NSLog(@"response %@",response);
                 if(statusCode == 429){
                     dispatch_async(dispatch_get_main_queue(), ^{
                         self.searchedPlaceLabel.text=@"API limit exceeded";
                         self.weatherDescription.text=@"Please try after a while";
                          [self.loader stopAnimating];
                     });
                 }
                else if(statusCode >= 400 && statusCode <500 ){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.searchedPlaceLabel.text=@"Unable to access loaction";
                        self.weatherDescription.text=@"Turn on location permission or search for your city";
                         [self.loader stopAnimating];
                    });
                }
 
                else if( statusCode>500){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.searchedPlaceLabel.text=@"OpenWeather";
                        self.weatherDescription.text=@"server error";
                         [self.loader stopAnimating];
                    });
                }
                
                
                [self clearLabels];
            }
            else{
                
                NSError *jsonError;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:&jsonError];
                
                
                NSLog(@"json %@", json);
                //                NSLog(@"sunrise %@", json[@"sys"][@"sunrise"]);
                //                NSLog(@"sunset %@", json[@"sys"][@"sunset"]);
                //                NSLog(@"visibility %@", json[@"visibility"]);
                //                NSLog(@"weather %@", json[@"weather"]);
                
                for (NSDictionary *dict in json[@"weather"]) {
                    
                    weatherDescripionVar=dict[@"description"];
                    weatherIconImage=[NSString stringWithFormat:@"%@.png", dict[@"icon"] ];
                    weatherBackgroundImage=[NSString stringWithFormat:@"%@.jpg", dict[@"icon"] ];
                    NSString* icon=[NSString stringWithFormat:@"%@", dict[@"icon"] ];
                    dayNightIndicator = [icon substringWithRange:NSMakeRange(2, 1)];
                    //                    NSLog(@"dayNightIndicator %@", dayNightIndicator);
                }
                
                
                
                NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
                [fmt setPositiveFormat:@"0.##"];
                
                NSString* windDirection=[self checkDirection:[json[@"wind"][@"deg"]doubleValue]];
                NSString* windSpeed=[fmt stringFromNumber:json[@"wind"][@"speed"]];
                
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
                    
                    [self.loader stopAnimating];
                    self.weatherDescription.text=[weatherDescripionVar capitalizedString];
                    self.avgTempLabel.text =[NSString stringWithFormat:@"%@%@", json[@"main"][@"temp"], @"°C" ];
                    self.searchedPlaceLabel.text =[NSString stringWithFormat:@"%@, %@", json[@"name"], json[@"sys"][@"country"] ];
                    self.minTempLabel.text =[NSString stringWithFormat:@"%@%@", json[@"main"][@"temp_min"], @"°C" ];
                    self.maxTempLabel.text =[NSString stringWithFormat:@"%@%@", json[@"main"][@"temp_max"], @"°C" ];
                    self.humidityLabel.text =[NSString stringWithFormat:@"%@%@", json[@"main"][@"humidity"], @"%" ];
                    self.sunriseLabel.text =[NSString stringWithFormat:@"%@ %@", sunriseTime, @"AM" ];
                    self.sunsetLabel.text =[NSString stringWithFormat:@"%@ %@", sunsetTime, @"PM" ];
                    
                    self.windLabel.text =[NSString stringWithFormat:@"%@ %@ %@", windSpeed, @"mph", windDirection ];
                    
                    self.weatherIcon.image=[UIImage imageNamed:weatherIconImage];
                    self.weatherBackground.image=[UIImage imageNamed:weatherBackgroundImage];
                    
                    if([dayNightIndicator isEqual:@"n"]){
                        self.avgTempLabel.textColor=[UIColor whiteColor];
                        self.minTempLabel.textColor=[UIColor whiteColor];
                        self.maxTempLabel.textColor=[UIColor whiteColor];
                        self.humidityLabel.textColor=[UIColor whiteColor];
                        self.sunriseLabel.textColor=[UIColor whiteColor];
                        self.sunsetLabel.textColor=[UIColor whiteColor];
                        self.windLabel.textColor=[UIColor whiteColor];
                        self.weatherDescription.textColor=[UIColor whiteColor];
                        self.disclaimerLabel.textColor=[UIColor whiteColor];
                        self.searchedPlaceLabel.textColor=[UIColor whiteColor];
                        
                        
                        self.avgTempLabelDescriptor.textColor=[UIColor whiteColor];
                        self.minTempLabelDescriptor.textColor=[UIColor whiteColor];
                        self.maxTempLabelDescriptor.textColor=[UIColor whiteColor];
                        self.humidityLabelDescriptor.textColor=[UIColor whiteColor];
                        self.sunriseLabelDescriptor.textColor=[UIColor whiteColor];
                        self.sunsetLabelDescriptor.textColor=[UIColor whiteColor];
                        self.windLabelDescriptor.textColor=[UIColor whiteColor];
                    }
                    else{
                        self.avgTempLabel.textColor=[UIColor blackColor];
                        self.minTempLabel.textColor=[UIColor blackColor];
                        self.maxTempLabel.textColor=[UIColor blackColor];
                        self.humidityLabel.textColor=[UIColor blackColor];
                        self.sunriseLabel.textColor=[UIColor blackColor];
                        self.sunsetLabel.textColor=[UIColor blackColor];
                        self.windLabel.textColor=[UIColor blackColor];
                        self.weatherDescription.textColor=[UIColor blackColor];
                        self.disclaimerLabel.textColor=[UIColor blackColor];
                        self.searchedPlaceLabel.textColor=[UIColor blackColor];
                        
                        self.avgTempLabelDescriptor.textColor=[UIColor blackColor];
                        self.minTempLabelDescriptor.textColor=[UIColor blackColor];
                        self.maxTempLabelDescriptor.textColor=[UIColor blackColor];
                        self.humidityLabelDescriptor.textColor=[UIColor blackColor];
                        self.sunriseLabelDescriptor.textColor=[UIColor blackColor];
                        self.sunsetLabelDescriptor.textColor=[UIColor blackColor];
                        self.windLabelDescriptor.textColor=[UIColor blackColor];
                    }
                });
            }
        }
    }];
    
    [task resume];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchOpenWeatherAPI:searchBar.text];
    [searchBar resignFirstResponder];
    
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    //    [self clearResponseErrorLabels];
}

- (void) searchOpenWeatherAPI:(NSString *)searchText{
    [self.loader startAnimating];
    NSString *escapedsearchText = [searchText stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@%@%@",
                     @"https://api.openweathermap.org/data/2.5/weather?q=",
                     escapedsearchText,
                     @"&units=metric",
                     @"&appid=",
                     @"4c1aa9e27863af68e069647e446328f3"];
    
    //    NSLog(@"searchQuery  %@",searchText);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"dataTaskWithRequest error: %@", error);
            
            NSString *getErrorMessage = error.localizedDescription;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.searchedPlaceLabel.text=@"...";
                self.weatherDescription.text=getErrorMessage;
                 [self.loader stopAnimating];
            });
            [self clearLabels];
            //            [self clearResponseErrorLabels];
        }
        
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            if (statusCode != 200) {
                NSLog(@"Expected responseCode == 200; received %ld", (long)statusCode);
                NSLog(@"response %@",response);
                if(statusCode == 429){
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     self.searchedPlaceLabel.text=@"API limit exceeded";
                                     self.weatherDescription.text=@"Please try after a while";
                                      [self.loader stopAnimating];
                                 });
                             }
                else if(statusCode >= 400 && statusCode <500 ){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.searchedPlaceLabel.text=self.searchBarWeatherTab.text;
                        self.weatherDescription.text=@"City not found, please try another city";
                         [self.loader stopAnimating];
                    });
                }
             
                else if( statusCode>500){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.searchedPlaceLabel.text=@"OpenWeather";
                        self.weatherDescription.text=@"server error";
                         [self.loader stopAnimating];
                    });
                }
                
                
                [self clearLabels];
            }
            else{
                
                NSError *jsonError;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:&jsonError];
                
                
                NSLog(@"json %@", json);
                //                NSLog(@"sunrise %@", json[@"sys"][@"sunrise"]);
                //                NSLog(@"sunset %@", json[@"sys"][@"sunset"]);
                //                NSLog(@"visibility %@", json[@"visibility"]);
                //                NSLog(@"weather %@", json[@"weather"]);
                
                for (NSDictionary *dict in json[@"weather"]) {
                    
                    weatherDescripionVar=dict[@"description"];
                    weatherIconImage=[NSString stringWithFormat:@"%@.png", dict[@"icon"] ];
                    weatherBackgroundImage=[NSString stringWithFormat:@"%@.jpg", dict[@"icon"] ];
                    NSString* icon=[NSString stringWithFormat:@"%@", dict[@"icon"] ];
                    dayNightIndicator = [icon substringWithRange:NSMakeRange(2, 1)];
                    NSLog(@"dayNightIndicator %@", dayNightIndicator);
                }
                
                NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
                [fmt setPositiveFormat:@"0.##"];
                
                NSString* windDirection=[self checkDirection:[json[@"wind"][@"deg"]doubleValue]];
                NSString* windSpeed=[fmt stringFromNumber:json[@"wind"][@"speed"]];
                
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
                    [self.loader stopAnimating];
                    self.weatherDescription.text=[weatherDescripionVar capitalizedString];
                    self.avgTempLabel.text =[NSString stringWithFormat:@"%@%@", json[@"main"][@"temp"], @"°C" ];
                    self.searchedPlaceLabel.text =[NSString stringWithFormat:@"%@, %@", json[@"name"], json[@"sys"][@"country"] ];
                    self.minTempLabel.text =[NSString stringWithFormat:@"%@%@", json[@"main"][@"temp_min"], @"°C" ];
                    self.maxTempLabel.text =[NSString stringWithFormat:@"%@%@", json[@"main"][@"temp_max"], @"°C" ];
                    self.humidityLabel.text =[NSString stringWithFormat:@"%@%@", json[@"main"][@"humidity"], @"%" ];
                    
                    self.sunriseLabel.text =[NSString stringWithFormat:@"%@ %@", sunriseTime, @"AM" ];
                    self.sunsetLabel.text =[NSString stringWithFormat:@"%@ %@", sunsetTime, @"PM" ];
                    
                    self.windLabel.text =[NSString stringWithFormat:@"%@ %@ %@", windSpeed, @"mph", windDirection ];
                    
                    self.weatherIcon.image=[UIImage imageNamed:weatherIconImage];
                    self.weatherBackground.image=[UIImage imageNamed:weatherBackgroundImage];
                    
                    if([dayNightIndicator isEqual:@"n"]){
                        self.avgTempLabel.textColor=[UIColor whiteColor];
                        self.minTempLabel.textColor=[UIColor whiteColor];
                        self.maxTempLabel.textColor=[UIColor whiteColor];
                        self.humidityLabel.textColor=[UIColor whiteColor];
                        self.sunriseLabel.textColor=[UIColor whiteColor];
                        self.sunsetLabel.textColor=[UIColor whiteColor];
                        self.windLabel.textColor=[UIColor whiteColor];
                        self.weatherDescription.textColor=[UIColor whiteColor];
                        self.disclaimerLabel.textColor=[UIColor whiteColor];
                        self.searchedPlaceLabel.textColor=[UIColor whiteColor];
                        
                        
                        self.avgTempLabelDescriptor.textColor=[UIColor whiteColor];
                        self.minTempLabelDescriptor.textColor=[UIColor whiteColor];
                        self.maxTempLabelDescriptor.textColor=[UIColor whiteColor];
                        self.humidityLabelDescriptor.textColor=[UIColor whiteColor];
                        self.sunriseLabelDescriptor.textColor=[UIColor whiteColor];
                        self.sunsetLabelDescriptor.textColor=[UIColor whiteColor];
                        self.windLabelDescriptor.textColor=[UIColor whiteColor];
                    }
                    else{
                        self.avgTempLabel.textColor=[UIColor blackColor];
                        self.minTempLabel.textColor=[UIColor blackColor];
                        self.maxTempLabel.textColor=[UIColor blackColor];
                        self.humidityLabel.textColor=[UIColor blackColor];
                        self.sunriseLabel.textColor=[UIColor blackColor];
                        self.sunsetLabel.textColor=[UIColor blackColor];
                        self.windLabel.textColor=[UIColor blackColor];
                        self.weatherDescription.textColor=[UIColor blackColor];
                        self.disclaimerLabel.textColor=[UIColor blackColor];
                        self.searchedPlaceLabel.textColor=[UIColor blackColor];
                        
                        self.avgTempLabelDescriptor.textColor=[UIColor blackColor];
                        self.minTempLabelDescriptor.textColor=[UIColor blackColor];
                        self.maxTempLabelDescriptor.textColor=[UIColor blackColor];
                        self.humidityLabelDescriptor.textColor=[UIColor blackColor];
                        self.sunriseLabelDescriptor.textColor=[UIColor blackColor];
                        self.sunsetLabelDescriptor.textColor=[UIColor blackColor];
                        self.windLabelDescriptor.textColor=[UIColor blackColor];
                    }
                    
                    
                });
            }
        }
    }];
    
    [task resume];
}

-(void)clearLabels{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.avgTempLabel.text =@"...";
        self.minTempLabel.text =@"...";
        self.maxTempLabel.text =@"...";
        self.humidityLabel.text =@"...";
        self.sunriseLabel.text =@"...";
        self.sunsetLabel.text =@"...";
        
        self.windLabel.text =@"...";;
        
        self.weatherIcon.image=nil;
        self.weatherBackground.image=nil;
        
        self.avgTempLabel.textColor=[UIColor blackColor];
        self.minTempLabel.textColor=[UIColor blackColor];
        self.maxTempLabel.textColor=[UIColor blackColor];
        self.humidityLabel.textColor=[UIColor blackColor];
        self.sunriseLabel.textColor=[UIColor blackColor];
        self.sunsetLabel.textColor=[UIColor blackColor];
        self.windLabel.textColor=[UIColor blackColor];
        self.weatherDescription.textColor=[UIColor blackColor];
        self.disclaimerLabel.textColor=[UIColor blackColor];
        self.searchedPlaceLabel.textColor=[UIColor blackColor];
        
        self.avgTempLabelDescriptor.textColor=[UIColor blackColor];
        self.minTempLabelDescriptor.textColor=[UIColor blackColor];
        self.maxTempLabelDescriptor.textColor=[UIColor blackColor];
        self.humidityLabelDescriptor.textColor=[UIColor blackColor];
        self.sunriseLabelDescriptor.textColor=[UIColor blackColor];
        self.sunsetLabelDescriptor.textColor=[UIColor blackColor];
        self.windLabelDescriptor.textColor=[UIColor blackColor];
        
        
    });
}

-(void)clearResponseErrorLabels{
    //    dispatch_async(dispatch_get_main_queue(), ^{
    self.searchedPlaceLabel.text=@"...";
    self.weatherDescription.text=@"...";
    //                  });
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
