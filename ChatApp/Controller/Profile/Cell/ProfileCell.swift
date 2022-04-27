//
//  ProfileCell.swift
//  ChatApp
//
//  Created by LeeJaeHyeok on 2022/04/10.
//

import UIKit
import Then
import SnapKit

class ProfileCell: UITableViewCell {

    public static let identifier = "ProfileCell"

    var viewModel: ProfileViewModel? {
        didSet { setData() }
    }

    // MARK: - Properties

    private let iconView = UIView().then {
        $0.backgroundColor = .systemPurple
        $0.layer.cornerRadius = 40 / 2
    }

    private let iconImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.tintColor = .white
    }

    private let titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16)
    }

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Helpers

    func setData() {
        guard let viewModel = viewModel else { return }

        iconImage.image = UIImage(systemName: viewModel.iconImageName)
        titleLabel.text = viewModel.description
    }
}

extension ProfileCell {
    private func setupLayout() {
        iconView.addSubview(iconImage)
        iconImage.snp.makeConstraints { make in
            make.width.height.equalTo(28)
            make.centerX.centerY.equalToSuperview()
        }

        iconView.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }

        let stackView = UIStackView(arrangedSubviews: [iconView, titleLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8

        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(12)
        }
    }
}