class testContent{
    ; ----------------------------------------------------------
    ; 单元测试 public static test()
    ; ----------------------------------------------------------
    test(){
        ; Av.rename 收藏夹重命名av女优
        ; ----------------------------------------------------------
        avstr := "佐山愛 - 演員 - 影片 - AVMOO"
        Clipboard := ""
        assert("Av.rename av女优-001", Av.rename(avstr) == "#av女优# ★★★ 佐山愛 1990-00-00 tags(标签) " . Sys.date() . " - 演員 - 影片 - AVMOO")

        ; 收藏夹重命名av女优, 从剪贴板获取生日和罩杯
        avstr := "佐山愛 - 演員 - 影片 - AVMOO"
        Clipboard := "1998年10月30日 g罩杯"
        assert("Av.rename av女优-002", Av.rename(avstr) == "#av女优# ★★★ 佐山愛 1998-10-30 tags(美颜 乳g) " . Sys.date() . " - 演員 - 影片 - AVMOO")

        ; Av.rename 收藏夹重命名av作品
        ; ----------------------------------------------------------
        avstr := "RBD-930 強制受胎闇市場 佐山愛_真木今日子 - AVMOO"
        assert("Av.rename av作品-001", Av.rename(avstr) == "#av作品# ★★★ RBD-930 強制受胎闇市場 佐山愛_真木今日子 tags(标签) " . Sys.date() . " - AVMOO")

        ; 对收藏夹内容格式化
        avstr := "#av作品# ★★★ RBD-930 強制受胎闇市場 佐山愛_真木今日子 tags(美颜_乳g_诱惑) 2019年10月30日 - AVMOO"
        assert("Av.rename av作品-002", Av.rename(avstr) == "#av作品# ★★★ RBD-930 強制受胎闇市場 佐山愛_真木今日子 tags(美颜 乳g 诱惑) 2019-10-30 - AVMOO")

        ; 模板_tags_format 识别下划线间隔的多个标签
        ; ----------------------------------------------------------
        avstr := "tags(美颜_丰乳h_美臀)"
        assert("模板_tags_format-001", 模板_tags_format(avstr) == "tags(美颜 丰乳h 美臀)")

        avstr := "#精品女优#(美颜_丰乳h_美臀)"
        assert("模板_tags_format-002", 模板_tags_format(avstr) == "tags(美颜 丰乳h 美臀)")

        avstr := "(美颜_丰乳h_美臀)"
        assert("模板_tags_format-003", 模板_tags_format(avstr) == "tags(美颜 丰乳h 美臀)")

        ; AvInfoAnalysis
        ; ----------------------------------------------------------
        ; 000 av女优 识别
        avstr := "#av女优# ★★★ 佐山愛 1989-01-08 tags(美颜 丰乳h 美臀)"
        assert("AvInfoAnalysis av女优 识别", arrayJoin(AvInfoAnalysis.parse(avstr).提取tags(avstr)) == "美颜 丰乳h 美臀")

        ; 001 Av作品日本有码 识别
        avstr := "#av作品# ★★★ MIDE-255 巨乳女教師の匂い立つ汗と愛液 神咲詩織 真木今日子 tags(美乳 风骚 诱惑)"
        _avinfo := AvInfoAnalysis.parse(avstr)
        _avinfo.提取全部(avstr)
        assert("AvInfoAnalysis Av作品日本有码 识别 01", _avinfo.toStr() == "#av作品# ★★★ MIDE-255 巨乳女教師の匂い立つ汗と愛液 神咲詩織 真木今日子 tags(美乳 风骚 诱惑)")


        ; 001-2 Av作品日本有码 识别
        avstr := "#av作品# ★★ HND-522 连续阴道榨的痴女姐姐 本田岬 tags(中字 诱惑)"
        _avinfo := AvInfoAnalysis.parse(avstr)
        _avinfo.提取全部(avstr)
        assert("AvInfoAnalysis Av作品日本有码 识别 02", _avinfo.toStr() == "#av作品# ★★ HND-522 连续阴道榨的痴女姐姐 本田岬 tags(中字 诱惑)")

        ; 002 Av作品日本无码 识别
        avstr := "#av作品# ★★ carib-060215-890 一本道~乳神 佐山愛 真木今日子 tags(极品诱惑_丰乳_风骚)"
        _avinfo := AvInfoAnalysis.parse(avstr)
        _avinfo.提取全部(avstr)
        assert("AvInfoAnalysis Av作品日本无码 识别", _avinfo.toStr("all") == "#av作品# ★★ carib-060215-890 一本道~乳神 演员(佐山愛 真木今日子) tags(极品诱惑 丰乳 风骚) 地区(日本) 无码 导演() 制作商() 发行商() 系列()")

        ; 002 Av作品欧美无码 识别
        avstr := "DorcelClub - Anna Polina, Tina Kay - Mes Nuits En Prison"
        _avinfo := AvInfoAnalysis.parse(avstr)
        _avinfo.提取全部(avstr)
        assert("AvInfoAnalysis Av作品欧美无码 识别", _avinfo.toStr() == "#av作品# ★ DorcelClub - Anna Polina, Tina Kay - Mes Nuits En Prison tags()")

        ; AvInfo
        ; ----------------------------------------------------------
        ; 000 标准格式化分析
        avstr := "#av女优# ★★★ 佐山愛 1989-01-08 tags(美颜 丰乳h 美臀)"
        assert("AvInfo.提取tags-000", arrayJoin(AvInfo.提取tags(avstr)) == "美颜 丰乳h 美臀")

        ; 001 特殊情况分析 tags下划线
        avstr := "#av女优# ★★★ 佐山愛 1989-01-08 tags(美颜_丰乳h_美臀)"
        assert("AvInfo.提取tags-001", arrayJoin(AvInfo.提取tags(avstr)) == "美颜 丰乳h 美臀")

        ; 002 特殊情况分析 tags只有括号且下划线间隔
        avstr := "#av女优# ★★★ 佐山愛 1989-01-08 (美颜_丰乳h_美臀)"
        assert("AvInfo.提取tags-002", arrayJoin(AvInfo.提取tags(avstr)) == "美颜 丰乳h 美臀")

        ; AvGirlInfo
        ; ----------------------------------------------------------
        ; 000 标准格式化分析
        avstr := "#av女优# ★★ 三浦歩美 1983-00-00 tags(美颜 乳g 熟女)"
        _avinfo := new AvGirlInfo(avstr)
        assert("AvGirlInfo-000", _avinfo.toStr() == "#av女优# ★★ 三浦歩美 1983-00-00 tags(美颜 乳g 熟女)")

        ; 001 特殊情况分析 收藏夹格式 toStr("all")
        avstr := "#av女优# ★★ 三浦歩美 1983-00-00 tags(美颜 乳g 熟女) 2019-06-13 - 演員 - 影片 - AVMOO"
        _avinfo := new AvGirlInfo(avstr)
        assert("AvGirlInfo-001", _avinfo.toStr("all") == "#av女优# ★★ 三浦歩美 1983-00-00 地区(日本) tags(美颜 乳g 熟女) 备注()")

        ; 002 特殊情况分析 tags下划线间隔
        avstr := "#av女优# ★★ 三浦歩美 1983-00-00 tags(美颜_乳g_熟女) 2019-06-13 - 演員 - 影片 - AVMOO"
        _avinfo := new AvGirlInfo(avstr)
        assert("AvGirlInfo-002", _avinfo.toStr() == "#av女优# ★★ 三浦歩美 1983-00-00 tags(美颜 乳g 熟女)")

        ; 003 特殊情况分析 tags只有括号且下划线间隔
        avstr := "#av女优# ★★ 咲々原リン 1998-07-05 (美颜_乳E_混血) 2019-03-05 - 演員 - 影片 - AVMOO"
        _avinfo := new AvGirlInfo(avstr)
        assert("AvGirlInfo-003", _avinfo.toStr() == "#av女优# ★★ 咲々原リン 1998-07-05 tags(美颜 乳E 混血)")

        ; Av作品日本有码Info
        ; ----------------------------------------------------------
        ; 000 标准格式化分析
        avstr := "#av作品# ★★★ MIDE-255 巨乳女教師の匂い立つ汗と愛液 神咲詩織 真木今日子 tags(美乳 风骚 诱惑)"
        _avinfo := new Av作品日本有码Info(avstr)
        assert("Av作品日本有码Info-000", _avinfo.toStr() == "#av作品# ★★★ MIDE-255 巨乳女教師の匂い立つ汗と愛液 神咲詩織 真木今日子 tags(美乳 风骚 诱惑)")

        ; 001 特殊情况分析 tags只有括号且下划线间隔
        avstr := "#av作品# ★★★ MIDE-255 巨乳女教師の匂い立つ汗と愛液 神咲詩織 真木今日子 (美乳_激情诱惑)"
        _avinfo := new Av作品日本有码Info(avstr)
        assert("Av作品日本有码Info-001", _avinfo.toStr("all") == "#av作品# ★★★ MIDE-255 巨乳女教師の匂い立つ汗と愛液 演员(神咲詩織 真木今日子) tags(美乳 激情诱惑) 地区(日本) 有码 导演() 制作商() 发行商() 系列()")

        ; 002 特殊情况分析 收藏夹测试
        avstr := "#av作品# ★★★ JUY-777 向かい部屋の人妻 佐山愛 真木今日子 (极品诱惑_丰乳_风骚) 2019-06-13 - AVMOO"
        _avinfo := new Av作品日本有码Info(avstr)
        assert("Av作品日本有码Info-002", _avinfo.toStr("all") == "#av作品# ★★★ JUY-777 向かい部屋の人妻 演员(佐山愛 真木今日子) tags(极品诱惑 丰乳 风骚) 地区(日本) 有码 导演() 制作商() 发行商() 系列()")

        ; 003 特殊情况分析 收藏夹格式 多女优 空格间隔
        avstr := "#av作品# ★★★ JUY-777 向かい部屋の人妻 佐山愛 真木今日子 (极品诱惑_丰乳_风骚) 2019-06-13 - AVMOO"
        _avinfo := new Av作品日本有码Info(avstr)
        assert("Av作品日本有码Info-003", _avinfo.toStr() == "#av作品# ★★★ JUY-777 向かい部屋の人妻 佐山愛 真木今日子 tags(极品诱惑 丰乳 风骚)")

        avstr := "MIDE-255 巨乳女教師の匂い立つ汗と愛液 神咲詩織 真木今日子"
        _avinfo := new Av作品日本有码Info(avstr)
        assert("Av作品日本有码Info-004", _avinfo.toStr() == "#av作品# ★ MIDE-255 巨乳女教師の匂い立つ汗と愛液 神咲詩織 真木今日子 tags()")

        ; Av作品日本无码Info
        ; ----------------------------------------------------------
        ; 000 标准格式化分析 all
        avstr := "#av作品# ★★ carib-060215-890 一本道~乳神 佐山愛 真木今日子 tags(极品诱惑_丰乳_风骚)"
        _avinfo := new Av作品日本无码Info(avstr)
        assert("Av作品日本无码Info-000", _avinfo.toStr("all") == "#av作品# ★★ carib-060215-890 一本道~乳神 演员(佐山愛 真木今日子) tags(极品诱惑 丰乳 风骚) 地区(日本) 无码 导演() 制作商() 发行商() 系列()")

        ; 001 标准格式化分析 carib-060215-890
        avstr := "#av作品# ★★ carib-060215-890 一本道~乳神 佐山愛 真木今日子 tags(极品诱惑_丰乳_风骚)"
        _avinfo := new Av作品日本无码Info(avstr)
        assert("Av作品日本无码Info-001", _avinfo.toStr() == "#av作品# ★★ carib-060215-890 一本道~乳神 佐山愛 真木今日子 tags(极品诱惑 丰乳 风骚)")

        ; 002 标准化格式分析 1pon-071912_387
        avstr := "#av作品# ★★ 1pon-071912-387 一本道~乳神 佐山愛 真木今日子 tags(极品诱惑_丰乳_风骚)"
        _avinfo := new Av作品日本无码Info(avstr)
        assert("Av作品日本无码Info-002", _avinfo.toStr() == "#av作品# ★★ 1pon-071912-387 一本道~乳神 佐山愛 真木今日子 tags(极品诱惑 丰乳 风骚)")

        ; 对不规范的无码av编号进行修复 060215-890-carib -> carib-060215-890
        avstr := "#av作品# ★★ 060215-890-carib 一本道~乳神 佐山愛 真木今日子 tags(极品诱惑_丰乳_风骚)"
        _avinfo := new Av作品日本无码Info(avstr)
        assert("Av作品日本无码Info-003", _avinfo.toStr() == "#av作品# ★★ carib-060215-890 一本道~乳神 佐山愛 真木今日子 tags(极品诱惑 丰乳 风骚)")

        ; 对不规范的无码av编号进行修复 071912_387-1pon -> 1pon-071912-387
        avstr := "#av作品# ★★ 071912_387-1pon 一本道~乳神 佐山愛 真木今日子 tags(极品诱惑_丰乳_风骚)"
        _avinfo := new Av作品日本无码Info(avstr)
        assert("Av作品日本无码Info-004", _avinfo.toStr() == "#av作品# ★★ 1pon-071912-387 一本道~乳神 佐山愛 真木今日子 tags(极品诱惑 丰乳 风骚)")

        ; 初始文件名格式化
        avstr := "carib-060215-890 一本道~乳神 佐山愛 真木今日子"
        _avinfo := new Av作品日本无码Info(avstr)
        assert("Av作品日本无码Info-005", _avinfo.toStr() == "#av作品# ★ carib-060215-890 一本道~乳神 佐山愛 真木今日子 tags()")

        ; 对不规范的无码av编号进行修复 071912_387-1pon -> 1pon-071912-387
        avstr := "#av作品# ★★ 071912_387-1pondo 一本道~乳神 佐山愛 真木今日子 tags(极品诱惑_丰乳_风骚)"
        _avinfo := new Av作品日本无码Info(avstr)
        assert("Av作品日本无码Info-006", _avinfo.toStr() == "#av作品# ★★ 1pon-071912-387 一本道~乳神 佐山愛 真木今日子 tags(极品诱惑 丰乳 风骚)")

        ; 对不规范的无码av编号进行修复 071912_387-1pon -> 1pon-071912-387
        avstr := "#av作品# ★★★ Caribbean-092217-504 美★ジーンズ VOL.26 立花瑠莉 tags(高画质 无码 极品诱惑)"
        _avinfo := new Av作品日本无码Info(avstr)
        assert("Av作品日本无码Info-007", _avinfo.toStr() == "#av作品# ★★★ carib-092217-504 美★ジーンズ VOL.26 立花瑠莉 tags(高画质 无码 极品诱惑)")

        ; Av作品欧美无码Info
        ; ----------------------------------------------------------
        预期结果    := "#av作品# ★★★ DorcelClub - Anna Polina, Tina Kay - Mes Nuits En Prison tags(极品 诱惑)"

        avstr := "DorcelClub - Anna Polina, Tina Kay - Mes Nuits En Prison"
        _avinfo := new Av作品欧美无码Info(avstr)
        assert("Av作品欧美无码Info-001", _avinfo.toStr() == "#av作品# ★ DorcelClub - Anna Polina, Tina Kay - Mes Nuits En Prison tags()")

        avstr := "DorcelClub - Anna Polina, Tina Kay - Mes Nuits En Prison"
        _avinfo := new Av作品欧美无码Info(avstr)
        assert("Av作品欧美无码Info-002", _avinfo.toStr("all") == "#av作品# ★ 制作商(DorcelClub) 演员(Anna Polina, Tina Kay) 标题(Mes Nuits En Prison) tags() 地区(欧美) 无码")

        avstr := "#av作品# ★★★ DorcelClub - Anna Polina, Tina Kay - Mes Nuits En Prison tags(极品 诱惑)"
        _avinfo := new Av作品欧美无码Info(avstr)
        assert("Av作品欧美无码Info-003", _avinfo.toStr() == 预期结果)

        avstr := "#av作品# ★★★ DorcelClub - Anna Polina, Tina Kay - Mes Nuits En Prison (极品_诱惑)"
        _avinfo := new Av作品欧美无码Info(avstr)
        assert("Av作品欧美无码Info-004", _avinfo.toStr() == 预期结果)


        ; Sys
        ; ----------------------------------------------------------
        assert("Sys-001", Sys.now() ~= "(?:\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})")
        assert("Sys-002", Sys.date() ~= "(?:\d{4}-\d{2}-\d{2})")
        assert("Sys-003", Sys.time() ~= "(?:\d{2}:\d{2}:\d{2})")
        assert("Sys-004", Sys.week() ~= "(?:[1-7])")

        ; path
        ; ----------------------------------------------------------
        assert("Path-001", true == Path.hasExtName("C:\Windows\hh.exe"))
        assert("Path-002", true == Path.hasExtName("C:\Windows\hh.1exe"))
        assert("Path-003", true == Path.isDir("C:\Windows\System32"))

        ; path test
        _path := Path.parse("C:\Windows\notepad.exe")

        assert("Path-004", "notepad.exe" == _path.file)
        assert("Path-005", "C:\Windows" == _path.dir)
        assert("Path-006", "exe" == _path.ext)
        assert("Path-007", "notepad" == _path.fileNoExt)
        assert("Path-008", "C:" == _path.drive)

        ; path test 2 对不含扩展名 split自动检测处理
        _path := Path.parse("C:\Windows\notepad")

        assert("Path-009", "notepad" == _path.file)
        assert("Path-010", "" == _path.ext)
        assert("Path-011", "notepad" == _path.fileNoExt)
    }
}


av_测试分析剪贴板(){
    _clipStr:= Clipboarder.get("copy")
    _list1 := []
    if(_clipStr ~= "識別碼.\s?[A-Za-z]+|#av作品#"){
        _提取内容 := AvInfoAnalysis.parse(_clipStr)
        _提取内容.提取全部(_clipStr)
        _list1.push({"提取内容": _提取内容
                    , "提取前": _clipStr
                    , "提取后": _提取内容.toStr()})
    }
    else {
        _提取内容 := AvInfoAnalysis.parse(_clipStr)
        _提取内容.提取全部(_clipStr)
        _list1.push({"提取内容": _提取内容
                    , "提取前": _clipStr
                    , "提取后": _提取内容.toStr()})
    }
    arrayPrint(_list1)
}
