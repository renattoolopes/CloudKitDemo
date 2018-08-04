//
//  CellCustom.swift
//  CloudKitDemo
//
//  Created by Renato Lopes on 03/08/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import Foundation
import UIKit

class CellCustom: UITableViewCell {
    var message: String?
    var mainImage: UIImage?
    
    
    let messageView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    let mainImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        super.addSubview(messageView)
        super.addSubview(mainImageView)
        adjustAnchorPositon()
        
        
        
    }
    
    func adjustAnchorPositon(){
        // Ajuste da ImageView
//        mainImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        mainImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
//        mainImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        mainImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        mainImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        //Ajuste do TextView
        messageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        messageView.leftAnchor.constraint(equalTo: self.mainImageView.rightAnchor).isActive = true
        messageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        messageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
    
    override func layoutSubviews() {
        if let img = mainImage {
            mainImageView.image = img
        }
        
        if let msg = message {
            messageView.text = msg
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
