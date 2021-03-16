//
//  SliderTvCell.swift
//  LinkerApp
//
//  Created by Thanh Minh on 3/15/21.
//  Copyright © 2021 Thanh Minh. All rights reserved.
//

import UIKit

protocol SliderTvCellDelegate {
    func didHandleSlideChange(slider: UISlider)
}

class SliderTvCell: UITableViewCell {
    var delegate: SliderTvCellDelegate?
    var ageRanges: [String : Any]? {
        didSet{
            setAgeRanges()
        }
    }
    
    var minAge: Float?
    var maxAge: Float?
    var maxValue: Int?
    
    let minLabel: UILabel = {
        let lbl = AgeRangeLabel()
        lbl.text = "Min Age: 18"
        return lbl
    }()
    
    let maxLabel: UILabel = {
        let lbl = AgeRangeLabel()
        lbl.text = "Max Age: 62"
        return lbl
    }()
    
    class AgeRangeLabel: UILabel {
        override var intrinsicContentSize: CGSize {
            return .init(width: 44, height: 0)
        }
    }
    
    lazy var minSlider: UISlider = {
        let sld = UISlider()
        sld.minimumValue = 18
        sld.maximumValue = 65
        sld.tintColor = UIColor.green
        sld.tag = 1
        sld.addTarget(self, action: #selector(handleSlideChange(_:)), for: .valueChanged)
        return sld
    }()
    
    lazy var maxSlider: UISlider = {
        let sld = UISlider()
        sld.minimumValue = 18
        sld.maximumValue = 65
        sld.tintColor = UIColor.green
        sld.tag = 2
        sld.addTarget(self, action: #selector(handleSlideChange(_:)), for: .valueChanged)
        return sld
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        let minStackView = UIStackView(arrangedSubviews: [minLabel, minSlider])
        minStackView.spacing = 16
        let maxStackView = UIStackView(arrangedSubviews: [maxLabel, maxSlider])
        let overallStackView = UIStackView(arrangedSubviews: [minStackView, maxStackView])
        maxStackView.spacing = 16
        overallStackView.axis = .vertical
        overallStackView.spacing = 16
        addSubview(overallStackView)
        overallStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 16, left: 16, bottom: 16, right: 16))
    }
    
    @objc func handleSlideChange(_ slider: UISlider){
        if(slider.tag == 1){
            minAge = slider.value
        } else {
            maxAge = slider.value
        }
        
        maxValue = max(Int(minAge ?? 18.0), (Int(maxAge ?? 65.0)))
        maxSlider.value = Float(maxValue ?? 65)
        minLabel.text = "Min: \(Int(minAge ?? 18.0))"
        maxLabel.text = "Max: \(Int(maxAge ?? 65.0))"
        
        delegate?.didHandleSlideChange(slider: slider)
    }
    
    func setAgeRanges(){
        minSlider.value = ageRanges?["minAge"] as? Float ?? 18.0
        minLabel.text = "Min: \(minSlider.value)"
        maxSlider.value = ageRanges?["maxAge"] as? Float ?? 65.0
        maxLabel.text = "Max: \(maxSlider.value)"
    }
}
