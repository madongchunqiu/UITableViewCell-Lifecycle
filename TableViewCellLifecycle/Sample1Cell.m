//
//  Sample1Cell.m
//  TableViewCellLifecycle
//
//  Created by Ma Dong on 1/10/16.
//  Copyright © 2016 Ma Dong. All rights reserved.
//

#import "Sample1Cell.h"
#import "UITableViewCell+Lifecycle.h"

@interface Sample1Cell ()
{
    NSTimer* timer;
    NSInteger row;
}
@end

@implementation Sample1Cell

- (void)cellWillAppear {
    if (0 == row) {
        self.animatingView.layer.masksToBounds = YES;
        self.animatingView.layer.cornerRadius = self.constraintViewWidth.constant / 2.0;
        NSLog(@" 🍎 Sample1Cell - cellWillAppear");
    }
}

- (void)cellDidAppear {
    if (0 == row) {
        NSLog(@" 🍎 Sample1Cell - cellDidAppear");
        timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerWorks) userInfo:nil repeats:YES];
    }
}

- (void)cellDidLayoutSubviews {
    if (0 == row) {
        NSLog(@" 🍎 Sample1Cell - cellDidLayoutSubviews");
    }
}

- (void)cellDidDisappear {
    if (0 == row) {
        NSLog(@" 🍎 Sample1Cell - cellDidDisappear");
    }
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}

- (void)timerWorks {
    self.constraintViewWidth.constant += 2.f;
    self.animatingView.layer.cornerRadius = self.constraintViewWidth.constant / 2.0;
}

#pragma mark - fill data

- (void)updateWithIndexPath:(NSIndexPath*)indexPath {
    row = indexPath.row;
}


@end
