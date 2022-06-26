//
//  IndicatorView.swift
//  CurrencyConverter
//
//  Created by Mert Karakas on 24.06.2022.
//

import UIKit

final class IndicatorView: UIView {

    private enum Layouts {
        static let backgroundAlpha = 0.5
        static let indicatorFrameSize: CGFloat = 50
    }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        prepareUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI

    private func prepareUI() {

        isUserInteractionEnabled = false

        let backgroundView = UIView()
        backgroundView.backgroundColor = .black
        backgroundView.alpha = Layouts.backgroundAlpha

        var activityIndicator = UIActivityIndicatorView()
        activityIndicator = UIActivityIndicatorView(frame: CGRect(
            x: .zero,
            y: .zero,
            width: Layouts.indicatorFrameSize,
            height: Layouts.indicatorFrameSize
        ))
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.color = .white
        activityIndicator.startAnimating()

        backgroundView.fit(subView: activityIndicator)
        fit(subView: backgroundView)
    }
}
