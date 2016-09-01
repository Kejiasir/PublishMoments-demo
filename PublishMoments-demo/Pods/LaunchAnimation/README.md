## 这是什么鬼?
*  这是一个简单的启动图动画.
*  您只需要一句代码就能使启动图开启一个动画效果.
*  暂时有三种效果, 提供一个枚举可任意选择, 后续再增加一些其他的效果.
*  哈哈, 话说之前写过这个Demo [一个裁剪图片的小工具类,通过一句代码调用](http://www.cnblogs.com/arvin-sir/p/5094445.html), 当时是不知道如何获取应用的启动图的, 现在呢, 知道了O(∩_∩)O哈哈哈~, 所以就写了这个简单的库, 核心代码都是一样一样的, 写的不好希望大家多多鼓励多多包涵...

##  要怎么集成?
### 手动添加:<br>
*   1. Clone or download 本项目
*   2. 将Demo中的 `LaunchAnimaiton` 文件夹Copy到您的工程目录中<br> 

### CocoaPods:<br>
*   1. 在 Podfile 中添加 `pod 'LaunchAnimaiton', '~> 0.1.0'`<br>
*   2. 在终端执行 `pod install` 或 `pod update` 命令<br> 

## 它如何使用?
*  如您所见, 一句代码 :
*  在 `AppDelegate.m` 文件中 `import "LaunchImageView.h"` 头文件即可
```Objective-C
// 切记:在添加前必须先设置window的视图可见并显示
// 即调用:[self.window makeKeyAndVisible],否则不会展示动画效果
[self.window addSubview:[[LaunchImageView alloc]
                             initWithFrame:self.window.bounds
                             animationType:AnimationTypeUpAndDown
                             duration:1.5f]];
```

## 另外需要注意的<br>
**请把启动图片放在项目的 `Assets.xcassets` 文件中, 应当从Brand Assets中加载**

<img src="IMAGE/img_000.png?v=3&s=100" alt="GitHub" title="启动图片应当从Brand Assets中加载" width="780" height="220"/>

### 嗯, 最后放几张图吧(gif图不太好录哦!!! 只能是截图了)

<img src="IMAGE/img_001.png?v=3&s=100" alt="GitHub" title="第一种动画效果" width="260" height="480"/> 
<img src="IMAGE/img_002.png?v=3&s=100" alt="GitHub" title="第二种动画效果" width="260" height="480"/> 
<img src="IMAGE/img_003.png?v=3&s=100" alt="GitHub" title="第三种动画效果" width="260" height="480"/>
 

##License
**LaunchAnimaiton 使用 MIT 许可证，详情见 LICENSE 文件**
