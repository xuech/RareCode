//
//  ViewController.m
//  PutACollectionInTableCell
//
//  Created by xuech on 16/3/25.
//  Copyright © 2016年 obizsoft. All rights reserved.
//

#import "ViewController.h"
#import "AFTableViewCell.h"
#import "ImageViewCollectionCell.h"

@interface ViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSMutableArray *dataSource;
    NSMutableArray *picUrlArr;
    UIImage *addImage;
}
@property (nonatomic, strong) NSMutableDictionary *contentOffsetDictionary;
@end

@implementation ViewController

static NSUInteger imageIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataSource = [NSMutableArray new];
    addImage = [UIImage imageNamed:@"upload"];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:UIImagePNGRepresentation(addImage) forKey:@"Data"];
    [dic setObject:@"Del" forKey:@"Type"];
    [dataSource addObject:dic];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 19) {
        static NSString *CellIdentifier = @"CellIdentifier";
        
        AFTableViewCell *cell = (AFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell)
        {
            cell = [[AFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }

        return cell;
    }
    else{
        static NSString *CellIdentifier = @"Id";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.imageView.image = [UIImage imageNamed:@"upload"];
        
        return cell;
    }

}

-(void)tableView:(UITableView *)tableView willDisplayCell:(AFTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 19) {
        [cell setCollectionViewDataSource:self CollectionViewDelegate:self indexPath:indexPath];
        NSInteger index = cell.collectionView.tag;
        NSLog(@"index%ld",(long)index);

    }

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSMutableDictionary *dic2 = [NSMutableDictionary new];
    [dic2 setObject:UIImagePNGRepresentation(addImage) forKey:@"Data"];
    [dic2 setObject:@"Del" forKey:@"Type"];
    if (dataSource.count<4) {
        [dataSource removeObject:dic2];
        [dataSource addObject:dic2];
    }
    return dataSource.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageViewCollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];

    NSDictionary *collectionViewDic = dataSource[indexPath.row];
    cell.imageData = [collectionViewDic objectForKey:@"Data"];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *type = [dataSource[indexPath.row] objectForKey:@"Type"];
    
    if ([type isEqualToString:@"Image"]) {
        UIActionSheet *actionSheetTemp = [[UIActionSheet alloc] initWithTitle:nil
                                                                     delegate:self
                                                            cancelButtonTitle:@"取消"
                                                       destructiveButtonTitle:@"删除图片"
                                                            otherButtonTitles:nil, nil];
        [actionSheetTemp showInView:self.view];
        imageIndex = indexPath.row;
    }else{
        UIActionSheet *actionSheetTemp = [[UIActionSheet alloc] initWithTitle:nil
                                                                     delegate:self
                                                            cancelButtonTitle:@"取消"
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:@"拍照", @"打开相册",nil];
        
        
        
        actionSheetTemp.delegate = self;
        [actionSheetTemp showInView:self.view];
    }
}

#pragma mark -actionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        
        [dataSource removeObjectAtIndex:imageIndex];
        [self.tableView reloadData];
        
    }
    
    if (buttonIndex == 0 && buttonIndex != actionSheet.destructiveButtonIndex && buttonIndex != actionSheet.cancelButtonIndex) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        
        [self presentViewController:picker animated:YES completion:^(void){
            NSLog(@"Picker View Controller is presented");
        }];
        
    }
    else if (buttonIndex == 1 && buttonIndex != actionSheet.destructiveButtonIndex && buttonIndex != actionSheet.cancelButtonIndex) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        picker.delegate = self;
        
        [self presentViewController:picker animated:YES completion:^(void){
            NSLog(@"Picker View Controller is presented");
        }];
        
    }
    
    
}

#define MaxImageWidth 640
#pragma mark -PickController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    image = [self imageWithImage:image scaledToSize:CGSizeMake(MaxImageWidth, image.size.height*MaxImageWidth/image.size.width)];
    
    NSData *imageData = UIImagePNGRepresentation(image);
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:imageData forKey:@"Data"];
    [dic setObject:@"Image" forKey:@"Type"];
    
    [dataSource insertObject:dic atIndex:dataSource.count-1];
    
    if (dataSource.count>7) {
        [dataSource removeLastObject];
    }
    
    [self.tableView reloadData];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (![scrollView isKindOfClass:[UICollectionView class]]) return;
//    
//    CGFloat horizontalOffset = scrollView.contentOffset.x;
//    
//    UICollectionView *collectionView = (UICollectionView *)scrollView;
//    NSInteger index = collectionView.tag;
//    self.contentOffsetDictionary[[@(index) stringValue]] = @(horizontalOffset);
//}


-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}
@end
