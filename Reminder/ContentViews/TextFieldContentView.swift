//
//  TextFieldContentView.swift
//  Reminder
//
//  Created by Mohamed Hamdy on 10/05/2022.
//

import UIKit

class TextFieldContentView: UIView, UIContentView {
    
    struct Configuration: UIContentConfiguration {
        var text: String? = ""
        
        func makeContentView() -> UIView & UIContentView {
            return TextFieldContentView(self)
        }
        
        var onChange: (String)->Void = { _ in }
    }
    
    let textField = UITextField()
    var configuration: UIContentConfiguration { //new
        didSet {
            configure(configuration: configuration)
        }
    }
    override var intrinsicContentSize: CGSize {
        CGSize(width: 0, height: 44)
    }
    
    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        textField.addTarget(self, action: #selector(didChange(_:)), for: .editingChanged)
        addPinnedSubview(textField, insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        textField.clearButtonMode = .whileEditing //This property directs the text field to display a Clear Text button on its trailing side when it has contents, providing a way for the user to remove text quickly
        
    }
    
    required init?(coder: NSCoder) { //UIView subclasses that implement custom initializers must also implement the required init(coder:) initializer.
        fatalError("init(coder:) has not been implemented")
    }
    
    //used to update the user iterface with any changes in model information
    func configure(configuration: UIContentConfiguration) {
        guard let configuration2 = configuration as? Configuration else { return }
        textField.text = configuration2.text
    }
    
    //used to update the model information with any changes in user iterface
    @objc func didChange(_ sender: UITextField) {
        guard let configuration = configuration as? Configuration else { return }
        configuration.onChange(textField.text ?? "")
    }
}

//new
extension UICollectionViewListCell {
    func textFieldConfiguration() -> TextFieldContentView.Configuration {
        TextFieldContentView.Configuration()
    }
}
