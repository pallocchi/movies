//  MIT License
//
//  Copyright (c) 2018 Pablo Pallocchi
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the “Software”), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit

final class URLImageView: UIImageView {
    
    private var imageURL: URL?
    
    /**
     Load an image form a URL into the image view.
     
     - Parameters:
        - url: The image URL
        - mode: The view content mode
     */
    func from(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        imageURL = url
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                    print("Image \(url) not loaded")
                    return
                }
            DispatchQueue.main.async() {
                if self.imageURL! == url {
                    self.image = image
                }
            }
            }.resume()
    }
    
    /**
     Load an image form a link into the image view.
     
     - Parameters:
     - link: The image link
     - mode: The view content mode
     */
    func from(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else {
            print("Image \(link) not loaded")
            return
        }
        from(url: url, contentMode: mode)
    }
    
}
