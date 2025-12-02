import Foundation
import UIKit

/// Google Gemini API와의 통신을 담당하는 서비스 클래스입니다.
/// 싱글톤 패턴(Singleton Pattern)을 사용하여 앱 전체에서 하나의 인스턴스만 공유하여 사용합니다.
class GeminiService {
    
    /// 앱 전체에서 공유되는 유일한 인스턴스입니다.
    static let shared = GeminiService()
    
    /// 외부에서 임의로 인스턴스를 생성하지 못하도록 생성자를 private으로 설정합니다.
    private init() {}
    
    /// Gemini API의 기본 URL입니다.
    /// `gemini-2.5-flash` 모델을 사용하여 빠르고 효율적인 응답을 기대합니다.
    private let baseURL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent"
    
    // MARK: - Public Methods
    
    /// 냉장고 사진을 분석하여 식재료 목록을 반환합니다.
    /// - Parameter image: 분석할 냉장고 사진 (UIImage)
    /// - Returns: 감지된 식재료 리스트 ([Ingredient])
    func analyzeImage(image: UIImage) async throws -> [Ingredient] {
        // 1. 이미지를 API 전송 가능한 데이터(JPEG)로 변환합니다.
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw URLError(.badURL) // 적절한 에러 처리 필요
        }
        
        // 2. 이미지를 Base64 문자열로 인코딩합니다. Gemini API는 이미지를 인라인 데이터로 받습니다.
        let base64Image = imageData.base64EncodedString()
        
        // 3. Gemini에게 보낼 프롬프트(명령어)를 작성합니다.
        // JSON 형식으로 정확하게 응답받기 위해 구체적인 지시사항을 포함합니다.
        let prompt = """
        이 사진은 냉장고 내부 사진이야. 사진에 보이는 식재료들을 식별해서 JSON 형식으로 알려줘.
        응답 형식은 다음과 같아야 해:
        [
            {"name": "토마토", "icon": "🍅", "quantity": "2개"},
            {"name": "계란", "icon": "🥚", "quantity": "6구"}
        ]
        다른 말은 하지 말고 오직 JSON 데이터만 반환해.
        """
        
