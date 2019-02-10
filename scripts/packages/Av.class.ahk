; ==========================================================
; Av.class.ahk  AV管理
;
; 文档作者: 烈焰
;
; 修改时间: 2018-02-21 01:52:26
; ==========================================================

; class Av
; ==========================================================
class Av {
    static testTag := "Av"
; ----------------------------------------------------------
; 单元测试 public static test()
; ----------------------------------------------------------
    test(){
        Test.eq("Av.rename(...) 收藏夹重命名(演员) == true"
            , "#av女优# ★ 有村千佳 1900-00-00 (备注) " . Sys.date() . " - 演員 - 影片 - AVMOO"
            , Av.rename("有村千佳 - 演員 - 影片 - AVMOO")
            , Av.testTag)
        Test.eq("Av.rename(...) 收藏夹重命名(演员) == true"
            , "#av导演# ★ 石井 (备注) " . Sys.date() . " - 導演 - 影片 - AVMOO"
            , Av.rename("石井 - 導演 - 影片 - AVMOO")
            , Av.testTag)
        Test.eq("Av.rename(...) 收藏夹重命名(制作商) == true"
            , "#av制作商# ★ ジャネス (备注) " . Sys.date() . " - 製作商 - 影片 - AVMOO"
            , Av.rename("ジャネス - 製作商 - 影片 - AVMOO")
            , Av.testTag)
        Test.eq("Av.rename(...) 收藏夹重命名(发行商) == true"
            , "#av发行商# ★ MANIA Play (备注) " . Sys.date() . " - 發行商 - 影片 - AVMOO"
            , Av.rename("MANIA Play - 發行商 - 影片 - AVMOO")
            , Av.testTag)
        Test.eq("Av.rename(...) 收藏夹重命名(系列) == true"
            , "#av系列# ★ 濃厚射精と男の潮吹き (备注) " . Sys.date() . " - 系列 - 影片 - AVMOO"
            , Av.rename("濃厚射精と男の潮吹き - 系列 - 影片 - AVMOO")
            , Av.testTag)
        Test.eq("Av.rename(...) 收藏夹重命名(类别) == true"
            , "#av类别# ★ 內衣 (备注) " . Sys.date() . " - 類別 - 影片 - AVMOO"
            , Av.rename("內衣 - 類別 - 影片 - AVMOO")
            , Av.testTag)
        Test.eq("Av.rename(...) 收藏夹重命名(搜索) == true"
            , "#av搜索# ★ 小川 (备注) " . Sys.date() . " - AVMOO"
            , Av.rename("小川 - AVMOO")
            , Av.testTag)
        Test.eq("Av.rename(...) 收藏夹重命名(作品) == true"
            , "#av作品# ★★ GXAZ-043 凄腕テクでイカされる濃厚射精と男 (备注) " . Sys.date() . " - AVMOO"
            , Av.rename("GXAZ-043 凄腕テクでイカされる濃厚射精と男の潮吹き - AVMOO")
            , Av.testTag)
        Test.eq("Av.rename(...) 收藏夹重命名(作品含女优名) == true"
            , "#av作品# ★★ GXAZ-043 凄腕テクでイカされる濃厚射精と男 小早川怜子 (备注) " . Sys.date() . " - AVMOO"
            , Av.rename("GXAZ-043 凄腕テクでイカされる濃厚射精と男の潮吹き 小早川怜子 - AVMOO")
            , Av.testTag)
        Test.eq("Av.rename(...) 收藏夹重命名(作品含女优名_标题含空格) == true"
            , "#av作品# ★★ GXAZ-043 凄腕テクでイカされる_濃厚_射精 小早川怜子 (备注) " . Sys.date() . " - AVMOO"
            , Av.rename("GXAZ-043 凄腕テクでイカされる 濃厚 射精と男の潮吹き 小早川怜子 - AVMOO")
            , Av.testTag)
        Test.eq("Av.rename(...) Av有码作品重命名 == true"
            , "#av作品# ★★ GXAZ-043 凄腕テクでイカされる濃厚射精と男 (备注)"
            , Av.rename("GXAZ-043 凄腕テクでイカされる濃厚射精と男の潮吹き")
            , Av.testTag)
        Test.eq("Av.rename(...) Av有码作品重命名(含女优名) == true"
            , "#av作品# ★★ GXAZ-043 凄腕テクでイカされる濃厚射精と男 小早川怜子 (备注)"
            , Av.rename("GXAZ-043 凄腕テクでイカされる濃厚射精と男の潮吹き 小早川怜子")
            , Av.testTag)
        Test.eq("Av.rename(...) Av无码作品重命名(加勒比 Carib-042416-144) == true"
            , "#av作品# ★ Carib-042416-144 最新加勒比-隔壁的妻子的 辻本りょう (备注)"
            , Av.rename("Carib-042416-144 最新加勒比-隔壁的妻子的 辻本りょう")
            , Av.testTag)
        Test.eq("Av.rename(...) Av无码作品重命名(加勒比 Carib-042416_144) == true"
            , "#av作品# ★ Carib-042416_144 最新加勒比-隔壁的妻子的 辻本りょう (备注)"
            , Av.rename("Carib-042416_144 最新加勒比-隔壁的妻子的 辻本りょう")
            , Av.testTag)
        Test.eq("Av.rename(...) Av无码作品重命名(加勒比 Cappv-042416-144) == true"
            , "#av作品# ★ Cappv-042416-144 最新加勒比-隔壁的妻子的 辻本りょう (备注)"
            , Av.rename("Cappv-042416-144 最新加勒比-隔壁的妻子的 辻本りょう")
            , Av.testTag)
        Test.eq("Av.rename(...) Av无码作品重命名(加勒比 Cappv-042416_144) == true"
            , "#av作品# ★ Cappv-042416_144 最新加勒比-隔壁的妻子的 辻本りょう (备注)"
            , Av.rename("Cappv-042416_144 最新加勒比-隔壁的妻子的 辻本りょう")
            , Av.testTag)
        Test.eq("Av.rename(...) Av无码作品重命名(一本道 1pondo-030615_039) == true"
            , "#av作品# ★ 1pondo-030615_039 一本道巨乳愛好者 秋野千尋 (备注)"
            , Av.rename("1pondo-030615_039 一本道巨乳愛好者 秋野千尋")
            , Av.testTag)
        Test.eq("Av.rename(...) Av无码作品重命名(一本道 1pon-030615_039) == true"
            , "#av作品# ★ 1pon-030615_039 一本道巨乳愛好者 秋野千尋 (备注)"
            , Av.rename("1pon-030615_039 一本道巨乳愛好者 秋野千尋")
            , Av.testTag)
        Test.eq("Av.rename(...) Av无码作品重命名(一本道 1pon-030615_039)(标题下划线替换空格) == true"
            , "#av作品# ★ 1pon-030615_039 一本道_巨乳_愛好者 秋野千尋 (备注)"
            , Av.rename("1pon-030615_039 一本道 巨乳 愛好者 秋野千尋")
            , Av.testTag)
    }

