//
//  ImageViewCell.m
//  Volunteer
//
//  Created by 沈鹏 on 14/12/8.
//
//
#define IS_KIND_CLASS(object,class)  if (![object isKindOfClass:class]) {NSLog(@"类型不匹配%@->%@",object,class);return;}

#import "ImageViewCollectionCell.h"

@interface ImageViewCollectionCell()

@property (nonatomic,strong)UIImageView* imageView;

@end

@implementation ImageViewCollectionCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        
        [self addSubview:self.imageView];

    }
    return self;
}

-(void)setImageData:(NSData *)imageData
{
    IS_KIND_CLASS(imageData, [NSData class]);
    
    _imageData = imageData;
    [self.imageView setImage:[UIImage imageWithData:self.imageData]];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.imageView setClipsToBounds:YES];
}

@end
