//
//  CropListViewController.h
//  CropReco
//
//  Created by Purnima Naik on 8/5/19.
//  Copyright © 2019 Purnima Naik. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface CropListViewController : UIViewController <UISearchControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate >
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableViewCropList;
@property (weak, nonatomic) IBOutlet UITabBarItem *cropListTabIcon;
@end
