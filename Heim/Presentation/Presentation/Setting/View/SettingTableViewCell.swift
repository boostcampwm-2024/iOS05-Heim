//
//  SettingTableViewCell.swift
//  Presentation
//
//  Created by 한상진 on 11/7/24.
//

import UIKit

import SnapKit

protocol CloudSwitchDelegate: AnyObject {
  func didChangedValue(_ cloudSwitch: UISwitch, isOn: Bool)
}

final class SettingTableViewCell: UITableViewCell {
  
  // MARK: - Properties
  private enum Constants {
    static let fontSize: CGFloat = 16
    static let defaultPadding: CGFloat = 16
    static let cloudSwitchVerticalPadding: CGFloat = 12
  }
  
  private let titleImageView = UIImageView()
  private let titleLabel = HeimLabel(font: .regular, size: Constants.fontSize)
  
  private let cloudSwitch: UISwitch = {
    let cloudSwitch = UISwitch()
    cloudSwitch.onTintColor = .heimBlue
    cloudSwitch.addTarget(self, action: #selector(didChangedSwitchValue), for: .valueChanged)
    return cloudSwitch
  }()
  
  private let subLabel = HeimLabel(font: .regular, size: Constants.fontSize, textColor: .heimGray)
  weak var cloudSwitchDelegate: CloudSwitchDelegate?
  
  // MARK: - Initializer
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setupViews()
    setupLayoutconstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - LifeCycle
  override func prepareForReuse() {
    super.prepareForReuse()

    titleImageView.image = nil
    titleLabel.text = nil
    subLabel.text = nil
    
    cloudSwitch.removeFromSuperview()
    subLabel.removeFromSuperview()
  }
  
  // MARK: - Methods
  func configure(
    iconImage: UIImage,
    titleText: String
  ) {
    titleImageView.image = iconImage
    titleLabel.text = titleText
  }
  
  func updateUserName(_ name: String) {
    subLabel.text = "\(name)  >"
  }
  
  func setupCloudSwitch(isOn: Bool) {
    cloudSwitch.isOn = isOn
    contentView.addSubview(cloudSwitch)
    
    cloudSwitch.snp.makeConstraints {
      $0.top.bottom.equalToSuperview().inset(Constants.cloudSwitchVerticalPadding)
      $0.trailing.equalToSuperview().inset(Constants.defaultPadding)
    }
  }
  
  func setupNameLabel(name: String) {
    contentView.addSubview(subLabel)
    
    subLabel.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(Constants.defaultPadding)
      $0.top.bottom.equalTo(titleLabel)
    }
  }
  
  func setupVersionLabel() {
    guard let dictionary = Bundle.main.infoDictionary,
          let version = dictionary["CFBundleShortVersionString"] as? String,
          let build = dictionary["CFBundleVersion"] as? String else { return }
    
    subLabel.text = "\(version).\(build)"
    contentView.addSubview(subLabel)
    
    subLabel.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(Constants.defaultPadding)
      $0.top.bottom.equalTo(titleLabel)
    }
  }
}

// MARK: - Private Extenion
private extension SettingTableViewCell {
  func setupViews() {
    backgroundColor = .clear
    selectionStyle = .none
    
    contentView.addSubview(titleImageView)
    contentView.addSubview(titleLabel)
  }
  
  func setupLayoutconstraints() {
    titleImageView.snp.makeConstraints {
      $0.top.leading.bottom.equalToSuperview().inset(Constants.defaultPadding)
    }
    
    titleLabel.snp.makeConstraints {
      $0.centerY.equalTo(titleImageView)
      $0.leading.equalTo(titleImageView.snp.trailing).offset(Constants.defaultPadding)
    }
  }
  
  @objc func didChangedSwitchValue() {
    cloudSwitchDelegate?.didChangedValue(cloudSwitch, isOn: cloudSwitch.isOn)
  }
}
