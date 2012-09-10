//
//  SKProductViewController.m
//  SpreadKit
//
//  Created by Sebastian Marr on 04.09.12.
//

#import "SKProductViewController.h"

#import "SKProductView.h"
#import "SKClient.h"

@interface SKProductViewController ()

@property SKProductView *productView;

@end

@implementation SKProductViewController

- (void)setProduct:(SKProduct *)product
{
    _product = product;
    self.productView = nil;
    self.productView = [[SKProductView alloc] initWithProduct:product andFrame:self.view.bounds];
    
    self.productView.appearanceChooserView.selectedAppearance = product.appearance;
    self.productView.appearanceChooserView.appearances = self.product.productType.appearances;
    self.productView.appearanceChooserView.delegate = self;
    
    self.productView.productTypeChooserView.selectedProductType = self.product.productType;
    self.productView.productTypeChooserView.delegate = self;
    [[SKClient sharedClient] getAll:[SKProductType class] completion:^(SKEntityList *objects, NSError *error) {
        self.productView.productTypeChooserView.productTypes = objects.elements;
    }];
    
    [self.view addSubview:self.productView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)appearanceChooser:(SKAppearanceChooserView *)appearanceChooser didSelectAppearance:(SKAppearance *)appearance
{
    _product.appearance = appearance;
    self.productView.product = _product;
}

- (void)productTypeChooser:(SKProductTypeChooserView *)productTypeChooser didSelectProductType:(SKProductType *)productType
{
    _product.productType = productType;
    self.productView.product = _product;
}

@end
