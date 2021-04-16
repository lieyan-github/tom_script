; ==========================================================
; Av.class.ahk  AV管理
;
; 文档作者: 烈焰
;
; 修改时间: 2018-02-21 01:52:26
; ==========================================================

; class Av
class 符号 {
    static avtags间隔符:= "｜"
}


; ==========================================================
class Av {
    _模板 := {}

    static 特征库 := {"女优": ["^#av女优#\s★*\s(\S+?)\s"
                                , "^(\S+)\s-\s演員"
                                , "演员\((.*?)\)"
                                , "(?:類別 正體中文 |類別 )(\S+)"]
                    , "有码作品": ["i)([a-z]{2,6}-\d{2,5}\s)"]
                    , "无码作品": ["i)(carib[a-z]*[-_]\d{6}[-_]\d{3})"
                                    , "i)(\d{6}[-_]\d{3}[-_]carib)"
                                    , "i)(1pon[a-z]*[-_]\d{6}[-_]\d{3})"
                                    , "i)(\d{6}[-_]\d{3}[-_]1pon[a-z]*)"]
                    , "欧美作品": ["\S{3,}\s-\s.+\s-\s(.+)\s(tags)?\(.+\)"
                                    , "\S{3,}\s-\s.+\s-\s(.+)"]}

    获取特征库(){
        _ret := {}

        _ret["女优"] := []
        _ret["女优"].push({"match": "^#av女优#\s★*\s(\S+?)\s", "replace": ""})
        _ret["女优"].push({"match": "^(\S+)\s-\s演員", "replace": ""})
        _ret["女优"].push({"match": "演员\((.*?)\)", "r": ""})
        _ret["女优"].push({"match": "(?:類別 正體中文 |類別 )(\S+)", "replace": ""})

        ; ----------------------------------------------------------
        _ret["有码作品"] := []
        _ret["有码作品"].push({"match": "i)([a-z]{2,6}-\d{2,5})\s", "replace": ""})

        ; ----------------------------------------------------------
        _ret["无码作品"] := {}
        _ret["无码作品"].push({"match": "i)(carib[a-z]*[-_](\d{6})[-_](\d{3}))", "replace": "carib-$2-$3"})
        _ret["无码作品"].push({"match": "i)((\d{6})[-_](\d{3})[-_]carib[a-z]*)", "replace": "carib-$2-$3"})

        _ret["无码作品"].push({"match": "i)(1pon[a-z]*[-_](\d{6})[-_](\d{3}))", "replace": "1pon-$2-$3"})
        _ret["无码作品"].push({"match": "i)((\d{6})[-_](\d{3})[-_]1pon[a-z]*)", "replace": "1pon-$2-$3"})

        _ret["无码作品"].push({"match": "i)(CAPPV[a-z]*[_-](\d{6})[_-](\d{3}))", "replace": "CAPPV-$2-$3"})
        _ret["无码作品"].push({"match": "i)((\d{6})[-_](\d{3})[-_]CAPPV[a-z]*)", "replace": "CAPPV-$2-$3"})

        _ret["无码作品"].push({"match": "i)(heyzo[a-z]*[_-](\d{6})[_-](\d{3}))", "replace": "heyzo-$2-$3"})
        _ret["无码作品"].push({"match": "i)((\d{6})[-_](\d{3})[-_]heyzo[a-z]*)", "replace": "heyzo-$2-$3"})

        ; ----------------------------------------------------------
        _ret["欧美作品"] := []
        _ret["欧美作品"].push({"match": "\S{3,}\s-\s.+\s-\s(.+)\s(tags)?\(.+\)", "replace": ""})
        _ret["欧美作品"].push({"match": "\S{3,}\s-\s.+\s-\s(.+)", "replace": ""})

        return _ret
    }

    _init(){
        this._模板["作品标签"] := "#av作品#"
        this._模板["制作商标签"] := "#av制作商#"
        this._模板["发行商标签"] := "#av发行商#"
        this._模板["导演标签"] := "#av导演#"
        this._模板["类别标签"] := "#av类别#"
        this._模板["系列标签"] := "#av系列#"
        this._模板["搜索标签"] := "#av搜索#"
        ;---
        this._模板["女优标签"] := "#av女优#"
        this._模板["生日"] := "1990-00-00"
        this._模板["tags"] := "tags(标签)"
        this._模板["评级"] := "★★★"
        this._模板["日期"] := Sys.date()
    }

    ; 获取tags格式, 为输入做提示建议
    get_tags格式(_type, _isHelp, _间隔符:="｜", _行间隔符:="`n"){
        _return := ""
        _tags_av := Av.get_tags_json(_type)

        if(! _isHelp){
            ; 关注的几个关键点(颜值, 是否美丰乳罩杯, 是否美臀, 性格是否活泼, 其他特点或技能演技, 是否诱惑, 是否精品女优)
            ; _return := "长相漂亮｜乳f｜美臀｜丰满｜熟女 80后｜演技｜技能｜特点｜极品诱惑｜精品女优"
            Loop % _tags_av.Length() {
                _return .= _tags_av[A_Index].item . _间隔符
            }
            _return := trim(_return, _间隔符)
        }
        else{
            Loop % _tags_av.Length() {
                _tag_可选项 := ""
                _index      := A_Index

                Loop % _tags_av[_index].可选项.Length() {
                    _tag_可选项 .=  _tags_av[_index].可选项[A_Index] . " "
                }
                _tag_可选项 := trim(_tag_可选项, " ")

                _return     .= format("{1}{2}{3}{4}{5}{6}"
                                , _tags_av[A_Index].item
                                , _间隔符
                                , _tag_可选项
                                , _间隔符
                                , _tags_av[A_Index].备注
                                , _行间隔符)
            }
            ; _return := format("{1}长相｜漂亮 一般 丑"
            ;                 . "{1}乳房｜巨乳h-L 美丰乳d-g 小乳a-c"
            ;                 . "{1}臀部｜蜜桃臀 美丰臀 扁臀"
            ;                 . "{1}身材｜丰满 苗条 骨感"
            ;                 . "{1}年龄｜熟女 少妇 萝莉 xx后"
            ;                 . "{1}演技｜风骚 活泼 生硬"
            ;                 . "{1}技能｜湿吻 舌舔 腰振 口交 乳交 肛交 自摸 女同 sm (任何主动性动作 或 能承受的东西)"
            ;                 . "{1}特点｜呻吟 母乳 痉挛 潮吹 淫荡 (任何被动性 或 表现出来的东西)"
            ;                 . "{1}诱惑｜极品诱惑 诱惑 无"
            ;                 . "{1}星评｜精品女优 无"
            ;                 , _tags_行间隔符)

        }
        Return _return
    }

