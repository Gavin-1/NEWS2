//
//  mainTableViewController.h
//  LoadView
//
//  Created by lkjy on 16/5/17.
//  Copyright © 2016年 lkjy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mainTableViewCell.h"
@interface mainTableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;



@end
