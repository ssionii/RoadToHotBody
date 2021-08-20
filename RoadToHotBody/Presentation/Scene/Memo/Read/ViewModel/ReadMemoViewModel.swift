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
        var isUpdated: Observable<Void>?
        var isDeleted: Observable<Void>?
    }
	
    internal var content: Content
    
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

        return Output(text: text, isEditType: isEditType)
    }
}
