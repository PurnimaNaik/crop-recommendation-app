//
//  RecommendationViewController.m
//  CropReco
//
//  Created by Purnima Naik on 8/4/19.
//  Copyright © 2019 Purnima Naik. All rights reserved.
//

#import "RecommendationViewController.h"
#import "RecommendationsCustomCell.h"

@interface RecommendationViewController (){
    NSMutableArray *mainCropArray;
    
}
@property (nonatomic, strong) NSDictionary *crop;
@property (nonatomic, strong) NSMutableArray *recommendedCropArray;
@property (nonatomic, strong) NSNumber *avgTemp;
@property (nonatomic, strong) NSNumber *weatherID;
@property (nonatomic, strong) NSString *country;


@end

@implementation RecommendationViewController
NSString* weatherDescripionVarInReco;
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    spinner.center = CGPointMake(160, 240);
//    spinner.tag = 12;
//    [self.view addSubview:spinner];

    
    self.recommendedCropArray=[[NSMutableArray alloc]init];
    
    mainCropArray=[[NSMutableArray alloc]init];
    
    NSDictionary *rootDictinary=[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"crops" ofType:@"plist"]];
    
    NSArray *arrayList=[NSArray arrayWithArray:[rootDictinary objectForKey:@"CropList"]];
    
    mainCropArray=[NSMutableArray arrayWithArray:arrayList];
    
    [self requestPermission];
}


