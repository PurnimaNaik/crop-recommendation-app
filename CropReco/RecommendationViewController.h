//
//  RecommendationViewController.h
//  CropReco
//
//  Created by Purnima Naik on 8/4/19.
//  Copyright © 2019 Purnima Naik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface RecommendationViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    CLLocationManager *locationManager;
    
}

@property (weak, nonatomic) IBOutlet UILabel *avgTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *minTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UITabBarItem *recommendationTabIcon;
@property (weak, nonatomic) IBOutlet UILabel *pressureLabel;

@property (strong, nonatomic) IBOutlet UITableView *recommendationTableView;

@end

