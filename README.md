## 1. 介绍

目前库提供文字和图片两种形式的国际化，各组件维护自己的国际化文字和图片文件。

目前剩下6件需要解决的事：

1. 跟服务端对接，请求header增加当前=语言字段
2. 跟H5对接，UserAgent增加字段
3. 后续找产品要正确翻译
4. 后续找视觉要图片的正确翻译
5. 时间相关的逻辑需要确认


## 2. 快速使用

### 1. 修改组件的`podspec`



```ruby
  s.resource_bundles = {
   # 资源引用，包含图片和strings文件
    'Component3' => ['Component3/Resources/**/*']
  }

  # 依赖资源库
  s.dependency 'RAMResource'
```

### 2. 文字国际化

```swift
UILabel().text("数据获取失败")

UILabel().text("数据获取失败".Component3S())
```

### 3. 图片国际化

在图片库的图片位置，配置需要适配的语言的图片，例如：`add_btn2_en`

```swift
let btn1 = UIButton().image(UIImage(named: "add_btn2"))

let btn1 = UIButton().image("add_btn2".Component3I())
```

### 4. 语言切换

需要实时更新的页面，增加`RAMLanguageChangeNotification`通知，例如参考：`TabbarVC.swift`

```swift
NotificationCenter.default.addObserver(self, selector: #selector(reloadUILan), name:
                                                Notification.Name(rawValue: RAMLanguageChangeNotification), object: nil)
```

## 3. 注意事项

### 1. 新建组件拓展YJSResource问题

目前现有业务组件已经全部建立函数直接调用的形式，例如：

```swift
UILabel().text("数据获取失败")

UILabel().text("数据获取失败".Component3S())
```

`Component3S()`指向的就是`Component3`组件的`Component3.strings`文件

如有新建组件，需要对库`String+Localize.swift`进行扩展，支持新组件，或是直接调用

```swift
RAMResource.resource(with: "Demo").string("测试")
```

图片也是类似

### 2. 现有组件图片引用不规范问题

自查`podspec`的编写是否规范，参考`Component3.podspec`的改造：

```ruby

# resource_bundles可以避免多组件之间的图片同名问题 https://juejin.cn/post/6844903559931117581
# s.resource = ['Component3/**/*.xcassets'] 修改之后图片的使用方式需要使用封装的方法，不能直接image with name
  s.resource_bundles = {
    'Component3' => ['Component3/Resources/**/*']
  }
```

资源文件的集成需要使用`resource_bundles`的形式，这样可以避免多组件之前的资源重名问题，详细见[文章](https://juejin.cn/post/6844903559931117581)

**注意**：**如果库中存在使用image with name的图片调用形式的话，需要改成指向组件图片调用方式**，如下：

```swift
let btn1 = UIButton().image(UIImage(named: "add_btn2"))
 
let btn1 = UIButton().image("add_btn2".Component3I())
```

不然会出现图片无法显示的问题，`Component3I`中对图片的国际化进行了适配

### 3. 图片国际化方案

图片国际化使用的是图片文件名区分的方式，通过在图片的结尾增加`_en`支持英文



## 4. 服务端国际化

在`RequestHead`中加个`lang`（en或cn）字段做语言区分

服务端获取到`lang`，返回对应的数据，一般差异会体现在文案、图片、`requestErrorMessage`



## 5. 时间国际化

日历时间需要转成对应国家地区的时间

首先我们要和服务端同学规定，凡是系统中和时间相关的字段，都需要返回**时间戳**格式。**时间戳！时间戳！时间戳！**（有遇到服务端过于友好，特意转成直接可用的字符串给客户端，所以这个大家要小心，不管做没做国际化。）

时间相关格式化需要设置`locale`

```swift
let formatter = DateFormatter()
formatter.locale = Locale.init(identifier: "zh_Hans_CN")
formatter.calendar = Calendar.init(identifier: .iso8601)

```



## 6. H5国际化

考虑在`UserAgent`中增加`lang`



## 参考文章

https://www.jianshu.com/p/1550f2835f4f

https://www.jianshu.com/p/274848cb37f3

https://github.com/marmelroy/Localize-Swift

https://juejin.cn/post/6844903716928094215

https://developer.aliyun.com/article/459143