-(void)findWeatherCompatibleCropsWithTemp:(NSNumber*)avgTemp
                            withWeatherID:(NSNumber*)weatherID  withCountry:(NSString*)country{
    
    
    NSMutableDictionary* cropScoreDict=[[NSMutableDictionary alloc]init];
    
    NSNumber *score = [NSNumber numberWithInt:0];
    for(NSDictionary * key in mainCropArray){
        score = [NSNumber numberWithInt:0];
        //        NSLog(@"---------------------");
        NSNumberFormatter *mintemp = [[NSNumberFormatter alloc] init];
        mintemp.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber* minTempNumber = [mintemp numberFromString:[key[@"MinTemp"]stringValue]];
        
        NSNumberFormatter *maxtemp = [[NSNumberFormatter alloc] init];
        maxtemp.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber* maxTempNumber = [maxtemp numberFromString:[key[@"MaxTemp"]stringValue]];
        
        NSArray* topProducers=key[@"TopProducers"];
        //        NSLog(@"---topProducers-%@",topProducers);
        
        if([avgTemp floatValue]>=[minTempNumber floatValue] && [avgTemp floatValue]<=[maxTempNumber floatValue]){
            
            int value = [score intValue];
            score = [NSNumber numberWithInt:value + 1];
        }
        
        if([topProducers containsObject: country]){
            int value = [score intValue];
            score = [NSNumber numberWithInt:value + 1];
        }
        [cropScoreDict setObject:score forKey:key[@"CropName"]];
        
    }
    //    NSLog(@"---cropScoreDict-%@",cropScoreDict);
    
    
    NSArray *sortedScoreArray = [cropScoreDict keysSortedByValueUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            
            return (NSComparisonResult)NSOrderedAscending;
        }
        if ([obj1 integerValue] < [obj2 integerValue]) {
            
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    //    NSLog(@"---sortedScoreArray-%@",sortedScoreArray);
    [self createRecommendedCropsList:sortedScoreArray];
    
    
    
}

-(void)createRecommendedCropsList:(NSArray*)sortedScoreArray{
    
    if(self.recommendedCropArray.count>0){
        [self.recommendedCropArray removeAllObjects];
    }
    
    for(int i=0;i<4;i++){
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains [search] %@",sortedScoreArray[i]];
        
        NSArray* matchedCrop=[[NSArray alloc]init];
        matchedCrop = [mainCropArray filteredArrayUsingPredicate:predicate];
        //          NSLog(@"--matchedCrop--%@",matchedCrop);
        if([matchedCrop count] > 0){
            //            self.filteredCropArray=[NSMutableArray arrayWithArray:matches];
            [self.recommendedCropArray addObject:matchedCrop];
        }
    }
    
    //    NSLog(@"--self.recommendedCropArray--%@",self.recommendedCropArray);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.recommendationTableView reloadData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        [self.recommendationTableView scrollToRowAtIndexPath:indexPath
                                            atScrollPosition:UITableViewScrollPositionTop
                                                    animated:YES];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
       [self.loader startAnimating];
    if( [self.recommendedCropArray count]>0){
        return [self.recommendedCropArray count];
    }
    else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *tableIdentifier=@"RecommendationsTableItem";
    
    RecommendationsCustomCell *customCell=[tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    
    if([self.recommendedCropArray count]>0){
        
        _crop=self.recommendedCropArray[indexPath.row][0];
        //            NSLog(@"_crop-----------%@",_crop);
        
        NSString *tempRange = [NSString stringWithFormat:@"%@-%@ °C",_crop[@"MinTemp"],_crop[@"MaxTemp"]];
        NSString *rainfallRange = [NSString stringWithFormat:@"%@-%@ cm",_crop[@"MinRainfall"],_crop[@"MaxRainfall"]];
        
        NSString *imageName = _crop[@"ImageName"];
        NSString *cropName = _crop[@"CropName"];
        UIImage *image =[UIImage imageNamed:imageName];
        NSString* soilTypes=_crop[@"SoilTypeToDisplay"];
        NSMutableAttributedString* attsoilTypes = [[NSMutableAttributedString alloc]initWithString:soilTypes];
        NSMutableParagraphStyle *soilParagraphStyle = [[NSMutableParagraphStyle alloc]init];
        soilParagraphStyle.firstLineHeadIndent=0.0f;
        [attsoilTypes addAttribute:NSParagraphStyleAttributeName value:soilParagraphStyle range:NSMakeRange(0, attsoilTypes.length)];
        [attsoilTypes addAttribute:NSParagraphStyleAttributeName
                             value:soilParagraphStyle
                             range:NSMakeRange(0, attsoilTypes.length)];
        
        NSString* producerList=self.crop[@"ProducersToDisplay"];
        NSMutableAttributedString* attproducerList = [[NSMutableAttributedString alloc]initWithString:producerList];
        NSMutableParagraphStyle *producerParagraphStyle = [[NSMutableParagraphStyle alloc]init];
        producerParagraphStyle.firstLineHeadIndent=0.0f;
        [attproducerList addAttribute:NSParagraphStyleAttributeName value:producerParagraphStyle range:NSMakeRange(0, attproducerList.length)];
        [attproducerList addAttribute:NSParagraphStyleAttributeName
                                value:producerParagraphStyle
                                range:NSMakeRange(0, attproducerList.length)];
        customCell.customRecommendationProducersLabel.attributedText = attproducerList;
        
        
        if(indexPath.row==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                self.recommendedCropImage.image=image;
                self.recommendedCropName.text=[self.recommendedCropArray[0][0][@"CropName"] capitalizedString];
                self.cropRainfallLabel.text=rainfallRange;
                self.cropTemperatureLabel.text=tempRange;
            });
        }
        //        else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.loader stopAnimating];
            customCell.customRecommendationNameLabel.text=[cropName capitalizedString];
            //                NSLog(@"CropName-------------%@",self.crop[@"CropName"]);
            customCell.customRecommendationTempLabel.text=tempRange;
            customCell.customRecommendationRainfallLabel.text=rainfallRange;
            customCell.customRecommendationImageView.image=image;
            customCell.customRecommendationProducersLabel.text= self.crop[@"ProducersToDisplay"];
            customCell.customRecommendationSoilLabel.attributedText = attsoilTypes;
            customCell.customRecommendationSoilLabel.adjustsFontSizeToFitWidth = true;
            customCell.customRecommendationProducersLabel.adjustsFontSizeToFitWidth = true;
            
       [customCell.customRecommendationImageView.layer setShadowColor: [UIColor grayColor].CGColor];
                   [customCell.customRecommendationImageView.layer setShadowOpacity:0.8];
                   [customCell.customRecommendationImageView.layer setShadowRadius:3.0];
                   [customCell.customRecommendationImageView.layer setShadowOffset:CGSizeMake(0.0, 0.0)];
            
            //    [myLabel sizeToFit];
        });
        //        }
        
        
    }
    return customCell;
}

