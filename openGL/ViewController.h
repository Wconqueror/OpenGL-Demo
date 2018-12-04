//
//  ViewController.h
//  openGL
//
//  Created by hgf on 2018/12/4.
//  Copyright © 2018 hgf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface ViewController : GLKViewController
{
    GLuint vertexBufferId;//顶点数据缓存的标识符
}

//GLKBaseEffect 是GLkit提供的一个内建的类,GLKBaseEffect的存在是为了简化更多的OpenGL ES的常用操作,GLKBase

@property (nonatomic,strong) GLKBaseEffect *baseEffect;
@end