        // 4. API 요청 본문(Body)을 생성합니다.
        let requestBody: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": prompt],
                        [
                            "inline_data": [
                                "mime_type": "image/jpeg",
                                "data": base64Image
                            ]
                        ]
                    ]
                ]
            ]
        ]
        
        return try await sendRequest(body: requestBody, responseType: [Ingredient].self)
        
        // Mock Data 반환 (테스트용 - 필요시 주석 해제하여 사용)
        /*
        try await Task.sleep(nanoseconds: 2 * 1_000_000_000) // 2초 지연 시뮬레이션
        return [
            Ingredient(name: "토마토", icon: "🍅", quantity: "3개"),
            Ingredient(name: "계란", icon: "🥚", quantity: "10구"),
            Ingredient(name: "파프리카", icon: "🫑", quantity: "1개"),
            Ingredient(name: "대파", icon: "🥬", quantity: "1단")
        ]
        */
    }
    
    /// 식재료 목록을 기반으로 요리를 추천받습니다.
    /// - Parameter ingredients: 감지된 식재료 목록
    /// - Returns: 추천 레시피 리스트 ([Recipe])
    func recommendRecipes(ingredients: [Ingredient]) async throws -> [Recipe] {
        // 1. 식재료 이름들을 콤마로 연결하여 문자열로 만듭니다.
        let ingredientNames = ingredients.map { $0.name }.joined(separator: ", ")
        
        // 2. 프롬프트를 작성합니다.
        let prompt = """
        다음 식재료들을 사용하여 만들 수 있는 맛있는 요리 3가지를 추천해줘: \(ingredientNames).
        
        각 요리에 대해 다음 정보를 JSON 형식으로 제공해줘:
        [
          {
            "name": "요리 이름",
            "description": "간단한 설명",
            "ingredients": ["필요한 식재료 목록"],
            "steps": ["요리 순서 1", "요리 순서 2"],
            "time": "예상 소요 시간",
            "difficulty": "난이도 (쉬움/보통/어려움)",
            "imageKeyword": "High quality food photography keyword in English for this dish (e.g., 'delicious tomato pasta food')"
          }
        ]
        
        응답은 오직 JSON 배열만 포함해야 해. 마크다운 포맷팅 없이 순수 JSON 텍스트만 줘.
        """
        
        // 3. API 요청 본문을 생성합니다. (텍스트 전용)
        let requestBody: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": prompt]
                    ]
                ]
            ]
        ]
        
        // 4. 실제 API 호출 (Mock Data 사용)
        return try await sendRequest(body: requestBody, responseType: [Recipe].self)
        
        // Mock Data 반환
        /*
        try await Task.sleep(nanoseconds: 2 * 1_000_000_000)
        return [
            Recipe(name: "토마토 달걀 볶음", description: "초간단 영양 반찬", ingredients: ["토마토", "계란"], steps: ["토마토 썰기", "스크램블 에그 만들기", "함께 볶기"], time: "10분", difficulty: "쉬움"),
            Recipe(name: "파프리카 계란찜", description: "부드러운 식감의 계란찜", ingredients: ["계란", "파프리카"], steps: ["계란 풀기", "파프리카 다지기", "전자레인지 조리"], time: "15분", difficulty: "쉬움"),
            Recipe(name: "대파 라면", description: "해장에 좋은 얼큰한 라면", ingredients: ["대파", "라면"], steps: ["물 끓이기", "라면 넣기", "대파 송송 썰어 넣기"], time: "5분", difficulty: "쉬움")
        ]
        */
    }
    
    // MARK: - Private Helper Methods
    
    /// 실제 HTTP 요청을 보내고 응답을 디코딩하는 공통 메서드입니다.
    enum GeminiError: Error, LocalizedError {
        case badServerResponse(statusCode: Int, body: String)
        case parseError
        case decodeError
        
        var errorDescription: String? {
            switch self {
            case .badServerResponse(let statusCode, let body):
                return "서버 오류 (상태 코드: \(statusCode))\n내용: \(body)"
            case .parseError:
                return "응답 데이터 분석 실패"
            case .decodeError:
                return "데이터 디코딩 실패"
            }
        }
    }

    private func sendRequest<T: Decodable>(body: [String: Any], responseType: T.Type) async throws -> T {
        // 1. URL 생성 (API Key 포함)
        guard let url = URL(string: "\(baseURL)?key=\(Constants.API.geminiKey)") else {
            throw URLError(.badURL)
        }
        
        // 2. URLRequest 설정
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        // 3. 네트워크 통신 수행
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // 4. 응답 상태 코드 확인 (200 OK)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        if httpResponse.statusCode != 200 {
            let errorBody = String(data: data, encoding: .utf8) ?? "No error body"
            print("Gemini API Error: Status \(httpResponse.statusCode), Body: \(errorBody)")
            throw GeminiError.badServerResponse(statusCode: httpResponse.statusCode, body: errorBody)
        }
        
        // 5. Gemini 응답 구조 파싱
        // Gemini는 응답이 중첩된 JSON 구조로 오기 때문에, 실제 데이터(텍스트)를 추출하는 과정이 필요합니다.
        // 여기서는 간략하게 구조체로 매핑하지 않고 Dictionary로 풀어서 텍스트를 꺼냅니다.
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let candidates = json["candidates"] as? [[String: Any]],
              let content = candidates.first?["content"] as? [String: Any],
              let parts = content["parts"] as? [[String: Any]],
              let text = parts.first?["text"] as? String else {
            print("Gemini API Parse Error: Invalid JSON structure")
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Response Body: \(jsonString)")
            }
            throw URLError(.cannotParseResponse)
        }
        
        // 6. 추출한 텍스트(JSON 형태의 문자열)를 실제 데이터 모델로 디코딩
        // Gemini가 가끔 마크다운 코드 블럭(```json ... ```)을 포함해서 줄 때가 있으므로 이를 제거합니다.
        let cleanText = text.replacingOccurrences(of: "```json", with: "")
                            .replacingOccurrences(of: "```", with: "")
                            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let jsonData = cleanText.data(using: .utf8) else {
            throw URLError(.cannotDecodeContentData)
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: jsonData)
    }
}
