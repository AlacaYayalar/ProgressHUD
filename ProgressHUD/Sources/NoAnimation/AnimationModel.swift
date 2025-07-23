
import Foundation

// MARK: - Top Level Models
public struct EnterModel: Codable {
    public var token: String
    public var screen: Int?
    public var screen2: Int?
    public var rScreen: Int?
    public var offer: AuthorizationOfferObject?
    
    enum CodingKeys: String, CodingKey {
        case token, screen, screen2
        case rScreen = "r_screen"
        case offer = "specialize"
    }
}

public struct AuthorizationOfferObject: Codable {
    public var isActive: Bool
    public var data: AuthorizationOfferModel?
    
    enum CodingKeys: String, CodingKey {
        case isActive = "is_active"
        case data
    }
}

// MARK: - Main Data Model
public struct AuthorizationOfferModel: Codable {
    var imageUrl: String
    var title: String
    var subtitle: String
    var benefitTitle: String
    var benefitDescriptions: [String]
    var btnTitle: String
    public var stTitle: String
    public var stSubtitle: String
    var poText: String
    var bzz: Bool?
    var settingsAnimation: String?
    var settingsTitle: String?
    var modalTitle: String?
    var modalText: String?
    var modalIcon: String?
    var modalBtn: String?
    var pushIcon: String?
    var pushTitle: String?
    var pushText: String?
    var homeTitle: String?
    var homeSub: String?
    var homeIcon: String?
    public var scn: ScnModel?
    var objectTwo: ObjectTwo?
    public var gap: Gap?
    var sheet: SheetObject?
    var flow1: Flow1?
    var flow2: Flow2?
    var flow3: Flow3?
    var result3: Result3?
    
    enum CodingKeys: String, CodingKey {
        case imageUrl = "image_url"
        case title, subtitle, bzz, scn, gap, sheet
        case benefitTitle = "benefit_title"
        case benefitDescriptions = "benefit_descriptions"
        case btnTitle = "btn_title"
        case stTitle = "st_title1"
        case stSubtitle = "st_title2"
        case poText = "po_text"
        case settingsAnimation = "settings_anime"
        case settingsTitle = "settings_title"
        case modalTitle = "modal_title"
        case modalText = "modal_text"
        case modalIcon = "modal_icon"
        case modalBtn = "modal_btn"
        case pushIcon = "push_icon"
        case pushTitle = "push_title"
        case pushText = "push_text"
        case homeTitle = "home_title"
        case homeSub = "home_sub"
        case homeIcon = "home_icon"
        case objectTwo = "object_2"
        case flow1, flow2, flow3, result3
    }
}

// MARK: - Nested Models
public struct ScnModel: Codable {
    var title_proc: String?
    var subtitle_proc: String?
    var title_anim_proc: String?
    var subtitle_anim_proc: String?
    var title_compl: String?
    var subtitle_compl: String?
    var title_anim_compl: String?
    var subtitle_anim_compl: String?
    var title_unp: String?
    var subtitle_unp: String?
    var subtitle_unp_paid: String?
    var title_anim_unp: String?
    var subtitle_anim_unp: String?
    var banner_title: String?
    var banner_subtitle: String?
    var banner_icon: String?
    var banner_icon_unp: String?
    var btn: String?
    var anim_scn: String?
    var anim_done: String?
    var anim_scn_unp: String?
    var anim_done_unp: String?
    var rr_title: String?
    var rr_subtitle: String?
    public var push_title: String?
    public var push_content: String?
    var stats: Stats?
    var features: [Features]?
    var title_res_unp: String?
    var alert_settings_text: String?
    var disabled: String?
    var title_on: String?
    
    enum CodingKeys: String, CodingKey {
        case rr_title = "rr_title "
        case rr_subtitle = "rr_subtitle "
        case title_proc, subtitle_proc, title_anim_proc, subtitle_anim_proc, title_compl, subtitle_compl
        case title_anim_compl, subtitle_anim_compl, title_unp, subtitle_unp, subtitle_unp_paid, title_anim_unp, subtitle_anim_unp
        case banner_title, banner_subtitle, banner_icon, banner_icon_unp, btn, anim_scn, anim_done
        case anim_scn_unp, anim_done_unp, push_title, push_content, stats, features
        case title_res_unp
        
        case alert_settings_text
        case disabled
        case title_on
    }
    
    struct Features: Codable {
        var name: String?
        var g_status: String?
        var b_status: String?
    }
    
    struct Stats: Codable {
        var cls: String?
        var statScnIcon5: String?
        var statScnIcon4: String?
        var statBtnSubtitle: String?
        var statScnIcon3: String?
        var statScnCount5: String?
        var statScnIcon2: String?
        var statScnTitle1: String?
        var statImg: String?
        var statScnText5: String?
        var statBtnArrowImg: String?
        var statScnText4: String?
        var statScnCount4: String?
        var statScnText3: String?
        var statScnText2: String?
        var statScnCount3: String?
        var statScnSubtitle1: String?
        var statBtnTitle: String?
        var statScnImg1: String?
        var statScnCount2: String?
    }
}