    ; ----------------------------------------------------------
    ; static rename(_avTitle)
    ; ----------------------------------------------------------
    rename(_avTitle){
        ; 输出结果
        _result := ""
        ; ----------------------------------------------------------
        ; 按类别对av标题或收藏名, 进行修改, 重新命名
        ; ----------------------------------------------------------
        if(_avTitle ~= "\s{1,2}-\s{1,2}\w{2,6}$"){
            ; 如果类似收藏夹的范围, 判断收藏名称格式是否匹配
            _result := Av.rename_收藏夹(_avTitle)
        }
        else if(_avTitle ~= "(?:^#av)"){
            ; 对已格式化内容, 仅对日期进行格式化
            ; 有待进一步增加功能
            重命名 := new dateRenamer(_avTitle)
            _result := 重命名.do()
            show_msg("已格式化内容, 不需要操作!")
        }
        else if(_avTitle ~= "i)(?:Heyzo|1pon|Carib|Cappv|一本道|加勒比|东京热)"){
            ; 对无码av作品, 比如一本道, 加勒比等, 修改收藏名
            重命名 := new Av无码作品重命名(_avTitle)
            _result := 重命名.do()
        }
        else if(_avTitle ~= "(?:^([A-Za-z]\w{1,5}-\d{2,6})\s)"){
            ; 对有码av作品, 修改收藏名
            重命名 := new Av有码作品重命名(_avTitle)
            _result := 重命名.do()
        }
        else{
            ; 不匹配, 恢复原状, 且进行提示
            _result := _avTitle
            show_msg("_avTitle不匹配, 不能进行格式化重命名!")
        }
        ; end
        return _result
    }
    ; ----------------------------------------------------------
    ; static rename_收藏夹(_avTitle)
    ; ----------------------------------------------------------
    rename_收藏夹(_avTitle){
        ; 基本入口数据
        _收藏名称 := _avTitle
        _收藏类别 := ""
        ; 检测数据
        _av收藏命名结构匹配 := "(.*?)\s{1,2}-\s{1,2}(.*?)\s{1,2}-\s{1,2}(.*?)\s{1,2}-\s{1,2}(.*)"
        ; 输出结果
        _result := ""
        ; ----------------------------------------------------------
        ; 按类别对av标题或收藏名, 进行修改, 重新命名
        ; ----------------------------------------------------------
        ; 如果类似收藏夹的范围, 判断收藏名称格式是否匹配
        if(RegExMatch(_收藏名称, _av收藏命名结构匹配, _匹配收藏名称)>0)
        {
            _收藏类别:= _匹配收藏名称2
            if(_收藏名称 ~= "(?:^#av)"){
                ; 对已格式化内容, 仅对日期进行格式化
                ; 有待进一步增加功能
                重命名 := new dateRenamer(_收藏名称)
                _result := 重命名.do()
                show_msg("已格式化内容, 不需要操作!")
            }
            else if(_收藏类别 ~= "(?:演员|演員)"){
                ;--- 对演员 修改收藏名
                重命名 := new Av演员重命名_收藏夹(_收藏名称)
                if(RegExMatch(clipboard, "(?:(\d{2,4})[-年\.](\d{1,2})[-月\.](\d{1,2})日?)", _date)>0)
                {
                    ;如果剪贴板里存有日期, 则当成是已存储的生日
                    avAnalysis := new AvActorInfoAnalysis()
                    avgirl := avAnalysis.analysis(clipboard)
                    _生日 := avgirl.data.birthday
                    _罩杯 := avgirl.data.bra
                    if(_罩杯 != "")
                        _罩杯 := "_" . _罩杯
                    重命名.replaceStr := "#av女优# " . "★" . " $1 " . _生日 . " (美颜" . _罩杯 . ") " . Sys.date() . "$2"
                    _result := 重命名.do()
                }
                else
                    _result := 重命名.do()
            }
            else if(_收藏类别 ~= "(?:导演|導演)"){            ; 对导演 修改收藏名
                重命名 := new Av导演重命名_收藏夹(_收藏名称)
                _result := 重命名.do()
            }
            else if(_收藏类别 ~= "(?:製作商|制作商)"){        ; 对制作商 修改收藏名
                重命名 := new Av制作商重命名_收藏夹(_收藏名称)
                _result := 重命名.do()
            }
            else if(_收藏类别 ~= "(?:發行商|发行商)"){        ; 对发行商 修改收藏名
                重命名 := new Av发行商重命名_收藏夹(_收藏名称)
                _result := 重命名.do()
            }
            else if(_收藏类别 ~= "(?:系列)"){                 ; 对av系列 修改收藏名
                重命名 := new Av系列重命名_收藏夹(_收藏名称)
                _result := 重命名.do()
            }
            else if(_收藏类别 ~= "(?:類別|类别)"){            ; 对av类别 修改收藏名
                重命名 := new Av类别重命名_收藏夹(_收藏名称)
                _result := 重命名.do()
            }
        }
        else if(_收藏名称 ~= "(?:^([A-Za-z]\w{1,5}-\d{2,6})\s)"){         ; 对av作品精品 修改收藏名
            重命名 := new Av作品重命名_收藏夹(_收藏名称)
            _result := 重命名.do()
        }
        else if(_收藏名称 ~= "^(?:.*)(?:\s-\s.*)"){         ; 对av搜索 修改收藏名
            重命名 := new Av搜索重命名_收藏夹(_收藏名称)
            _result := 重命名.do()
        }
        else                                                ; 不匹配, 恢复原状, 并进行提示
        {
            _result := _收藏名称
            show_msg("收藏名称不匹配, 不能进行格式化重命名!")
        }
        ; end
        return _result
    }
}

