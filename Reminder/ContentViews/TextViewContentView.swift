//
//  TextViewContentView.swift
//  Reminder
//
//  Created by Mohamed Hamdy on 11/05/2022.
//

import UIKit

class TextViewContentView: UIView, UIContentView {
    struct Configuration: UIContentConfiguration {
        var text: String? = ""
        
        func makeContentView() -> UIView & UIContentView {
            return TextViewContentView(self)
        }
        
        var onHandler: (String)->Void = {_ in}
    }
    
    var textView = UITextView()
    var configuration: UIContentConfiguration {
        didSet{
            configure(configuration: configuration)
        }
    }
    override var intrinsicContentSize: CGSize {
        CGSize(width: 0, height: 44)
    }
    
    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        addPinnedSubview(textView, height: 200, insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        textView.backgroundColor = nil
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(configuration: UIContentConfiguration) {
        guard let configuration2 = configuration as? Configuration else { return }
        textView.text = configuration2.text
    }

}

extension UICollectionViewListCell {
    func textViewConfiguration() -> TextViewContentView.Configuration {
        TextViewContentView.Configuration()
    }
}

extension TextViewContentView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let configuration = configuration as? Configuration else { return }
        configuration.onHandler(textView.text)
    }
}
