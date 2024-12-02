//
//  CustomTabBarViewModel.swift
//  Presentation
//
//  Created by 한상진 on 12/2/24.
//

import Foundation
import Combine
import Domain

public final class CustomTabBarViewModel: ViewModel {
  // MARK: - Properties
  public enum Action {
    case startRecording
  }
  
  public struct State: Equatable {
    var isEnableWriteDiary: Bool
    var recordPermissionStatus: RecordManager.PermissionStatus?
  }
  
  let useCase: DiaryUseCase
  @Published public var state: State
  
  // MARK: - Initializer
  init(useCase: DiaryUseCase) {
    self.useCase = useCase
    state = State(isEnableWriteDiary: true)
  }
  
  // MARK: - Methods
  public func action(_ action: Action) {
    switch action {
    case .startRecording:
      Task {
        await checkPermissionAndFetchDiary()
      }
    }
  }
}

private extension CustomTabBarViewModel {
  func checkPermissionAndFetchDiary() async {
    // 1. 권한 체크
    let status = await RecordManager.checkUserPermission()
    
    // 2. authorized가 아닌 경우 조기에 종료
    if status != .authorized {
      state.recordPermissionStatus = status
      return
    }
    
    // 3. 마이크, 음성 권한이 authorized인 경우 -> 일기 작성 가능 여부 확인
    do {
      let date = Date()
      let todayDiary = try await useCase.readDiaries(calendarDate: date.calendarDate())
      let isEnable = todayDiary.filter { $0.calendarDate.day == date.calendarDate().day }.isEmpty
      
      state.recordPermissionStatus = status
      state.isEnableWriteDiary = isEnable
    } catch {
      state.recordPermissionStatus = status
      state.isEnableWriteDiary = true
    }
  }
}
