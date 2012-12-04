//
//  SPProductViewController.m
//  SpreadKit
//
//  Created by Sebastian Marr on 04.09.12.
//

#import "SPProductViewController.h"

#import "SPProductView.h"
#import "SPClient.h"

@interface SPProductViewController ()

@property SPProductView *productView;

@end

@implementation SPProductViewController

- (void)setProduct:(SPProduct *)product
{
    _product = product;
    self.productView = nil;
    self.productView = [[SPProductView alloc] initWithProduct:product andFrame:self.view.bounds];
    
    self.productView.appearanceChooserView.selectedAppearance = product.appearance;
    self.productView.appearanceChooserView.appearances = self.product.productType.appearances;
    self.productView.appearanceChooserView.delegate = self;
    
    self.productView.productTypeChooserView.selectedProductType = self.product.productType;
    self.productView.productTypeChooserView.delegate = self;
    [[SPClient sharedClient] getAll:[SPProductType class] completion:^(SPEntityList *objects, NSError *error) {
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

- (void)appearanceChooser:(SPAppearanceChooserView *)appearanceChooser didSelectAppearance:(SPAppearance *)appearance
{
    _product.appearance = appearance;
    self.productView.product = _product;
}

- (void)productTypeChooser:(SPProductTypeChooserView *)productTypeChooser didSelectProductType:(SPProductType *)productType
{
    self.productView.appearanceChooserView.appearances = _product.productType.appearances;
    self.productView.appearanceChooserView.selectedAppearance = _product.appearance;
    [self productTypeChooserDidSelectProductType:productType];
}

- (void)productTypeChooserDidSelectProductType:(SPProductType *)productType
{
    [NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

@end
