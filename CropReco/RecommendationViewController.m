//
//  RecommendationViewController.m
//  CropReco
//
//  Created by Purnima Naik on 8/4/19.
//  Copyright © 2019 Purnima Naik. All rights reserved.
//

#import "RecommendationViewController.h"


@interface RecommendationViewController ()

@end

@implementation RecommendationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
//    if ([CLLocationManager locationServicesEnabled]){
//
//        NSLog(@"Location Services Enabled");
//
//        if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
//            alert = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
//                                               message:@"To re-enable, please go to Settings and turn on Location Service for this app."
//                                              delegate:nil
//                                     cancelButtonTitle:@"OK"
//                                     otherButtonTitles:nil];
//            [alert show];
//        }
//    }
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated{
    locationManager=[[CLLocationManager alloc]init];
    [locationManager requestWhenInUseAuthorization];
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    NSLog(@"%f",locationManager.location.coordinate.latitude);
    NSLog(@"%f",locationManager.location.coordinate.longitude);
}
@end
