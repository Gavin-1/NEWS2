//
//  SidebarViewController.m
//  BlurSideBar
//
//  Created by 郑随山 on 16/5/19.
//  Copyright © 2016年 郑随山. All rights reserved.
//

#import "SidebarViewController.h"
#import <Masonry/Masonry.h>
#import <QuartzCore/QuartzCore.h>
#import "mainTableViewController.h"
#import "VariousNews_TableViewController.h"
#import "navigationViewController.h"
#import "QRCatchViewController.h"
@interface SidebarViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    mainTableViewController *main;
    VariousNews_TableViewController *news;
    navigationViewController *nav;
    QRCatchViewController *qrC;
}
@property (nonatomic,strong)UIView *topView;
@property (nonatomic, retain) UITableView* menuTableView;
@property (nonatomic,strong)UIImageView *headView;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UIButton *dayButton;
@property (nonatomic,strong)UIButton *nightButton;
@end

@implementation SidebarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSubview];
    [self configSubviews];
    news=[[VariousNews_TableViewController alloc] init];
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    qrC=[storyBoard instantiateViewControllerWithIdentifier:@"QRCatchViewController"];
}

-(void)addSubview{
    NSArray *viewArrays=@[self.topView,self.menuTableView];
    [viewArrays enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.contentView addSubview:view];
    }];
}
-(void)configSubviews{
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView);
        make.height.equalTo(@150);
        make.width.equalTo(@300);
    }];
    [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_topView).offset(15);
        make.top.equalTo(_topView).offset(30);
        make.width.height.equalTo(@60);
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headView.mas_centerY);
        make.left.equalTo(self.headView.mas_right).offset(15);
        make.height.equalTo(@30);
        make.width.equalTo(@150);
    }];
    [_dayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView.mas_bottom).offset(15);
        make.left.equalTo(self.nameLabel).offset(35);
        make.right.equalTo(self.nameLabel).offset(-35);
        make.height.equalTo(@30);
        [_dayButton.layer setCornerRadius:10];
        _dayButton.layer.masksToBounds=YES;
    }];
    [_menuTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.equalTo(self.contentView);
        make.width.height.equalTo(@300);
    }];
}
#pragma mark - getters
-(UITableView *)menuTableView{
    if (!_menuTableView) {
        self.menuTableView = [[UITableView alloc] init];
        [self.menuTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        self.menuTableView.backgroundColor = [UIColor blueColor];
        self.menuTableView.delegate = self;
        self.menuTableView.dataSource = self;
    }
    return _menuTableView;
}
-(UIView *)topView{
    NSArray *viewArrays=@[self.headView,self.nameLabel,self.dayButton,self.nightButton];
    if (!_topView) {
        _topView=[[UIView alloc] initWithFrame:CGRectMake(-300, 0, 300, 150)];
        _topView.backgroundColor=[UIColor redColor];
        [viewArrays enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
            [_topView addSubview:view];
        }];
    }
    return _topView;
}
-(UIImageView *)headView{
    if (!_headView) {
        self.headView=[[UIImageView alloc] init];
        self.headView.backgroundColor=[UIColor whiteColor];
        [self.headView.layer setCornerRadius:30];
        self.headView.layer.masksToBounds=YES;
        self.headView.clipsToBounds=YES;
    }
    return _headView;
}
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel=[[UILabel alloc] init];
        _nameLabel.backgroundColor=[UIColor whiteColor];
    }
    return _nameLabel;
}
-(UIButton *)dayButton{
    if (!_dayButton) {
        _dayButton=[[UIButton alloc] init];
        _dayButton.backgroundColor=[UIColor whiteColor];
    }
    return _dayButton;
}
-(UIButton *)nightButton{
    if (!_nightButton) {
        _nightButton=[[UIButton alloc] init];
        _nightButton.backgroundColor=[UIColor whiteColor];
    }
    return _dayButton;
}
#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *sidebarMenuCellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sidebarMenuCellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sidebarMenuCellIdentifier] ;
        cell.backgroundColor = [UIColor clearColor];
        
    }
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = [NSString stringWithFormat:@"菜单%d", indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *child;
    switch (indexPath.row) {
        case 0:
            break;
        case 1:
            child=[[navigationViewController alloc] initWithRootViewController:news];
            [self showViewController:child sender:nil];
            break;
        case 2:
            child=[[navigationViewController alloc] initWithRootViewController:qrC];
            [self showViewController:child sender:nil];
            break;
        default:
            break;
    }
    [self showHideSidebar];
}
@end
