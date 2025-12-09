import SwiftUI
import UIKit

/// SwiftUI에서 UIImagePickerController를 사용하기 위한 래퍼 뷰입니다.
/// 카메라 촬영 및 앨범에서 사진 선택 기능을 제공합니다.
struct ImagePicker: UIViewControllerRepresentable {
    /// 선택된 이미지를 바인딩으로 전달
    @Binding var image: UIImage?
    
    /// ImagePicker 화면 닫기 위한 환경 변수
    @Environment(\.presentationMode) var presentationMode
    
    /// 이미지 소스 타입 (카메라 또는 앨범)
    var sourceType: UIImagePickerController.SourceType
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        // 시뮬레이터에서 카메라 사용 불가 시 앨범으로 대체하는 로직은 호출하는 쪽에서 처리하거나 여기서 안전하게 처리
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            picker.sourceType = sourceType
        } else {
            picker.sourceType = .photoLibrary // fallback
        }
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        // 뷰 업데이트 시 특별한 동작 없음
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    /// UIImagePickerControllerDelegate 처리를 위한 코디네이터 클래스
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
