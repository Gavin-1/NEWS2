//
//  mainTableViewController.m
//  LoadView
//
//  Created by lkjy on 16/5/17.
//  Copyright © 2016年 lkjy. All rights reserved.
//

#import "mainTableViewController.h"
#import "ScrollViewController.h"
#import "MJRefresh.h"
#import "SidebarViewController.h"
#define viewcount 5;
#define scrollviewSize (self.scrollView.frame.size)
@interface mainTableViewController ()
{
    CGFloat width;
    
}
@property (nonatomic, retain) SidebarViewController* sidebarVC;

@end

@implementation mainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self loadScrollView];
//    [self loadpageviewC];
//    [self loadtimer];
    ScrollViewController* scrollView=[ScrollViewController new];
    [self.view addSubview:scrollView.view];
    
    self.tableView.sectionFooterHeight=80;
    self.tableView.rowHeight=60;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    //初始化tableviewCell
    UINib *cell = [UINib nibWithNibName:@"mainTableViewCell" bundle:nil];
    [self.tableView registerNib:cell forCellReuseIdentifier:@"theReuseIdentifier"];
    
    NSLog(@"sfswgwre");
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title=@"新闻资讯";
    UIBarButtonItem* button=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"celaButton"] style:UIBarButtonItemStylePlain target:self action:@selector(cela)];
    self.navigationItem.leftBarButtonItem=button;
    self.navigationController.navigationBar.translucent=NO;
    NSLog(@"fwegagrw");
    
    
    self.sidebarVC = [[SidebarViewController alloc] init];
    [self.view addSubview:self.sidebarVC.view];
    self.sidebarVC.view.frame  = self.view.bounds;
}

-(void)cela
{
    [self.sidebarVC showHideSidebar];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(newsData)];
    [self.tableView.header setTitle:@"下拉刷新" forState:MJRefreshHeaderStateIdle];
    [self.tableView.header setTitle:@"松开来就刷新啦" forState:MJRefreshHeaderStatePulling];
    [self.tableView.header setTitle:@"~~刷~~新~~中~~" forState:MJRefreshHeaderStateRefreshing];
    self.tableView.header.font=[UIFont systemFontOfSize:15];
    self.tableView.header.textColor=[UIColor grayColor];
    [self.tableView.header beginRefreshing];
    
    [super viewWillAppear:animated];

}
-(void)newsData
{
    //在这做从网络获取资源
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 结束刷新
        [self.tableView.header endRefreshing];
    });
}
//-(void)loadScrollView
//{
//    for(int i=0;i<5;i++)
//    {
//        UIImageView* imageview=[[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i]]];
//        imageview.frame=CGRectMake(i*scrollviewSize.width, 0, scrollviewSize.width, scrollviewSize.width);
//        [self.scrollView addSubview:imageview];
//        
//        
//    }
//    width=5* scrollviewSize.width;
//    
//    self.scrollView.contentSize=CGSizeMake(width, 0);//scrollerView滑动的范围
//    self.scrollView.showsHorizontalScrollIndicator=NO;//scrollerView在滑动时是否显示水平方向的滑动条
//    // self.scrollView.showsVerticalScrollIndicator=YES;//scrollerView在滑动时是否显示垂直方向的滑动条
//    self.scrollView.pagingEnabled=NO;//当值是YES会自动滚动到subview的边界。默认是NO
//    self.scrollView.delegate=self;
//}
//-(void)loadpageviewC
//{
//    self.pageC.numberOfPages=viewcount;//UIPageControl控制的页面个数
//    self.pageC.currentPage=0;//UIPageControl设置当前的页码
//    self.pageC.currentPageIndicatorTintColor=[UIColor colorWithRed:1.000 green:0.503 blue:0.446 alpha:1.000];
//    self.pageC.pageIndicatorTintColor=[UIColor colorWithRed:1.000 green:0.853 blue:0.207 alpha:1.000];
//    
//    
//}
//-(void)loadtimer
//{
//    _timer=[NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(pagechange:) userInfo:nil repeats:YES];
//    NSRunLoop* mainLoop=[NSRunLoop mainRunLoop];
//    [mainLoop addTimer:_timer forMode:NSRunLoopCommonModes];
//}
//-(void)pagechange:(id)sender
//{
//    NSInteger n=self.pageC.currentPage;//获取当前页面的索引
//    CGPoint offset=self.scrollView.contentOffset;//获取当前页面的偏移量
//    
//    if(n>=4)
//    {
//        n=0;
//        offset.x=0.0f;
//        
//        
//    }
//    else
//    {
//        n++;
//        offset.x+=scrollviewSize.width;
//        
//    }
//    self.pageC.currentPage=n;
//    self.scrollView.contentOffset=offset;
//    
//}
//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    CGPoint offset=scrollView.contentOffset;
//    NSInteger currentPage=offset.x/scrollviewSize.width;
//    self.pageC.currentPage=currentPage;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark----UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"theReuseIdentifier";
    mainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier ];
    cell.textLabel.text=@"你好";
    return cell;
    
}





/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)siderButton:(UIButton *)sender {
}
@end
