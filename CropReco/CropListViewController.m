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
@property (nonatomic, copy)NSMutableArray *filteredCrop;
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation CropListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _filteredCrop=[[NSMutableArray alloc]init];
  
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    
//    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
//    self.searchController.searchBar.delegate = self;
    
    self.searchBar.barTintColor=[UIColor whiteColor];
    
    
    for (UIView *subView in _searchBar.subviews) {
        for(id field in subView.subviews){
            if ([field isKindOfClass:[UITextField class]]) {
                UITextField *textField = (UITextField *)field;
                //                [textField setBackgroundColor:[UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:0.5]];
                [textField setBackgroundColor:[UIColor whiteColor]];
                [textField setFont:[UIFont fontWithName:@"Optima" size:20]];
            }
        }
    }
    
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


- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = self.searchController.searchBar.text;
//    [self searchForText:searchString scope:searchController.searchBar.selectedScopeButtonIndex];
    NSLog(@"searched-%@",searchString);
    [self.tableViewCropList reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(_tableViewCropList.tag==1){
        return [mainCropArray count];
    }
    else{
        return [_filteredCrop count];
    }
//    return [mainCropArray count];
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *tableIdentifier=@"SimpleTableItem";
    
    CustomCell *customCell=[tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    
    
    if(_tableViewCropList.tag==1){
    _crop=mainCropArray[indexPath.row];
    
    
    NSString *tempRange = [NSString stringWithFormat:@"%@-%@ °C",_crop[@"MinTemp"],_crop[@"MaxTemp"]];
    NSString *rainfallRange = [NSString stringWithFormat:@"%@-%@ cm",_crop[@"MinRainfall"],_crop[@"MaxRainfall"]];
    
    NSString *imageName = _crop[@"ImageName"];
    UIImage *image =[UIImage imageNamed:imageName];
    
    customCell.customNameLabel.text=[_crop[@"CropName"] capitalizedString];
    customCell.customTempLabel.text=tempRange;
    customCell.customRainfallLabel.text=rainfallRange;
    customCell.customImageView.image=image;
    customCell.customProducersLabel.text= _crop[@"ProducersToDisplay"];
    
    NSString* soilTypes=[_crop[@"SoilTypeToDisplay"] capitalizedString];
    NSMutableAttributedString* attsoilTypes = [[NSMutableAttributedString alloc]initWithString:soilTypes];
    NSMutableParagraphStyle *soilParagraphStyle = [[NSMutableParagraphStyle alloc]init];
    soilParagraphStyle.firstLineHeadIndent=0.0f;
    [attsoilTypes addAttribute:NSParagraphStyleAttributeName value:soilParagraphStyle range:NSMakeRange(0, attsoilTypes.length)];
    [attsoilTypes addAttribute:NSParagraphStyleAttributeName
                         value:soilParagraphStyle
                         range:NSMakeRange(0, attsoilTypes.length)];
    customCell.customSoilLabel.attributedText = attsoilTypes;
    
    NSString* producerList=_crop[@"ProducersToDisplay"];
    NSMutableAttributedString* attproducerList = [[NSMutableAttributedString alloc]initWithString:producerList];
    NSMutableParagraphStyle *producerParagraphStyle = [[NSMutableParagraphStyle alloc]init];
    producerParagraphStyle.firstLineHeadIndent=0.0f;
    [attproducerList addAttribute:NSParagraphStyleAttributeName value:producerParagraphStyle range:NSMakeRange(0, attproducerList.length)];
    [attproducerList addAttribute:NSParagraphStyleAttributeName
                            value:producerParagraphStyle
                            range:NSMakeRange(0, attproducerList.length)];
    customCell.customProducersLabel.attributedText = attproducerList;
    
    
    customCell.customSoilLabel.adjustsFontSizeToFitWidth = true;
    customCell.customProducersLabel.adjustsFontSizeToFitWidth = true;
    //    [myLabel sizeToFit];
    }
    
    else
    {
        _crop=_filteredCrop[indexPath.row];
        
        
        NSString *tempRange = [NSString stringWithFormat:@"%@-%@ °C",_crop[@"MinTemp"],_crop[@"MaxTemp"]];
        NSString *rainfallRange = [NSString stringWithFormat:@"%@-%@ cm",_crop[@"MinRainfall"],_crop[@"MaxRainfall"]];
        
        NSString *imageName = _crop[@"ImageName"];
        UIImage *image =[UIImage imageNamed:imageName];
        
        customCell.customNameLabel.text=[_crop[@"CropName"] capitalizedString];
        customCell.customTempLabel.text=tempRange;
        customCell.customRainfallLabel.text=rainfallRange;
        customCell.customImageView.image=image;
        customCell.customProducersLabel.text= _crop[@"ProducersToDisplay"];
        
        NSString* soilTypes=[_crop[@"SoilTypeToDisplay"] capitalizedString];
        NSMutableAttributedString* attsoilTypes = [[NSMutableAttributedString alloc]initWithString:soilTypes];
        NSMutableParagraphStyle *soilParagraphStyle = [[NSMutableParagraphStyle alloc]init];
        soilParagraphStyle.firstLineHeadIndent=0.0f;
        [attsoilTypes addAttribute:NSParagraphStyleAttributeName value:soilParagraphStyle range:NSMakeRange(0, attsoilTypes.length)];
        [attsoilTypes addAttribute:NSParagraphStyleAttributeName
                             value:soilParagraphStyle
                             range:NSMakeRange(0, attsoilTypes.length)];
        customCell.customSoilLabel.attributedText = attsoilTypes;
        
        NSString* producerList=_crop[@"ProducersToDisplay"];
        NSMutableAttributedString* attproducerList = [[NSMutableAttributedString alloc]initWithString:producerList];
        NSMutableParagraphStyle *producerParagraphStyle = [[NSMutableParagraphStyle alloc]init];
        producerParagraphStyle.firstLineHeadIndent=0.0f;
        [attproducerList addAttribute:NSParagraphStyleAttributeName value:producerParagraphStyle range:NSMakeRange(0, attproducerList.length)];
        [attproducerList addAttribute:NSParagraphStyleAttributeName
                                value:producerParagraphStyle
                                range:NSMakeRange(0, attproducerList.length)];
        customCell.customProducersLabel.attributedText = attproducerList;
        
        
        customCell.customSoilLabel.adjustsFontSizeToFitWidth = true;
        customCell.customProducersLabel.adjustsFontSizeToFitWidth = true;
        //    [myLabel sizeToFit];
    }
    return customCell;
}


@end

