# ZBDebuggerTool

[![CI Status](https://img.shields.io/travis/ZB/ZBDebuggerTool.svg?style=flat)](https://travis-ci.org/ZB/ZBDebuggerTool)
[![Version](https://img.shields.io/cocoapods/v/ZBDebuggerTool.svg?style=flat)](https://cocoapods.org/pods/ZBDebuggerTool)
[![License](https://img.shields.io/cocoapods/l/ZBDebuggerTool.svg?style=flat)](https://cocoapods.org/pods/ZBDebuggerTool)
[![Platform](https://img.shields.io/cocoapods/p/ZBDebuggerTool.svg?style=flat)](https://cocoapods.org/pods/ZBDebuggerTool)

## 安装指南

使用CocoaPods安装

```ruby
pod 'ZBDebuggerTool'
```

## Example

 1、导入文件
 
 2、Appdelegate 文件开启监听
 ```objc
 
   /**可以配置监听器的参数*/
  [ZBDebuggerConfig defaultDebuggerConfig].ballThemeColor = [UIColor redColor];
  
  /**开始监听*/
  [[ZBDebuggerTool shareDebuggerTool] startWorking];

 ```
 
 3、如果不使用可以关闭监听
 ```objc
 
 [[ZBDebuggerTool shareDebuggerTool] stopWorking];
 
 ```

## 效果图

![image](https://github.com/lzbgithubcode/ZBDebuggerTool/raw/master/screenshotImage/result.gif)



## 作者

lzb, 1835064412@qq.com

## License

ZBDebuggerTool is available under the MIT license. See the LICENSE file for more info.
