//
//  MDRuntimeHelper.m
//  TableViewCellLifecycle
//
//  Created by Ma Dong on 1/10/16.
//  Copyright © 2016 Ma Dong. All rights reserved.
//

#import "MDRuntimeHelper.h"

#import <objc/runtime.h>
#import <objc/message.h>

@implementation MDRuntimeHelper

+ (void)switchMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector forClass:(Class)class {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}


+ (void)injectNewSelectorForClass:(Class)class withSelector:(SEL)newSelector andImp:(IMP)newImp toReplaceSelector:(SEL)oldSelector {
    Method oldMethod = class_getInstanceMethod(class, oldSelector);
    class_addMethod(class, newSelector, newImp, method_getTypeEncoding(oldMethod));
}


+ (BOOL)isSubclass:(Class)childClass ofClass:(Class)rootClass {
    while(childClass) {
        if(childClass == rootClass) return YES;
        childClass = class_getSuperclass(childClass);
    }
    return NO;
}

@end
