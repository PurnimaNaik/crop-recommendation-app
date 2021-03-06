//
//  RecommendationViewController.h
//  CropReco
//
//  Created by Purnima Naik on 8/4/19.
//  Copyright © 2019 Purnima Naik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface RecommendationViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>{
//    CLLocationManager *locationManager;
    
}
//@property (nonatomic,retain) CLLocationManager
@property (weak, nonatomic) IBOutlet UILabel *avgTempLabelinReco;
@property (strong, nonatomic) IBOutlet UILabel *cropTemperatureLabel;

@property (weak, nonatomic) IBOutlet UITabBarItem *recommendationTabIcon;
@property (strong, nonatomic) IBOutlet UILabel *recommendedCropName;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *cropRainfallLabel;
@property (strong, nonatomic) IBOutlet UIImageView *recommendedCropImage;

@property (strong, nonatomic) IBOutlet UILabel *weatherDescriptionLabel;
@property (strong, nonatomic) IBOutlet UITableView *recommendationTableView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loader;

@end

