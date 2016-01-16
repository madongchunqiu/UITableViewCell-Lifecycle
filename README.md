# Description
The `UITableViewCell+Lifecycle` category (with `MDTableViewDelegate`) provide lifecycle events for *UITableViewCell*, just like similar events of UIViewController:  

* cellWillAppear
* cellDidAppear
* cellDidLayoutSubviews
* cellDidDisappear


![Debug log](https://github.com/madongchunqiu/UITableViewCell-Lifecycle/blob/master/UITableViewCell-Lifecycle.gif)  


# Why
I'm a big fan of **UITableView**, since it provides the flexibility of organizing contents dynamically. And with more and more animations in the UI, I found it hard to locate my code elegantly.  
On the other hand, UIViewController is nice with viewWillAppear, viewDidAppear, viewDidLayoutSubviews, viewWillDisappear and viewDidDisappear etc.   
I though I shall make this happen to *UITableViewCell*.  

# How to Use
*see the sample code*

* **Preferred:** include `UITableViewCell+Lifecycle.h/m` and `MDTableViewDelegate.h/m` into the projects. Subclass MDTableViewDelegate, and put your tableView's dataSource and delegate code in this class. And these events will be triggerred in the cells.  
* **NOT recommended:** include `UITableViewCell+Lifecycle.h/m` and `UITableViewController+CellLifecycle.h/m` int to the projects, and subclass **UITableViewController** (shall explictly conform to protocol UITableViewDelegate), and these events will be triggerred in the cells.  

# Swift Verion
[UITableViewCell-Lifecycle-Swift](https://github.com/madongchunqiu/UITableViewCell-Lifecycle-Swift)
```
The difference between Swift version and Objective-C version is:   
the Swift version swizzle method `tableView:willDisplayCell:forRowAtIndexPath:` directly in `MDTableViewDelegate`, not its subclass.
```

# Known Issues
These events won't be triggerred if the whole tableView is going on-screen or off-screen, e.g. when pushing another view controller or poped back from another view controller. (Currently I don't see the need to fix this.)  
It only happens when the *UITableViewCell* is scrolling into or out-of the visible area of the table view.

# 中文说明
[给TableViewCell加上生命周期事件（如cellWillAppear）(下)](http://www.jianshu.com/p/64c76a587450)