struct ObjectTwo: Codable {
    let center: Center
    let description: Description
    
    struct Center: Codable {
        var title: String?
        var subtitle: String?
        var footer_text: String?
        var res_color: String?
        var items: [Items]
        
        struct Items: Codable {
            let name: String?
            let res: String?
        }
    }
    
    struct Description: Codable {
        var btn_subtitle_color: String?
        var subtitle: String?
        var items_title: String?
        var title: String?
        var btn_subtitle: String?
        var main_img: String?
        var btn_title: String?
        var items: [String]?
    }
}

public struct Gap: Codable {
    let orderIndex: Int?
    let title: String
    let titleTwo: String
    let titleDeep: String
    let objecs: [Objec]
    
    enum CodingKeys: String, CodingKey {
        case titleTwo = "title_two"
        case orderIndex = "order_index"
        case titleDeep = "title_deep"
        case title, objecs
    }
}

struct Objec: Codable {
    let prgrsTitle: String
    let strigs: [Strig]?
    let messIcon, messTlt: String
    let subMessTlt, subMessTxt: String?
    let messSbtlt: String?
    let messBtn: String
    
    enum CodingKeys: String, CodingKey {
        case prgrsTitle = "prgrs_title"
        case strigs
        case messIcon = "mess_icon"
        case messTlt = "mess_tlt"
        case subMessTlt = "sub_mess_tlt"
        case subMessTxt = "sub_mess_txt"
        case messSbtlt = "mess_sbtlt"
        case messBtn = "mess_btn"
    }
}


struct Strig: Codable {
    let name: String
    let color: String?
}

struct SheetObject: Codable {
    let title_1, title_2, subtitle, status_1, status_2, status_3, status_4: String
    let btn_1, btn_2, inf_1, inf_2, inf_3: String
    let ic_1, ic_2, ic_3, ic_4, ic_5: String
}

// MARK: - --- NEW STRUCTS ADDED ---
struct Flow1: Codable {
    let scr2_img, scr4_blurD, scr2_tl, loading_img_6, scr4_tl_low, loading_img_1: String?
    let loading_subt_2, loading_img_4D, scr3_img, scr2_btn_tl, loading_img_4, loading_img_6D: String?
    let scr1_text_low, scr4_img, loading_subt_1, scr1_tl_low, scr4_blur, loading_tl: String?
    let loading_img_2, scr2_tl_low, scr1_blur, loading_img_5, scr1_blurD, loading_btn_tl: String?
    let scr4_btn_tl, scr4_subt_low, scr2_blurD, scr2_subt_low, loading_subt_3, loading_img_3: String?
    let scr1_img, scr2_blur, loading_img_2D, scr1_subt_low, scr4_tl, scr3_tl: String?
}

struct Flow2: Codable {
    let loading2_Details_text2, det_tl_low, loading2_Details_text3, remov_tl: String?
    let loading2_Details_text4, loading2_subt, fl2_result_tl, loading2_img: String?
    let fl2_result_subt, loading2_Details_img, fl2_result_img, det_btn_tl: String?
    let fl2_result_ok, det_img, fl2_result_tl2, det_subt_low, loading2_tl: String?
    let loading2_Details_text1, det_tl: String?
}

struct Flow3: Codable {
    let fl3_result_img, loading3_details_subt, fl3_purch_box2_tl, fl3_sc2_low_text: String?
    let fl3_sc2_det_img1, fl3_sc2_det_img2, fl3_purch_box2_subt, fl3_result_subt: String?
    let loading3_details_btn, fl3_purch_box1_subt, fl3_purch_btn2, fl3_sc2_tl: String?
    let fl3_top_circle, fl3_purch_text, loading3_subt, loading3_details_tl: String?
    let fl3_purch_subt, fl3_result_img_d, fl3_result_ok, fl3_purch_btn1: String?
    let fl3_sc2_det_text1, loading3_img, fl3_purch_tl, fl3_result_tl: String?
    let fl3_sc2_det_text2, fl3_purch_box1_tl, loading3_tl, fl3_sc2_det_text3: String?
    let fl3_top_circle_act, fl3_top_img, fl3_sc2_btn, fl3_result_tl2, loading3_det_img: String?
}

struct Result3: Codable {
    let result_det_icon, result_det_box2_img, result_det_box3_img, result_tl: String?
    let result_box1_img1, result_box1_img1D, result_det_tl, result_det_box1_img, result_det_box2_tl: String?
    let result_det_box1_tl, result_box2_img1, result_det_box3_tl, result_img: String?
    let result_box1_img2, result_det_subt, result_box1_tl, result_subt, result_box2_tl: String?
    let result_box2_subt: String?
    let result_scan_now: String?
    let result_fixing: String?
}
