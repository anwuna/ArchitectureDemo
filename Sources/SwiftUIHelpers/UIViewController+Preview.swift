//
//  File.swift
//  
//
//  Created by Chibundu Anwuna on 2022-12-09.
//

import UIKit
@_exported import SwiftUI

#if DEBUG
extension UIViewController {
    struct PreviewProvider: UIViewControllerRepresentable {
        let viewController: UIViewController

        init(viewController: UIViewController) {
            self.viewController = viewController
        }

        func makeUIViewController(context: Context) -> some UIViewController {
            return viewController
        }

        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }

    public var preview: some View {
        PreviewProvider(viewController: self)
    }
}

#endif
