//
//  UIImageView+.swift
//  Disc
//
//  Created by Jamila Mahammadli on 08.10.25.
//

import UIKit
import Kingfisher

extension UIImageView {
    func downloadImage(from url: String) {
        let highQualityURL = url.replacingOccurrences(of: "100x100", with: "600x600")
        guard let url = URL(string: highQualityURL) else { return }
        self.kf.setImage(with: url, placeholder: UIImage(systemName: "photo"))
    }
}
