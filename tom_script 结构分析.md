# [笔记] tom_script 结构分析
> 2019-11-04 16:29:54

## Av.class.ahk
    - class Av
        - static public 模板()
        - rename()
        - rename_收藏夹()

    - class Renamer
        - methods
            - do()
            - rename()
        - child class
            - class Av有码作品重命名
            - class Av无码作品重命名
            - class Av作品重命名_收藏夹
            - class Av演员重命名_收藏夹
            - class Av导演重命名_收藏夹 
            - class Av制作商重命名_收藏夹
            - class Av发行商重命名_收藏夹
            - class Av系列重命名_收藏夹
            - class Av类别重命名_收藏夹
            - class Av搜索重命名_收藏夹

    - class AvInfo
        - methods
            - 识别特征(in_avStr)
            - 识别特征库()
                - return []
            - 提取评级()
            - 提取tags()
            - 提取备注()
            - toStr()       转标准格式字符串  依赖 formatStr() 
            - toCsvStr()    转Csv格式字符串 - 部分内容 ???
            - is女优()
            - is作品()
        - child class
            - class AvGirlInfo extends AvInfo
                - 提取全部()
                - formatStr()   info内容转格式化字符串
                - toCsvStr()
                - 提取女优名()
                - 提取生日()
                - 提取地区()
                - 提取bra()
            - class Av作品日本有码Info extends AvInfo
                - 提取全部()
                - formatStr()   info内容转格式化字符串
                - 提取编号()
                - 提取标题()
                - 提取演员()
                - 提取地区()
                - 提取是否无码()
                - 提取导演()
                - 提取制作商()
                - 提取发行商()
                - 提取系列()
            - class Av作品日本无码Info extends AvInfo
                - 提取全部()
                - formatStr()   info内容转格式化字符串
                - 提取编号()
                - 无码编号格式化()
                - 提取标题()
                - 提取演员()
                - 提取地区()
                - 提取是否无码()
                - 提取导演()
                - 提取制作商()
                - 提取发行商()
                - 提取系列()
            - class Av作品欧美无码Info extends AvInfo
                - 提取全部()
                - formatStr()   info内容转格式化字符串
                - 提取标题()
                - 提取演员()
                - 提取制作商()

    - class AvInfoAnalysis
        - init()
        - parse()

    - 按特征库提取字符串()
    - 按特征库提取tags()
    - 匹配特征库()

    - 模板_tags_create()
    - 模板_tags_format()
    - 模板_日期_format()

    - av作品_查询已看过()
    - av女优_查询已看过()

---

