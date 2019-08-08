//
//  CropListViewController.m
//  CropReco
//
//  Created by Purnima Naik on 8/5/19.
//  Copyright © 2019 Purnima Naik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CropListViewController.h"
#import "CustomCell.h"

@interface CropListViewController (){
//    NSMutableArray *cropNameArr;
//    NSMutableArray *minTempArr;
    NSMutableArray *mainCropArray;
}
    @property (nonatomic, strong) NSDictionary *crop;
@end

@implementation CropListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    _cropTable.delegate = self;
//    _cropTable.dataSource = self;
    
//    cropNameArr=[[NSMutableArray alloc]init];
//    minTempArr=[[NSMutableArray alloc]init];
    mainCropArray=[[NSMutableArray alloc]init];
    
    NSDictionary *rootDictinary=[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"crops" ofType:@"plist"]];
    
    NSArray *arrayList=[NSArray arrayWithArray:[rootDictinary objectForKey:@"CropList"]];
    
    mainCropArray=[NSMutableArray arrayWithArray:arrayList];
    
//    [arrayList enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL * stop) {
//        [self->cropNameArr addObject:[obj valueForKey:@"CropName"]];
//        [self->minTempArr addObject:[obj valueForKey:@"MinTemp"]];
//    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [mainCropArray count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *tableIdentifier=@"SimpleTableItem";
    
    CustomCell *customCell=[tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    
//    if(customCell==nil){
//        customCell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:tableIdentifier];
//    }
    
    _crop=mainCropArray[indexPath.row];
//    NSLog(@"---------- %@ ---------- %ld", mainCropArray[indexPath.row], (long)indexPath.row);
    
//    cell.textLabel.text=[cropNameArr objectAtIndex:indexPath.row];
//    NSString *minTempString = [NSString stringWithFormat:@"%@",[minTempArr objectAtIndex:indexPath.row]];
//    cell.detailTextLabel.text= minTempString;
    
    
    NSString *tempRange = [NSString stringWithFormat:@"%@-%@ °C",_crop[@"MinTemp"],_crop[@"MaxTemp"]];
     NSString *rainfallRange = [NSString stringWithFormat:@"%@-%@ cm",_crop[@"MinRainfall"],_crop[@"MaxRainfall"]];
    
//    [view.layer setShadowColor: [UIColor grayColor].CGColor];
//    [view.layer setShadowOpacity:0.8];
//    [view.layer setShadowRadius:3.0];
//    [view.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    NSString *imageName = _crop[@"ImageName"];
    UIImage *image =[UIImage imageNamed:imageName];
    
    customCell.customNameLabel.text=[_crop[@"CropName"] capitalizedString];
    customCell.customTempLabel.text=tempRange;
    customCell.customRainfallLabel.text=rainfallRange;
    customCell.customSoilLabel.text=_crop[@"SoilTypeToDisplay"];
    customCell.customProducersLabel.text= _crop[@"ProducersToDisplay"];
    customCell.customImageView.image=image;
    
    customCell.customSoilLabel.adjustsFontSizeToFitWidth = true;
    customCell.customProducersLabel.adjustsFontSizeToFitWidth = true;
    
    
    return customCell;
}


@end

