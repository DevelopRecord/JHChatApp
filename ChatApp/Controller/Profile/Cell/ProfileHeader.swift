//
//  ProfileHeader.swift
//  ChatApp
//
//  Created by LeeJaeHyeok on 2022/04/10.
//

import UIKit

protocol ProfileHeaderDelegate: AnyObject {
    func dismissController()
}

class ProfileHeader: BaseView {

    // MARK: - Properties

    weak var delegate: ProfileHeaderDelegate?

    var user: User? {
        didSet { setData() }
    }

    private let dismissButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "xmark"), for: .normal)
        $0.tintColor = UIColor(named: "nav_item_color")
        $0.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
    }

    private let profileImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 200 / 2
        $0.layer.borderWidth = 4.0
        $0.layer.borderColor = UIColor.white.cgColor
    }

    private let fullnameLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 20)
        $0.textAlignment = .center
    }

    private let nicknameLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textAlignment = .center
    }

    // MARK: - Helpers

    override func configureUI() {
        backgroundColor = .secondarySystemBackground
        configureConstraints()
    }

    override func configureConstraints() {
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(200)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(65)
        }

        let stackView = UIStackView(arrangedSubviews: [fullnameLabel, nicknameLabel])
        stackView.axis = .vertical
        stackView.spacing = 4

        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(profileImageView.snp.bottom).offset(16)
        }

        addSubview(dismissButton)
        dismissButton.snp.makeConstraints { make in
            make.width.height.equalTo(48)
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(safeAreaLayoutGuide.snp.leading)
        }
    }

    func setData() {
        guard let user = user else { return }
        guard let url = URL(string: user.profileImageUrl) else { return }

        profileImageView.kf.setImage(with: url)
        fullnameLabel.text = user.fullname
        nicknameLabel.text = "@" + user.nickname
    }

    // MARK: - Selectors

    @objc func handleDismissal() {
        delegate?.dismissController()
    }
}
