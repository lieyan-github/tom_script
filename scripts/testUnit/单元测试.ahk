class testContent{
    ; ----------------------------------------------------------
    ; 单元测试 public static test()
    ; ----------------------------------------------------------
    test(){

        ;收藏夹 tags格式化
        avstr := "tags(美颜_丰乳h_美臀)"
        assert("tags格式化tags(美颜_丰乳h_美臀)"
            , 模板_tags_format(avstr) == "tags(美颜 丰乳h 美臀)")

        avstr := "#精品女优#(美颜_丰乳h_美臀)"
        assert("tags格式化#精品女优#(美颜_丰乳h_美臀)"
            , 模板_tags_format(avstr) == "tags(美颜 丰乳h 美臀)")

        ; ----------------------------------------------------------

        avstr := "#av女优# ★★★ 佐山愛 1989-01-08 tags(美颜_丰乳h_美臀) 2016-03-02 - 演員 - 影片 - JavZoo"
        assert("收藏夹 tags格式化"
            , 模板_tags_format(avstr) == "#av女优# ★★★ 佐山愛 1989-01-08 tags(美颜 丰乳h 美臀) 2016-03-02 - 演員 - 影片 - JavZoo")

        avstr := "#av女优# ★★★ 佐山愛 1989-01-08 (美颜_丰乳h_美臀) 2016-03-02 - 演員 - 影片 - JavZoo"
        assert("收藏夹 识别无tags格式化"
            , 模板_tags_format(avstr) == "#av女优# ★★★ 佐山愛 1989-01-08 tags(美颜 丰乳h 美臀) 2016-03-02 - 演員 - 影片 - JavZoo")


        ;av女优 单元测试
        ; ----------------------------------------------------------

        avstr := "#av女优# ★★ 三浦歩美 1983-00-00 tags(美颜_乳g_熟女) 2019-06-13 - 演員 - 影片 - AVMOO"
        _av作品提取内容 := new AvGirlInfo(avstr)
        assert("AvGirlInfo 识别收藏夹女优格式内容  tags下划线间隔"
            , _av作品提取内容.toStr() == "#av女优# ★★ 三浦歩美 1983-00-00 地区(日本) tags(美颜 乳g 熟女) 备注()")

        avstr := "#av女优# ★★ 三浦歩美 1983-00-00 tags(美颜 乳g 熟女) 2019-06-13 - 演員 - 影片 - AVMOO"
        _av作品提取内容 := new AvGirlInfo(avstr)
        assert("AvGirlInfo 识别收藏夹女优格式内容 tags空格间隔"
            , _av作品提取内容.toStr() == "#av女优# ★★ 三浦歩美 1983-00-00 地区(日本) tags(美颜 乳g 熟女) 备注()")

        avstr := "#av女优# ★★ 咲々原リン 1998-07-05 (美颜_乳E_混血) 2019-03-05 - 演員 - 影片 - AVMOO"
        _av作品提取内容 := new AvGirlInfo(avstr)
        assert("AvGirlInfo 识别收藏夹女优格式内容  无tags"
            , _av作品提取内容.toStr() == "#av女优# ★★ 咲々原リン 1998-07-05 地区(日本) tags(美颜 乳E 混血) 备注()")

        avstr := "#av女优# ★★ 咲々原リン 1998年07月05日 (美颜_乳E_混血) 2019-03-05 - 演員 - 影片 - AVMOO"
        _av作品提取内容 := new AvGirlInfo(avstr)
        assert("AvGirlInfo 识别收藏夹女优格式内容  日期识别1998年07月05日"
            , _av作品提取内容.toStr() == "#av女优# ★★ 咲々原リン 1998-07-05 地区(日本) tags(美颜 乳E 混血) 备注()")

        avstr := "#av女优# ★★ 咲々原リン 1998/07/05 (美颜_乳E_混血) 2019-03-05 - 演員 - 影片 - AVMOO"
        _av作品提取内容 := new AvGirlInfo(avstr)
        assert("AvGirlInfo 识别收藏夹女优格式内容  日期识别1998/07/05"
            , _av作品提取内容.toStr() == "#av女优# ★★ 咲々原リン 1998-07-05 地区(日本) tags(美颜 乳E 混血) 备注()")


        ;av有码作品 单元测试
        ; ----------------------------------------------------------

        avstr := "#av作品# ★★★ MIDE-255 巨乳女教師の匂い立つ汗と愛液 神咲詩織 (美乳_激情诱惑) 2016-03-07 - AVMOO"
        _av作品提取内容 := new Av作品日本有码Info(avstr)
        assert("Av作品日本有码Info 识别收藏夹av作品"
            , _av作品提取内容.toStr() == "#av作品# ★★★ MIDE-255 巨乳女教師の匂い立つ汗と愛液 演员(神咲詩織) tags(美乳 激情诱惑) 地区(日本) 有码 导演() 制作商() 发行商() 系列()")


        avstr := "#av作品# ★★★ JUY-777 向かい部屋の人妻 佐山愛_佐山爱 (极品诱惑_丰乳_风骚) 2019-06-13 - AVMOO"
        _av作品提取内容 := new Av作品日本有码Info(avstr)
        assert("Av作品日本有码Info 识别提取多演员 以空格分隔"
            , _av作品提取内容.toStr() == "#av作品# ★★★ JUY-777 向かい部屋の人妻 演员(佐山愛 佐山爱) tags(极品诱惑 丰乳 风骚) 地区(日本) 有码 导演() 制作商() 发行商() 系列()")


        ;av无码作品 单元测试
        ; ----------------------------------------------------------

        avstr := "#av作品# ★★ carib-060215-890 一本道~乳神 真木今日子 tags(极品诱惑_丰乳_风骚)"
        _av作品提取内容 := new Av作品日本无码Info(avstr)
        assert("Av作品日本无码Info 识别carib-060215-890"
            , _av作品提取内容.toStr() == "#av作品# ★★ carib-060215-890 一本道~乳神 演员(真木今日子) tags(极品诱惑 丰乳 风骚) 地区(日本) 无码 导演() 制作商() 发行商() 系列()")

        avstr := "#av作品# ★★ 060215-890-carib 一本道~乳神 真木今日子 tags(极品诱惑_丰乳_风骚)"
        _av作品提取内容 := new Av作品日本无码Info(avstr)
        assert("Av作品日本无码Info 识别060215-890-carib"
            , _av作品提取内容.toStr() == "#av作品# ★★ carib-060215-890 一本道~乳神 演员(真木今日子) tags(极品诱惑 丰乳 风骚) 地区(日本) 无码 导演() 制作商() 发行商() 系列()")

        avstr := "#av作品# ★★ 1pon-071912_387 一本道~乳神 真木今日子 tags(极品诱惑_丰乳_风骚)"
        _av作品提取内容 := new Av作品日本无码Info(avstr)
        assert("Av作品日本无码Info 识别1pon-071912_387"
            , _av作品提取内容.toStr() == "#av作品# ★★ 1pon-071912-387 一本道~乳神 演员(真木今日子) tags(极品诱惑 丰乳 风骚) 地区(日本) 无码 导演() 制作商() 发行商() 系列()")

        avstr := "#av作品# ★★ 071912_387-1pon 一本道~乳神 真木今日子 tags(极品诱惑_丰乳_风骚)"
        _av作品提取内容 := new Av作品日本无码Info(avstr)
        assert("Av作品日本无码Info 识别071912_387-1pon"
            , _av作品提取内容.toStr() == "#av作品# ★★ 1pon-071912-387 一本道~乳神 演员(真木今日子) tags(极品诱惑 丰乳 风骚) 地区(日本) 无码 导演() 制作商() 发行商() 系列()")


        ;av欧美无码作品 单元测试
        ; ----------------------------------------------------------

        avstr := "#av作品# ★★ x-art - Abella Danger, Angela White, Krissy Lynn - Phone Service Skills"
        _av作品提取内容 := new Av作品欧美无码Info(avstr)
        assert("Av作品欧美无码Info 识别"
            , _av作品提取内容.toStr() == "#av作品# ★★ x-art - Abella Danger, Angela White, Krissy Lynn - Phone Service Skills 演员() tags() 地区(欧美) 无码 制作商(x-art) 发行商(x-art) 系列()")

        avstr := "#av作品# ★★★ Blacked - Danni Rivers - My First BBC tags(极品诱惑_后入)"
        _av作品提取内容 := new Av作品欧美无码Info(avstr)
        assert("Av作品欧美无码Info 识别演员Danni Rivers"
            , _av作品提取内容.toStr() == "#av作品# ★★★ Blacked - Danni Rivers - My First BBC 演员(Danni Rivers) tags(极品诱惑 后入) 地区(欧美) 无码 制作商(Blacked) 发行商(Blacked) 系列()")



        ; ----------------------------------------------------------

        assert("Sys.now() ~= dddd-dd-dd dd:dd:dd"
                    , Sys.now() ~= "(?:\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})")

        assert("Sys.date() ~= dddd-dd-dd"
                    , Sys.date() ~= "(?:\d{4}-\d{2}-\d{2})")

        assert("Sys.time() ~= dd:dd:dd"
                    , Sys.time() ~= "(?:\d{2}:\d{2}:\d{2})")

        assert("Sys.week() ~= d[1-7]"
                    , Sys.week() ~= "(?:[1-7])")


        ; ----------------------------------------------------------

        assert("Path.hasExtName(""C:\Windows\hh.exe"") == true"
                    , true == Path.hasExtName("C:\Windows\hh.exe"))

        assert("Path.hasExtName(""C:\Windows\hh.1exe"") == true"
                    , true == Path.hasExtName("C:\Windows\hh.1exe"))

        assert("Path.isDir(""C:\Windows\System32"") == true"
                    , true == Path.isDir("C:\Windows\System32"))

        ; path test
        _path := Path.parse("C:\Windows\notepad.exe")

        assert("parse(""C:\Windows\notepad.exe"") file: notepad.exe"
                    , "notepad.exe" == _path.file)

        assert("parse(""C:\Windows\notepad.exe"") dir: C:\Windows"
                    , "C:\Windows" == _path.dir)

        assert("parse(""C:\Windows\notepad.exe"") ext: exe"
                    , "exe" == _path.ext)

        assert("parse(""C:\Windows\notepad.exe"") fileNoExt: notepad"
                    , "notepad" == _path.fileNoExt)

        assert("parse(""C:\Windows\notepad.exe"") drive: C: //区分大小写"
                    , "C:" == _path.drive)

        ; path test 2 对不含扩展名 split自动检测处理
        _path := Path.parse("C:\Windows\notepad")

        assert("parse(""C:\Windows\notepad"") file: notepad"
                    , "notepad" == _path.file)

        assert("parse(""C:\Windows\notepad"") ext: 空字符"
                    , "" == _path.ext)

        assert("parse(""C:\Windows\notepad"") fileNoExt: notepad"
                    , "notepad" == _path.fileNoExt)



    }
}


av_测试分析剪贴板(){
    _clipStr:= strClean(Clipboarder.get("copy"))
    _list1 := []
    if(_clipStr ~= "識別碼.\s?[A-Za-z]+|#av作品#"){
        _提取内容 := new Av作品日本有码Info(_clipStr)
        _list1.push({"提取内容": _提取内容
                    , "提取前": _clipStr
                    , "提取后": _提取内容.toStr()})
    }
    else {
        _提取内容 := new AvGirlInfo(_clipStr)
        _list1.push({"提取内容": _提取内容
                    , "提取前": _clipStr
                    , "提取后": _提取内容.toStr()})
    }
    arrayPrint(_list1)
}
