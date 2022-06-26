//
//  UIView+Extension.swift
//  CurrencyConverter
//
//  Created by Mert Karakas on 24.06.2022.
//

import UIKit

extension UIView {

    func fit(subView: UIView, withPadding insets: UIEdgeInsets = .zero) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subView)
        let constraints: [NSLayoutConstraint] = [
            subView.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            subView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom),
            subView.leftAnchor.constraint(equalTo: leftAnchor, constant: insets.left),
            subView.rightAnchor.constraint(equalTo: rightAnchor, constant: -insets.right)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    func setLoading(_ show: Bool) {
        show ? showLoading() : hideLoading()
    }

    static func generateHeaderView(text: String) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 40).isActive = true
        view.backgroundColor = .systemGroupedBackground

        let label = UILabel()
        label.text = text

        view.fit(
            subView: label,
            withPadding: UIEdgeInsets(
                top: 0,
                left: 16,
                bottom: 0,
                right: 16
            ))

        return view
    }
}

// MARK: - Private extension functions

extension UIView {

    private func showLoading() {
        if let _ = subviews.first(where: { $0 is IndicatorView }) {
            return
        }
        let indicatorView = IndicatorView()
        fit(subView: indicatorView)
    }

    private func hideLoading() {
        guard let indicatorView = subviews.first(where: { $0 is IndicatorView }) else {
            return
        }
        indicatorView.removeFromSuperview()
    }
}
