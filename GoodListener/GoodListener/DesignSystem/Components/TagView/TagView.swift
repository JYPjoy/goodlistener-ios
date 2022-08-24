//
//  TagCollectionView.swift
//  GoodListener
//
//  Created by cheonsong on 2022/08/11.
//

import UIKit
import RxCocoa
import RxSwift

struct TagList {
    static let ageList = ["10대", "20대", "30대", "40대 이상"]
    static let sexList = ["남자", "여자"]
    static let jobList = ["학생", "직장인", "프리랜서", "취준생", "기타"]
}

class TagView: UIView {
    
    var tagData: [String] = []
    
    var selectedTag: BehaviorRelay<String> = .init(value: "")
    
    var title = UILabel().then {
        $0.text = "제목"
        $0.font = FontManager.shared.notoSansKR(.bold, 16)
        $0.textColor = .f3
    }
    
    lazy var collectionView: UICollectionView = {
        
        let layout = TagCollectionViewLayout()
        layout.scrollDirection = .vertical
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.register(TagCell.self, forCellWithReuseIdentifier: TagCell.identifier)
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    let line = UIView().then {
        $0.backgroundColor = .l2
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(frame: CGRect, data: [String]) {
        self.init(frame: frame)
        self.tagData = data
        
        addSubview(title)
        addSubview(collectionView)
        addSubview(line)
        title.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.left.equalToSuperview().inset(Const.padding)
            $0.height.equalTo(24)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(Const.padding)
            $0.bottom.equalToSuperview().inset(21)
        }
        
        line.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    func calculateCellWidth(index: Int) -> CGFloat {
        let label = UILabel()
        label.text = tagData[index]
        label.font = FontManager.shared.notoSansKR(.bold, 14)
        label.sizeToFit()
        // ✅ 32(여백)
        return label.frame.width + 32
    }
    
    func tagCollectionViewHeight()-> CGFloat {
        let spacing: CGFloat = 8
        var totalCellWidth: CGFloat = Const.padding * 2
        let cellSpacing: CGFloat = 32
        let screenWidth = UIScreen.main.bounds.width
        var height: CGFloat = 113
        
        tagData.forEach { (text) in
            let label = UILabel()
            label.text = text
            label.font = FontManager.shared.notoSansKR(.bold, 14)
            label.sizeToFit()
            totalCellWidth += (label.frame.width + cellSpacing)
            if totalCellWidth + spacing < screenWidth {
                totalCellWidth += spacing
            } else {
                height += (38 + spacing)
                totalCellWidth = Const.padding * 2
            }
        }

        return height
    }

}

extension TagView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.identifier, for: indexPath) as! TagCell
        
        cell.label.text = tagData[indexPath.row]
        tagData[indexPath.row] == selectedTag.value ? cell.configUI(.selected) : cell.configUI(.deselected)
        
        return cell
    }
    
}

extension TagView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.visibleCells.forEach {
            if let cell = $0 as? TagCell {
                cell.configUI(.deselected)
            }
        }
        guard let cell = collectionView.cellForItem(at: indexPath) as? TagCell else { return }
        cell.configUI(.selected)
        self.selectedTag.accept(tagData[indexPath.row])
        
    }
}

extension TagView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = calculateCellWidth(index: indexPath.row)
        
        return CGSize(width: cellWidth, height: 38)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}