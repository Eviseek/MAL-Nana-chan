//
//  UIImageView+RemoteImage.swift
//  MAL Nana-chan
//

import UIKit
import AlamofireImage

extension UIImageView {

    /// Loads a poster from an API-supplied URL string.
    func setRemoteImage(_ urlString: String?) {
        guard let urlString, let url = URL(string: urlString) else {
            af.cancelImageRequest()
            image = nil
            return
        }
        af.setImage(withURL: url)
    }
}