; ----------------------------------------------------------
; 重命名行为超类
; ----------------------------------------------------------
class Renamer {
    ; public
    result := ""
    upRenamer := ""
    ; public
    __new(_result:="", _renamer:=""){
        this.result := _result
        this.upRenamer := _renamer
    }
    ; public do()
    do(){
        if(this.result == ""){
            ; 如果没有输入要处理的字符串, 则进行调用上一级的处理
            this.result := this.upRenamer.do()
        }
        return this.rename()
    }
    ; protected rename()
    rename(){
        this.result := RegExReplace(this.result, this.matchStr, this.replaceStr)
        return this.result
    }
}

; ----------------------------------------------------------
; 日期重命名
; ----------------------------------------------------------
class dateRenamer extends Renamer {
    matchStr := "(\d{2,4})[-年/\\.](\d{1,2})[-月/\\.](\d{1,2})日?"
    replaceStr := "$1-$2-$3"
}

; ----------------------------------------------------------
; 对有码av作品名重命名
; ----------------------------------------------------------
class Av有码作品重命名 extends Renamer {
    matchStr := "^([A-Za-z]\w{1,5}-\d{2,5})\s(.*)\s(.{1,12})$"
    matchStrNoName := "^([A-Za-z]\w{1,5}-\d{2,5})\s(.*)$"
    replaceStr := "#av作品# ★ $1 $2 $3 (备注)"
    ; protected rename() overwrite
    rename(){
        if(RegExMatch(this.result, this.matchStr, _匹配值)>0){
            ;如果检测包含女优名, 则匹配三项, 并对第二项标题部分, 将空格替换下划线, 然后截取前16个字符;
            this.result := "#av作品# ★★ " . _匹配值1 . " " . SubStr(StrReplace(_匹配值2, " ", "_"), 1, 16) . " " . _匹配值3 . " (备注)"
        }
        else if(RegExMatch(this.result, this.matchStrNoName, _匹配值)>0){
            ;如果检测包含女优名, 则匹配两项, 并对第二项标题部分, 将空格替换下划线, 然后截取前16个字符;
            this.result := "#av作品# ★★ " . _匹配值1 . " " . SubStr(StrReplace(_匹配值2, " ", "_"), 1, 16) . " (备注)"
        }
        else{
            show_msg("Av有码作品重命名, 匹配失败")
        }
        ;this.result := RegExReplace(this.result, this.matchStr, this.replaceStr)
        return this.result
    }
}

