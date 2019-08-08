//
//  CropListViewController.m
//  CropReco
//
//  Created by Purnima Naik on 8/5/19.
//  Copyright © 2019 Purnima Naik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CropListViewController.h"

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
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:tableIdentifier];
    }
    
    _crop=mainCropArray[indexPath.row];
//    NSLog(@"---------- %@ ---------- %ld", mainCropArray[indexPath.row], (long)indexPath.row);
    
//    cell.textLabel.text=[cropNameArr objectAtIndex:indexPath.row];
//    NSString *minTempString = [NSString stringWithFormat:@"%@",[minTempArr objectAtIndex:indexPath.row]];
//    cell.detailTextLabel.text= minTempString;
    
    
    NSString *minTempString = [NSString stringWithFormat:@"%@",_crop[@"MinTemp"]];
    NSString *imageName = _crop[@"ImageName"];

    
    UIImage *image =[UIImage imageNamed:imageName];
    
    cell.textLabel.text=_crop[@"CropName"];
    cell.detailTextLabel.text= minTempString;
    cell.imageView.image=image;
    
    return cell;
}


@end

