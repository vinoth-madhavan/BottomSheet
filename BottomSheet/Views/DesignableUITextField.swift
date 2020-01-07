//
//  DesignableUITextField.swift
//  BottomSheet
//
//  Created by Vinoth on 7/1/20.
//  Copyright © 2020 Vinoth. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableUITextField: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override init(frame: CGRect) {
      super.init(frame: frame)
        setup()

    }
    
    func setup() {
        borderStyle = .none
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: -5.0, y: -5.0, width: self.frame.size.width + 10.0, height: self.frame.size.height + 10.0)
        border.borderWidth = width
        border.cornerRadius = 10
        self.layer.addSublayer(border)
        self.layer.masksToBounds = false
    }

    @IBInspectable var insetX: CGFloat = 0
    @IBInspectable var insetY: CGFloat = 0
    

       // placeholder position
       override func textRect(forBounds bounds: CGRect) -> CGRect {
           return bounds.insetBy(dx: insetX, dy: insetY)
       }

       // text position
       override func editingRect(forBounds bounds: CGRect) -> CGRect {
           return bounds.insetBy(dx: insetX, dy: insetY)
       }
    
    @IBInspectable var leftImage: UIImage?{
        didSet{
            leftViewMode = .always
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20 + 20, height: 20))
            let imageView = UIImageView(frame: CGRect(x: 15, y: 0, width: 20, height: 20))
            imageView.image = self.leftImage
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = UIColor.orange
            paddingView.addSubview(imageView)
            self.leftView = paddingView
        }
        
    }
    @IBInspectable var rightImage: UIImage?{
        didSet {
            rightViewMode = .always
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20 + 20, height: 20))
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.image = self.rightImage
            imageView.image!.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = UIColor.lightGray
            imageView.contentMode = .scaleAspectFit
            paddingView.addSubview(imageView)
            self.rightView = paddingView
        }
    }

}
