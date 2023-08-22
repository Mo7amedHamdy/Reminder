//
//  ProgressHeaderView.swift
//  Reminder
//
//  Created by Mohamed Hamdy on 15/08/2023.
//

import UIKit

class ProgressHeaderView: UICollectionReusableView {
    //supplementary header
    //The element kind specifies a type of supplementary view
    //that the collection view can present.
    static var elementKind: String {UICollectionView.elementKindSectionHeader}
    
    var progress: CGFloat = 0 {
        didSet {
            heightConstrain?.constant = progress * bounds.height
            UIView.animate(withDuration: 0.4) { [weak self] in
                self?.layoutIfNeeded()
            }
        }
    }
    
    private var upperView = UIView(frame: .zero)
    private var lowerView = UIView(frame: .zero)
    private var containerView = UIView(frame: .zero)
    var heightConstrain: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 0.5 * containerView.bounds.width
        heightConstrain?.constant = progress * bounds.height
    }
    
    private func prepareSubViews() {
        containerView.addSubview(upperView)
        containerView.addSubview(lowerView)
        addSubview(containerView)
        
        upperView.translatesAutoresizingMaskIntoConstraints = false
        lowerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        containerView.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1).isActive = true
        
        containerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        containerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85).isActive = true
        
        upperView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        upperView.bottomAnchor.constraint(equalTo: lowerView.topAnchor).isActive = true
        lowerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        upperView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        upperView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        lowerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        lowerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        heightConstrain = lowerView.heightAnchor.constraint(equalToConstant: 0)
        heightConstrain?.isActive = true
        
        backgroundColor = .clear
        containerView.backgroundColor = .clear
        upperView.backgroundColor = .todayProgressUpperBackground
        lowerView.backgroundColor = .todayProgressLowerBackground
        
    }
}