    ; 返回指定类型的默认值, 比如返回av女优的默认值为第三个"好看"
    get_tags默认值(a_type, a_item){
        _tags_av := Av.get_tags_json(a_type)
        Loop % _tags_av.Length() {
            if(_tags_av[A_Index]["item"] == a_item)
                return _tags_av[A_Index]["默认值"]
        }
        return ""
    }

    ; 返回tags json对象
    get_tags_json(_type){
        return (JsonFile.read(Config.upath("tags_av")))[_type]
    }

    ; static pubic 模板(_type)
    模板(_type){
        av := new Av()
        av._init()
        return av._模板[_type]
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
        if(_avTitle ~= "(?:^#av)"){
            ; 对已格式化内容, 仅对日期进行格式化
            ; 有待进一步增加功能
            _result := 模板_日期_format(_avTitle)
            _result := 模板_tags_format(_result)
            show_msg("已格式化内容, 不需要操作!")
        }
        else if(_avTitle ~= "\s{1,2}-\s{1,2}\w{2,6}$"){
            ; 如果类似收藏夹的范围, 判断收藏名称格式是否匹配
            _result := Av.rename_收藏夹(_avTitle)
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
        ; 收集捕捉新的av信息
        av数据捕捉_api(_result, "add")
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
                if(RegExMatch(clipboard, format("(?:{1})", 正则表达式.模板("日期")), _date)>0)
                {
                    ;如果剪贴板里存有日期, 则当成是已存储的生日
                    _生日 := AvGirlInfo.提取生日(clipboard)
                    _罩杯 := AvGirlInfo.提取bra(clipboard)
                    if(_罩杯 != "")
                        _罩杯 := "乳" . _罩杯
                    ;重命名.replaceStr := "#av女优# " . "★" . " $1 " . _生日 . " tags(美颜" . _罩杯 . ") " . Sys.date() . "$2"
                    重命名.replaceStr := format("{1} {2} {3} {4} {5} {6} {7}"
                                                , Av.模板("女优标签")
                                                , Av.模板("评级")
                                                , "$1"
                                                , _生日
                                                , 模板_tags_create("长相" . Av.get_tags默认值("av女优", "长相"), _罩杯)
                                                , Av.模板("日期")
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
                            , Av.模板("作品标签")
                            , Av.模板("评级")
                            , "$1"
                            , "$2"
                            , "$3"
                            , Av.模板("tags"))
    ; protected rename() overwrite
    rename(){
        if(RegExMatch(this.result, this.matchStr, _匹配值)>0){
            ;如果检测包含女优名, 则匹配三项, 并对第二项标题部分, 将空格替换下划线, 然后截取前16个字符;
            ;this.result := "#av作品# ★★ " . _匹配值1 . " " . SubStr(StrReplace(_匹配值2, " ", "_"), 1, 16) . " " . _匹配值3 . " (备注)"
            this.result := format("{1} {2} {3} {4} {5} {6}"
                            , Av.模板("作品标签")
                            , Av.模板("评级")
                            , _匹配值1
                            , SubStr(StrReplace(_匹配值2, " ", "_"), 1, 16)
                            , _匹配值3
                            , Av.模板("tags"))
        }
        else if(RegExMatch(this.result, this.matchStrNoName, _匹配值)>0){
            ;如果检测包含女优名, 则匹配两项, 并对第二项标题部分, 将空格替换下划线, 然后截取前16个字符;
            ;this.result := "#av作品# ★★ " . _匹配值1 . " " . SubStr(StrReplace(_匹配值2, " ", "_"), 1, 16) . " (备注)"
            this.result := format("{1} {2} {3} {4} {5}"
                            , Av.模板("作品标签")
                            , Av.模板("评级")
                            , _匹配值1
                            , SubStr(StrReplace(_匹配值2, " ", "_"), 1, 16)
                            , Av.模板("tags"))
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
                            , Av.模板("作品标签")
                            , Av.模板("评级")
                            , _av2
                            , _av3
                            , Av.模板("tags"))
                show_msg(_av2 . "-" . _av3)
            }
            else{
                ;this.result :=  "#av作品# ★ " . _av2 . " " . trim(_av1) . "_" . _av3 . " (备注)"
                this.result := format("{1} {2} {3} {4}_{5} {6}"
                            , Av.模板("作品标签")
                            , Av.模板("评级")
                            , _av2
                            , _av1
                            , _av3
                            , Av.模板("tags"))
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
                            , Av.模板("作品标签")
                            , Av.模板("评级")
                            , "$1"
                            , Av.模板("日期")
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
    matchStr := "(.*?)\s(-\s.*)"
    replaceStr := format("{1} {2} {3} {4} {5} {6} {7}"
                            , Av.模板("女优标签")
                            , Av.模板("评级")
                            , "$1"
                            , Av.模板("生日")
                            , Av.模板("tags")
                            , Av.模板("日期")
                            , "$2")
}

; ----------------------------------------------------------
; Av导演重命名_收藏夹
; ----------------------------------------------------------
class Av导演重命名_收藏夹 extends Renamer {
    matchStr := "(.*?)(\s-\s.*)"
    replaceStr := format("{1} {2} {3} {4} {5} {6}"
                    , Av.模板("导演标签")
                    , Av.模板("评级")
                    , "$1"
                    , Av.模板("tags")
                    , Av.模板("日期")
                    , "$2")
}

; ----------------------------------------------------------
; Av制作商重命名_收藏夹
; ----------------------------------------------------------
class Av制作商重命名_收藏夹 extends Renamer {
    matchStr := "(.*?)(\s-\s.*)"
    replaceStr := format("{1} {2} {3} {4} {5} {6}"
                    , Av.模板("制作商标签")
                    , Av.模板("评级")
                    , "$1"
                    , Av.模板("tags")
                    , Av.模板("日期")
                    , "$2")
}

; ----------------------------------------------------------
; Av发行商重命名_收藏夹
; ----------------------------------------------------------
class Av发行商重命名_收藏夹 extends Renamer {
    matchStr := "(.*?)(\s-\s.*)"
    replaceStr := format("{1} {2} {3} {4} {5} {6}"
                    , Av.模板("发行商标签")
                    , Av.模板("评级")
                    , "$1"
                    , Av.模板("tags")
                    , Av.模板("日期")
                    , "$2")
}

; ----------------------------------------------------------
; Av系列重命名_收藏夹
; ----------------------------------------------------------
class Av系列重命名_收藏夹 extends Renamer {
    matchStr := "(.*?)(\s-\s.*)"
    replaceStr := format("{1} {2} {3} {4} {5} {6}"
                    , Av.模板("系列标签")
                    , Av.模板("评级")
                    , "$1"
                    , Av.模板("tags")
                    , Av.模板("日期")
                    , "$2")
}

; ----------------------------------------------------------
; Av类别重命名_收藏夹
; ----------------------------------------------------------
class Av类别重命名_收藏夹 extends Renamer {
    matchStr := "(.*?)(\s-\s.*)"
    replaceStr := format("{1} {2} {3} {4} {5} {6}"
                    , Av.模板("类别标签")
                    , Av.模板("评级")
                    , "$1"
                    , Av.模板("tags")
                    , Av.模板("日期")
                    , "$2")
}

; ----------------------------------------------------------
; Av搜索重命名_收藏夹
; ----------------------------------------------------------
class Av搜索重命名_收藏夹 extends Renamer {
    matchStr := "^(.*)(\s-\s.*)"
    replaceStr := format("{1} {2} {3} {4} {5} {6}"
                    , Av.模板("搜索标签")
                    , Av.模板("评级")
                    , "$1"
                    , Av.模板("tags")
                    , Av.模板("日期")
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

    ; 识别av字符串是否属于某种类型, 比如av女优, av有码作品, av无码作品 ...
    识别特征(in_avStr){
        return 匹配特征库含重命名(in_avStr, this.识别特征库())
    }
    ; 识别特征() 配套的特征库
    识别特征库(){
        return []
    }

    ; 提取评级
    ; 格式化特征: ★+
    提取评级(in_avStr){
        _特征库 := ["(★+)"]
        _评级   := ""
        ; 匹配特征
        _评级 := StrLen(按特征库提取字符串(in_avStr, _特征库))
        _评级 := _评级>0 ? _评级 : 1
        ; 返回结果
        return _评级
    }

    ; 提取tags
    ; 1. 格式化特征: tags(...)
    ; 2. 未格式化特征: (...)
    提取tags(in_avStr){
        _特征库 := ["tags\((.+?)\)"
                    , "\s\((.+?)\)"
                    , "#\((.+?)\)"]
        return 按特征库提取tags(in_avStr, _特征库)
    }

    ; 提取备注
    ; 格式化特征: 备注(...)
    提取备注(in_avStr){
        _特征库 := ["备注\((.*?)\)"]
        _备注   := ""
        ; 匹配特征
        _备注 := 按特征库提取字符串(in_avStr, _特征库)
        ; 返回结果
        return _备注
    }

    ; toStr()
    ; 参数: _type
    ;       all 输出标准字符串格式, 包含所有属性
    ;       ""  输出标准字符串格式, 常用简化内容
    toStr(_type:=""){
        if("all" == _type)
            return this.formatStr("all")
        else
            return this.formatStr()
    }

    ; 转Csv格式字符串
    toCsvStr(){
        return ""
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
                    , 类型: Av.模板("女优标签")
                    , 地区: "日本"
                    , 评级: 1
                    , 名字: []
                    , 生日: ""
                    , bra: ""
                    , tags: []
                    , 备注: ""
                    , 登记时间: Av.模板("日期")}
        if(in_avStr!=""){
            this.提取全部(in_avStr)
        }
    }

    ; 识别特征() 配套的特征库
    识别特征库(){
        return  (Av.获取特征库())["女优"]
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

    ; public formatStr()
    ; [输出格式化]
    ; #av女优# ★★★ 女优名 2000-03-05 地区(日本) tags(美颜_乳c_风骚_诱惑) 备注(备注内容...)
    formatStr(_type:=""){
        _out := ""
        if("all" == _type)
            ; 所有info内容格式化
            _out := Format("{1} {2} {3} {4} 地区({5}) tags({6}) 备注({7})"
                            , this.info["类型"]
                            , strN("★", this.info["评级"])
                            , list_join(this.info["名字"], "_")
                            , this.info["生日"]
                            , this.info["地区"]
                            , list_join(this.info["tags"], " ")
                            , this.info["备注"])
        else
            ; 标准info格式化
            _out := Format("{1} {2} {3} {4} tags({5})"
                            , this.info["类型"]
                            , strN("★", this.info["评级"])
                            , list_join(this.info["名字"], "_")
                            , this.info["生日"]
                            , list_join(this.info["tags"], " "))
        return _out
    }

    toCsvStr(){
        _str := Format("{1},{2},{3},{4},{5}"
                        , list_join(this.info["名字"], "_")
                        , this.info["评级"]
                        , this.info["生日"]
                        , this.info["bra"]
                        , list_join(this.info["tags"], 符号.avtags间隔符))
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

    提取生日(in_avStr){
        _特征库 := []
        _特征库.push(Format("({1})", 正则表达式.模板("日期")))
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
                    , 类型: Av.模板("作品标签")
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
                    , 登记时间: Av.模板("日期")}
        if(in_avStr!=""){
            this.提取全部(in_avStr)
        }
    }

    ; 识别特征() 配套的特征库
    识别特征库(){
        return  (Av.获取特征库())["有码作品"]
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

    ; public formatStr()
    ; [收藏夹内容]
    ; #av作品# ★★★ MIDE-255 巨乳女教師の匂い立つ汗と愛液 神咲詩織_真木今日子 (美乳_激情诱惑) 2016-03-07 - AVMOO
    ; [输出格式化]
    ; #av作品# ★★★ MIDE-255 巨乳女教師の匂い立つ汗と愛液 演员(神咲詩織 真木今日子) tags(美颜_乳c_风骚_诱惑) 地区(日本) 有码 导演(紋℃) 制作商(ムーディーズ) 发行商(MOODYZ DIVA) 备注(备注内容...)
    formatStr(_type:=""){
        _out := ""
        if("all" == _type)
            ; 所有info内容格式化
            _out := format("{1} {2} {3} {4} 演员({5}) tags({6}) 地区({7}) {8} 导演({9}) 制作商({10}) 发行商({11}) 系列({12})"
                            , this.info["类型"]
                            , strN("★", this.info["评级"])
                            , this.info["编号"]
                            , this.info["标题"]
                            , list_join(this.info["演员"], " ")
                            , list_join(this.info["tags"], " ")
                            , this.info["地区"]
                            , this.info["是否无码"]
                            , this.info["导演"]
                            , this.info["制作商"]
                            , this.info["发行商"]
                            , this.info["系列"])
        else
            ; 标准info格式化
            ; #av作品# ★★★ MIDE-255 巨乳女教師の匂い立つ汗と愛液 神咲詩織_真木今日子 tags(美颜 乳c 风骚 诱惑)
            _out := format("{1} {2} {3} {4} {5} tags({6})"
                            , this.info["类型"]
                            , strN("★", this.info["评级"])
                            , this.info["编号"]
                            , this.info["标题"]
                            , list_join(this.info["演员"], " ")
                            , list_join(this.info["tags"], " "))
        return _out
    }

    toCsvStr(){
        _str := Format("{1},{2},{3},{4}"
                        , this.info["编号"]
                        , this.info["评级"]
                        , list_join(this.info["演员"], " ")
                        , list_join(this.info["tags"], 符号.avtags间隔符))
        return _str
    }

    ; ----------------------------------------------------------
    ; public static 提取av作品的相关信息, 第一个特征都设置为标准模式
    ; ----------------------------------------------------------
    提取编号(in_avStr){
        _特征库 := (Av.获取特征库())["有码作品"]
        _编号   := ""
        ; 匹配特征
        _编号 := format("{:L}", 按特征库提取字符串含重命名(in_avStr, _特征库))
        return _编号
    }

    提取标题(in_avStr){
        _特征库 := ["^#av\S+#\s★*\s\S+\s(\S+)"
                    , "\S+-\S+ (\S+) .+"
                    , "(?:類別 正體中文 |類別 )[a-zA-z]+-\d+ (\S+)"]
        _标题   := ""
        ; 匹配特征
        _标题 := 按特征库提取字符串(in_avStr, _特征库)
        ; 返回结果
        return _标题
    }

    提取演员(in_avStr){
        _特征库 := ["演员\((.*?)\)"
                    , "^#av\S+#\s★*\s\S+\s\S+\s(.+)\s(tags)?\(.+\)"
                    , "^(\S+)\s-\s演員"
                    , "推薦 演員.(.+?).(?:樣品圖像|下載)"
                    , "\S+-\S+ \S+ (.+)"]
        _演员列表 := []
        ; 匹配特征
        _演员列表 := str_Split(strTrim(按特征库提取字符串(in_avStr, _特征库)
                                        , " ")
                                , " ")
        ; 返回结果
        return _演员列表
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

    ; 识别特征() 配套的特征库
    识别特征库(){
        return  (Av.获取特征库())["无码作品"]
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

    ; public formatStr()
    ; [标准格式]
    ; #av作品# ★★ carib-060215-890 一本道~乳神 佐山愛 真木今日子 tags(极品诱惑_丰乳_风骚)
    ; [输出格式化]
    ; #av作品# ★★ carib-060215-890 一本道~乳神 演员(佐山愛 真木今日子) tags(极品诱惑 丰乳 风骚) 地区(日本) 无码 导演() 制作商() 发行商() 备注()
    formatStr(_type:=""){
        _out := ""
        if("all" == _type)
            ; 所有info内容格式化
            _out := format("{1} {2} {3} {4} 演员({5}) tags({6}) 地区({7}) {8} 导演({9}) 制作商({10}) 发行商({11}) 系列({12})"
                            , this.info["类型"]
                            , strN("★", this.info["评级"])
                            , this.info["编号"]
                            , this.info["标题"]
                            , list_join(this.info["演员"], " ")
                            , list_join(this.info["tags"], " ")
                            , this.info["地区"]
                            , this.info["是否无码"]
                            , this.info["导演"]
                            , this.info["制作商"]
                            , this.info["发行商"]
                            , this.info["系列"])
        else
            ; 标准info格式化
            ; #av作品# ★★ carib-060215-890 一本道~乳神 佐山愛 真木今日子 tags(极品诱惑 丰乳 风骚)
            _out := format("{1} {2} {3} {4} {5} tags({6})"
                            , this.info["类型"]
                            , strN("★", this.info["评级"])
                            , this.info["编号"]
                            , this.info["标题"]
                            , list_join(this.info["演员"], " ")
                            , list_join(this.info["tags"], " "))
        return _out
    }

    toCsvStr(){
        _str := Format("{1},{2},{3},{4}"
                        , this.info["编号"]
                        , this.info["评级"]
                        , list_join(this.info["演员"], " ")
                        , list_join(this.info["tags"], 符号.avtags间隔符))
        return _str
    }

    ; ----------------------------------------------------------
    ; public static 提取av作品的相关信息, 第一个特征都设置为标准模式
    ; ----------------------------------------------------------
    提取编号(in_avStr){
        _特征库 := (Av.获取特征库())["无码作品"]
        _编号   := ""
        ; 匹配特征, 并按特征replace进行重命名结构
        _编号 := format("{:L}", 按特征库提取字符串含重命名(in_avStr, _特征库))
        return _编号
    }

    提取标题(in_avStr){
        _特征库 := ["^#av\S+#\s★*\s\S+\s(\S+)"
                    , "\S+-\S+-\S+ (\S+) .+"
                    , "(?:類別 正體中文 |類別 )[a-zA-z]+-\d+ (\S+)"]
        _标题   := ""
        ; 匹配特征
        _标题 := 按特征库提取字符串(in_avStr, _特征库)
        ; 返回结果
        return _标题
    }

    提取演员(in_avStr){
        _特征库 := ["演员\((.*?)\)"
                    , "^#av\S+#\s★*\s\S+\s\S+\s(.+)\s(tags)?\(.+\)"
                    , "^#av\S+#\s★*\s\S+\s\S+\s(.+)"
                    , "^(\S+)\s-\s演員"
                    , "推薦 演員.(.+?).(?:樣品圖像|下載)"
                    , "\S+-\S+-\S+ \S+ (.+)"]
        _演员列表 := []
        ; 匹配特征
        _演员列表 := str_Split(strTrim(按特征库提取字符串(in_avStr, _特征库)
                                        , " ")
                                , " ")
        ; 返回结果
        return _演员列表
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

    ; 识别特征() 配套的特征库
    识别特征库(){
        return  (Av.获取特征库())["欧美作品"]
    }

    ; public 提取全部(in_avStr)
    提取全部(in_avStr){
        _avStr:= in_avStr
        this.info.评级    := this.提取评级(_avStr)
        ; 欧美没有编号
        this.info.标题    := this.提取标题(_avStr)
        this.info.演员    := this.提取演员(_avStr)
        this.info.tags    := this.提取tags(_avStr)
        ; 确认是欧美, 也就确定地区是欧美, 并且是无码
        ; 欧美没有导演和发行商, 只有制作商
        this.info.制作商  := this.提取制作商(_avStr)
    }

    ; public formatStr()
    ; [一般欧美作品文件名格式]
    ; DorcelClub - Anna Polina, Tina Kay - Mes Nuits En Prison
    ; [格式化后的欧美作品名]
    ; #av作品# ★★★ DorcelClub - Anna Polina, Tina Kay - Mes Nuits En Prison tags(极品 诱惑)
    ; [输出格式化all]
    ; #av作品# ★★★ 制作商 - 演员名1, 演员名2 - 作品标题 tags(极品 诱惑) 地区(欧美) 无码
    formatStr(_type:=""){
        _out := ""
        if("all" == _type)
            ; 所有info内容格式化
            ; #av作品# ★★★ 制作商(DorcelClub) 演员(Anna Polina, Tina Kay) 标题(Mes Nuits En Prison) tags(极品 诱惑) 地区(欧美) 无码
            _out := format("{1} {2} 制作商({3}) 演员({4}) 标题({5}) tags({6}) 地区({7}) {8}"
                            , this.info["类型"]
                            , strN("★", this.info["评级"])
                            , this.info["制作商"]
                            , list_join(this.info["演员"], ", ")
                            , this.info["标题"]
                            , list_join(this.info["tags"], " ")
                            , this.info["地区"]
                            , this.info["是否无码"])
        else
            ; 标准info格式化
            ; #av作品# ★★★ DorcelClub - Anna Polina,Tina Kay - Mes Nuits En Prison tags(极品 诱惑)
            _out := format("{1} {2} {3} - {4} - {5} tags({6})"
                            , this.info["类型"]
                            , strN("★", this.info["评级"])
                            , this.info["制作商"]
                            , list_join(this.info["演员"], ", ")
                            , this.info["标题"]
                            , list_join(this.info["tags"], " "))
        return _out
    }

    ; ----------------------------------------------------------
    ; public static 提取av作品的相关信息, 第一个特征都设置为标准模式
    ; ----------------------------------------------------------
    提取标题(in_avStr){
        _特征库 := ["标题\((.*?)\)"
                    , "\S{3,}\s-\s.+\s-\s(.+)\s(tags)?\(.+\)"
                    , "\S{3,}\s-\s.+\s-\s(.+)"
                    , "(?:類別 正體中文 |類別 )[a-zA-z]+-\d+ (\S+)"]
        _标题   := ""
        ; 匹配特征
        _标题 := 按特征库提取字符串(in_avStr, _特征库)
        ; 返回结果
        return _标题
    }

    提取演员(in_avStr){
        _特征库 := ["演员\((.*?)\)"
                    , "\S{3,}\s-\s(.+)\s-\s.+"]
        _演员列表 := []
        ; 匹配特征 欧美演员逗号间隔"Anna Polina,Tina Kay"
        _演员列表 := str_Split(strTrim(StrReplace(按特征库提取字符串(in_avStr, _特征库)
                                                    , ", ", ",")
                                        , ",")
                                , ",")
        ; 返回结果
        return _演员列表
    }

    提取制作商(in_avStr){
        _特征库 := ["制作商\((.*?)\)"
                    , "(\S{3,})\s-\s.+\s-\s.+"]
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
    __New(){
        this.avGirlInfo := new AvGirlInfo()
        this.av作品日本有码Info := new Av作品日本有码Info()
        this.av作品日本无码Info := new Av作品日本无码Info()
        this.av作品欧美无码Info := new Av作品欧美无码Info()
    }

    ; public static parse(in_avStr) return AvInfoObject
    ; 需要判断是
    ; 1. 日本av女优
    ; 2. 日本有码
    ; 3. 日本无码
    ; 4. 欧美无码
    parse(in_avStr){
        _avinfo := new AvInfoAnalysis()
        _ret := ""
        if(_avinfo.avGirlInfo.识别特征(in_avStr))
            _ret :=  _avinfo.avGirlInfo
        else if(_avinfo.av作品日本无码Info.识别特征(in_avStr))
            _ret :=  _avinfo.av作品日本无码Info
        else if(_avinfo.av作品日本有码Info.识别特征(in_avStr))
            _ret :=  _avinfo.av作品日本有码Info
        else if(_avinfo.av作品欧美无码Info.识别特征(in_avStr))
            _ret :=  _avinfo.av作品欧美无码Info
        return _ret
    }
}

按特征库提取字符串(in_avStr, in_特征库){
    _特征库 := in_特征库
    _ret := ""
    ; 匹配特征
    loop % _特征库.Length() {
        _特征 := _特征库[A_Index]
        if(RegExMatch(in_avStr, _特征, _match)>0){
            _ret := _match1
            Break
        }
    }
    ; 返回结果
    return _ret
}

; 按特征库提取字符串
; 特征库的replace选项, 提供字符串的结构调整
; in_特征库 = [{"match": "匹配特征", "replace": "重命名模式"}, ....]
按特征库提取字符串含重命名(in_avStr, in_特征库){
    _特征库 := in_特征库

    _ret := ""
    ; 匹配特征
    loop % _特征库.Length() {
        _特征 := _特征库[A_Index]
        if(RegExMatch(in_avStr, _特征["match"], _match)>0){
            _ret := _match1

            ; 如果需要重命名, 则按正则进行替换
            if(_特征["replace"] != ""){
                _ret := RegExReplace(_ret, _特征["match"], _特征["replace"])
            }

            Break
        }
    }
    ; 返回结果
    return _ret
}

匹配特征库(in_avStr, in_特征库){
    _特征库 := in_特征库
    _ret := false
    ; 匹配特征
    loop % _特征库.Length() {
        _特征 := _特征库[A_Index]
        if(RegExMatch(in_avStr, _特征, _match)>0){
            _ret := true
            Break
        }
    }
    ; 返回结果
    return _ret
}

; in_特征库 = [{"match": "匹配特征", "replace": "重命名模式"}, ....]
匹配特征库含重命名(in_avStr, in_特征库){
    _特征库 := in_特征库
    _result := false
    ; 匹配特征
    loop % _特征库.Length() {
        _特征 := _特征库[A_Index]
        if(RegExMatch(in_avStr, _特征["match"], _match)>0){
            _result := true
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
    else if(InStr(_tagsStr,"｜"))
        _tags := str_Split(_tagsStr, "｜")
    else
        _tags := str_Split(_tagsStr, " ")
    ; 返回结果
    return _tags
}

; ----------------------------------------------------------

; 模板_tags_create(_tags*)
; 创建tags字符串
模板_tags_create(_tags*){
    if(_tags.MaxIndex()>0){
        _标签内容:= ""
        for index, _tag in _tags
            _标签内容 .= _tag . " "
        return "tags(" . SubStr(_标签内容, 1, -1) . ")"
    }
    else
        return Av.模板("tags")
}

; 针对tags(美颜_乳g_熟女) 中的下划线清理
; 转换为空格间隔 tags(美颜 乳g 熟女)
模板_tags_format(_avStr){
    if(RegExMatch(_avStr, "O)((\S+)?\(.+\))", _match)){
        _tagsStr := _match.value(1)
        _result := ""
        _tags := SubStr(_tagsStr, InStr(_tagsStr, "(")+1, -1)
        _tags := StrReplace(_tags, "_", 符号.avtags间隔符)
        _tags := StrReplace(_tags, "美颜", "长相" . Av.get_tags默认值("av女优", "长相"))
        _result := "tags(" . _tags . ")"
        ;替换源字符串中的tags内容
        _result := StrReplace(_avStr, _tagsStr, _result)
    }
    else
        _result := _avStr
    return _result
}

模板_日期_format(_avStr) {
    _matchStr := 正则表达式.模板("日期")
    _replaceStr := "$1-$2-$3"
    _result := RegExReplace(_avStr, _matchStr, _replaceStr)
    return _result
}

; ----------------------------------------------------------

; av_查询已看过(_查询av关键字){
;     if(RegExMatch(_查询av关键字, "\d"))          ; 如果包含数字, 查询av作品
;         av作品_查询已看过(_查询av关键字)
;     else                                        ; 否则查询av女优
;         av女优_查询已看过(_查询av关键字)
; }

; av查询_作品(_in查询av编号)
; 返回值: -1 失败, >0 存在已看过作品
av查询_作品(_in查询av编号){
    return av_csv查询(_in查询av编号
                        , "av作品"
                        , Config.upath("db_av作品")
                        , "编辑格式:`n av编号(key), 评级(0烂片-3精品), 演员(可空 空格间隔), 标签(可空｜间隔),登记时间"
                        , "{1},2,演员,高画质 中字 无码｜影片亮点｜诱惑," . strDate()
                        , "分析_av查询_作品_输入内容"
                        , "检查_av查询_作品_行关键字")
}

分析_av查询_作品_输入内容(_str){
    _result := ""
    if(InStr(_str, "#av作品#") or InStr(_str, "#av剪辑#")){
        ; 如果是格式化的内容, 则直接解析
        _avInfo := AvInfoAnalysis.parse(_str)
        _avInfo.提取全部(_str)
        _result := _avInfo.toCsvStr()
    }

    return _result
}

检查_av查询_作品_行关键字(a_rowkey){
    if(a_rowkey ~= "\d")
        return True
    Else
        Return False
}

; av查询_女优(_in查询av女优名)
; 返回值: -1 失败, >0 存在已看过女优
av查询_女优(_in查询av女优名){
    return av_csv查询(_in查询av女优名
                        , "av女优"
                        , Config.upath("db_av女优")
                        , "编辑格式:`n 女优名(key), 评分(0烂-3精品), 生日(可空), 罩杯(a-l), 标签(可空 空格间隔),登记时间"
                        , "{1},2,,乳a-l,待看 长相好看 乳a-l 美臀 身材 演技 阴毛浓密 肛," . strDate()
                        , "分析_av查询_女优_输入内容"
                        , "检查_av查询_女优_行关键字")
}

分析_av查询_女优_输入内容(_str){
    _result := ""
    if(InStr(_str, "#av女优#") > 0){
        ; 如果是格式化的内容, 则直接解析
        _avInfo := new AvGirlInfo(_str)
        _result := _avInfo.toCsvStr()
    }
    return _result
}

检查_av查询_女优_行关键字(a_rowkey){
    if(a_rowkey ~= "\d")
        return False
    Else
        Return True
}

; av_csv查询(...)
; 返回值: -1 失败, >0 存在
; 参数:
; _in初始行内容格式, 为新数据设置初始输入格式
; _in分析函数名(要分析的字符串), 返回分析取得的内容, 否则返回""
av_csv查询(_in查询关键字, _in查询类型, _in查询文件, _in编辑格式提示信息, _in初始行内容格式:="key{1},列2,列3,列4,列5", _in分析函数名:="", a_行关键字合法性检查函数名:=""){
    _result := -1
    _查询类型 := Format("{:L}", _in查询类型)
; 1.清洗av女优名: 全部小写,包含"-_"
    _查询关键字 := Format("{:L}", _in查询关键字)
; 2.从_查询文件"已看过的_精品av女优.txt"文件中, 读取所有非空行到_查询列表
    _编辑格式提示               := _in编辑格式提示信息
    _查询文件                   := _in查询文件
    _查询列表                   := []
    _分析函数名                 := trim(_in分析函数名)
    _行关键字合法性检查函数名    := trim(a_行关键字合法性检查函数名)

    ; 添加一个对查询关键字的过滤处理
    ; 过滤一 如果是一个文件路径, 则取出文件名, 不含扩展名
    if(FileExist(_查询关键字)){
        _查询关键字 := (Path.parse(_查询关键字)).file_no_ext
    }

    ; 过滤二 如果是一个文件名
    ; 针对偷懒输入整个文件名, 如"#av作品# ★★★ ...", 或者 "#av女优# ★★★ ...."
    ; 如果查询关键字包含"#av"特征, 则先进行分析找出对应的内容关键字
    if(InStr(_查询关键字, "#av") == 1){
        if(_分析函数名 != ""){
            _分析后的关键字 := (Func(_分析函数名)).Call(_查询关键字)
            ; 取第一个逗号前的关键字
            _分析后的关键字 := SubStr(_分析后的关键字, 1, InStr(_分析后的关键字, ",")-1)
            if(_分析后的关键字 != "")
                _查询关键字 := _分析后的关键字
        }
    }

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
                Break
            }
        }
    }
    else{
        MsgBox %_查询类型% `n`n指定文件路径不存在: `n%_查询文件% `n`n下一步将新建文件
    }

; 3. 用input窗口显示数据行内容, 按ok键可保存修改
    _初始行内容        := ""
    _修改后的行内容    := ""
    _inputbox标题     := ""
    _inputbox提示信息 := ""
    ; 根据是否存在已有数据行区别对待
    if(_result>0){
        ; 如果已存在数据项, 则显示已有信息, 按ok可保存修改
        Loop % _查询列表[_result].Length()
        {
            _初始行内容 .= _查询列表[_result][A_Index] . ","
        }
        _初始行内容 := trim(_初始行内容, ",")
        ; iputbox提示信息
        _inputbox标题 := "编辑" . _查询类型
        _inputbox提示信息 := format("查询{1}: `n目标 - 在第[{4}]行 "
                                        . "`n`n查询关键字: `n{2} "
                                        . "`n`n操作类型:`n编辑行数据 "
                                        . "`n`n{3}"
                                    , _查询类型
                                    , _查询关键字
                                    , _编辑格式提示
                                    , _result)
    }
    else{
        ; 如果不存在数据项, 则显示查询关键字, 并使用初始行内容格式
        _初始行内容 := format(_in初始行内容格式, _查询关键字)
        ; iputbox提示信息
        _inputbox标题 := "添加" . _查询类型
        _inputbox提示信息 := format("查询{1}: `n目标 - 不存在! "
                                        . "`n`n查询关键字: `n{2} "
                                        . "`n`n操作类型:`n添加行数据 "
                                        . "`n`n{3}"
                                    , _查询类型
                                    , _查询关键字
                                    , _编辑格式提示)
    }
    ; ----------------------------------------------------------
    ; 用户在inputbox编辑内容
    ; ----------------------------------------------------------
    InputBox, _input修改后的行内容, %_inputbox标题%, %_inputbox提示信息%, , 640, 320,,,,,%_初始行内容%
    _修改后的行内容 := Format("{:L}",_input修改后的行内容)
    ; 退出条件1, 用户取消编辑
    if ErrorLevel {
        MsgBox, % format("{1}: {2} `n`n用户取消编辑, 未保存!", _查询类型, _查询关键字)
        return _result
    }
    ; 退出条件2, 用户输入空
    if(trim(_修改后的行内容) == ""){
        MsgBox, % format("{1}: {2} `n`n用户编辑内容为空 `n`n结束查询操作!", _查询类型, _查询关键字)
        return _result
    }
    ; 分析内容1, 对格式化形式的输入内容进行提取
    if(_分析函数名 != ""){
        _分析后的内容 := (Func(_分析函数名)).Call(_修改后的行内容)
        if(_分析后的内容 != "")
            _修改后的行内容 := _分析后的内容
    }
    ; 合法验证, 对输入内容进行合法验证, 第一个逗号前的内容必须包含搜索关键字
    _第一个逗号位置 := InStr(_修改后的行内容, ",")
    if(_第一个逗号位置 <= 1){
        msgbox, % format("{1} 第{5}行: `n{2} "
                            . "`n`n操作取消, 用户未按格式输入内容: `n注意逗号间隔且关键字不能为空! "
                            . "`n`n{3} "
                            . "`n`n用户输入: `n{4}"
                        , _查询类型
                        , _查询关键字
                        , _编辑格式提示
                        , _修改后的行内容
                        , _result)
        return _result
    }
    _第一个逗号前的内容 := SubStr(_修改后的行内容, 1, _第一个逗号位置-1)
    if(InStr(_第一个逗号前的内容, _查询关键字) < 1){
        msgbox, % format("{1} 第{5}行: `n{2} "
                            . "`n`n操作取消, 用户未按格式输入内容: `n第一项未包含查询的关键字!    "
                            . "`n`n{3} "
                            . "`n`n用户输入: `n{4}"
                        , _查询类型
                        , _查询关键字
                        , _编辑格式提示
                        , _修改后的行内容
                        , _result)
        return _result
    }
    ; ----------------------------------------------------------
    ; 用户在inputbox编辑内容 - end
    ; ----------------------------------------------------------

    ; 对修改后的数据行, 进行关键字合法性检查, 防止非法关键字
    if(_行关键字合法性检查函数名 != ""){
        _行主关键字 := SubStr(_修改后的行内容, 1, InStr(_修改后的行内容, ",")-1)
        if(! (Func(_行关键字合法性检查函数名)).Call(_行主关键字)){
            show_debug(format("查询类型:`n{1}`n`n提示信息:`n操作取消, 用户输入关键字不合法! `n当前输入关键字为: {2}", _查询类型, _行主关键字))
            return -1
        }
    }

    ; 保存修改后的数据行
    ; 保存到列表
    ; 区别对待, 根据是否存在已有数据行
    if(_result>0){
        ; 已存在项目, 进行修改
        _查询列表[_result] := StrSplit(Trim(_修改后的行内容), ",")
    }
    else{
        ; 新项目, 进行追加
        _查询列表.push(StrSplit(Trim(_修改后的行内容), ","))
    }
    ; 保存到文件
    CsvFile.writeListToCsv(_查询列表, _查询文件)
    MsgBox, % format("{1}: {2} `n`n编辑内容已保存 `n`n{3}", _查询类型, _查询关键字, _修改后的行内容)

    return _result
}


; av_csv数据行修改_api(...) 用于其他程序调用, 无界面
; 返回值: -1 失败, >0 存在
; 参数:
; _in分析函数名(要分析的字符串), 返回分析取得的内容, 否则返回""
; _in操作类型 "add"只添加新数据行, "update"有则修改无则添加;
av_csv数据行修改_api(_in输入数据行, _in数据表类型, _in数据表文件, _in操作类型, _in分析函数名:="", a_行关键字合法性检查函数名:=""){
    _result     := -1
    _数据表类型  := Format("{:L}", _in数据表类型)
; 1.清洗数据行: 全部小写,包含"-_"
    _输入数据行  := Format("{:L}", _in输入数据行)
; 2.从_数据表文件"已看过的_精品av女优.txt"文件中, 读取所有非空行到 _数据列表
    _数据表文件   := _in数据表文件
    _数据列表     := []
    _分析函数名   := trim(_in分析函数名)
    _行关键字合法性检查函数名 := a_行关键字合法性检查函数名

    ; 分析内容1, 对格式化形式的输入内容进行提取
    _分析后的csv行 := _输入数据行
    if(_分析函数名 != ""){
        _分析后的csv行 := (Func(_分析函数名)).Call(_输入数据行)
    }

    ; 获取 _行主关键字, _第一个逗号前的内容
    _行主关键字 := SubStr(_分析后的csv行, 1, InStr(_分析后的csv行, ",")-1)

    ; 检查文件是否存在, 若存在, 则加载全部已有数据
    if(FileExist(_数据表文件)){
        ; 读取文件到列表
        Loop, read, %_数据表文件%
        {
            if(trim(A_LoopReadLine) != "")
                ; 清洗数据表文件的脏数据, 这里加入Format("{:L}",A_LoopReadLine) 小写字母转换
                _数据列表.push(StrSplit(Format("{:L}",A_LoopReadLine), ","))
        }
        ; 在查询列表中根据关键字, 查询数据行索引号
        Loop % _数据列表.Length()
        {
            if(InStr(_数据列表[A_Index][1], _行主关键字) > 0)
            {
                _result := A_Index
                Break
            }
        }
    }
    else{
        MsgBox %_数据表类型% `n`n指定文件路径不存在: `n%_数据表文件% `n`n下一步将新建文件
    }

    ; 对修改后的数据行, 进行关键字合法性检查, 防止非法关键字
    if(_行关键字合法性检查函数名 != ""){
        _行主关键字 := SubStr(_分析后的csv行, 1, InStr(_分析后的csv行, ",")-1)
        if(! (Func(_行关键字合法性检查函数名)).Call(_行主关键字)){
            show_debug(format("查询类型:`n{1}`n`n提示信息:`n操作取消, 用户输入关键字不合法! `n当前输入关键字为: {2}", _数据表类型, _行主关键字))
            return -1
        }
    }

    ; 保存修改后的数据行, 到数据列表
    ; 区别对待, 根据是否存在已有数据行
    _log := "`n; =========================================================="
    if(_result>0){
        ; 已存在项目, 进行修改
        ; 操作限制
        if(_in操作类型 = "update"){
            _数据列表[_result] := StrSplit(Trim(_分析后的csv行), ",")
            _log .= format("`n更改数据行 - {1} `n`n更新内容: {2}"
                            , _result
                            , _分析后的csv行)
        }
        else{
            _log .= format("`n更改数据行 - {1} `n`n操作被拒绝, 当前操作类型为: {2}"
                            , _result
                            , _in操作类型)
        }
    }
    else{
        ; 新项目, 进行追加
        ; 操作限制
        if(_in操作类型 = "add" || _in操作类型 = "update"){
            _数据列表.push(StrSplit(Trim(_分析后的csv行), ","))
            _log .= format("`n增加数据行 - {1} `n`n新数据行: {2}", _数据列表.MaxIndex(), _分析后的csv行)
        }
        else{
            _log .= format("`n增加数据行 `n`n操作被拒绝, 当前操作类型为: {1}", _in操作类型)
        }
    }
    _log .= "`n; =========================================================="
    ; 保存到文件
    CsvFile.writeListToCsv(_数据列表, _数据表文件)
    show_msg(format("数据表类型: {1} "
                        . "`n`n输入数据行: {2} "
                        . "`n`n分析后的csv数据行: {3} "
                        . "`n`n日志: {4}"
                    , _数据表类型
                    , _输入数据行
                    , _分析后的csv行
                    , _log)
            , "csv数据行修改"
            , 6000)
    ; end
    return _result
}

; av作品_csv数据行修改_api(_in输入数据)
; _in操作类型 "add"只添加新数据行, "update"有则修改无则添加;
; 返回值: -1 失败, >0 存在已看过作品
av作品_csv数据行修改_api(_in输入数据, _in操作类型){
    return av_csv数据行修改_api(_in输入数据
                        , "av作品"
                        , Config.upath("db_av作品")
                        , _in操作类型
                        , "分析_av查询_作品_输入内容"
                        , "检查_av查询_作品_行关键字")
}

; av女优_csv数据行修改_api(_in输入数据)
; _in操作类型 "add"只添加新数据行, "update"有则修改无则添加;
; 返回值: -1 失败, >0 存在已看过女优
av女优_csv数据行修改_api(_in输入数据, _in操作类型){
    return av_csv数据行修改_api(_in输入数据
                        , "av女优"
                        , Config.upath("db_av女优")
                        , _in操作类型
                        , "分析_av查询_女优_输入内容"
                        , "检查_av查询_女优_行关键字")
}

; _in操作类型 "add"只添加新数据行, "update"有则修改无则添加;
av数据捕捉_api(_in输入数据, _in操作类型){
    if(InStr(_in输入数据, "#av作品#")){
        av作品_csv数据行修改_api(_in输入数据, _in操作类型)
    }
    else if(InStr(_in输入数据, "#av女优#")){
        av女优_csv数据行修改_api(_in输入数据, _in操作类型)
    }
}


; 从图片文件名中获取AV作品编号(arg_图片文件名), 返回可识别的AV作品编号或者原文件名
从图片文件名中获取AV作品编号(arg_图片文件名){
    _ret := arg_图片文件名

    _作品编号    := ""
    _厂牌       := ""
    _编号       := ""
    ; 如果有多个截图, 会出现序号
    _序号       := ""
    _序号前缀    := "_"

    _分割后obj := cut3P(arg_图片文件名, "[a-zA-Z]{2,}\d{3,}")

    if(_分割后obj["mid"] != ""){
        
        _作品编号 := _分割后obj["mid"]     ; 这里采集的是混乱的格式"abcd00123"
        
        ; 对作品编号清洗格式化
        _厂牌 := (cut3P(_作品编号, "[a-zA-Z]{2,}"))["mid"]

        _编号 := (cut3P(_作品编号, "\d{3}$"))["mid"]

        ; 开始检测序号
        _序号部分obj := cut3P(_分割后obj["right"], "[_-]\d{1,3}")
        ; 获取序号
        if(_序号部分obj["mid"] != ""){
            _序号 := _序号部分obj["mid"]
            _序号 := StrReplace(_序号, "-", _序号前缀)
        }

        _ret := format("{1}-{2}{3}", _厂牌, _编号, _序号)
    }
        
    Return _ret
}