//
//  PagingView.swift
//  Mobislet
//
//  Created by Ahmet KÖRÜK on 15/03/16.
//  Copyright © 2016 akoruk. All rights reserved.
//

import UIKit

@objc protocol PagingViewDelegate {
    optional func pagingView(pagingView pagingView: PagingView, selectedIndex index:Int)
    optional func pagingView(pagingView pagingView: PagingView, pressedLikeButtonItemAtIndex index:Int)
}

class PagingView: UIView, PagedReusableScrollViewDataSource {
    
    var delegate: PagingViewDelegate?
    
    private var title: String = ""
    
    private var headingLabel: UILabel!
    private var scrollView: PagedReusableScrollView!
    var loadingView : MAActivityIndicatorView?

    
    private var _datas = [Mobitem]() {
        didSet {
            if scrollView != nil {
                scrollView.reload()
                loadingView?.stopAnimating()
            }
        }
    }

    var datas: [Mobitem] {
        return _datas
    }
    
    private var headingLabelTopMargin: CGFloat = 20.0
    private var headingLabelHeight: CGFloat = 35.0
    private var headingLabelBottomMargin: CGFloat = 20.0
    
    private var scrollTopMargin: CGFloat {
        get {
            return headingLabelTopMargin + headingLabelHeight + headingLabelBottomMargin
        }
    }
    
    private var labelsHeight: CGFloat {
        get {
            return labelsTopMargin + mainTitleHeight + labelsBottomMargin
        }
        
    }
    
    
    private var scrollBottomMargin: CGFloat = 10.0
    private var scrollHorizontalMargin: CGFloat = 10.0
    private var pageInBetweenOffset: CGFloat = 2.0
    private var labelsOffset: CGFloat = 5.0
    
    private var mainTitleHeight:CGFloat = 40.0
    private var titleHeight:CGFloat = 25.0
    private var subTitleHeight:CGFloat = 20.0
    
    private var labelsTopMargin:CGFloat = 3.0
    private var labelsBottomMargin:CGFloat = 4.0
    
    
    private var itemDetailsLabelHeight:CGFloat = 80.0
    private var itemDetailsBackgroundHeight:CGFloat = 100.0
    private var itemDetailsMargin:CGFloat = 10.0
    
    private var itemSubDetailsLabelHeight:CGFloat = 25.0
    private var itemSubDetailsLabelWidth:CGFloat = 60.0
    
    private var likeImageWidth:CGFloat = 50.0
    
    private var roundedImageRadius:CGFloat = 30.0
    
