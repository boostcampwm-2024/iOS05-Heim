## 하임(Heim)

당신의 목소리로 담는 오늘의 순간 ✨

"나도 몰랐던 나의 감정을 알게 된다면 어떨까?” 

오늘 하루의 감정을 하임이와 함께 기록해보세요 🌙

하임이가 당신만의 특별한 감정을 따뜻하게 보듬어주고, 숨겨진 마음의 이야기를 들려드릴 거에요  💫


<br/>

  
**` "진실된 감정을 표현하는 용기가 있다면, 그것은 이미 절반의 치유다." - Carl Jung `**

![1](https://github.com/user-attachments/assets/f8db841b-7383-400d-8939-8eefc3bade2d)
![2](https://github.com/user-attachments/assets/e378d076-dce5-41d5-bd79-973b02a8b110)

<br/>

## 🧸 하임이 주요 기능

🎤 **음성 녹음**

- 목소리로 일기를 기록하세요! 하임이가 당신의 이야기를 따뜻하게 들어줍니다.

💻 **텍스트 기반 AI 감정 분석**

- 녹음된 음성을 텍스트로 변환해, 그날의 감정을 세심하게 분석해드립니다.

💌 **하임이의 답장**

- 당신의 감정에 공감하며, 위로와 응원의 메시지를 전해드립니다.

📊 **통계**

- 최근 나의 기분 추이를 한눈에 확인해보세요.
- 가장 많이 느꼈던 감정에 대한 하임이의 맞춤형 답장도 받아보실 수 있습니다.


<br>

## 🖥️ 개발 환경

- Xcode: **16+**
- Swift: **5.9**
- 배포타겟: **iOS 15+**
- 의존성 관리: **SPM**
- 작업 일정관리: **Github WiKi / Projects / Notion**

<br>

## 🌌 프로젝트 Overview

### 🔭 프로젝트 구조
- **Clean Architecture** + **MVVM-C**

<br>

### 🔑 핵심 기술 스택

- UI: **UIKit**
- Test: **XCTest**

- AI: **CoreML**
    - 음성 녹음을 텍스트로 변환한 문장에서 감정을 분석하기 위해 AI 모델 학습이 필요했습니다.
    - 높은 정확도를 갖추는 것이 목표였으며, 학습의 과정에서 Python의 PyTorch를 통한 학습과 CoreML의 CreateML을 통한 학습을 모두 진행해 본 결과 CreateML을 통한 학습이 훨씬 높은 정확도를 갖게 되어 CoreML을 채택하기로 결정했습니다.
    - Text Classification 모델에 데이터 셋 2만개를 주입해 학습을 진행했으며, 텍스트 문장에서 7가지의 감정 분류(슬픔, 분노, 기쁨, 당황, 공포, 혐오, 중립) 중 한 가지를 추출할 수 있도록 했습니다.

- Generative AI: **Gemini**
  - 사용자의 일기 내용을 바탕으로 답변과 요약문을 제공해 줄 생성형 AI가 필요했습니다.
  - OpenAI의 GPT-4 모델 수준의 오픈 소스를 찾아보던 중, 비슷한 성능을 가지며 Google이 무료로 제공하고 있는 Gemini 1.5 Flash 버전을 알게 되었습니다. OpenAI가 제공하는 GPT-4와 다르게, 무료임에도 준수한 성능과 많은 토큰 수를 제공하므로 이를 사용하기로 결정했습니다.

- Persistent: **FileManager**
  - 유저 이름과 일기에 대한 데이터를 로컬 저장소에 읽고 쓸 수 있는 기능이 필요했습니다.
  - 현재 데이터 구조가 복잡한 구조를 갖고 있지 않는 단일 데이터 파일들이고, JSON 형식으로 간단하게 읽고 쓰기 위해 FileManager를 선택했습니다.
  
- Media: **AVFoundation**, **Speech**
  - STT(Speech-To-Text)를 구현하는 과정에 Speech 프레임워크를 사용하였습니다. 애플에서 제공하는 프레임워크로써 무료로 사용할 수 있어 용이했으며, 준수한 성능을 갖추고 있었습니다.
  - 음성 입력과 녹음된 오디오 파일의 재생/일시정지/중지 등 오디오 제어를 위해 AVFoundation 프레임워크를 사용했습니다.

- Reactive Programming: **Combine**
  - 데이터 바인딩, 반응형 프로그래밍에 Combine을 활용했습니다.
  - Combine을 통해 간결하고 직관적인 코드 작성이 가능했으며, 유지보수에 용이성을 지닐 수 있었습니다.

- Asynchronous: **Swift Concurrency**
  - 비동기 처리 과정에 Swift Concurrency를 활용했습니다.
  - Concurrency를 활용해 기존의 비동기 처리 방식들보다 더욱 간결하고 안전한 비동기 처리 작업을 수행할 수 있었으며, 명확한 에러 핸들링을 수행할 수 있었습니다.

<br>

### 🗂️ 외부 의존성

- Layout: **SnapKit**
    - 간략한 코드로 가독성과 효율성을 높이기 위해서 SnapKit을 사용하였습니다.
- Lint: **SwiftLint**
    - SwiftLint를 사용하여 코드 컨벤션을 최대한 통일할 수 있도록 하였습니다.
- Animation: **Lottie**
    - 애니메이션을 쉽게 구현하고 관리하기 위해 Lottie를 사용했습니다.

<br>

## 📚 설계도
![설계도1](https://github.com/user-attachments/assets/db469d07-d09b-411d-b273-e372ffea3fad)


<br>

## 팀원 소개

|[S012_김미래](https://github.com/futuremirae)|[S025_박성근](https://github.com/ParkSeongGeun)|[S063_정지용](https://github.com/clxxrlove)|[S074_한상진](https://github.com/Hansangjin98)|
|:---:|:---:|:---:|:---:|
|<img src="https://avatars.githubusercontent.com/u/136614563?v=4" width=150>|<img src="https://avatars.githubusercontent.com/u/117553364?v=4" width=150>|<img src="https://avatars.githubusercontent.com/u/70135292?v=4" width=150>|<img src="https://hackmd.io/_uploads/SyoeWvcuC.png" width=150>|

<br>

<hr>

<br>

### 프로젝트 진행과 관련한 자세한 사항은 [Wiki](https://github.com/boostcampwm-2024/iOS05-Heim/wiki)를 참고해주세요!