; ----------------------------------------------------------
; 对无码av作品名重命名, 比如一本道, 加勒比等 ;debug 继续增加判断和不同公司的分解内容
; ----------------------------------------------------------
class Av无码作品重命名 extends Renamer {
    ; 无码特征匹配
    matchStr1 := "i)(?:Heyzo|1pon|Carib|Cappv|一本道|加勒比|东京热)"
    matchStr := "i)(.*?)[(\[]?(1Pondo-\d{6}_\d{3}|1Pon-\d{6}_\d{3}|Caribpr-\d{6}-\d{3}|\d{6}-\d{3}-Caribpr|Carib-\d{6}-\d{3}|\d{6}-\d{3}-Carib|[a-z][a-z0-9]{2,5}-?\d{2,6})[)\]]?\s{0,2}(.*)"
    replaceStr := ""
    ; public rename()
    rename(){
        if(RegExMatch(this.result, this.matchStr, _av) == 1)
        {
            ;--- _av1 前缀; _av2 编号;  _av3 标题和演员
            if(trim(_av1) == ""){
                this.result :=  "#av作品# ★ " . _av2 . " " . _av3 . " (备注)"
                show_msg(_av2 . "-" . _av3)
            }
            else{
                this.result :=  "#av作品# ★ " . _av2 . " " . trim(_av1) . "_" . _av3 . " (备注)"
                show_msg(_av1 . "-" . _av2 . "-" . _av3)
            }
        }
        else{
            show_msg("Av无码作品重命名, 匹配失败")
        }
        return this.result
    }
}

; ----------------------------------------------------------
; Av作品重命名_收藏夹
; ----------------------------------------------------------
class Av作品重命名_收藏夹 extends Renamer {
    matchStr := "^(.*)\s(-\s.*)$"
    replaceStr := "#av作品# ★★ $1 " . Sys.date() . " $2"
    ; protected rename() overwrite
    rename(){
        ;
        ; 先对标题部分, 将空格替换成下划线, 然后截取前16个字符
        if(RegExMatch(this.result, this.matchStr, _匹配值)>0){
            _重命名 := new Av有码作品重命名(_匹配值1)
            _匹配值1_result := _重命名.do()
            this.result := _匹配值1_result . " " . Sys.date() . " " . _匹配值2
        }
        ;this.result := RegExReplace(this.result, this.matchStr, this.replaceStr)
        return this.result
    }
}

; ----------------------------------------------------------
; Av演员重命名_收藏夹
; ----------------------------------------------------------
class Av演员重命名_收藏夹 extends Renamer {
    matchStr := "(.*?)(\s-\s.*)"
    replaceStr := "#av女优# ★ $1 1900-00-00 (备注) " . Sys.date() . "$2"
}

; ----------------------------------------------------------
; Av导演重命名_收藏夹
; ----------------------------------------------------------
class Av导演重命名_收藏夹 extends Renamer {
    matchStr := "(.*?)(\s-\s.*)"
    replaceStr := "#av导演# ★ $1 (备注) " . Sys.date() . "$2"
}

