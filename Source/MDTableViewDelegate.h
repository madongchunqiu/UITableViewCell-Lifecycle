//
//  MDTableViewDelegate.h
//  TableViewCellLifecycle
//
//  Created by Ma Dong on 1/10/16.
//  Copyright © 2016 Ma Dong. All rights reserved.
//
// This class will be used as base class to implement UITableView's delegate/dataSource
//  to remove part of View Controller's burden in common MVC design,
//  it is commonly a good practice to move the tableview's delegate/datasource into another class
//

#import <UIKit/UIKit.h>

@interface MDTableViewDelegate : NSObject

@end
