//
//  UITableViewCell+Lifecycle.m
//  TableViewCellLifecycle
//
//  Created by Ma Dong on 1/10/16.
//  Copyright © 2016 Ma Dong. All rights reserved.
//

#import "UITableViewCell+Lifecycle.h"
#import "MDTableViewDelegate.h"
#import "MDRuntimeHelper.h"

#import <objc/runtime.h>
#import <objc/message.h>


static NSString* const keyPropertyCellWillOnScreen = @"keyPropertyCellWillOnScreen";
static NSString* const keyPropertyCellDidOnScreen = @"keyPropertyCellDidOnScreen";
static NSString* const keyPropertyCellWillAppeared = @"keyPropertyCellWillAppeared";
static NSString* const keyPropertyCellDidAppeared = @"keyPropertyCellDidAppeared";
static NSString* const keyPropertyCellDidLayoutSubviews = @"keyPropertyCellDidLayoutSubviews";

static NSString* const selectorNameWillDisplayCell = @"hG8nHae3Enxg8o_tableView:willDisplayCell:forRowAtIndexPath";
static NSString* const selectorNameDidEndDisplayCell = @"j6x8bUx2gnh9st_tableView:didEndDisplayCell:forRowAtIndexPath";

#pragma mark -
#pragma mark - UITableViewCell (LifecycleInternal)

@interface UITableViewCell (LifecycleInternal)
@property (nonatomic) BOOL isCellWillOnScreen; /*< (used internally) YES, if the cell is going to be on screen, NO if the cell is off screen */
@property (nonatomic) BOOL isCellDidOnScreen; /*< YES, if the cell is on screen, NO if the cell is off screen */
@end

