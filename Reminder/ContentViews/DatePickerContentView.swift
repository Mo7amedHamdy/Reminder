//
//  DatePickerContentView.swift
//  Reminder
//
//  Created by Mohamed Hamdy on 13/05/2022.
//

import UIKit

class DatePickerContentview: UIView, UIContentView {
    struct Configuration: UIContentConfiguration {
        var date = Date.now
        
        func makeContentView() -> UIView & UIContentView {
            return DatePickerContentview(self)
        }
        
        var onChange: (Date)->Void = { _ in}
    }
    
    var datePicker = UIDatePicker()
    var configuration: UIContentConfiguration {
        didSet{
            configure(configuration: configuration)
        }
    }
    
    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        addPinnedSubview(datePicker)
        datePicker.preferredDatePickerStyle = .inline
        datePicker.addTarget(self, action: #selector(didPick(_:)), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(configuration: UIContentConfiguration) {
        guard let configuration2 = configuration as? Configuration else { return }
        datePicker.date = configuration2.date
    }
    
    @objc func didPick(_ sender: UIDatePicker) {
        guard let configuration = configuration as? Configuration else { return }
        configuration.onChange(sender.date)
    }

}

extension UICollectionViewListCell {
    func datePickerConfiguration() -> DatePickerContentview.Configuration {
        DatePickerContentview.Configuration()
    }
}
