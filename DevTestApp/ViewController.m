//
//  ViewController.m
//  DevTestApp
//
//  Created by Nitin Maheshwari on 11/23/17.
//  Copyright © 2017 NitinTestApp. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSPredicate+Search.h"
#import "SongsObject.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UITableView *listView;
@property (strong, nonatomic) IBOutlet UISearchBar *musicSearchBar;

@property(nonatomic,strong)NSMutableArray *dataSourceArray;
@property(nonatomic,strong)NSMutableArray *tableDataArray;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSourceArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.tableDataArray = [[NSMutableArray alloc]initWithCapacity:0];

    [self getdataFromService];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.tableDataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    SongsObject *object = [self.tableDataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = object.name;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:object.songlink]
                 placeholderImage:[UIImage imageNamed:@"Placeholder.png"]];
    
    return cell;
}

#pragma UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    self.selectedItem = self.currentHistoryList[indexPath.row];
//    [self dismissVC];
}

-(void)getdataFromService{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"http://private-f4bf5-music6.apiary-mock.com/search"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
            NSArray *responseArray = [NSArray arrayWithArray:responseObject];
            for(NSDictionary *dict in responseArray){
                [self.dataSourceArray addObject:[[SongsObject alloc] initWithName:[dict valueForKey:@"title"] Songlink:[dict valueForKey:@"m"]]];
                [self.tableDataArray addObject:[[SongsObject alloc] initWithName:[dict valueForKey:@"title"] Songlink:[dict valueForKey:@"m"]]];
            }
            [self.listView reloadData];
        }
    }];
    [dataTask resume];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length == 0) {
        self.tableDataArray = [[NSMutableArray alloc] initWithArray:self.dataSourceArray];
        [self.listView reloadData];
        return;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithSearch:searchText searchTerm:@"name"];
    self.tableDataArray = [[NSMutableArray alloc] initWithArray:[self.dataSourceArray filteredArrayUsingPredicate:predicate]];
    
    [self.listView reloadData];
}

//- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
//    CGPoint offset = aScrollView.contentOffset;
//    CGRect bounds = aScrollView.bounds;
//    CGSize size = aScrollView.contentSize;
//    UIEdgeInsets inset = aScrollView.contentInset;
//    float y = offset.y + bounds.size.height - inset.bottom;
//    float h = size.height;
//    
//    float reload_distance = 10;
//    if(y > h + reload_distance) {
//        NSLog(@"load more rows");
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No more results"
//                                                                               message:nil
//                                                                        preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *cancelButtonAction = [UIAlertAction actionWithTitle:@"OK"
//                                                                     style:UIAlertActionStyleDefault
//                                                                   handler:^(UIAlertAction * _Nonnull action) {
//                                                                   }];
//
//        [alertController addAction:cancelButtonAction];
//        [self presentViewController:alertController animated:YES completion:nil];
//    }
//}
@end
