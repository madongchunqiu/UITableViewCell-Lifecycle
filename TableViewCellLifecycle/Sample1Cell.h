//
//  Sample1Cell.h
//  TableViewCellLifecycle
//
//  Created by Ma Dong on 1/10/16.
//  Copyright © 2016 Ma Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Sample1Cell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *animatingView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewWidth;

- (void)updateWithIndexPath:(NSIndexPath*)indexPath;

@end