    private var scrollImageCornerRadius:CGFloat = 2.0
    private var roundedImageBorderRadius:CGFloat = 2.0
    
    
    private var loadingViewHeight:CGFloat = 30.0

    
    // Check here for every variables
    private var scaleParameter: CGFloat = 1.0 {
        didSet {
            
            headingLabelTopMargin *= scaleParameter
            headingLabelHeight *= scaleParameter
            headingLabelBottomMargin *= scaleParameter
            
            scrollBottomMargin *= scaleParameter
            scrollHorizontalMargin *= scaleParameter
            pageInBetweenOffset *= scaleParameter
            labelsOffset *= scaleParameter
            
            mainTitleHeight *= scaleParameter
            titleHeight *= scaleParameter
            subTitleHeight *= scaleParameter
            
            labelsTopMargin *= scaleParameter
            labelsBottomMargin *= scaleParameter
            
            itemDetailsLabelHeight *= scaleParameter
            itemDetailsBackgroundHeight *= scaleParameter
            itemDetailsMargin *= scaleParameter
            
            itemSubDetailsLabelHeight *= scaleParameter
            itemSubDetailsLabelWidth *= scaleParameter
            
            likeImageWidth *= scaleParameter
            
            
            roundedImageRadius *= scaleParameter
            
            scrollImageCornerRadius *= scaleParameter
            roundedImageBorderRadius *= scaleParameter

            
            loadingViewHeight *= scaleParameter

        }
    }
    
    
    convenience init(frame: CGRect, title: String, backgroundColor: UIColor) {
        self.init(frame: frame)
        
        self.backgroundColor = backgroundColor
        self.title = title
        
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = CONSTANTS.colorAppBackground
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setData(datas: [Mobitem]) {
            self._datas = datas
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        scaleParameter = UTILS.scaleFactor
        
        let width = self.bounds.width
        let height = self.bounds.height
        
        
        scrollView = PagedReusableScrollView(frame: CGRectMake(self.scrollHorizontalMargin, self.scrollTopMargin, width - 2*self.scrollHorizontalMargin, height - self.scrollTopMargin - self.scrollBottomMargin))
        
        headingLabel = UILabel(frame: CGRectMake(self.scrollHorizontalMargin + self.labelsOffset, self.headingLabelTopMargin ,width - 2*self.scrollHorizontalMargin, self.headingLabelHeight))
        headingLabel.text = self.title
        headingLabel.font = CONSTANTS.fontHeading
        headingLabel.textColor = CONSTANTS.colorHeadingGray
        headingLabel.adjustsFontSizeToFitWidth = true
        headingLabel.minimumScaleFactor = 0.5
        
        
        
        self.addSubview(scrollView)
        self.addSubview(headingLabel)
        
        let topLine: UIView = UIView(frame: CGRectMake(0.0, 0.0, width, 1.0))
        topLine.backgroundColor = CONSTANTS.colorAppDarkerBackground
        
        let bottomLine: UIView = UIView(frame: CGRectMake(0.0, height-1.0, width, 1.0))
        bottomLine.backgroundColor = CONSTANTS.colorAppDarkerBackground
        
        self.addSubview(topLine)
        self.addSubview(bottomLine)
        
        
        
        
        self.loadingView = MAActivityIndicatorView(frame: CGRectMake(self.scrollHorizontalMargin, self.scrollTopMargin + self.scrollView.frame.height / 2 , width - 2*self.scrollHorizontalMargin, self.loadingViewHeight))
        self.loadingView?.startAnimating()
        self.loadingView?.style = IndicatorViewType.Small
        self.addSubview(self.loadingView!)
        

        
        
        scrollView.dataSource = self
    }
    
    // MARK: - Paged Reusable ScrollView
    func scrollView(scrollView: PagedReusableScrollView, viewIndex index: Int) -> ScrollViewPageProvider {
        
        let item = datas[index]
        
        let scrollWidth = scrollView.frame.width - 2*self.pageInBetweenOffset
        let scrollHeigth = scrollView.frame.height
        
        var newView = scrollView.dequeueReusableView(tag: item.mobitemType.rawValue)
        
        if newView == nil {
            switch item.mobitemType {
                
            case .Default:
                
                let imgView = UIImageView(frame: CGRectMake(self.pageInBetweenOffset, 0.0, scrollWidth, scrollHeigth - labelsHeight))
                imgView.contentMode = .ScaleAspectFill
                imgView.layer.cornerRadius = self.scrollImageCornerRadius
                imgView.clipsToBounds = true
                
                let mainTitle = UILabel(frame: CGRectMake(self.labelsOffset, imgView.frame.height + labelsTopMargin , scrollWidth, mainTitleHeight))
                mainTitle.font  = CONSTANTS.fontMainTitle
                mainTitle.textColor = CONSTANTS.colorMainTitleGray
                mainTitle.adjustsFontSizeToFitWidth = true
                mainTitle.minimumScaleFactor = 0.7
                
                newView = ScrollViewPageProvider()

                newView?.mainImageView = imgView
                newView?.mainTitleLabel = mainTitle
                
            case .Campaign:
                
                let imgView = UIImageView(frame: CGRectMake(self.pageInBetweenOffset, 0.0, scrollWidth, scrollHeigth - self.labelsHeight))
                imgView.contentMode = .ScaleAspectFill
                imgView.layer.cornerRadius = self.scrollImageCornerRadius
                imgView.clipsToBounds = true
                
                let mainTitle = UILabel(frame: CGRectMake(self.labelsOffset, imgView.frame.height + self.labelsTopMargin , scrollWidth - 7*self.scrollHorizontalMargin, self.mainTitleHeight))
                mainTitle.font  = CONSTANTS.fontMainTitle
                mainTitle.textColor = CONSTANTS.colorMainTitleGray
                mainTitle.adjustsFontSizeToFitWidth = true
                mainTitle.minimumScaleFactor = 0.7
                
                let itemDetailBackgroundView = UIView(frame: CGRectMake(self.scrollHorizontalMargin, (scrollHeigth - self.labelsHeight)/2 + self.itemDetailsMargin, scrollWidth - 2*self.scrollHorizontalMargin, self.itemDetailsBackgroundHeight))
                itemDetailBackgroundView.backgroundColor = CONSTANTS.colorPagingViewCampaignDetailBackground
                
                let itemDetailsLabel = UILabel(frame: CGRectMake(self.itemDetailsMargin, self.itemDetailsMargin,  scrollWidth - 2*self.scrollHorizontalMargin - 2*self.itemDetailsMargin, self.itemDetailsLabelHeight))
                itemDetailsLabel.font  = CONSTANTS.fontPagingCampaignDetails
                itemDetailsLabel.textColor = CONSTANTS.colorPagingViewCampaignDetails
                itemDetailsLabel.numberOfLines = 5
                itemDetailsLabel.adjustsFontSizeToFitWidth = true
                itemDetailsLabel.minimumScaleFactor = 0.5
                
                itemDetailBackgroundView.addSubview(itemDetailsLabel)
                
                
                let itemCategory = RoundedImageView(frame: CGRectMake(imgView.frame.width - 2*self.roundedImageRadius - self.itemDetailsMargin, imgView.frame.height - self.roundedImageRadius, 2*self.roundedImageRadius, 2*self.roundedImageRadius))
                
                itemCategory.cornerRadius = self.roundedImageRadius
                itemCategory.clipsToBounds = true
                
                itemCategory.layer.borderColor = CONSTANTS.colorPagingViewCampaignCategoryBorder.CGColor
                
                
                let itemSubDetails = UILabel(frame: CGRectMake(self.itemDetailsMargin, self.itemDetailsMargin, self.itemSubDetailsLabelWidth, self.itemSubDetailsLabelHeight))
                itemSubDetails.textAlignment = .Center
                itemSubDetails.layer.cornerRadius = self.scrollImageCornerRadius
                itemSubDetails.clipsToBounds = true
                itemSubDetails.font  = CONSTANTS.fontPagingCampaignSubDetails
                itemSubDetails.textColor = CONSTANTS.colorPagingViewCampaignDetails
                itemSubDetails.backgroundColor = CONSTANTS.colorPagingViewCampaignSubDetailBackground
                itemSubDetails.adjustsFontSizeToFitWidth = true
                itemSubDetails.minimumScaleFactor = 0.7
                
                let likeButton = UIButton(frame: CGRectMake(imgView.frame.width - self.itemDetailsMargin - self.itemSubDetailsLabelWidth, self.itemDetailsMargin, self.likeImageWidth, self.likeImageWidth))
                
                newView = ScrollViewPageProvider()

                newView?.mainImageView = imgView
                newView?.mainTitleLabel = mainTitle
                newView?.itemDetailsBackgroundView = itemDetailBackgroundView
                newView?.itemDetailsLabel = itemDetailsLabel
                newView?.itemSubDetailsLabel = itemSubDetails
                newView?.roundedImageView = itemCategory
                newView?.likeButton = likeButton
                
            case .Store:
                
                let imgView = UIImageView(frame: CGRectMake(self.pageInBetweenOffset, 0.0, scrollWidth, scrollHeigth - self.labelsHeight))
                imgView.contentMode = .ScaleAspectFill
                imgView.layer.cornerRadius = self.scrollImageCornerRadius
                imgView.clipsToBounds = true
                
                let title = UILabel(frame: CGRectMake(self.labelsOffset, imgView.frame.height + self.labelsTopMargin , scrollWidth - 2*self.scrollHorizontalMargin, self.titleHeight))
                title.font  = CONSTANTS.fontTitle
                title.textColor = CONSTANTS.colorTitleGray
                title.adjustsFontSizeToFitWidth = true
                title.minimumScaleFactor = 0.7
                
                let subTitle = UILabel(frame: CGRectMake(self.labelsOffset, imgView.frame.height + labelsTopMargin + title.frame.height , scrollWidth - 2*self.scrollHorizontalMargin, self.subTitleHeight))
                subTitle.font  = CONSTANTS.fontSubtitle
                subTitle.textColor = CONSTANTS.colorSubtitleGray
                subTitle.adjustsFontSizeToFitWidth = true
                subTitle.minimumScaleFactor = 0.7
                
                
                let itemSubDetails = UILabel(frame: CGRectMake(self.itemDetailsMargin, self.itemDetailsMargin, self.itemSubDetailsLabelWidth, self.itemSubDetailsLabelHeight))
                itemSubDetails.textAlignment = .Center
                itemSubDetails.layer.cornerRadius = self.scrollImageCornerRadius
                itemSubDetails.clipsToBounds = true
                itemSubDetails.font  = CONSTANTS.fontPagingCampaignSubDetails
                itemSubDetails.textColor = CONSTANTS.colorPagingViewCampaignDetails
                itemSubDetails.backgroundColor = CONSTANTS.colorPagingViewCampaignSubDetailBackground
                itemSubDetails.adjustsFontSizeToFitWidth = true
                itemSubDetails.minimumScaleFactor = 0.7
                
                let likeButton = UIButton(frame: CGRectMake(imgView.frame.width - self.itemDetailsMargin - self.itemSubDetailsLabelWidth, self.itemDetailsMargin, self.likeImageWidth, self.likeImageWidth))
                
                newView = ScrollViewPageProvider()
                
                newView?.mainImageView = imgView
                newView?.titleLabel = title
                newView?.subTitleLabel = subTitle
                newView?.itemSubDetailsLabel = itemSubDetails
                newView?.likeButton = likeButton
           
            case .Mall:
                
                let imgView = UIImageView(frame: CGRectMake(self.pageInBetweenOffset, 0.0, scrollWidth, scrollHeigth - self.labelsHeight))
                imgView.contentMode = .ScaleAspectFill
                imgView.layer.cornerRadius = self.scrollImageCornerRadius
                imgView.clipsToBounds = true
                
                let mainTitle = UILabel(frame: CGRectMake(self.labelsOffset, imgView.frame.height + self.labelsTopMargin , scrollWidth - 2*self.scrollHorizontalMargin, self.mainTitleHeight))
                mainTitle.font  = CONSTANTS.fontMainTitle
                mainTitle.textColor = CONSTANTS.colorMainTitleGray
                mainTitle.adjustsFontSizeToFitWidth = true
                mainTitle.minimumScaleFactor = 0.7
                
                let likeButton = UIButton(frame: CGRectMake(imgView.frame.width - self.itemDetailsMargin - self.itemSubDetailsLabelWidth, self.itemDetailsMargin, self.likeImageWidth, self.likeImageWidth))
                
                newView = ScrollViewPageProvider()
                
                newView?.mainImageView = imgView
                newView?.mainTitleLabel = mainTitle
                newView?.likeButton = likeButton
                
            }
            
            newView?.tag = item.mobitemType.rawValue
        }
        
        newView?.configureView(datas[index])
        return newView!
    }
    
    func numberOfViews(forScrollView scrollView: PagedReusableScrollView) -> Int {
        return datas.count
    }
    
    func scrollView(scrollView scrollView: PagedReusableScrollView, selectedIndex index:Int) {
        if datas.count > 0 {
            self.delegate?.pagingView?(pagingView: self, selectedIndex: index)
        }
    }
    
    func scrollView(scrollView scrollView: PagedReusableScrollView, didHideView view: ScrollViewPageProvider) {

        view.cancelRequests()
        print("\(view.getDescription()) is not visible anymore")
    }
    
}
