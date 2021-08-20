//
//  ReadMemoViewModel.swift
//  RoadToHotBody
//
//  Created by 양시연 on 2021/08/14.
//

import RxSwift
import RxCocoa

class ReadMemoViewModel {
    
    struct Input {
        var confirmButtonClicked: Observable<Void>
        var deleteButtonClicked: Observable<Void>
        var text: Observable<String?>
    }
    
    struct Output {
        var text: Driver<String>?
        var isEditType: Observable<Void>
        var isUpdated: Observable<Void>
        var isDeleted: Observable<Void>
    }
    
    private let updateDetailContentUseCase = UpdateDetailContentUseCase(repository: DetailContentRepository(dataSource: TrainingDetailInternalDB()))
    private let deleteDetailContentUseCase = DeleteDetailContentUseCase(repository: DetailContentRepository(dataSource: TrainingDetailInternalDB()))
    private let updateRecordUseCase = UpdateRecordUseCase(repository: RecordRepository(dataSource: RecordInternalDB()))
	
    private var content: Content
    
    init(content: Content) {
        self.content = content
    }
    
    func transform(input: Input) -> Output {
        
        let text = Observable.of(self.content)
            .compactMap { $0 }
            .map { content -> String? in
                content.text
            }
            .compactMap { $0 }
            .asDriver(onErrorJustReturn: "")
        
        let isEditType = input.text
            .skip(1)
            .take(1)
            .map { _ -> Void in
                return ()
            }
		
        let isUpdated = input.confirmButtonClicked
            .withLatestFrom(input.text)
            .compactMap { $0 }
            .flatMap { text -> Observable<UpdateDetailContentUseCaseModels.Response> in
                self.updateDetailContentUseCase.execute(
                    request: UpdateDetailContentUseCaseModels.Request(
                        index: self.content.index,
                        text: text
                    )
                )
            }
            .map { response -> Void in
                return ()
            }
        
        let isDeleted = input.deleteButtonClicked
            .flatMap { _ -> Observable<DeleteDetailContentUseCaseModels.Response> in
                self.deleteDetailContentUseCase.execute(
                    request: DeleteDetailContentUseCaseModels.Request(index: self.content.index)
                )
            }
            .map { response -> Void in
                return ()
            }

        return Output(text: text, isEditType: isEditType, isUpdated: isUpdated, isDeleted: isDeleted)
    }
}
