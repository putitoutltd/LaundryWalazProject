//
//  PIOWebViewController.m
//  LaundryWalaz
//
//  Created by pito on 7/22/16.
//  Copyright © 2016 pito. All rights reserved.
//

#import "PIOWebViewController.h"
#import "PIOAppController.h"
#import "PIOPriceListViewController.h"

@interface PIOWebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *contentsWebView;

@end

@implementation PIOWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Hide Back button
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem=nil;
    self.backButtonHide = YES;
    
    [[NSNotificationCenter defaultCenter] removeObserver: self name: @"PIORefreshPage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(refreshPage:) name: @"PIORefreshPage" object:nil];
    NSString *fileName = @"terms";
    if (self.isFromFAQs) {
       fileName = @"faqs";
    }
    [self loadPageWithFileName: fileName];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadPageWithFileName:(NSString *)fileName
{
    // Set Screen Title
    NSString *titleString = @"Terms & Policies";
    
    if ([fileName isEqualToString: @"faqs"]) {
        titleString = @"FAQ";
    }
    
    [[PIOAppController sharedInstance] titleFroNavigationBar: titleString onViewController:self];
    
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource: fileName ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [self.contentsWebView loadHTMLString:htmlString baseURL:nil];
}

- (void)refreshPage:(NSNotification *)notification
{
    NSLog(@"%@", notification.object);
    NSLog(@"%@", [notification.object objectForKey:@"page"]);
    [self loadPageWithFileName: [notification.object objectForKey:@"page"]];
}
-(BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request   navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL *url = request.URL;
    NSString *urlString = url.absoluteString;
    NSRange page = [ urlString rangeOfString: @"applewebdata://" ];
    // URL is main page
    
    if ( page.location != NSNotFound ) {
       
        PIOPriceListViewController  *priceListViewController = [PIOPriceListViewController new];
        priceListViewController.fromFAQs = YES;
        [self.navigationController pushViewController: priceListViewController animated: YES];
        
    }
    // URL is clicked link
    
        
       return YES;
   
}

@end
