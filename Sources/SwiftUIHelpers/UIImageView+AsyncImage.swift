//
//  File.swift
//  
//
//  Created by Chibundu Anwuna on 2022-12-10.
//

import UIKit
import AsyncImage

extension UIImageView {
    public func loadAsync(_ url: URL, placeholder: UIImage? = nil) {
        self.image = placeholder

        Task { @MainActor in
            let imageFetcher = AsyncImageFetcher()
            self.image = await imageFetcher.fetchImage(from: url)
        }
    }
}
