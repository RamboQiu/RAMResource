//  Created by 裘俊云 on 2023/7/5.
//

import SwiftUI
import RAMResource

public struct Component2VC: View {
    public init() {}
    public var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("你好，我是组件2".Component2())
        }
        .padding()
    }
}
