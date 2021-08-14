//
//  WriteMemoViewModel.swift
//  RoadToHotBody
//
//  Created by 양시연 on 2021/08/14.
//

import RxSwift
import RxCocoa

class WriteMemoViewModel {
    
    struct Input {
        var confirmButtonClicked: Observable<Void>
        var text: Observable<String?>
    }
    
    struct Output {
        var isSaved: Observable<Bool>
    }
    
    private let saveDetailContentUseCase = SaveDetailContentUseCase(repository: DetailContentRepository(dataSource: DetailContentDataSource()))
    
    private var muscle: Muscle
    
    init(muscle: Muscle) {
        self.muscle = muscle
    }
    
    func transform(input: Input) -> Output {
        let isSaved = input.confirmButtonClicked
            .withLatestFrom(input.text)
            .compactMap { $0 }
            .flatMap({ text -> Observable<SaveDetailContentUseCaseModels.Response> in
                self.saveDetailContentUseCase.execute(
                    request: SaveDetailContentUseCaseModels.Request(type: .Memo, text: text, muscleIndex: self.muscle.index)
                )
            })
            .map { response -> Bool in
                return response.isSuccess
            }
        
        return Output(isSaved: isSaved)
    }
}
