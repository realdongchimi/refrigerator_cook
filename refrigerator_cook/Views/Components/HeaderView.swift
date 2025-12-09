import SwiftUI

/// 앱의 상단 헤더를 담당하는 뷰입니다.
/// "냉장고를 부탁해" 타이틀을 표시합니다.
struct HeaderView: View {
    var body: some View {
        HStack {
            Spacer() // 왼쪽 여백 (중앙 정렬용)
            
            // 앱 타이틀 이미지
            // 사용자가 추가한 'headerimg' 에셋 사용
            Image("headerimg")
                .frame(width: 340)
                .scaledToFit()
                .frame(height: 70)
            
            Spacer() // 오른쪽 여백 (중앙 정렬용)
        }
        .padding(.horizontal)
        .padding(.top, 10)
        .padding(.bottom, 10) // 하단 여백 추가
        .background(Color.SoftGreen) // 배경색을 SoftGreen으로 변경 (흰색 텍스트 가독성 확보)
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
            .previewLayout(.sizeThatFits)
    }
}
