//
//  RecommendationsCustomCell.h
//  CropReco
//
//  Created by Purnima Naik on 8/14/19.
//  Copyright © 2019 Purnima Naik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendationsCustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *customRecommendationNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *customRecommendationTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *customRecommendationRainfallLabel;
@property (weak, nonatomic) IBOutlet UILabel *customRecommendationSoilLabel;
@property (weak, nonatomic) IBOutlet UILabel *customRecommendationProducersLabel;
@property (weak, nonatomic) IBOutlet UIImageView *customRecommendationImageView;
@end
