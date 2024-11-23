//
//  SpotifyLoginView.swift
//  Presentation
//
//  Created by 정지용 on 11/21/24.
//

import SwiftUI

public struct SpotifyLoginView: View {
  @StateObject private var viewModel: SpotifyLoginViewModel
  @Environment(\.dismiss) private var dismiss
  
  public init(
    viewModel: SpotifyLoginViewModel
  ) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  public var body: some View {
    ZStack {
      Color(UIColor.secondarySystemBackground)
      VStack {
        Text(Constants.loginSubTitle)
          .padding(Constants.titleImagePadding)
        Button(
          action: {
            viewModel.action(.authorize)
            print("hi")
          },
          label: {
            Image(Constants.buttonImageName)
        })
      }
    }.ignoresSafeArea()
  }
  
  private enum Constants {
    static let loginSubTitle = "SNS 로그인"
    static let buttonImageName = "SpotifyLogo"
    static let titleImagePadding: CGFloat = 30.0
    static let loginSubTitlePadding: CGFloat = 5.0
  }
}
