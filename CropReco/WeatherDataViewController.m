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
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchOpenWeatherAPI:searchBar.text];
    [searchBar resignFirstResponder];
}

- (void) searchOpenWeatherAPI:(NSString *)searchText{
    
    NSString *escapedsearchText = [searchText stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@%@",
                     @"https://api.openweathermap.org/data/2.5/weather?q=",
                     escapedsearchText,
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
                NSLog(@"json %@", json[@"main"]);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.avgTempLabel.text =[NSString stringWithFormat:@"%@", json[@"main"][@"temp"] ];
                    self.minTempLabel.text =[NSString stringWithFormat:@"%@", json[@"main"][@"temp_min"] ];
                    self.maxTempLabel.text =[NSString stringWithFormat:@"%@", json[@"main"][@"temp_max"] ];
                    self.humidityLabel.text =[NSString stringWithFormat:@"%@", json[@"main"][@"humidity"] ];
                    self.pressureLabel.text =[NSString stringWithFormat:@"%@", json[@"main"][@"pressure"] ];
                });
            }
        }
    }];
    [task resume];
}



@end
