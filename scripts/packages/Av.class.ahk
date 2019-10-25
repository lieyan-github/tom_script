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
            _result := 模板_日期_format(_avTitle)
            _result := 模板_tags_format(_result)
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
                _result := 模板_日期_format(_收藏名称)
                _result := 模板_tags_format(_result)
                show_msg("已格式化内容, 不需要操作!")
            }
            else if(_收藏类别 ~= "(?:演员|演員)"){
                ;--- 对演员 修改收藏名
                重命名 := new Av演员重命名_收藏夹(_收藏名称)
                if(RegExMatch(clipboard, "(?:(\d{2,4})[-年\.](\d{1,2})[-月\.](\d{1,2})日?)", _date)>0)
                {
                    ;如果剪贴板里存有日期, 则当成是已存储的生日
                    _生日 := AvGirlInfo.提取生日(clipboard)
                    _罩杯 := AvGirlInfo.提取bra(clipboard)
                    if(_罩杯 != "")
                        _罩杯 := "乳" . _罩杯
                    ;重命名.replaceStr := "#av女优# " . "★" . " $1 " . _生日 . " tags(美颜" . _罩杯 . ") " . Sys.date() . "$2"
                    重命名.replaceStr := format("{1} {2} {3} {4} {5} {6} {7}"
                                                , 模板_av女优标签()
                                                , 模板_评级()
                                                , "$1"
                                                , _生日
                                                , 模板_tags("美颜", _罩杯)
                                                , 模板_日期()
                                                , "$2")
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
    ; public
    __new(_result:=""){
        this.result := _result
    }
    ; public do()
    do(){
        return this.rename()
    }
    ; protected rename()
    rename(){
        this.result := RegExReplace(this.result, this.matchStr, this.replaceStr)
        return this.result
    }
}

; ----------------------------------------------------------
; 对有码av作品名重命名
; ----------------------------------------------------------
class Av有码作品重命名 extends Renamer {
    matchStr := "^([A-Za-z]\w{1,5}-\d{2,5})\s(.*)\s(.{1,12})$"
    matchStrNoName := "^([A-Za-z]\w{1,5}-\d{2,5})\s(.*)$"
    ;replaceStr := "#av作品# ★ $1 $2 $3 tags(备注)"
    replaceStr := format("{1} {2} {3} {4} {5} {6}"
                            , 模板_av作品标签()
                            , 模板_评级()
                            , "$1"
                            , "$2"
                            , "$3"
                            , 模板_tags())
    ; protected rename() overwrite
    rename(){
        if(RegExMatch(this.result, this.matchStr, _匹配值)>0){
            ;如果检测包含女优名, 则匹配三项, 并对第二项标题部分, 将空格替换下划线, 然后截取前16个字符;
            ;this.result := "#av作品# ★★ " . _匹配值1 . " " . SubStr(StrReplace(_匹配值2, " ", "_"), 1, 16) . " " . _匹配值3 . " (备注)"
            this.result := format("{1} {2} {3} {4} {5} {6}"
                            , 模板_av作品标签()
                            , 模板_评级()
                            , _匹配值1
                            , SubStr(StrReplace(_匹配值2, " ", "_"), 1, 16)
                            , _匹配值3
                            , 模板_tags())
        }
        else if(RegExMatch(this.result, this.matchStrNoName, _匹配值)>0){
            ;如果检测包含女优名, 则匹配两项, 并对第二项标题部分, 将空格替换下划线, 然后截取前16个字符;
            ;this.result := "#av作品# ★★ " . _匹配值1 . " " . SubStr(StrReplace(_匹配值2, " ", "_"), 1, 16) . " (备注)"
            this.result := format("{1} {2} {3} {4} {5}"
                            , 模板_av作品标签()
                            , 模板_评级()
                            , _匹配值1
                            , SubStr(StrReplace(_匹配值2, " ", "_"), 1, 16)
                            , 模板_tags())
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
                ;this.result :=  "#av作品# ★ " . _av2 . " " . _av3 . " (备注)"
                this.result := format("{1} {2} {3} {4} {5}"
                            , 模板_av作品标签()
                            , 模板_评级()
                            , _av2
                            , _av3
                            , 模板_tags())
                show_msg(_av2 . "-" . _av3)
            }
            else{
                ;this.result :=  "#av作品# ★ " . _av2 . " " . trim(_av1) . "_" . _av3 . " (备注)"
                this.result := format("{1} {2} {3} {4}_{5} {6}"
                            , 模板_av作品标签()
                            , 模板_评级()
                            , _av2
                            , _av1
                            , _av3
                            , 模板_tags())
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
    replaceStr := format("{1} {2} {3} {4} {5}"
                            , 模板_av作品标签()
                            , 模板_评级()
                            , "$1"
                            , 模板_日期()
                            , "$2")

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
    replaceStr := format("{1} {2} {3} {4} {5} {6} {7}"
                            , 模板_av女优标签()
                            , 模板_评级()
                            , "$1"
                            , 模板_生日()
                            , 模板_tags()
                            , 模板_日期()
                            , "$2")
}

; ----------------------------------------------------------
; Av导演重命名_收藏夹
; ----------------------------------------------------------
class Av导演重命名_收藏夹 extends Renamer {
    matchStr := "(.*?)(\s-\s.*)"
    replaceStr := format("{1} {2} {3} {4} {5} {6}"
                    , 模板_av导演标签()
                    , 模板_评级()
                    , "$1"
                    , 模板_tags()
                    , 模板_日期()
                    , "$2")
}

; ----------------------------------------------------------
; Av制作商重命名_收藏夹
; ----------------------------------------------------------
class Av制作商重命名_收藏夹 extends Renamer {
    matchStr := "(.*?)(\s-\s.*)"
    replaceStr := format("{1} {2} {3} {4} {5} {6}"
                    , 模板_av制作商标签()
                    , 模板_评级()
                    , "$1"
                    , 模板_tags()
                    , 模板_日期()
                    , "$2")
}

; ----------------------------------------------------------
; Av发行商重命名_收藏夹
; ----------------------------------------------------------
class Av发行商重命名_收藏夹 extends Renamer {
    matchStr := "(.*?)(\s-\s.*)"
    replaceStr := format("{1} {2} {3} {4} {5} {6}"
                    , 模板_av发行商标签()
                    , 模板_评级()
                    , "$1"
                    , 模板_tags()
                    , 模板_日期()
                    , "$2")
}

; ----------------------------------------------------------
; Av系列重命名_收藏夹
; ----------------------------------------------------------
class Av系列重命名_收藏夹 extends Renamer {
    matchStr := "(.*?)(\s-\s.*)"
    replaceStr := format("{1} {2} {3} {4} {5} {6}"
                    , 模板_av系列标签()
                    , 模板_评级()
                    , "$1"
                    , 模板_tags()
                    , 模板_日期()
                    , "$2")
}

; ----------------------------------------------------------
; Av类别重命名_收藏夹
; ----------------------------------------------------------
class Av类别重命名_收藏夹 extends Renamer {
    matchStr := "(.*?)(\s-\s.*)"
    replaceStr := format("{1} {2} {3} {4} {5} {6}"
                    , 模板_av类别标签()
                    , 模板_评级()
                    , "$1"
                    , 模板_tags()
                    , 模板_日期()
                    , "$2")
}

; ----------------------------------------------------------
; Av搜索重命名_收藏夹
; ----------------------------------------------------------
class Av搜索重命名_收藏夹 extends Renamer {
    matchStr := "^(.*)(\s-\s.*)"
    replaceStr := format("{1} {2} {3} {4} {5} {6}"
                    , 模板_av搜索标签()
                    , 模板_评级()
                    , "$1"
                    , 模板_tags()
                    , 模板_日期()
                    , "$2")
}


; ----------------------------------------------------------
; av资料结构类, 其对象用于av数据采集
; ----------------------------------------------------------
class AvInfo {
    ; public new
    __new(){
        this.info := {}
    }

    ; ----------------------------------------------------------
    ; public static 类别判断是女优资料/作品/导演/制作商/发行商资料
    ; ----------------------------------------------------------
    is女优(in_avStr){
        _特征库 := ["^(#av女优#)"
                    , "(演員)"]
        _结果 := false
        if(匹配特征库(in_avStr, _特征库))
            _结果 := True
        return _结果
    }

    is作品(in_avStr){
        _特征库 := ["^(#av作品#)"
                    , "識別碼.\s?[A-Za-z]+"]
        _结果 := false
        if(匹配特征库(in_avStr, _特征库))
            _结果 := True
        return _结果
    }
}

; ----------------------------------------------------------
; av演员资料结构类
; ----------------------------------------------------------
class AvGirlInfo extends AvInfo {
    ; public new
    __new(in_avStr := ""){
        ; av演员资料: 类别, 评级, 女优名(因为女优多名所以用数组), 生日, 乳罩杯(存放在tags中), 备注(存放无法解析的部分), 登记时间
        this.info := {id: strId()   ; key
                    , 类型: 模板_av女优标签()
                    , 地区: "日本"
                    , 评级: 1
                    , 名字: []
                    , 生日: ""
                    , bra: ""
                    , tags: []
                    , 备注: ""
                    , 登记时间: 模板_日期()}
        if(in_avStr!=""){
            this.提取全部(in_avStr)
        }
    }

    ; public 提取全部(in_avStr)
    提取全部(in_avStr){
        _avStr:= in_avStr
        this.info.名字 := this.提取女优名(_avStr)
        this.info.评级 := this.提取评级(_avStr)
        this.info.生日 := this.提取生日(_avStr)
        this.info.地区 := this.提取地区(_avStr)
        this.info.tags := this.提取tags(_avStr)
        this.info.bra := this.提取bra(_avStr)
        this.info.备注 := this.提取备注(_avStr)
    }

    ; public toStr()
    ; [输出格式化]
    ; #av女优# ★★★ 女优名 2000-03-05 地区(日本) tags(美颜_乳c_风骚_诱惑) 备注(备注内容...)
    toStr(){
        _str := Format("{1} {2} {3} {4} 地区({5}) tags({6}) 备注({7})"
                        , this.info["类型"]
                        , strN("★", this.info["评级"])
                        , arrayJoin(this.info["名字"], "_")
                        , this.info["生日"]
                        , this.info["地区"]
                        , arrayJoin(this.info["tags"], " ")
                        , this.info["备注"])
        return _str
    }

    toCsvStr(){
        _str := Format("{1},{2},{3},{4},{5}"
                        , arrayJoin(this.info["名字"], "_")
                        , this.info["评级"]
                        , this.info["生日"]
                        , this.info["bra"]
                        , arrayJoin(this.info["tags"], " "))
        return _str
    }

    ; ----------------------------------------------------------
    ; public 提取女优的相关信息, 第一个特征都设置为标准模式
    ; ----------------------------------------------------------
    提取女优名(in_avStr){
        _特征库 := ["^#av女优#\s★*\s(\S+?)\s"
                    , "^(\S+)\s-\s演員"
                    , "演员\((.*?)\)"
                    , "(?:類別 正體中文 |類別 )(\S+)"]
        _女优名列表 := []
        ; 匹配特征
        _女优名列表 := str_Split(strTrim(按特征库提取字符串(in_avStr, _特征库), "_"), "_")
        ; 返回结果
        return _女优名列表
    }

    提取评级(in_avStr){
        _特征库 := ["(★+)"]
        _评级   := ""
        ; 匹配特征
        _评级 := StrLen(按特征库提取字符串(in_avStr, _特征库))
        _评级 := _评级>0 ? _评级 : 1
        ; 返回结果
        return _评级
    }

    提取生日(in_avStr){
        _特征库 := ["((\d{2,4})[-年\.](\d{1,2})[-月\.](\d{1,2})日?)"]
        _生日   := ""
        ; 匹配特征
        _生日 := strFixDate(按特征库提取字符串(in_avStr, _特征库))
        ; 返回结果
        return _生日
    }

    提取地区(in_avStr){
        _地区特征库 := {"日本":["日本"
                            , "i)1pon"
                            , "i)carib"
                            , "i)paco"]
                    , "欧美":["欧美"
                            , "i)^([a-z-]+)\s-\s"]
                    , "韩国":["韩国"]}
        _地区   := "日本"
        ; 匹配特征
        for _地区名, _特征库 in _地区特征库 {
            for _i, _特征 in _特征库 {
                if(RegExMatch(in_avStr, _特征, _match)>0){
                    _地区 := _地区名
                    Break
                }
            }
        }
        ; 返回结果
        return _地区
    }

    ; 匹配特征
    ; 1. tags(...);
    ; 2. 前期没格式化的tags特征 " (...)"
    提取tags(in_avStr){
        _特征库 := ["tags\((.*?)\)"
                    , "#精品女优#\((.*?)\)"
                    , "\s\((\S+?)\)"]
        return 按特征库提取tags(in_avStr, _特征库)
    }

    提取bra(in_avStr){
        ; 日语e罩杯 Eカップ
        _特征库 := ["罩?\s?杯:?.?([a-lA-L])"
                    , "([a-lA-L]).?罩?\s?杯"
                    , "乳.?([a-lA-L])"
                    , "([a-lA-L]).?乳"
                    , "([a-lA-L]).?カップ"
                    , "カップ.?([a-lA-L])"]
        _bra   := ""
        ; 匹配特征
        _bra := 按特征库提取字符串(in_avStr, _特征库)
        ; 转小写字母
        StringLower, _bra, _bra
        ; 返回结果
        return _bra
    }

    提取备注(in_avStr){
        _特征库 := ["备注\((.*?)\)"]
        _备注   := ""
        ; 匹配特征
        _备注 := 按特征库提取字符串(in_avStr, _特征库)
        ; 返回结果
        return _备注
    }
}

; ----------------------------------------------------------
; av影片资料结构类
; av作品日本有码
; ----------------------------------------------------------
class Av作品日本有码Info extends AvInfo {
    ; public new
    ; 需要判断是
    ; 1. 日本有码
    ; 2. 日本无码
    ; 3. 欧美无码
    __new(in_avStr := ""){
        ; av作品资料: 类别, 评级, 作品标题, 导演, 演员, 系列, 登记时间
        this.info := {编号: ""        ; key
                    , 类型: 模板_av作品标签()
                    , 地区: "日本"
                    , 是否无码: "有码"
                    , 评级: 1
                    , 标题: ""
                    , 导演: ""
                    , 演员: []
                    , 制作商: ""
                    , 发行商: ""
                    , tags: []
                    , 系列: ""
                    , 登记时间: 模板_日期()}
        if(in_avStr!=""){
            this.提取全部(in_avStr)
        }
    }

    ; public 提取全部(in_avStr)
    提取全部(in_avStr){
        _avStr:= in_avStr
        this.info.评级    := this.提取评级(_avStr)
        this.info.编号    := this.提取编号(_avStr)
        this.info.标题    := this.提取标题(_avStr)
        this.info.演员    := this.提取演员(_avStr)
        this.info.tags    := this.提取tags(_avStr)
        this.info.地区    := this.提取地区(_avStr)
        this.info.是否无码:= this.提取是否无码(_avStr)
        this.info.导演    := this.提取导演(_avStr)
        this.info.制作商  := this.提取制作商(_avStr)
        this.info.发行商  := this.提取发行商(_avStr)
        this.info.系列    := this.提取系列(_avStr)
    }

    ; public toStr()
    ; [收藏夹内容]
    ; #av作品# ★★★ MIDE-255 巨乳女教師の匂い立つ汗と愛液 神咲詩織 (美乳_激情诱惑) 2016-03-07 - AVMOO
    ; [输出格式化]
    ; #av作品# ★★★ MIDE-255 巨乳女教師の匂い立つ汗と愛液 演员(神咲詩織) tags(美颜_乳c_风骚_诱惑) 地区(日本) 有码 导演(紋℃) 制作商(ムーディーズ) 发行商(MOODYZ DIVA) 备注(备注内容...)
    toStr(){
        ; debug format
        _str := format("{1} {2} {3} {4} 演员({5}) tags({6}) 地区({7}) {8} 导演({9}) 制作商({10}) 发行商({11}) 系列({12})"
                        , this.info["类型"]
                        , strN("★", this.info["评级"])
                        , this.info["编号"]
                        , this.info["标题"]
                        , arrayJoin(this.info["演员"], " ")
                        , arrayJoin(this.info["tags"], " ")
                        , this.info["地区"]
                        , this.info["是否无码"]
                        , this.info["导演"]
                        , this.info["制作商"]
                        , this.info["发行商"]
                        , this.info["系列"])
        return _str
    }

    ; ----------------------------------------------------------
    ; public static 提取av作品的相关信息, 第一个特征都设置为标准模式
    ; ----------------------------------------------------------
    提取编号(in_avStr){
        _特征库 := ["i)(carib[a-z]*[-_]\d{6}[-_]\d{3})"
                    , "i)(\d{6}[-_]\d{3}[-_]carib)"
                    , "i)(1pon[a-z]*[-_]\d{6}[-_]\d{3})"
                    , "i)(\d{6}[-_]\d{3}[-_]1pon)"
                    , "i)([a-z]{2,6}-\d{2,5})"]
        _编号   := ""
        ; 匹配特征
        _编号 := 按特征库提取字符串(in_avStr, _特征库)
        ; 修正无码作品编号格式 carib-000000-000, 1pon-000000-000
        ; 返回结果
        return _编号
    }

    提取评级(in_avStr){
        _特征库 := ["(★+)"]
        _评级   := ""
        ; 匹配特征
        _评级 := StrLen(按特征库提取字符串(in_avStr, _特征库))
        _评级 := _评级>0 ? _评级 : 1
        ; 返回结果
        return _评级
    }

    提取标题(in_avStr){
        _特征库 := ["^#av作品#\s★*\s\S+\s(\S+)"
                    , "(?:類別 正體中文 |類別 )[a-zA-z]+-\d+ (\S+)"]
        _标题   := ""
        ; 匹配特征
        _标题 := 按特征库提取字符串(in_avStr, _特征库)
        ; 返回结果
        return _标题
    }

    提取演员(in_avStr){
        _特征库 := ["演员\((.*?)\)"
                    , "^#av作品#\s★*\s\S+\s\S+\s(\S+)"
                    , "^(\S+)\s-\s演員"
                    , "推薦 演員.(.+?).(?:樣品圖像|下載)"]
        _演员列表 := []
        ; 匹配特征
        _演员列表 := str_Split(strTrim(StrReplace(按特征库提取字符串(in_avStr
                                                                    , _特征库)
                                                    , " "
                                                    , "_")
                                        , "_")
                                , "_")
        ; 返回结果
        return _演员列表
    }

    ; 匹配特征
    ; 1. tags(...);
    ; 2. 前期没格式化的tags特征 " (...)"
    提取tags(in_avStr){
        _特征库 := ["tags\((.*?)\)"
                    , "\s\((\S+?)\)"]
        return 按特征库提取tags(in_avStr, _特征库)
    }

    提取地区(in_avStr){
        _地区特征库 := {"日本":["日本"
                            , "i)1pon"
                            , "i)carib"
                            , "i)paco"]
                    , "欧美":["欧美"
                            , "i)^([a-z-]+)\s-\s"]
                    , "韩国":["韩国"]}
        _地区   := "日本"
        ; 匹配特征
        for _地区名, _特征库 in _地区特征库 {
            for _i, _特征 in _特征库 {
                if(RegExMatch(in_avStr, _特征, _match)>0){
                    _地区 := _地区名
                    ; 无需在avStr中删去已匹配内容
                    ;in_avStr := strDelSub(in_avStr, _match1)
                    Break
                }
            }
        }
        ; 返回结果
        return _地区
    }

    提取是否无码(in_avStr){
        _特征库 := ["无码"
                    , "i)1pon"
                    , "i)carib"
                    , "i)paco"
                    , "i)^([a-z-]+)\s-\s"]
        _是否无码   := "有码"
        ; 匹配特征
        for _i, _特征 in _特征库 {
            if(RegExMatch(in_avStr, _特征, _match)>0){
                _是否无码 := "无码"
                ; 无需在avStr中删去已匹配内容
                ;in_avStr := strDelSub(in_avStr, _match1)
                Break
            }
        }
        ; 返回结果
        return _是否无码
    }

    提取导演(in_avStr){
        _特征库 := ["导演\((.*?)\)"
                    , "導演.(\S+)"]
        _导演   := ""
        ; 匹配特征
        _导演  := 按特征库提取字符串(in_avStr, _特征库)
        ; 返回结果
        return _导演
    }

    提取制作商(in_avStr){
        _特征库 := ["制作商\((.*?)\)"
                    , "製作商.(\S+)"]
        _制作商 := ""
        ; 匹配特征
        _制作商 := 按特征库提取字符串(in_avStr, _特征库)
        ; 返回结果
        return _制作商
    }

    提取发行商(in_avStr){
        _特征库 := ["发行商\((.*?)\)"
                    , "發行商.(\S+)"]
        _发行商 := ""
        ; 匹配特征
        _发行商 := 按特征库提取字符串(in_avStr, _特征库)
        ; 返回结果
        return _发行商
    }

    提取系列(in_avStr){
        _特征库 := ["系列\((.*?)\)"
                    , "系列.(\S+)"]
        _系列   := ""
        ; 匹配特征
        _系列 := 按特征库提取字符串(in_avStr, _特征库)
        ; 返回结果
        return _系列
    }
}

; ----------------------------------------------------------
; av影片资料结构类
; av作品日本无码
; ----------------------------------------------------------
class Av作品日本无码Info extends AvInfo {
    ; public new
    ; 需要判断是
    ; 1. 日本有码
    ; 2. 日本无码
    ; 3. 欧美无码
    __new(in_avStr := ""){
        ; av作品资料: 类别, 评级, 作品标题, 导演, 演员, 系列, 登记时间
        this.info := {编号: ""        ; key
                    , 类型: "#av作品#"
                    , 地区: "日本"
                    , 是否无码: "无码"
                    , 评级: 1
                    , 标题: ""
                    , 导演: ""
                    , 演员: []
                    , 制作商: ""
                    , 发行商: ""
                    , tags: []
                    , 系列: ""
                    , 登记时间: Sys.date()}
        if(in_avStr!=""){
            this.提取全部(in_avStr)
        }
    }

    ; public 提取全部(in_avStr)
    提取全部(in_avStr){
        _avStr:= in_avStr
        this.info.评级    := this.提取评级(_avStr)
        this.info.编号    := this.提取编号(_avStr)
        this.info.标题    := this.提取标题(_avStr)
        this.info.演员    := this.提取演员(_avStr)
        this.info.tags    := this.提取tags(_avStr)
        this.info.地区    := this.提取地区(_avStr)
        this.info.是否无码:= this.提取是否无码(_avStr)
        this.info.导演    := this.提取导演(_avStr)
        this.info.制作商  := this.提取制作商(_avStr)
        this.info.发行商  := this.提取发行商(_avStr)
        this.info.系列    := this.提取系列(_avStr)
    }

    ; public toStr()
    ; [收藏夹内容]
    ; #av作品# ★★★ MIDE-255 巨乳女教師の匂い立つ汗と愛液 神咲詩織 (美乳_激情诱惑) 2016-03-07 - AVMOO
    ; [输出格式化]
    ; #av作品# ★★★ MIDE-255 巨乳女教師の匂い立つ汗と愛液 演员(神咲詩織) tags(美颜_乳c_风骚_诱惑) 地区(日本) 有码 导演(紋℃) 制作商(ムーディーズ) 发行商(MOODYZ DIVA) 备注(备注内容...)
    toStr(){
        ; debug format
        _str := format("{1} {2} {3} {4} 演员({5}) tags({6}) 地区({7}) {8} 导演({9}) 制作商({10}) 发行商({11}) 系列({12})"
                        , this.info["类型"]
                        , strN("★", this.info["评级"])
                        , this.info["编号"]
                        , this.info["标题"]
                        , arrayJoin(this.info["演员"], "_")
                        , arrayJoin(this.info["tags"], "_")
                        , this.info["地区"]
                        , this.info["是否无码"]
                        , this.info["导演"]
                        , this.info["制作商"]
                        , this.info["发行商"]
                        , this.info["系列"])
        return _str
    }

    ; ----------------------------------------------------------
    ; public static 提取av作品的相关信息, 第一个特征都设置为标准模式
    ; ----------------------------------------------------------
    提取编号(in_avStr){
        _特征库 := ["i)(carib[a-z]*[-_]\d{6}[-_]\d{3})"
                    , "i)(\d{6}[-_]\d{3}[-_]carib)"
                    , "i)(1pon[a-z]*[-_]\d{6}[-_]\d{3})"
                    , "i)(\d{6}[-_]\d{3}[-_]1pon)"
                    , "i)([a-z]{2,6}-\d{2,5})"]
        _编号   := ""
        ; 匹配特征
        _编号 := 按特征库提取字符串(in_avStr, _特征库)
        ; 修正无码作品编号格式 carib-000000-000, 1pon-000000-000
        ; 返回结果
        return _编号
    }

    提取评级(in_avStr){
        _特征库 := ["(★+)"]
        _评级   := ""
        ; 匹配特征
        _评级 := StrLen(按特征库提取字符串(in_avStr, _特征库))
        _评级 := _评级>0 ? _评级 : 1
        ; 返回结果
        return _评级
    }

    提取标题(in_avStr){
        _特征库 := ["^#av作品#\s★*\s\S+\s(\S+)"
                    , "(?:類別 正體中文 |類別 )[a-zA-z]+-\d+ (\S+)"]
        _标题   := ""
        ; 匹配特征
        _标题 := 按特征库提取字符串(in_avStr, _特征库)
        ; 返回结果
        return _标题
    }

    提取演员(in_avStr){
        _特征库 := ["演员\((.*?)\)"
                    , "^#av作品#\s★*\s\S+\s\S+\s(\S+)"
                    , "^(\S+)\s-\s演員"
                    , "推薦 演員.(.+?).(?:樣品圖像|下載)"]
        _演员列表 := []
        ; 匹配特征
        _演员列表 := str_Split(strTrim(StrReplace(按特征库提取字符串(in_avStr
                                                                    , _特征库)
                                                    , " "
                                                    , "_")
                                        , "_")
                                , "_")
        ; 返回结果
        return _演员列表
    }

    ; 匹配特征
    ; 1. tags(...);
    ; 2. 前期没格式化的tags特征 " (...)"
    提取tags(in_avStr){
        _特征库 := ["tags\((.*?)\)"
                    , "\s\((\S+?)\)"]
        return 按特征库提取tags(in_avStr, _特征库)
    }

    提取地区(in_avStr){
        _地区特征库 := {"日本":["日本"
                            , "i)1pon"
                            , "i)carib"
                            , "i)paco"]
                    , "欧美":["欧美"
                            , "i)^([a-z-]+)\s-\s"]
                    , "韩国":["韩国"]}
        _地区   := "日本"
        ; 匹配特征
        for _地区名, _特征库 in _地区特征库 {
            for _i, _特征 in _特征库 {
                if(RegExMatch(in_avStr, _特征, _match)>0){
                    _地区 := _地区名
                    ; 无需在avStr中删去已匹配内容
                    ;in_avStr := strDelSub(in_avStr, _match1)
                    Break
                }
            }
        }
        ; 返回结果
        return _地区
    }

    提取是否无码(in_avStr){
        _特征库 := ["无码"
                    , "i)1pon"
                    , "i)carib"
                    , "i)paco"
                    , "i)^([a-z-]+)\s-\s"]
        _是否无码   := "有码"
        ; 匹配特征
        for _i, _特征 in _特征库 {
            if(RegExMatch(in_avStr, _特征, _match)>0){
                _是否无码 := "无码"
                ; 无需在avStr中删去已匹配内容
                ;in_avStr := strDelSub(in_avStr, _match1)
                Break
            }
        }
        ; 返回结果
        return _是否无码
    }

    提取导演(in_avStr){
        _特征库 := ["导演\((.*?)\)"
                    , "導演.(\S+)"]
        _导演   := ""
        ; 匹配特征
        _导演  := 按特征库提取字符串(in_avStr, _特征库)
        ; 返回结果
        return _导演
    }

    提取制作商(in_avStr){
        _特征库 := ["制作商\((.*?)\)"
                    , "製作商.(\S+)"]
        _制作商 := ""
        ; 匹配特征
        _制作商 := 按特征库提取字符串(in_avStr, _特征库)
        ; 返回结果
        return _制作商
    }

    提取发行商(in_avStr){
        _特征库 := ["发行商\((.*?)\)"
                    , "發行商.(\S+)"]
        _发行商 := ""
        ; 匹配特征
        _发行商 := 按特征库提取字符串(in_avStr, _特征库)
        ; 返回结果
        return _发行商
    }

    提取系列(in_avStr){
        _特征库 := ["系列\((.*?)\)"
                    , "系列.(\S+)"]
        _系列   := ""
        ; 匹配特征
        _系列 := 按特征库提取字符串(in_avStr, _特征库)
        ; 返回结果
        return _系列
    }
}

; ----------------------------------------------------------
; av影片资料结构类
; av作品欧美无码
; ----------------------------------------------------------
class Av作品欧美无码Info extends AvInfo {
    ; public new
    ; 需要判断是
    ; 1. 日本有码
    ; 2. 日本无码
    ; 3. 欧美无码
    __new(in_avStr := ""){
        ; av作品资料: 类别, 评级, 作品标题, 导演, 演员, 系列, 登记时间
        this.info := {编号: ""        ; key
                    , 类型: "#av作品#"
                    , 地区: "欧美"
                    , 是否无码: "无码"
                    , 评级: 1
                    , 标题: ""
                    , 导演: ""
                    , 演员: []
                    , 制作商: ""
                    , 发行商: ""
                    , tags: []
                    , 系列: ""
                    , 登记时间: Sys.date()}
        if(in_avStr!=""){
            this.提取全部(in_avStr)
        }
    }

    ; public 提取全部(in_avStr)
    提取全部(in_avStr){
        _avStr:= in_avStr
        this.info.评级    := this.提取评级(_avStr)
        ; 欧美没有编号
        ;this.info.编号    := this.提取编号(_avStr)
        this.info.标题    := this.提取标题(_avStr)
        this.info.演员    := this.提取演员(_avStr)
        this.info.tags    := this.提取tags(_avStr)
        ; 确认是欧美, 也就确定地区是欧美, 并且是无码
        ; 欧美没有导演和发行商, 只有制作商
        ;this.info.导演    := this.提取导演(_avStr)
        this.info.制作商  := this.提取制作商(_avStr)
        ;this.info.发行商  := this.提取发行商(_avStr)
        ;this.info.系列    := this.提取系列(_avStr)
    }

    ; public toStr()
    ; [一般作品文件名格式]
    ; #av作品# ★★★ DorcelClub - Anna Polina Mes Nuits En Prison (极品诱惑)
    ; [输出格式化]
    ; #av作品# ★★★ 制作商 - 演员(演员名) 作品标题 tags(极品诱惑_风骚_美乳) 地区(欧美) 无码
    toStr(){
        ; debug format
        _str := format("{1} {2} {3} {4} 演员({5}) tags({6}) 地区({7}) {8} 导演({9}) 制作商({10}) 发行商({11}) 系列({12})"
                        , this.info["类型"]
                        , strN("★", this.info["评级"])
                        , this.info["编号"]
                        , this.info["标题"]
                        , arrayJoin(this.info["演员"], "_")
                        , arrayJoin(this.info["tags"], "_")
                        , this.info["地区"]
                        , this.info["是否无码"]
                        , this.info["导演"]
                        , this.info["制作商"]
                        , this.info["发行商"]
                        , this.info["系列"])
        return _str
    }

    ; ----------------------------------------------------------
    ; public static 提取av作品的相关信息, 第一个特征都设置为标准模式
    ; ----------------------------------------------------------
    提取编号(in_avStr){
        _特征库 := ["i)(carib[a-z]*[-_]\d{6}[-_]\d{3})"
                    , "i)(\d{6}[-_]\d{3}[-_]carib)"
                    , "i)(1pon[a-z]*[-_]\d{6}[-_]\d{3})"
                    , "i)(\d{6}[-_]\d{3}[-_]1pon)"
                    , "i)([a-z]{2,6}-\d{2,5})"]
        _编号   := ""
        ; 匹配特征
        _编号 := 按特征库提取字符串(in_avStr, _特征库)
        ; 修正无码作品编号格式 carib-000000-000, 1pon-000000-000
        ; 返回结果
        return _编号
    }

    提取评级(in_avStr){
        _特征库 := ["(★+)"]
        _评级   := ""
        ; 匹配特征
        _评级 := StrLen(按特征库提取字符串(in_avStr, _特征库))
        _评级 := _评级>0 ? _评级 : 1
        ; 返回结果
        return _评级
    }

    提取标题(in_avStr){
        _特征库 := ["^#av作品#\s★*\s\S+\s(\S+)"
                    , "(?:類別 正體中文 |類別 )[a-zA-z]+-\d+ (\S+)"]
        _标题   := ""
        ; 匹配特征
        _标题 := 按特征库提取字符串(in_avStr, _特征库)
        ; 返回结果
        return _标题
    }

    提取演员(in_avStr){
        _特征库 := ["演员\((.*?)\)"
                    , "^#av作品#\s★*\s\S+\s\S+\s(\S+)"
                    , "^(\S+)\s-\s演員"
                    , "推薦 演員.(.+?).(?:樣品圖像|下載)"]
        _演员列表 := []
        ; 匹配特征
        _演员列表 := str_Split(strTrim(StrReplace(按特征库提取字符串(in_avStr
                                                                    , _特征库)
                                                    , " "
                                                    , "_")
                                        , "_")
                                , "_")
        ; 返回结果
        return _演员列表
    }

    ; 匹配特征
    ; 1. tags(...);
    ; 2. 前期没格式化的tags特征 " (...)"
    提取tags(in_avStr){
        _特征库 := ["tags\((.*?)\)"
                    , "\s\((\S+?)\)"]
       return 按特征库提取tags(in_avStr, _特征库)
    }

    提取制作商(in_avStr){
        _特征库 := ["制作商\((.*?)\)"
                    , "製作商.(\S+)"]
        _制作商 := ""
        ; 匹配特征
        _制作商 := 按特征库提取字符串(in_avStr, _特征库)
        ; 返回结果
        return _制作商
    }
}

; ----------------------------------------------------------
; av资料分析采集类, 返回收集的资料对象
; ----------------------------------------------------------
class AvInfoAnalysis{
    ; public new
    __new(){
        ; todo
    }

    ; public static parse(in_avStr) return AvInfoObject
    ; 需要判断是
    ; 1. 日本有码
    ; 2. 日本无码
    ; 3. 欧美无码
    parse(in_avStr){
        _avInfo := {}
        _av女优_特征库   := [""]
        _日本有码_特征库 := [""]
        _日本无码_特征库 := [""]
        _欧美无码_特征库 := [""]
        if(匹配特征库(in_avStr, _av女优_特征库))
            _avInfo := new AvGirlInfo(in_avStr)
        else if(匹配特征库(in_avStr, _日本有码_特征库))
            _avInfo := new Av作品日本有码Info(in_avStr)
        else if(匹配特征库(in_avStr, _日本无码_特征库))
            _avInfo := new Av作品日本无码Info(in_avStr)
        else if(匹配特征库(in_avStr, _欧美无码_特征库))
            _avInfo := new Av作品欧美无码Info(in_avStr)

        return _avInfo
    }
}

按特征库提取字符串(in_avStr, in_特征库){
    _特征库 := in_特征库
    _result := ""
    ; 匹配特征
    for _i, _特征 in _特征库 {
        if(RegExMatch(in_avStr, _特征, _match)>0){
            _result := _match1
            Break
        }
    }
    ; 返回结果
    return _result
}

按特征库提取tags(in_avStr, _特征库){
    _tags := []
    ; 匹配特征
    _tagsStr := strTrim(按特征库提取字符串(in_avStr, _特征库), "_ ")
    ; 优先以下划线分割tags, 标准以空格分隔
    if(InStr(_tagsStr,"_"))
        _tags := str_Split(_tagsStr, "_")
    else
        _tags := str_Split(_tagsStr, " ")
    ; 返回结果
    return _tags
}

匹配特征库(in_avStr, in_特征库){
    _特征库 := in_特征库
    _result := false
    ; 匹配特征
    for _i, _特征 in _特征库 {
        if(RegExMatch(in_avStr, _特征, _match)>0){
            _result := true
            Break
        }
    }
    ; 返回结果
    return _result
}

; ----------------------------------------------------------

模板_av作品标签(){
    return "#av作品#"
}

模板_av导演标签(){
    return "#av导演#"
}

模板_av制作商标签(){
    return "#av制作商#"
}

模板_av发行商标签(){
    return "#av发行商#"
}

模板_av系列标签(){
    return "#av系列#"
}

模板_av类别标签(){
    return "#av类别#"
}

模板_av搜索标签(){
    return "#av搜索#"
}

; ----------------------------------------------------------

模板_av女优标签(){
    return "#av女优#"
}

模板_生日(){
    return "1990-00-00"
}

模板_tags(_tags*){
    if(_tags.MaxIndex()>0){
        _标签内容:= ""
        for index, _tag in _tags
            _标签内容 .= _tag . " "
        return "tags(" . SubStr(_标签内容, 1, -1) . ")"
    }
    else
        return "tags(标签)"
}


; 针对tags(美颜_乳g_熟女) 中的下划线清理
; 转换为空格间隔 tags(美颜 乳g 熟女)
模板_tags_format(_avStr){
    if(RegExMatch(_avStr, "O)((\S+)?\(.+\))", _match)){
        _tagsStr := _match.value(1)
        _result := ""
        _tags := SubStr(_tagsStr, InStr(_tagsStr, "(")+1, -1)
        _tags := StrReplace(_tags, "_", " ")
        _result := "tags(" . _tags . ")"
        ;替换源字符串中的tags内容
        _result := StrReplace(_avStr, _tagsStr, _result)
    }
    else
        _result := _avStr
    return _result
}

模板_评级(){
    return "★★★"
}

模板_日期(){
    return Sys.date()
}

模板_日期_format(_avStr) {
    _matchStr := "(\d{2,4})[-年/\\.](\d{1,2})[-月/\\.](\d{1,2})日?"
    _replaceStr := "$1-$2-$3"
    _result := RegExReplace(_avStr, _matchStr, _replaceStr)
    return _result
}

; ----------------------------------------------------------


; av作品_查询已看过(_in查询av编号)
; 返回值: -1 失败, >0 存在已看过作品
av作品_查询已看过(_in查询av编号){
    _result := -1
    _查询名称 := "av作品"
; 1.清洗av编号: 全部小写,包含"-_"
    _查询关键字 := Format("{:L}", _in查询av编号)
; 2.从_查询文件"已看过的_av作品.txt"文件中, 读取所有非空行到_查询列表
    _每行编辑格式 := "每行编辑格式:`n av编号(key), 评级(0烂片-3精品), 演员(可空 空格间隔), 标签(可空 空格间隔)"
    _查询文件 := Config.upath("已看过的av作品")
    _查询列表 := []
    ; 检查文件是否存在
    if(FileExist(_查询文件)){
        ; 读取文件到列表
        Loop, read, %_查询文件%
        {
            if(trim(A_LoopReadLine) != "")
                ; 清洗查询文件的脏数据, 这里加入Format("{:L}",A_LoopReadLine) 小写字母转换
                _查询列表.push(StrSplit(Format("{:L}",A_LoopReadLine), ","))
        }
        ; 在查询列表中根据关键字, 查询数据行索引号
        Loop % _查询列表.Length()
        {
            if(_查询关键字 == _查询列表[A_Index][1])
            {
                _result := A_Index
                break
            }
        }
    }
    else{
        MsgBox 指定文件路径不存在:`n %_查询文件% `n`n下一步将新建文件
    }

; 3. 用input窗口显示数据行内容, 按ok键可保存修改
    _初始行内容 := ""
    _修改后的行内容 := ""
    ; 根据是否存在已有数据行区别对待
    if(_result>0){
        ; 如果已存在, 则显示已有信息, 按ok可保存修改
        Loop % _查询列表[_result].Length()
        {
            _初始行内容 .= _查询列表[_result][A_Index] . ","
        }
        _初始行内容 := trim(_初始行内容, ",")
        InputBox, _input修改后的行内容, 编辑%_查询名称%, 指定%_查询名称%存在`, 编辑%_查询名称%`n`n%_每行编辑格式%, , 640, 320,,,,,%_初始行内容%
        _修改后的行内容 := Format("{:L}",_input修改后的行内容)
        if ErrorLevel
            MsgBox, 用户取消编辑, 未保存.
        else{
            if(trim(_修改后的行内容) == ""){
                MsgBox, 编辑内容为空`n`n结束查询操作!
                return _result
            }
            ; 保存修改后的数据行
            ; 保存到列表
            _查询列表[_result] := StrSplit(Trim(_修改后的行内容), ",")
            ; 保存到文件
            CsvFile.writeListToCsv(_查询列表, _查询文件)
            MsgBox, 编辑内容已保存`n`n%_修改后的行内容%
        }
    }
    else{
        ; 如果未存在, 则显示添加信息, 按ok可保存修改
        InputBox, _input修改后的行内容, 添加%_查询名称%, 指定%_查询名称%不存在`, 添加%_查询名称%`n`n%_每行编辑格式%, , 640, 320,,,,,%_查询关键字%
        _修改后的行内容 := Format("{:L}",_input修改后的行内容)
        if ErrorLevel
            MsgBox, 用户取消编辑, 未保存.
        else{
            if(trim(_修改后的行内容) == ""){
                MsgBox, 编辑内容为空`n`n结束查询操作!
                return _result
            }
            ; 保存修改后的数据行
            ; 保存到列表
            _查询列表.push(StrSplit(Trim(_修改后的行内容), ","))
            ; 保存到文件
            CsvFile.writeListToCsv(_查询列表, _查询文件)
            MsgBox, 新内容已保存`n`n%_修改后的行内容%
            ; 结果指向最后一个元素索引
            _result := _查询列表.Length()
        }
    }
    return _result
}

; av女优_查询已看过(_in查询av女优名)
; 返回值: -1 失败, >0 存在已看过女优
av女优_查询已看过(_in查询av女优名){
    _result := -1
    _查询名称 := "av女优"
; 1.清洗av女优名: 全部小写,包含"-_"
    _查询关键字 := Format("{:L}", _in查询av女优名)
; 2.从_查询文件"已看过的_精品av女优.txt"文件中, 读取所有非空行到_查询列表
    _每行编辑格式 := "每行编辑格式:`n 女优名(key), 评分(0烂-3精品), 生日(可空), 罩杯(a-z), 标签(可空 空格间隔)"
    _查询文件 := Config.upath("已看过的av女优")
    _查询列表 := []
    ; 检查文件是否存在
    if(FileExist(_查询文件)){
        ; 读取文件到列表
        Loop, read, %_查询文件%
        {
            if(trim(A_LoopReadLine) != "")
                ; 清洗查询文件的脏数据, 这里加入Format("{:L}",A_LoopReadLine) 小写字母转换
                _查询列表.push(StrSplit(Format("{:L}",A_LoopReadLine), ","))
        }
        ; 在查询列表中根据关键字, 查询数据行索引号
        Loop % _查询列表.Length()
        {
            if(InStr(_查询列表[A_Index][1], _查询关键字) > 0)
            {
                _result := A_Index
                return _result
            }
        }
    }
    else{
        MsgBox 指定文件路径不存在:`n %_查询文件% `n`n下一步将新建文件
    }

; 3. 用input窗口显示数据行内容, 按ok键可保存修改
    _初始行内容 := ""
    _修改后的行内容 := ""
    ; 根据是否存在已有数据行区别对待
    if(_result>0){
        ; 如果已存在, 则显示已有信息, 按ok可保存修改
        Loop % _查询列表[_result].Length()
        {
            _初始行内容 .= _查询列表[_result][A_Index] . ","
        }
        _初始行内容 := trim(_初始行内容, ",")
        InputBox, _input修改后的行内容, 编辑%_查询名称%, 指定%_查询名称%存在`, 编辑%_查询名称%`n`n%_每行编辑格式%, , 640, 320,,,,,%_初始行内容%
        _修改后的行内容 := Format("{:L}",_input修改后的行内容)
        if ErrorLevel
            MsgBox, 用户取消编辑, 未保存.
        else{
            if(trim(_修改后的行内容) == ""){
                MsgBox, 编辑内容为空`n`n结束查询操作!
                return _result
            }
            ; 保存修改后的数据行
            if(InStr(_修改后的行内容, "#av女优#") > 0){
                ; 如果是格式化的内容, 则直接解析
                avGirlInfo := new AvGirlInfo(_修改后的行内容)
                _修改后的行内容 := avGirlInfo.toCsvStr()
            }
            ; 保存到列表
            _查询列表[_result] := StrSplit(Trim(_修改后的行内容), ",")
            ; 保存到文件
            CsvFile.writeListToCsv(_查询列表, _查询文件)
            MsgBox, 编辑内容已保存`n`n%_修改后的行内容%
        }
    }
    else{
        ; 如果未存在, 则显示添加信息, 按ok可保存修改
        InputBox, _input修改后的行内容, 添加%_查询名称%, 指定%_查询名称%不存在`, 添加%_查询名称%`n`n%_每行编辑格式%, , 640, 320,,,,,%_查询关键字%
        _修改后的行内容 := Format("{:L}",_input修改后的行内容)
        if ErrorLevel
            MsgBox, 用户取消编辑, 未保存.
        else{
            if(trim(_修改后的行内容) == ""){
                MsgBox, 编辑内容为空`n`n结束查询操作!
                return _result
            }
            ; 保存修改后的数据行
            if(InStr(_修改后的行内容, "#av女优#") > 0){
                ; 如果是格式化的内容, 则直接解析
                avGirlInfo := new AvGirlInfo(_修改后的行内容)
                _修改后的行内容 := avGirlInfo.toCsvStr()
            }
            ; 保存到列表
            _查询列表.push(StrSplit(Trim(_修改后的行内容), ","))
            ; 保存到文件
            CsvFile.writeListToCsv(_查询列表, _查询文件)
            MsgBox, 新内容已保存`n`n%_修改后的行内容%
            ; 结果指向最后一个元素索引
            _result := _查询列表.Length()
        }
    }
    return _result
}
