//
//  ViewController.m
//  SpliteScreenDemo
//
//  Created by jufn on 2020/8/8.
//  Copyright © 2020 陈俊峰. All rights reserved.
//

#import "ViewController.h"
#import <GLKit/GLKit.h>
#import "FilterBar.h"

typedef struct {
    GLKVector3 positionCoord;
    GLKVector2 textureCoord;
} ScreenVertex;

@interface ViewController () <FilterBarDelegate>

@property (nonatomic, assign) ScreenVertex *vertices;

@property (nonatomic, strong) EAGLContext *context;

@property (nonatomic, assign) GLuint textureID;

@property (nonatomic, assign) GLuint vertexBuffer;

@property (nonatomic, assign) GLuint program;

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, assign) NSTimeInterval startTimeInterval;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self configureFliterBar];
    [self configureVertices];
    
    [self setup];
    [self startAnimate];
}

- (void)startAnimate {
    if (self.displayLink) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(actionDisplayLink)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    self.startTimeInterval = 0;
}

- (void)actionDisplayLink {
    if (self.startTimeInterval == 0) {
        self.startTimeInterval = self.displayLink.timestamp;
    }
    
    NSTimeInterval duration = self.displayLink.timestamp - self.startTimeInterval;
    glUseProgram(self.program);
    glBindBuffer(GL_ARRAY_BUFFER, self.vertexBuffer);
    GLuint time = glGetUniformLocation(self.program, "time");
    glUniform1f(time, duration);
    
    glClear(GL_COLOR_BUFFER_BIT);
    glClearColor(1, 1, 1, 1);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    [self.context presentRenderbuffer:GL_RENDERBUFFER];
    
}

- (void)setup {
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:self.context];
    
    CAEAGLLayer *layer = [CAEAGLLayer layer];
    layer.frame = CGRectMake(0.0, 100.0, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame));
    layer.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:layer];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"kunkun" ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    [self textureIDWithImage:image];
    
    GLint renderWidth, renderHeight;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &renderWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &renderHeight);
    
    glViewport(0, 0, renderWidth, renderHeight);
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, self.vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(ScreenVertex) * 4, self.vertices, GL_STATIC_DRAW);
    
    [self setupNormalShader];
}

- (void)setupNormalShader {
    [self setupShaderWithShaderName:@"normal"];
}

- (void)setupShaderWithShaderName:(NSString *)shaderName {
    self.program = [self getProgram:shaderName];
    glUseProgram(self.program);
    
    GLuint positionSlot = glGetAttribLocation(self.program, "Position");
    GLuint textureCoordsSlot = glGetAttribLocation(self.program, "TextureCoords");
    GLuint textureSlot = glGetUniformLocation(self.program, "Texture");
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, self.textureID);
    glUniform1i(textureSlot, 0);
    
    glEnableVertexAttribArray(positionSlot);
    glVertexAttribPointer(positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(ScreenVertex), NULL + offsetof(ScreenVertex, positionCoord));
    
    glEnableVertexAttribArray(textureCoordsSlot);
    glVertexAttribPointer(textureCoordsSlot, 2, GL_FLOAT, GL_FALSE, sizeof(ScreenVertex), NULL + offsetof(ScreenVertex, textureCoord));
}

- (GLuint)getProgram:(NSString *)shaderName {
    GLuint vShader = [self compileShaderName:shaderName type:GL_VERTEX_SHADER];
    GLuint fShader = [self compileShaderName:shaderName type:GL_FRAGMENT_SHADER];
    
    GLuint program = glCreateProgram();
    glAttachShader(program, vShader);
    glAttachShader(program, fShader);
    
    // 链接程序
    glLinkProgram(program);
    GLenum status;
    glGetProgramiv(program, GL_LINK_STATUS, &status);
    if (status == GL_FALSE) {
        char message[256];
        glGetProgramInfoLog(program, sizeof(message), 0, &message[0]);
        printf("%s", message);
        return 0;
    }
    
//    glDetachShader(program, vShader);
//    glDetachShader(program, fShader);
    return program;
}

