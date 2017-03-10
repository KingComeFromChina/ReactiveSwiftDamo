# ReactiveSwiftDamo

简书中，我已经很详细的介绍了[ReactiveSwift](http://www.jianshu.com/p/25a39fe98723)，接下来我就举个[简单的例子](http://www.jianshu.com/p/5ccb81602946)供大家参考。
##键盘的监听
这在我们开发中很常用，因为很多App都需要对登录注册进行判断，这样可以避免服务器存储很多废数据，减轻服务器的压力。

首先我们先看一下效果图，当然这个只是个简单的damo[项目地址](https://github.com/KingComeFromChina/ReactiveSwiftDamo)
```
git clone https://github.com/KingComeFromChina/ReactiveSwiftDamo
```
![1.png](http://upload-images.jianshu.io/upload_images/3873966-0d223bff95947862.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![2.png](http://upload-images.jianshu.io/upload_images/3873966-019264f901860b89.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![3.png](http://upload-images.jianshu.io/upload_images/3873966-334792ea3252fd20.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![4.png](http://upload-images.jianshu.io/upload_images/3873966-ff12c31ce8748a81.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###接下来就让我详细的解释一下这些是怎么实现的吧。
#####1.首先，我们用<code>cocoaPod</code> 
`
pod 'ReactiveCocoa'
`
![4.png](http://upload-images.jianshu.io/upload_images/3873966-41bd6b01c02b7abf.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#####2.在类中顶部位置导入头文件

![5.png](http://upload-images.jianshu.io/upload_images/3873966-b5dfd91bb1d4d6b3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#####3.搭建UI，这个就不多说了，无论你是纯代码撸还是Xib拉，无所谓了
#####4.声明两个私有变量，用户名是否合法，密码是否合法

![6.png](http://upload-images.jianshu.io/upload_images/3873966-c7012999015b7f33.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
#####对了，在这里跟大家分享两个正则表达式，一个判断是否是手机号，一个判断密码是否是字母加数字多少多少位的，这个也是很常用的

![7.png](http://upload-images.jianshu.io/upload_images/3873966-b26070b27e67c167.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#####5.接下来就到了关键地方
######监听键盘的内容，RAC中已经封装好了专门的方法

![8.png](http://upload-images.jianshu.io/upload_images/3873966-ea19d17ad48c04f5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

######创建用户名、密码合法信号和订阅信号

![9.png](http://upload-images.jianshu.io/upload_images/3873966-6a82e609c181e97d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

这上面两个传递的都是颜色数据，通过验证用户名和密码是否合法从而改变输入字体的颜色和提示语的隐藏，其实是BOOL类型的信号，然后传递颜色数据，观察者订阅信号后根据信号的BOOL值改变颜色


![10.png](http://upload-images.jianshu.io/upload_images/3873966-dc1c76a9a6d75ed7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
创建登录按钮合法性信号，通过判断用户名合法信号和密码合法信号同时满足时，登录按钮信号BOOL值为true，这个可以控制按钮是否可以被点击


