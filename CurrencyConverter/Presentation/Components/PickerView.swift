//
//  PickerView.swift
//  CurrencyConverter
//
//  Created by Mert Karakas on 25.06.2022.
//

import UIKit

protocol PickerViewDelegate: AnyObject {
    func didSelected(with index: Int, sender: PickerView)
}

final class PickerView: UIControl {

    // MARK: - Overrides

    override var inputView: UIView? {
        pickerView
    }

    override var inputAccessoryView: UIView? {
        UIToolbar.buildWithDoneButton(target: self, action: #selector(doneTapped))
    }

    override var canBecomeFirstResponder: Bool {
        true
    }

    // MARK: - Delegates

    weak var delegate: PickerViewDelegate?

    // MARK: - Properties

    private let stackView = UIStackView()

    private lazy var pickerTextField: UITextField = {
        let view = UITextField()
        view.textAlignment = .center
        view.isUserInteractionEnabled = false
        view.widthAnchor.constraint(equalToConstant: 40).isActive = true
        return view
    }()

    private lazy var arrowImage: UIImageView = {
        let imageView = UIImageView()
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.tintColor = .systemGray
        return imageView
    }()

    private let pickerView = UIPickerView()

    private let items: [String]

    private var selectedIndex: Int

    // MARK: - Init

    init(items: [String], selectedIndex: Int = 0) {
        self.items = items
        self.selectedIndex = selectedIndex
        super.init(frame: .zero)

        self.pickerView.delegate = self
        self.pickerTextField.text = items[selectedIndex]
        self.pickerView.selectRow(selectedIndex, inComponent: 0, animated: false)

        prepareUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func prepareUI() {
        stackView.addArrangedSubview(pickerTextField)
        if items.count > 1 {
            stackView.addArrangedSubview(arrowImage)
        }
        fit(subView: stackView)

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        addGestureRecognizer(gestureRecognizer)
    }

    @objc private func viewTapped() {
        becomeFirstResponder()
    }

    @objc private func doneTapped() {
        resignFirstResponder()
    }
}

extension PickerView: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        items.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        items[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedIndex = row
        pickerTextField.text = items[selectedIndex]
        delegate?.didSelected(with: selectedIndex, sender: self)
    }
}
