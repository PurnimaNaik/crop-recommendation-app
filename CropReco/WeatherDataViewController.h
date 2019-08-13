//
//  WeatherDataViewController.h
//  CropReco
//
//  Created by Purnima Naik on 8/4/19.
//  Copyright © 2019 Purnima Naik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherDataViewController : UIViewController <UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBarOutlet;
@property (weak, nonatomic) IBOutlet UILabel *avgTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *minTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *pressureLabel;
@property (weak, nonatomic) IBOutlet UITextView *disclaimerLabel;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBarWeatherTab;
@property (weak, nonatomic) IBOutlet UILabel *sunriseLabel;
@property (weak, nonatomic) IBOutlet UILabel *sunsetLabel;
@property (weak, nonatomic) IBOutlet UILabel *windLabel;
@property (weak, nonatomic) IBOutlet UILabel *visibilityLabel;
@property (strong, nonatomic) IBOutlet UILabel *avgTempLabelDescriptor;
@property (weak, nonatomic) IBOutlet UILabel *weatherDescription;
@property (weak, nonatomic) IBOutlet UIImageView *weatherIcon;
@property (weak, nonatomic) IBOutlet UIImageView *weatherBackground;
@property (strong, nonatomic) IBOutlet UILabel *sunriseLabelDescriptor;
@property (weak, nonatomic) IBOutlet UITabBarItem *weatherTabIcon;
@property (strong, nonatomic) IBOutlet UILabel *sunsetLabelDescriptor;
@property (strong, nonatomic) IBOutlet UILabel *minTempLabelDescriptor;
@property (strong, nonatomic) IBOutlet UILabel *visibilityLabelDescriptor;
@property (strong, nonatomic) IBOutlet UILabel *humidityLabelDescriptor;
@property (strong, nonatomic) IBOutlet UILabel *windLabelDescriptor;
@property (strong, nonatomic) IBOutlet UILabel *pressureLabelDescriptor;
@property (strong, nonatomic) IBOutlet UILabel *maxTempLabelDescriptor;





@end

