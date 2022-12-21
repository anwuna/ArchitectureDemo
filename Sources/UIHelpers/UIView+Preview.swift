//
//  File.swift
//  
//
//  Created by Chibundu Anwuna on 2022-12-09.
//

import UIKit
@_exported import SwiftUI

#if DEBUG
extension UIView {
    struct PreviewProvider: UIViewRepresentable {
        let view: UIView

        init(view: UIView) {
            self.view = view
        }

        func makeUIView(context: Context) -> UIView {
            return view
        }

        func updateUIView(_ uiView: UIView, context: Context) {
        }
    }

    public var preview: some View {
        PreviewProvider(view: self)
    }
}

#endif
