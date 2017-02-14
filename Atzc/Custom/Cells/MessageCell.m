//
//  MessageCell.m
//  Atzc
//
//  Created by 夏兆伟 on 13-12-14.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "MessageCell.h"

#define CELL_HEIGHT self.contentView.frame.size.height
#define CELL_WIDTH self.contentView.frame.size.width

@implementation MessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // 初始化代码
        _userHead =[[[UIImageView alloc]initWithFrame:CGRectZero]autorelease];
        _bubbleBg =[[[UIImageView alloc]initWithFrame:CGRectZero]autorelease];
        _messageConent=[[[UILabel alloc]initWithFrame:CGRectZero]autorelease];
        _headMask =[[[UIImageView alloc]initWithFrame:CGRectZero]autorelease];
        _chatImage =[[[UIImageView alloc]initWithFrame:CGRectZero]autorelease];
        
        [_messageConent setBackgroundColor:[UIColor clearColor]];
        [_messageConent setFont:[UIFont systemFontOfSize:15]];
        [_messageConent setNumberOfLines:20];
        
        [self.contentView addSubview:_bubbleBg];
        [self.contentView addSubview:_userHead];
        [self.contentView addSubview:_headMask];
        [self.contentView addSubview:_messageConent];
        [self.contentView addSubview:_chatImage];
        
        [_chatImage setBackgroundColor:[UIColor redColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [_headMask setImage:[[UIImage imageNamed:@"UserHeaderImageBox"]stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    }
    return self;
}
//布局视图
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    NSString *orgin=_messageConent.text;
    CGSize textSize=[orgin sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake((320-HEAD_SIZE-3*INSETS-40), TEXT_MAX_HEIGHT) lineBreakMode:NSLineBreakByWordWrapping];
    
    
    switch (_msgStyle) {
        case kWCMessageCellStyleMe://如果是我的信息
        {
            [_chatImage setHidden:YES];
            [_messageConent setHidden:NO];
            [_messageConent setFrame:CGRectMake(CELL_WIDTH-INSETS*2-HEAD_SIZE-textSize.width-15, (CELL_HEIGHT-textSize.height)/2, textSize.width, textSize.height)];
            [_userHead setFrame:CGRectMake(CELL_WIDTH-INSETS-HEAD_SIZE, INSETS,HEAD_SIZE , HEAD_SIZE)];
            
            [_bubbleBg setImage:[[UIImage imageNamed:@"SenderTextNodeBkg"]stretchableImageWithLeftCapWidth:20 topCapHeight:30]];
            _bubbleBg.frame=CGRectMake(_messageConent.frame.origin.x-15, _messageConent.frame.origin.y-12, textSize.width+30, textSize.height+30);
        }
            break;
        case kWCMessageCellStyleOther://如果是别人的信息
        {
            [_chatImage setHidden:YES];
            [_messageConent setHidden:NO];
            [_userHead setFrame:CGRectMake(INSETS, INSETS,HEAD_SIZE , HEAD_SIZE)];
            [_messageConent setFrame:CGRectMake(2*INSETS+HEAD_SIZE+15, (CELL_HEIGHT-textSize.height)/2, textSize.width, textSize.height)];
            
            
            [_bubbleBg setImage:[[UIImage imageNamed:@"ReceiverTextNodeBkg"]stretchableImageWithLeftCapWidth:20 topCapHeight:30]];
            _bubbleBg.frame=CGRectMake(_messageConent.frame.origin.x-15, _messageConent.frame.origin.y-12, textSize.width+30, textSize.height+30);
        }
            break;
        case kWCMessageCellStyleMeWithImage://如果是我的图片信息
        {
            //[_messageConent setFrame:CGRectMake(CELL_WIDTH-INSETS*2-HEAD_SIZE-textSize.width-15, (CELL_HEIGHT-textSize.height)/2, textSize.width, textSize.height)];
            [_chatImage setHidden:NO];
            [_messageConent setHidden:YES];
            [_chatImage setFrame:CGRectMake(CELL_WIDTH-INSETS*2-HEAD_SIZE-115, (CELL_HEIGHT-100)/2, 100, 100)];
            [_userHead setFrame:CGRectMake(CELL_WIDTH-INSETS-HEAD_SIZE, INSETS,HEAD_SIZE , HEAD_SIZE)];
            
            [_bubbleBg setImage:[[UIImage imageNamed:@"SenderTextNodeBkg"]stretchableImageWithLeftCapWidth:20 topCapHeight:30]];
            _bubbleBg.frame=CGRectMake(_chatImage.frame.origin.x-15, _chatImage.frame.origin.y-12, 100+30, 100+30);
        }
            break;
        case kWCMessageCellStyleOtherWithImage://如果是别人的图片信息
        {
            [_chatImage setHidden:NO];
            [_messageConent setHidden:YES];
            [_chatImage setFrame:CGRectMake(2*INSETS+HEAD_SIZE+15, (CELL_HEIGHT-100)/2,100,100)];
            [_userHead setFrame:CGRectMake(INSETS, INSETS,HEAD_SIZE , HEAD_SIZE)];
            
            [_bubbleBg setImage:[[UIImage imageNamed:@"ReceiverTextNodeBkg"]stretchableImageWithLeftCapWidth:20 topCapHeight:30]];
            
            _bubbleBg.frame=CGRectMake(_chatImage.frame.origin.x-15, _chatImage.frame.origin.y-12, 100+30, 100+30);
            
        }
            break;
        default:
            break;
    }
    
    //头像遮罩层
    _headMask.frame=CGRectMake(_userHead.frame.origin.x-3, _userHead.frame.origin.y-1, HEAD_SIZE+6, HEAD_SIZE+6);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//设置信息对象
-(void)setMessageObject:(MessageModel*)aMessage
{
    [_messageConent setText:aMessage.messageContent];
    
}
//设置头像
-(void)setHeadImage:(UIImage*)headImage
{
    [_userHead setImage:headImage];
}
//设置俩天内容的图片
-(void)setChatImage:(UIImage *)chatImage
{
    [_chatImage setImage:chatImage];
}

@end
