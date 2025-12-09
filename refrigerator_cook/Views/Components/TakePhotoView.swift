import SwiftUI

/// 사진 촬영 및 업로드 기능을 제공하는 뷰입니다.
/// 냉장고 캐릭터 이미지와 두 개의 버튼(촬영, 업로드)으로 구성됩니다.
struct TakePhotoView: View {
    /// 카메라 뷰 표시 여부 바인딩
    @Binding var showCamera: Bool
    
    /// 사진 보관함 표시 여부 바인딩
    @Binding var showPhotoPicker: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            // 1. 냉장고 캐릭터 이미지
            // (이미지 생성 실패로 인해 사용자가 직접 Assets에 'fridge_character' 이미지를 추가해야 함)
            Image("fridge_character")
                .resizable()
                .scaledToFit()
                .frame(height: 120) // 목업에 맞춰 적절한 크기 설정
                .padding(.top, 20)
            
            // 2. 버튼 영역
            HStack(spacing: 15) {
                // 냉장고 촬영 버튼
                Button(action: {
                    showCamera = true
                }) {
                    HStack {
                        Image(systemName: "camera.fill")
                        Text(Constants.UI.cameraButtonTitle)
                    }
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        LinearGradient(
                            colors: [Color.SoftOrange, Color.orange],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .cornerRadius(25)
                    .shadow(color: Color.SoftOrange.opacity(0.5), radius: 5, x: 0, y: 3)
                }
                
                // 사진 업로드 버튼
                Button(action: {
                    showPhotoPicker = true
                }) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text(Constants.UI.uploadButtonTitle)
                    }
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        LinearGradient(
                            colors: [Color.SoftGreen, Color.green.opacity(0.6)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .cornerRadius(25)
                    .shadow(color: Color.SoftGreen.opacity(0.5), radius: 5, x: 0, y: 3)
                }
            }
            .padding(.horizontal, 30) // 좌우 여백
            .padding(.bottom, 20)
        }
        .background(Color.white) // 전체 배경 흰색
        .cornerRadius(20) // 뷰 자체의 둥근 모서리 (필요 시)
        // 그림자는 HomeView에서 컨테이너에 적용하거나 여기서 적용
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        .padding(.horizontal, 20) // 전체 뷰의 좌우 여백
    }
}

struct TakePhotoView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.Cream.ignoresSafeArea()
            TakePhotoView(showCamera: .constant(false), showPhotoPicker: .constant(false))
        }
    }
}
