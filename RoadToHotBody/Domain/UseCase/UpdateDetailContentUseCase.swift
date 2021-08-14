//
//  UpdateDetailContentUseCase.swift
//  RoadToHotBody
//
//  Created by 양시연 on 2021/08/14.
//

import RxSwift

protocol UpdateDetailContentUseCaseProtocol {
    func execute(
        request: UpdateDetailContentUseCaseModels.Request
    ) -> Observable<UpdateDetailContentUseCaseModels.Response>
}

struct UpdateDetailContentUseCaseModels {
    struct Request {
        var index: Int
        var text: String
    }
    
    struct Response {
        var isSuccess: Bool
    }
}

class UpdateDetailContentUseCase: UpdateDetailContentUseCaseProtocol {
    
    private let detailContentRepository: DetailContentRepositoryProtocol
    
    init(repository: DetailContentRepositoryProtocol) {
        self.detailContentRepository = repository
    }
    
    func execute(request: UpdateDetailContentUseCaseModels.Request) -> Observable<UpdateDetailContentUseCaseModels.Response> {
        return detailContentRepository.updateDetailContent(request: request)
    }
}