@implementation UITableViewCell (LifecycleInternal)
- (BOOL)isCellWillOnScreen {
    NSNumber *result = objc_getAssociatedObject(self, &keyPropertyCellWillOnScreen);
    if (!result) {
        self.isCellWillOnScreen = NO;
        return NO;
    }
    return result.boolValue;
}
- (void)setIsCellWillOnScreen:(BOOL)flag {
    objc_setAssociatedObject(self, &keyPropertyCellWillOnScreen, @(flag), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isCellDidOnScreen {
    NSNumber *result = objc_getAssociatedObject(self, &keyPropertyCellDidOnScreen);
    if (!result) {
        self.isCellDidOnScreen = NO;
        return NO;
    }
    return result.boolValue;
}
- (void)setIsCellDidOnScreen:(BOOL)flag {
    objc_setAssociatedObject(self, &keyPropertyCellDidOnScreen, @(flag), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end

#pragma mark -
#pragma mark - UITableViewCell (Lifecycle)

@implementation UITableViewCell (Lifecycle)

- (BOOL)isCellWillAppeared {
    NSNumber *result = objc_getAssociatedObject(self, &keyPropertyCellWillAppeared);
    if (!result) {
        self.isCellWillAppeared = NO;
        return NO;
    }
    return result.boolValue;
}
- (void)setIsCellWillAppeared:(BOOL)flag {
    objc_setAssociatedObject(self, &keyPropertyCellWillAppeared, @(flag), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isCellDidAppeared {
    NSNumber *result = objc_getAssociatedObject(self, &keyPropertyCellDidAppeared);
    if (!result) {
        self.isCellDidAppeared = NO;
        return NO;
    }
    return result.boolValue;
}
- (void)setIsCellDidAppeared:(BOOL)flag {
    objc_setAssociatedObject(self, &keyPropertyCellDidAppeared, @(flag), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isCellDidLayoutSubviews {
    NSNumber *result = objc_getAssociatedObject(self, &keyPropertyCellDidLayoutSubviews);
    if (!result) {
        self.isCellDidLayoutSubviews = NO;
        return NO;
    }
    return result.boolValue;
}
- (void)setIsCellDidLayoutSubviews:(BOOL)flag {
    objc_setAssociatedObject(self, &keyPropertyCellDidLayoutSubviews, @(flag), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark ======== lifecycle events ========

- (void)cellWillAppear {
    return;
}
- (void)cellDidAppear {
    return;
}
- (void)cellDidLayoutSubviews {
    return;
}
- (void)cellDidDisappear {
    return;
}

#pragma mark ======== black magic ========

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once (&onceToken, ^ {
        [MDRuntimeHelper switchMethod:@selector(layoutSubviews)
                           withMethod:@selector(layoutSubviews_ns6Ubn0nbwOnBs)
                             forClass:UITableViewCell.class];
        [UITableViewCell _swizzleProtocolMethodsInClassTree];
    });
}


- (void)layoutSubviews_ns6Ubn0nbwOnBs {
    [self layoutSubviews_ns6Ubn0nbwOnBs]; // call the original one
    
    if (self.isCellWillOnScreen || self.isCellDidOnScreen) {
        if (!self.isCellDidOnScreen) {
            self.isCellWillOnScreen = NO;
            [self cellDidAppear]; // call action - 1
            self.isCellDidOnScreen = YES;
            self.isCellDidAppeared = YES; // set flag afterwards - 1
        }
        
        [self cellDidLayoutSubviews]; // call action - 2
        self.isCellDidLayoutSubviews = YES; // set flag afterwards - 2
    }
}

+ (void)_swizzleProtocolMethodsInClassTree {
#ifdef DEBUG
    clock_t start = clock();
#endif
    
    // Get the class list
    Class *classes = NULL;
    int numClasses = objc_getClassList(NULL, 0);
    if (numClasses <= 0 ) {
        return;
    }
    
    classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
    numClasses = objc_getClassList(classes, numClasses);

    BOOL isUITableViewControllerCategoryUsed = [UITableViewController instancesRespondToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)] &&
                                               [UITableViewController instancesRespondToSelector:@selector(tableView:didEndDisplayingCell:forRowAtIndexPath:)];
    
    // For every class
    for(int i = 0; i < numClasses; i++)
    {
        Class class = classes[i];
        
        BOOL isClassToSwizzle = NO;
        
        // -------------------------------
        // 1. Check, if it is a subclass of MDTableViewDelegate, and implements UITableViewDelegate
        if ([MDRuntimeHelper isSubclass:class ofClass:MDTableViewDelegate.class] &&
            class != MDTableViewDelegate.class) {
            isClassToSwizzle = YES;
        }
        
        // -------------------------------
        // 2. Check, if it is a subclass of UITableViewController and implemented UITableViewDelegate
        // NOTE: class_conformsToProtocol only applies to the class itself, not its superclass (this is unlike NSObject's conformsToProtocol)
        if (!isClassToSwizzle && // for performance!
            isUITableViewControllerCategoryUsed && // since it is not a recommended option to use UITableViewController's category
            [MDRuntimeHelper isSubclass:class ofClass:UITableViewController.class] &&
            class_conformsToProtocol(class, @protocol(UITableViewDelegate)) &&
            class != UITableViewController.class) {
            
            Class superClass = class_getSuperclass(class);
            
            // case 1: the super class don't conform to protocol (avoid swizzling twice?)
            BOOL isSuperClassConforms = class_conformsToProtocol(superClass, @protocol(UITableViewDelegate));
            if (!isSuperClassConforms) {
                isClassToSwizzle = YES;
            }
            
            // case 2: the super class is UITableViewController
            if (isSuperClassConforms && superClass == UITableViewController.class) {
                isClassToSwizzle = YES;
            }
        }

        if (isClassToSwizzle) {
#ifdef DEBUG
            NSLog(@" === class with tableviewcell lifecycle => %s", class_getName(class));
#endif
            [UITableViewCell _swizzleCellLifecycleMethodsForClass:class];
        }
    }
    
    free(classes);

#ifdef DEBUG
    double executionTime = (double)(clock()-start) / CLOCKS_PER_SEC;
    NSLog(@"class iteration for cell lifecycle injection excution length = %f s", executionTime);
    // LOG
    // 0.2s (10 tries) - check desendent of NSObject
    // 0.035s (10 tries) - check desendent of MDTableViewDelegate only
#endif
}

+ (void)_swizzleCellLifecycleMethodsForClass:(Class)class {
    Method originalMethod_willDiaplayCell = class_getInstanceMethod(class, @selector(tableView:willDisplayCell:forRowAtIndexPath:));
    Method originalMethod_didDiaplayCell = class_getInstanceMethod(class, @selector(tableView:didEndDisplayingCell:forRowAtIndexPath:));
    if (originalMethod_willDiaplayCell && originalMethod_didDiaplayCell) {
        
        SEL willDisplaySelector = NSSelectorFromString(selectorNameWillDisplayCell);
        SEL didEndDisplaySelector = NSSelectorFromString(selectorNameDidEndDisplayCell);
        
        SEL old_willDisplaySelector = @selector(tableView:willDisplayCell:forRowAtIndexPath:);
        SEL old_didEndDisplaySelector = @selector(tableView:didEndDisplayingCell:forRowAtIndexPath:);
        
        [MDRuntimeHelper injectNewSelectorForClass:class withSelector:willDisplaySelector andImp:(IMP)_willDisplayCell_h7Gio8Gos2W toReplaceSelector:old_willDisplaySelector];
        [MDRuntimeHelper injectNewSelectorForClass:class withSelector:didEndDisplaySelector andImp:(IMP)_didEndDisplayCell_i5jnG0a2Nad toReplaceSelector:old_didEndDisplaySelector];
        
        [MDRuntimeHelper switchMethod:old_willDisplaySelector
                           withMethod:willDisplaySelector
                             forClass:class];
        [MDRuntimeHelper switchMethod:old_didEndDisplaySelector
                           withMethod:didEndDisplaySelector
                             forClass:class];
    }
}


void _willDisplayCell_h7Gio8Gos2W(id self, SEL cmd, UITableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath) {
    // this function will be used in swizzling, so call the original one here
    void (*objc_msgSendTyped)(id, SEL, UITableView*, UITableViewCell*, NSIndexPath*) = (void*)objc_msgSend;
    objc_msgSendTyped(self, NSSelectorFromString(selectorNameWillDisplayCell), tableView, cell, indexPath);
    
    if ([cell isKindOfClass:UITableViewCell.class]) {
        UITableViewCell* baseCell = (UITableViewCell*)cell;
        [baseCell cellWillAppear];
        baseCell.isCellWillAppeared = YES;
        baseCell.isCellWillOnScreen = YES;
    }
}

void _didEndDisplayCell_i5jnG0a2Nad(id self, SEL cmd, UITableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath) {
    // this function will be used in swizzling, so call the original one here
    void (*objc_msgSendTyped)(id, SEL, UITableView*, UITableViewCell*, NSIndexPath*) = (void*)objc_msgSend;
    objc_msgSendTyped(self, NSSelectorFromString(selectorNameDidEndDisplayCell), tableView, cell, indexPath);
    
    if ([cell isKindOfClass:UITableViewCell.class]) {
        UITableViewCell* baseCell = (UITableViewCell*)cell;
        [baseCell cellDidDisappear];
        baseCell.isCellDidOnScreen = NO;
    }
    
}

@end
