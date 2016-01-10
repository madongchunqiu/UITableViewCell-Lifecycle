//
//  Sample1LighterViewController.m
//  TableViewCellLifecycle
//
//  Created by Ma Dong on 1/10/16.
//  Copyright © 2016 Ma Dong. All rights reserved.
//

#import "Sample1LighterViewController.h"
#import "Sample1DataSourceDelegate.h"

@interface Sample1LighterViewController ()
{
    Sample1DataSourceDelegate* delegateDelegate;
}
@end

@implementation Sample1LighterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    delegateDelegate = [[Sample1DataSourceDelegate alloc] init];
    
    self.tableView.dataSource = delegateDelegate;
    self.tableView.delegate = (id<UITableViewDelegate>)delegateDelegate; //sss// NOTE: I'm just verifying that the subclass of MDTableViewDelegate won't explictly state that it conforms to UITableViewDelegate
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
