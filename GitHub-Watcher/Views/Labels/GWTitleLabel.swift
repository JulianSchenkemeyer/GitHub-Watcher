//
//  GWTitleLabel.swift
//  GitHub-Watcher
//
//  Created by Julian Schenkemeyer on 07.12.22.
//

import UIKit

class GWTitleLabel: UILabel {

	override init(frame: CGRect) {
		super.init(frame: frame)
		
		configure()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
		self.init(frame: .zero)
		self.textAlignment = textAlignment
		self.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
	}

	private func configure() {
		translatesAutoresizingMaskIntoConstraints = false

		textColor = .label
		adjustsFontSizeToFitWidth = true
		minimumScaleFactor = 0.9
		lineBreakMode = .byTruncatingTail
	}
}