- (GLuint)compileShaderName:(NSString *)shaderName type:(GLenum)type {
    NSString *vFile = [[NSBundle mainBundle] pathForResource:shaderName ofType:type == GL_FRAGMENT_SHADER ? @"fsh" : @"vsh" ];
    
    NSError *error = NULL;
    NSString *souce = [NSString stringWithContentsOfFile:vFile encoding:NSUTF8StringEncoding error:&error];
    if (error != NULL) {
        printf("read shader file failed");
        return 0;
    }
  	const GLchar *sc = (GLchar *)[souce UTF8String];

    GLint length = (GLint)souce.length;
    GLuint shader = glCreateShader(type);
    glShaderSource(shader, 1, &sc, &length);
    
    glCompileShader(shader);
    GLenum status;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &status);
    if (status == GL_FALSE) {
        GLchar message[256];
        glGetShaderInfoLog(shader, sizeof(message), 0, &message[0]);
        printf("%s", message);
        return 0;
    }
    return shader;
}

- (void)textureIDWithImage:(UIImage *)image {
    CGImageRef imageRef = [image CGImage];
    if (imageRef == NULL) {
        printf("image load failed");
        return;
    }
    
    GLuint w = (GLuint)CGImageGetWidth(imageRef);
    GLuint h = (GLuint)CGImageGetHeight(imageRef);
    CGRect rect = CGRectMake(0, 0, w, h);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    void *imageData = malloc(w * h * 4);
    CGContextRef context = CGBitmapContextCreate(imageData, w, h, 8, w * 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);

    CGContextTranslateCTM(context, 0, h);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    CGColorSpaceRelease(colorSpace);
    CGContextClearRect(context, rect);

    CGContextDrawImage(context, rect, imageRef);
    CGContextRelease(context);

    GLuint textureID = 0;
    glGenTextures(1, &textureID);
    glBindTexture(GL_TEXTURE_2D, textureID);
    glTexImage2D(GL_TEXTURE_2D, 1, GL_RGBA, w, h, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

    glBindTexture(GL_TEXTURE_2D, 0);
    free(imageData);

    self.textureID = textureID;
}

- (void)bindRenderBufferAndFrameBufferInLayer:(CAEAGLLayer *)layer {
    GLuint renderBuffer, frameBuffer;
    
    glGenRenderbuffers(1, &renderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, renderBuffer);
    [self.context renderbufferStorage:GL_RENDERBUFFER fromDrawable:layer];
    
    
    glGenFramebuffers(1, &frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, renderBuffer);
}

- (void)configureFliterBar {
    FilterBar *bar = [[FilterBar alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 100, CGRectGetWidth(self.view.frame), 100)];
    bar.delegate = self;
    bar.itemList = @[@"无", @"2分屏", @"3分屏", @"4分屏", @"6分屏", @"9分屏"];
    
    [self.view addSubview:bar];
}

- (void)filterBar:(FilterBar *)filterBar didScrollToIndex:(NSUInteger)index {
    printf("--- %zd", index);
}

- (void)configureVertices {
    self.vertices = malloc(sizeof(ScreenVertex) * 4);
    self.vertices[0] = (ScreenVertex){{-1.0f, 1.0f, 0.0f},{0.0f, 1.0f}};
    self.vertices[1] = (ScreenVertex){{-1.0f, -1.0f, 0.0f},{0.0f, 0.0f}};
    self.vertices[2] = (ScreenVertex){{1.0f, 1.0f, 0.0f}, {1.0f, 1.0f}};
    self.vertices[3] = (ScreenVertex){{1.0f, -1.0f, 0.0f}, {1.0f, 0.0f}};
}

- (void)dealloc {
    if (_vertices) {
        free(_vertices);
        _vertices = nil;
    }
}




@end