-(void)requestPermission{
    locationManager=[[CLLocationManager alloc]init];
    [locationManager requestWhenInUseAuthorization];
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    
    CLGeocoder *geocoder =[[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:locationManager.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        NSString *searchQuery = [NSString stringWithFormat:@"%@,%@", [placemarks objectAtIndex:0].locality, [placemarks objectAtIndex:0].ISOcountryCode];
        
        //        https://api.openweathermap.org/data/2.5/weather?q=London,uk&appid=YOUR_API_KEY
        
        NSString *url = [NSString stringWithFormat:@"%@%@%@%@%@",
                         @"https://api.openweathermap.org/data/2.5/weather?q=",
                         searchQuery,
                         @"&units=metric",
                         @"&appid=",
                         @"4c1aa9e27863af68e069647e446328f3"];
        
        //        NSLog(@"searchQuery  %@",searchQuery);
        
        
        NSString *escapedURL = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        //        NSLog(@"escapedURL: %@", escapedURL);
        
        [self getDataFrom:escapedURL];
    }];
}


- (void) getDataFrom:(NSString *)url{
    //    NSLog(@"url  %@",url);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"dataTaskWithRequest error: %@", error);
            
            NSString *getErrorMessage = error.localizedDescription;
            
            
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"Error"
                                         message:getErrorMessage
                                         preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* okButton = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
                //Handle your yes please button action here
                [self.loader stopAnimating];
            }];
            [alert addAction:okButton];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            if (statusCode != 200) {
                NSLog(@"Expected responseCode == 200; received %ld", (long)statusCode);
                 if(statusCode == 429){
                    UIAlertController * alert = [UIAlertController
                                                 alertControllerWithTitle:@"API limit exceeded"
                                                 message:@"Please try after a while."
                                                 preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* okButton = [UIAlertAction
                                               actionWithTitle:@"OK"
                                               style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                        //Handle your yes please button action here
                        [self.loader stopAnimating];
                    }];
                    [alert addAction:okButton];
                    [self presentViewController:alert animated:YES completion:nil];
                }
               else if(statusCode >= 400 && statusCode <500 ){
                    
                    UIAlertController * alert = [UIAlertController
                                                 alertControllerWithTitle:@"Location cannot be determined"
                                                 message:@"Please check your location permissions. Crop Reco cannot recommend crops without knowing the current weather of your location."
                                                 preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* okButton = [UIAlertAction
                                               actionWithTitle:@"OK"
                                               style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                        //Handle your yes please button action here
                        [self.loader stopAnimating];
                    }];
                    [alert addAction:okButton];
                    [self presentViewController:alert animated:YES completion:nil];
                    
                }

                else if( statusCode>500){
                    UIAlertController * alert = [UIAlertController
                                                 alertControllerWithTitle:@"OpenWeather API"
                                                 message:@"server error"
                                                 preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* okButton = [UIAlertAction
                                               actionWithTitle:@"OK"
                                               style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                        //Handle your yes please button action here
                        [self.loader stopAnimating];
                    }];
                    [alert addAction:okButton];
                    [self presentViewController:alert animated:YES completion:nil];
                }
                
            }
            else{
                
                NSError *jsonError;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:&jsonError];
                
                NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
                [fmt setPositiveFormat:@"0.##"];
                
                NSNumberFormatter *weatherid = [[NSNumberFormatter alloc] init];
                weatherid.numberStyle = NSNumberFormatterDecimalStyle;
                //                self.weatherID = [weatherid numberFromString:[json[@"weather"][0][@"id"] stringValue]];
                
                NSNumberFormatter *avgtemp = [[NSNumberFormatter alloc] init];
                avgtemp.numberStyle = NSNumberFormatterDecimalStyle;
                //                self.avgTemp = [avgtemp numberFromString:[json[@"main"][@"temp"]stringValue]];
                
                self.country=json[@"sys"][@"country"];
                
                [self findWeatherCompatibleCropsWithTemp:[avgtemp numberFromString:[json[@"main"][@"temp"]stringValue]]
                                           withWeatherID:[weatherid numberFromString:[json[@"weather"][0][@"id"] stringValue]]
                                             withCountry:json[@"sys"][@"country"]];
                
                for (NSDictionary *dict in json[@"weather"]) {
                    weatherDescripionVarInReco=dict[@"description"];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.locationLabel.text =[NSString stringWithFormat:@"%@, %@", json[@"name"], json[@"sys"][@"country"] ];
                    self.weatherDescriptionLabel.text=[weatherDescripionVarInReco capitalizedString];
                    self.avgTempLabelinReco.text =[NSString stringWithFormat:@"%@ °C", json[@"main"][@"temp"] ];
                });
            }
        }
    }];
    [task resume];
    
}



@end


