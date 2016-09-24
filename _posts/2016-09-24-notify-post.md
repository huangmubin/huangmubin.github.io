---
layout: post
title: "Notify"
description: "利用通知中心，搭建一个好玩的消息分发机制。"
date: 2016-09-24
tags: [Swift, Codes, Notification]
comments: true
share: true
---

在开始写这篇文章之前，我就已经隐隐然的感觉到了，这将会是我挖下去的另一个坑。

我试着去了解 RxSwift 的时候，对于那种只需要几行代码的设置，然后就可以接收到各种原来需要使用代理才能收到，并且还要仔细考虑线程问题的做法，感觉真是 awesome！！！

所以，我也想，能不能，也模拟一下这种做法。有一种简单的方式，能让一个对象，向一个，或多个对象发送消息。这种消息是安全的，而且线程可以控制。

# 背景知识

NSNotification

主要的日常应用集中在三类方法中。

* addObserver 添加观察者
* removeObserver 移除观察者
* post 发送消息

贴上完整的方法接口：

```
public func addObserver(observer: AnyObject, selector aSelector: Selector, name aName: String?, object anObject: AnyObject?)

public func postNotificationName(aName: String, object anObject: AnyObject?, userInfo aUserInfo: [NSObject : AnyObject]?)
    
public func removeObserver(observer: AnyObject, name aName: String?, object anObject: AnyObject?)
    
public func addObserverForName(name: String?, object obj: AnyObject?, queue: NSOperationQueue?, usingBlock block: (NSNotification) -> Void) -> NSObjectProtocol
```

