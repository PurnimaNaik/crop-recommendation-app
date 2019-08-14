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
@property (nonatomic, strong) NSMutableArray *cropNameList;
@property (nonatomic, strong) NSMutableArray *filteredCropArray;
@property (nonatomic, strong) UISearchController *cropSearchController;

@end

@implementation CropListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)]];
    
    self.filteredCropArray=[[NSMutableArray alloc]init];
    self.cropNameList=[[NSMutableArray alloc]init];
    self.cropSearchController = [[UISearchController alloc] init];
    self.cropSearchController.searchResultsUpdater = self;
    self.cropSearchController.delegate = self;
    self.cropSearchController.searchBar.delegate = self;
    self.cropSearchController.obscuresBackgroundDuringPresentation = NO;
    
    
    self.searchBar.barTintColor=[UIColor whiteColor];
    
    
    for (UIView *subView in _searchBar.subviews) {
        for(id field in subView.subviews){
            if ([field isKindOfClass:[UITextField class]]) {
                UITextField *textField = (UITextField *)field;
                [textField setBackgroundColor:[UIColor whiteColor]];
                [textField setFont:[UIFont fontWithName:@"Optima" size:20]];
            }
        }
    }
    
    mainCropArray=[[NSMutableArray alloc]init];
    
    NSDictionary *rootDictinary=[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"crops" ofType:@"plist"]];
    
    NSArray *arrayList=[NSArray arrayWithArray:[rootDictinary objectForKey:@"CropList"]];
    
    mainCropArray=[NSMutableArray arrayWithArray:arrayList];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{    
    [self searchCropList];
    [self.tableViewCropList reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if( [self.searchBar.text isEqual:@""]){
        return [mainCropArray count];
    }
    else{
        return [self.filteredCropArray count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *tableIdentifier=@"SimpleTableItem";
    
    CustomCell *customCell=[tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    
    if( [self.searchBar.text isEqual:@""]){
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
        _crop=self.filteredCropArray[indexPath.row];
        NSString *tempRange = [NSString stringWithFormat:@"%@-%@ °C",_crop[@"MinTemp"],_crop[@"MaxTemp"]];
        NSString *rainfallRange = [NSString stringWithFormat:@"%@-%@ cm",_crop[@"MinRainfall"],_crop[@"MaxRainfall"]];
        
        NSString *imageName = _crop[@"ImageName"];
        UIImage *image =[UIImage imageNamed:imageName];
        
        [_cropNameList addObject:_crop[@"CropName"]];
        
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

-(void)searchCropList{
    if(self.filteredCropArray.count>0){
        [self.filteredCropArray removeAllObjects];
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.CropName MATCHES[c] %@", [NSString stringWithFormat: @".*\\b%@.*",self.searchBar.text]];
    
    NSArray* matches=[[NSArray alloc]init];
    
    matches = [mainCropArray filteredArrayUsingPredicate:predicate];
    
    if([matches count] > 0){
        self.filteredCropArray=[NSMutableArray arrayWithArray:matches];
    }
    
}




@end

