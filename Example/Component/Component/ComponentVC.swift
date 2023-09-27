//
//  Created by 裘俊云 on 2023/7/5.
//

import SwiftUI
import RAMResource

public struct ComponentVC: View {
    public init() {
// 使用静态编译选项传入入参  = #file，去解析出module，但是对于dev模式下，各开发人员的文件目录不可控一致的情况下，不能很好的有规则进行解析
// jenkins正式打包的情况下，文件路径是可控的，如下
//        var filename = "/Users/zhushuaishuai/.jenkins/workspace/Cinmoore_release/Pods/YJMedia/YJMedia/Living/YJLivingVC.swift"
//        var modulename: String?
//        if let fileurl = URL(string: filename) {
//            filename = fileurl.lastPathComponent
//            let path = fileurl.pathComponents
//            if let podsDir = path.firstIndex(of: "Pods"), podsDir > 0, podsDir + 1 < path.count {
//                modulename = path[podsDir + 1]
//            }
//        }
//        if let modulename = modulename {
//            print(modulename)
//        }
    }
    
    public var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("你好，我是组件1".Component())
        }
        .padding()
    }
}
