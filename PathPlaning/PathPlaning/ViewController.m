//
//  ViewController.m
//  PathPlaning
//
//  Created by admin on 2017/2/10.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "ViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapNaviKit/AMapNaviKit.h>

@interface ViewController ()<MAMapViewDelegate,AMapNaviDriveManagerDelegate>
#define api_key  @"950dd74ecac9693b5705b0ec8eb3f51f"
#define screenW  [UIScreen mainScreen].bounds.size.width
@property (nonatomic,strong) MAMapView *mapView;
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) AMapNaviPoint *startPoint;
@property (nonatomic,strong) AMapNaviPoint *endPoint;
@property (nonatomic,strong) AMapNaviDriveManager *driveManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"路径规划";
    [AMapServices sharedServices].apiKey = api_key;
    [self initProperties];
    [self initBackView];
    [self initMapView];
    [self initDriveManager];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self initAnnotations];
}
#pragma mark  初始化View
- (void)initBackView{
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenW, 150)];
    self.backView.backgroundColor = [UIColor redColor];
    UIButton *singleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [singleBtn setFrame:CGRectMake(0, 0, 100, 30)];
    singleBtn.center = self.backView.center;
    [singleBtn setTitle:@"单线程" forState:UIControlStateNormal];
    [singleBtn addTarget:self action:@selector(singleRoutePlanAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backView];
    [self.backView addSubview:singleBtn];
}
#pragma mark  初始化导航的起点和终点坐标（为了方便展示路线，特定固定了起点和终点坐标）
- (void)initProperties
{
    self.startPoint = [AMapNaviPoint locationWithLatitude:39.99 longitude:116.47];
    self.endPoint   = [AMapNaviPoint locationWithLatitude:39.90 longitude:116.32];
}
#pragma mark  初始化 MAMapView
- (void)initMapView
{
    if (self.mapView == nil)
    {
        self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 150, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [self.mapView setDelegate:self];
        [self.view addSubview:self.mapView];
    }
}
#pragma mark  初始化 AMapNaviDriveManager
- (void)initDriveManager
{
    if (self.driveManager == nil)
    {
        self.driveManager = [[AMapNaviDriveManager alloc] init];
        [self.driveManager setDelegate:self];
    }
}
- (void)initAnnotations
{
    MAPointAnnotation *beginAnnotation = [[MAPointAnnotation alloc] init];
    [beginAnnotation setCoordinate:CLLocationCoordinate2DMake(self.startPoint.latitude, self.startPoint.longitude)];
    beginAnnotation.title = @"起始点";
    
    [self.mapView addAnnotation:beginAnnotation];
    
    MAPointAnnotation *endAnnotation = [[MAPointAnnotation alloc] init];
    [endAnnotation setCoordinate:CLLocationCoordinate2DMake(self.endPoint.latitude, self.endPoint.longitude)];
    endAnnotation.title = @"终点";
   
    [self.mapView addAnnotation:endAnnotation];
}
#pragma mark  按钮回掉方法
- (void)singleRoutePlanAction:(UIButton *)sender{
    
    [self.driveManager calculateDriveRouteWithStartPoints:@[_startPoint] endPoints:@[_endPoint] wayPoints:nil drivingStrategy:17];
}
#pragma mark  驾车路径规划
-(void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager{
    
    //算路成功后显示路径
    [self showNaviRoutes];
    
}
#pragma mark  计算路径
- (void)showNaviRoutes{
    
    if ([self.driveManager.naviRoutes count] <= 0) {
        return;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
