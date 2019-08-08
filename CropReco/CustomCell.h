//
//  CustomCell.h
//  CropReco
//
//  Created by Purnima Naik on 8/8/19.
//  Copyright © 2019 Purnima Naik. All rights reserved.
//

//#ifndef CustomCell_h
//#define CustomCell_h
//
//
//#endif /* CustomCell_h */

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *customNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *customTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *customRainfallLabel;
@property (weak, nonatomic) IBOutlet UILabel *customSoilLabel;
@property (weak, nonatomic) IBOutlet UILabel *customProducersLabel;
@property (weak, nonatomic) IBOutlet UIImageView *customImageView;

@end