; ----------------------------------------------------------
; Av制作商重命名_收藏夹
; ----------------------------------------------------------
class Av制作商重命名_收藏夹 extends Renamer {
    matchStr := "(.*?)(\s-\s.*)"
    replaceStr := "#av制作商# ★ $1 (备注) " . Sys.date() . "$2"
}

; ----------------------------------------------------------
; Av发行商重命名_收藏夹
; ----------------------------------------------------------
class Av发行商重命名_收藏夹 extends Renamer {
    matchStr := "(.*?)(\s-\s.*)"
    replaceStr := "#av发行商# ★ $1 (备注) " . Sys.date() . "$2"
}

; ----------------------------------------------------------
; Av系列重命名_收藏夹
; ----------------------------------------------------------
class Av系列重命名_收藏夹 extends Renamer {
    matchStr := "(.*?)(\s-\s.*)"
    replaceStr := "#av系列# ★ $1 (备注) " . Sys.date() . "$2"
}

; ----------------------------------------------------------
; Av类别重命名_收藏夹
; ----------------------------------------------------------
class Av类别重命名_收藏夹 extends Renamer {
    matchStr := "(.*?)(\s-\s.*)"
    replaceStr := "#av类别# ★ $1 (备注) " . Sys.date() . "$2"
}

; ----------------------------------------------------------
; Av搜索重命名_收藏夹
; ----------------------------------------------------------
class Av搜索重命名_收藏夹 extends Renamer {
    matchStr := "^(.*)(\s-\s.*)"
    replaceStr := "#av搜索# ★ $1 (备注) " . Sys.date() . "$2"
}


; ----------------------------------------------------------
; av资料结构类, 其对象用于av数据采集
; ----------------------------------------------------------
class AvInfo {
    ; public data : {}
    data := ""
    ; public new
    __new(){

    }
    ; public get()
    get(){
        return this.data
    }
}

; ----------------------------------------------------------
; av演员资料结构类
; ----------------------------------------------------------
class AvActorInfo extends AvInfo {
    ; public new
    __new(){
        ; av演员资料: 类别, 评级, 女优名, 生日, 乳罩杯, 备注, 登记时间
        this.data := {type:"", level:"", name:"", birthday:"", bra:"", note:"", regtime:""}
    }
}

; ----------------------------------------------------------
; av影片资料结构类
; ----------------------------------------------------------
class AvMovieInfo extends AvInfo {
    ; public new
    __new(){
        ; av作品资料: 类别, 评级, 作品标题, 导演, 演员, 备注, 登记时间
        this.data := {type:"", level:"", title:"", director:"", actor:"", note:"", regtime:""}
    }
}

; ----------------------------------------------------------
; av资料分析采集类, 返回收集的资料对象
; ----------------------------------------------------------
class AvInfoAnalysis{
    ; public new
    __new(){

    }
}

; ----------------------------------------------------------
; av资料分析采集, 返回收集的av演员资料对象
; ----------------------------------------------------------
class AvActorInfoAnalysis extends AvInfoAnalysis{
    ; 数据模版
    match_name := "^(.*)(\s-\s.*)"
    match_birthday := "((\d{2,4})[-年\.](\d{1,2})[-月\.](\d{1,2})日?)"
    match_bra := "(?:罩\s?杯:?\s?)([a-lA-L])|([a-lA-L])(?:\s?罩\s?杯)"
    ; public analysis(av内容字符串) 返回演员资料货影片资料对象
    analysis(in_avStr){
        avinfo := new AvActorInfo()
        if(RegExMatch(in_avStr, this.match_birthday, _match)>0){
            avinfo.data.birthday := strFixDate(_match1)
        }
        if(RegExMatch(in_avStr, this.match_bra, _match)>0){
            _bra := _match1!="" ? _match1 : _match2
            StringUpper, _bra, _bra
            if(_bra>"F")
                avinfo.data.bra := "巨乳" . _bra
            else if(_bra>"B")
                avinfo.data.bra := "美丰乳" . _bra
            else
                avinfo.data.bra := "小乳" . _bra
        }
        return avinfo
    }

    ; static debug()
    debug(in_avstr){
        avAnalysis := new AvActorInfoAnalysis()
        avgirl := avAnalysis.analysis(in_avstr)
        _生日 := avgirl.data.birthday
        _罩杯 := avgirl.data.bra
        _return:= "生日: " . _生日 . " | " . "罩杯: " . _罩杯
        return _return
    }
}
