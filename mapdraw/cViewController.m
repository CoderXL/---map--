//
//  cViewController.m
//  EXxingbake
//
//  Created by admin on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "cViewController.h"
#import "poimark.h"
#import "selfmark.h"
#import "c1ViewController.h"
#import "dView.h"

@implementation cViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)getlocation{
    locationManager = [[CLLocationManager alloc] init];//创建位置管理器  
    locationManager.delegate=self;  
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;  
    locationManager.distanceFilter=1000.0f;  
      
    [locationManager startUpdatingLocation];//启动位置更新
}
-(void)buildmap{
    arrla = [[NSMutableArray alloc]initWithObjects:[NSNumber numberWithDouble:31.216515],
             [NSNumber numberWithDouble:31.187170], 
              [NSNumber numberWithDouble:31.220142], 
               [NSNumber numberWithDouble:31.193884], 
                [NSNumber numberWithDouble:31.218660], nil];
    arrlo = [[NSMutableArray alloc]initWithObjects:[NSNumber numberWithDouble:121.538985], 
             [NSNumber numberWithDouble:121.422438],
              [NSNumber numberWithDouble:121.445540], 
               [NSNumber numberWithDouble:121.394430], 
                [NSNumber numberWithDouble:121.419608], nil];
    arrtitle = [[NSArray alloc]initWithObjects:@"111dfgfsa1",@"22sdafsd22",@"ssfsd333",@"4gtretg444",@"55resgre5",nil];
    arrimg = [[NSArray alloc]initWithObjects:@"gosick1.jpg",@"gosick2.jpg",@"gosick3.jpg",@"gosick4.jpg",@"gosick5.jpg",nil];
    
    span.latitudeDelta=0.1;
    span.longitudeDelta=0.1;
    coordinate.latitude = 31.21331;
    coordinate.longitude = 121.47777;
    region.span = span;
    region.center = coordinate;
    //region.center = [[locationManager location] coordinate];
    [mapview setRegion:region];
    //locationManager.location.coordinate.latitude
    mapview.delegate = self;
    [mapview addAnnotation:[[selfmark alloc] initWithCoords:coordinate]];
    
    arrpoi = [[NSMutableArray alloc]init];//如果不初始化一下，addAnnotations:arrpoi就会失效，图标无法显示
    for (loopi=0; loopi<[arrla count]; loopi++) {
        coordinate.latitude = [[arrla objectAtIndex:loopi]doubleValue];
        coordinate.longitude = [[arrlo objectAtIndex:loopi]doubleValue];
        poimark *poishop = [[poimark alloc] initWithCoords:coordinate];
        poishop.title = [arrtitle objectAtIndex:loopi];
        poishop.subtitle = [arrtitle objectAtIndex:loopi];
        poishop.headimage = [arrimg objectAtIndex:loopi];
        poishop.tag = loopi;
        [arrpoi addObject:poishop];
    }
    
    [mapview addAnnotations:arrpoi];
} 

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation{
    //方法二：using the image as a PlaceMarker to display on map   
    if ([annotation isKindOfClass:[poimark class]])
    {
        MKAnnotationView *newAnnotation=[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"anno"];
        newAnnotation.image = [UIImage imageNamed:@"shop.png"];
        poimark *travellerAnnotation = (poimark *)annotation; 
        UIImageView *imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:travellerAnnotation.headimage]];
        [imageview setFrame:CGRectMake(0, 0, 20, 20)];
        newAnnotation.leftCalloutAccessoryView = imageview;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [btn addTarget:self action:@selector(gotodetailmap:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = travellerAnnotation.tag;//在按钮事件里可获取某个tag标示，以拿到点击来源的btn
        newAnnotation.rightCalloutAccessoryView = btn;
        newAnnotation.canShowCallout=YES;
        newAnnotation.annotation = annotation;
        return newAnnotation;
    }
    if ([annotation isKindOfClass:[selfmark class]]) {
        MKAnnotationView *newAnnotation = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"sdf"];
        newAnnotation.canShowCallout=YES;
        newAnnotation.image = [UIImage imageNamed:@"self.png"];
        newAnnotation.annotation=annotation;
        return newAnnotation;
    }
    return Nil;
}   
-(void)gotodetailmap:(UIButton *)button{
    c1ViewController *c1vc = [self.storyboard instantiateViewControllerWithIdentifier:@"cc1"];
    c1vc.imgstr = [arrimg objectAtIndex:button.tag];
    [self.navigationController pushViewController:c1vc animated:YES];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //mapview = [[MKMapView alloc] initWithFrame:self.view.frame];
    //[self.view addSubview:mapview];
    //dv = [[dView alloc] initWithFrame:self.view.frame];
    //[self.view addSubview:dv];
    
    ////dv.backgroundColor = [UIColor clearColor];
    candraw = NO;
    ////[dv setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    
    [self performSelector:@selector(getlocation)];
    [self performSelector:@selector(buildmap)];
    
    drawarrla = [NSMutableArray arrayWithCapacity:100];
    
    dv = [[dView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:dv];
    dv.backgroundColor = [UIColor clearColor];
    [dv setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    
    // Adds a polygon over the commuter parking in front of the library
//    CLLocationCoordinate2D libComPark[4];
//    libComPark[0] = CLLocationCoordinate2DMake(31.216515,121.538985);
//    libComPark[1] = CLLocationCoordinate2DMake(31.187170,121.422438);
//    libComPark[2] = CLLocationCoordinate2DMake(31.220142,121.445540);
//    libComPark[3] = CLLocationCoordinate2DMake(31.193884,121.394430);
//    MKPolygon *polLibcomPark = [MKPolygon polygonWithCoordinates:libComPark count:4];
//    [mapview addOverlay:polLibcomPark];
}
-(IBAction)iscandrawshap:(id)sender{
    if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"画区域"]) {
        [drawbtn setTitle:@"画ing" forState:UIControlStateNormal];
        [mapview setScrollEnabled:NO];
        [mapview setZoomEnabled:NO];
        candraw = YES;
        tlabel.text = [NSString stringWithFormat:@"%f",self.view.frame.size.height];// height is 416
        [dv setFrame:CGRectMake(0, 0, self.view.frame.size.width, 480-44/2)];
        //鼠标划线和实际坐标有偏差，480-44/2高度修正值，可能因为navigatorbar引起
    }else{
        [drawbtn setTitle:@"画区域" forState:UIControlStateNormal];
        [mapview setScrollEnabled:YES];
        [mapview setZoomEnabled:YES];
        candraw = NO;
        [dv setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    tlabel.text = @"aaaaaaa";
    if (candraw) {
        [drawarrla removeAllObjects];
        [mapview removeOverlay:polLibcomPark];
        CGPoint point = [[touches anyObject] locationInView:self.view];
        //CLLocationCoordinate2D coo = [mapview convertPoint:point toCoordinateFromView:mapview];
        [drawarrla addObject:[NSValue valueWithCGPoint:point]];
//        libComPark[0] = CLLocationCoordinate2DMake(coo.latitude,coo.longitude);
    }
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if (candraw) {
        CGPoint point = [[touches anyObject] locationInView:self.view];
        [drawarrla addObject:[NSValue valueWithCGPoint:point]];
//        CLLocationCoordinate2D coo = [mapview convertPoint:point toCoordinateFromView:mapview];
//        libComPark[count] = CLLocationCoordinate2DMake(coo.latitude,coo.longitude);
//        polLibcomPark = [MKPolygon polygonWithCoordinates:libComPark count:count];
//        [mapview addOverlay:polLibcomPark];
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    tlabel.text = @"eeee";
    if (candraw) {
    CLLocationCoordinate2D libComPark[[drawarrla count]];
    for (di = 0; di < [drawarrla count]; di ++) {
        CGPoint po = [[drawarrla objectAtIndex:di] CGPointValue];
        CLLocationCoordinate2D coo = [mapview convertPoint:po toCoordinateFromView:mapview];
        libComPark[di] = CLLocationCoordinate2DMake(coo.latitude,coo.longitude);
    }
    polLibcomPark = [MKPolygon polygonWithCoordinates:libComPark count:[drawarrla count]];
    [mapview addOverlay:polLibcomPark];
        
        [drawbtn setTitle:@"画区域" forState:UIControlStateNormal];
        [mapview setScrollEnabled:YES];
        [mapview setZoomEnabled:YES];
        candraw = NO;
        [dv setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    }
}
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolygon class]])
    {
        MKPolygonView* aView = [[MKPolygonView alloc]initWithPolygon:(MKPolygon*)overlay];
        aView.fillColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
        aView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        aView.lineWidth = 3;
        return aView;
    }
    return nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
