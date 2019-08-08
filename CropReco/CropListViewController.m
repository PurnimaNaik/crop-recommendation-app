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
    NSMutableArray *cropNameArr;
    NSMutableArray *minTempArr;
}

@end

@implementation CropListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    _cropTable.delegate = self;
//    _cropTable.dataSource = self;
    
    cropNameArr=[[NSMutableArray alloc]init];
    minTempArr=[[NSMutableArray alloc]init];
    
    NSDictionary *rootDictinary=[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"crops" ofType:@"plist"]];
    
    NSArray *arrayList=[NSArray arrayWithArray:[rootDictinary objectForKey:@"CropList"]];
    
    [arrayList enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL * stop) {
        [self->cropNameArr addObject:[obj valueForKey:@"CropName"]];
        [self->minTempArr addObject:[obj valueForKey:@"MinTemp"]];
    }];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"json %lu", (unsigned long)[cropNameArr count]);
    return [cropNameArr count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *tableIdentifier=@"SimpleTableItem";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:tableIdentifier];
    }
    
    cell.textLabel.text=[cropNameArr objectAtIndex:indexPath.row];
    NSString *minTempString = [NSString stringWithFormat:@"%@",[minTempArr objectAtIndex:indexPath.row]];
    cell.detailTextLabel.text= minTempString;
    
    return cell;
}


@end

