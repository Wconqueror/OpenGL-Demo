//
//  ViewController.m
//  openGL
//
//  Created by hgf on 2018/12/4.
//  Copyright © 2018 hgf. All rights reserved.
//

#import "ViewController.h"

typedef struct{
    GLKVector3 positionCoords;
} SceneVertex;

static const SceneVertex vertices[] = {
    {{-0.5f,-0.5f,0.0}},
    {{0.5f,-0.5f,0.0}},
    {{-0.5f,0.5f,0.0}}
};

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self setEAGContext];
    
    [self setBaseEffect];
    
    //glClearColor 函数用户设置当前上下文的清除颜色,由RGBA组成,用户在上下文的帧缓存被清除时初始化每个像素的颜色值
    glClearColor(0.5f, 0.5f, 0.5f, 1.0f);//background color
    
    [self setBufferData];
}


-(void)setEAGContext{
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"Viewcongroller 的 view is not a GLKView");
    view.context = [[EAGLContext alloc]initWithAPI:(kEAGLRenderingAPIOpenGLES2)]; //openGL 2.0
    [EAGLContext setCurrentContext:view.context];
}

-(void)setBaseEffect{
    self.baseEffect = [[GLKBaseEffect alloc]init];
    self.baseEffect.useConstantColor = GL_TRUE;
    //控制渲染的方法有很多种,下面是个很定的白色三角形,使用一个保存颜色四元素的结构体来设置很定的颜色
    
    //颜色格式为RGBA
    GLKVector4 vector4 = GLKVector4Make(1.0f,
                                        1.0f,
                                        1.0f,
                                        1.0f);
    self.baseEffect.constantColor = vector4;
}

-(void)setBufferData{
    //glGenBuffers 用于生成一个独一无二的标识符,第一个参数指定要生成的缓存的数量为1,第二个参数只想生成标识符的内存地址,并保存,当前情况下,一个标识符呗生成并保存在verTexBufferId实例变量种
    glGenBuffers(1, &vertexBufferId); //第一步
    
    //glBindBuffers 函数用户绑定指定的标识符的缓存到当前缓存,OpenGL ES保存不同类型的缓存到当前上下文的不同部位,但是在同一时刻只能绑定一个缓存
    //第一个参数是一个常量,用于指定缓存的类型,GL_ARRAY_BUFFER类型用于指定一个顶点属性数组,三角形就属于这种类型,第二个参数是要绑定的标识符
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferId); //第二步
    
    //glBufferData函数,复制引用的顶点数据到当前上下文,绑定顶点到缓存中
    glBufferData( //第三步
                 GL_ARRAY_BUFFER,//指定当前上下文所绑定的是哪一个缓存
                 sizeof(vertices),//复制到这个缓存的字节数
                 vertices,       //要复制的字节的地址
                 GL_STATIC_DRAW);//提示缓存在未来会被怎样使用,GL_STATIC_DRAW会提示上下文缓存中的内容适合复制到GPU控制的内存,对其很少修改,这个信息会提示OpenGL ES来优化内存使用
}


//该方法GLKView的代理方法,实现该方法就意味着要告诉GLKBaseEffect去准备号OpenGL ES上下文
-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    [self.baseEffect prepareToDraw];
    
    //清除之前设置的值,使用glClearColor设置值
    //注意:该glClear功能提示OpenGL ES可以丢弃任何现有的帧缓存区内容,避免了将先前内容加载到内存中的昂贵内存操作,为确保最佳性能,你应该在绘制之前始终调用次函数
    glClear(GL_COLOR_BUFFER_BIT);
    
    /* 第四步,启动
     * 第五步,设置指针
     * 第六步,绘图
     */
    
    //该方法用于启动订单缓存的渲染操作,
    glEnableVertexAttribArray(//第四步
                              GLKVertexAttribPosition);
    
    //该方法会告诉OpenGL ES 定点数据在哪里,以及怎么解释定点数据
    glVertexAttribPointer(//第五步
                          GLKVertexAttribPosition,//当前绑定的缓存 包含每个定点的位置信息
                          3, //每个顶点位置 包含几个部分(x,y,z)
                          GL_FLOAT,//告诉OpenGL ES每个定点位置都是一个浮点类型
                          GL_FALSE,//告诉OpenGL ES小数点固定数据是否可以被改变
                          sizeof(SceneVertex),//每个定点的保存需要多少字节
                          NULL//NULL 告诉OpenGL ES可以从当前绑定的定点缓存的开始位置访问定点数据
                          );
    
    //第六步
    glDrawArrays(
                 GL_TRIANGLES,//告诉GPU如何q去处理绑定在定点缓存内的顶点数据,该参数是渲染一个三角形
                 0,//要渲染的第一个顶点的位置
                 3);//要渲染的顶点的数量
}

-(void)dealloc{
    GLKView *view = (GLKView *)self.view;
    [EAGLContext setCurrentContext:view.context];
    
    //释放资源
    
    if (0!=vertexBufferId) {//第七步
        glDeleteBuffers(1, &vertexBufferId);
        vertexBufferId = 0;//设置为0避免在对应的缓存呗删除之后存在未被使用的无效标识符
    }
    
    ((GLKView *)self.view).context = nil;
    [EAGLContext setCurrentContext:nil];
    
    
}

@end
