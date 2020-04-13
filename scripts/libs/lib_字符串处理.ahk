; ==========================================================
;
; 字符串类
;
; 文档作者: tom
;
; 修改时间: 2019-02-25 03:37:23
;
; ==========================================================

; 根据_instr和正则表达式_regExp(大写O模式), 生成一个match数组对象,
; return 内容为捕获的子模式,
create_regexMatch(_instr, _inregExp){
    _regExp := "O)" . _inregExp
    _foundPos :=  RegExMatch(_instr, _regExp, _matchObj)
    if(_foundPos > 0){
        _matches := []
        loop % _matchObj.Count(){
            _matches.push(_matchObj.Value(A_Index))
        }
        return _matches
    }
    else
        return ""
}

; 移除字符串的开始和/或末尾的某些字符, 例如, " abc " => "abc"
; _type in ["", "r", "l"]; ""首尾都清理
strTrim(_instr, _OmitChars:=" `t", _type:=""){
    _result := ""
    if(_type="")
        _result := Trim(_instr, _OmitChars)
    else if(_type="r")
        _result := RTrim(_instr, _OmitChars)
    else if(_type="l")
        _result := LTrim(_instr, _OmitChars)
    return _result
}

; 包裹字符串, 例如, abc => "abc"
strWrap(_instr, _wrapStart:="""", _wrapEnd:=""""){
    result:= _wrapStart . _instr . _wrapEnd
    return result
}

; 从_instr中删除所有_subStr, 返回删除后的剩余字符串
strDelSub(_instr, _subStr){
    return StrReplace(_instr, _subStr, "")
}

; 清洗字符串
; 测试清洗
; [2019.12.12]    [韩国]    [剧情]    [BT下载][妹妹不是你][HD-MP4/1.2G][独家韩语.中字][720P][妻子姐姐.教我姿势]
; TransAngels.18.07.02.Domino.Presley.Independent.Woman..480p.MP4-XxX
strClean(_string, _clean_str_list:="(\s|\?|\/|\[|\]|＋|\+|""|_|　|,|:|(?<!\d)\.|\.(?!\d))+"){
    result:= _string
    ; 先用空格替代
    result := RegExReplace(result, _clean_str_list, " ")
    ; 替代完再把连续重复的空格替代成单独空格
    ; result := RegExReplace(result, "\s+", " ")
    return trim(result, " `t")
}

; 把字符串分解成多个子字符串, 返回字符串数组
str_Split(_String, _Delimiters:=",", _OmitChars:=" `t`n`r"){
    return StrSplit(_String, _Delimiters, _OmitChars)
}

; 把字符串分解成多个子字符串, 返回字符串数组
; _Delimiters 数组型, 二级以上多维数组分割符字符
; 多层递归调用
strSplitDeep(_String , _Delimiters, _OmitChars:=" `t", _level:=1){
    result := []
    ; 根据分隔符, 划分层级
    ; 第一层分隔数组
    if(InStr(_String, _Delimiters[_level]))
    {
        result:= StrSplit(_String, _Delimiters[_level], _OmitChars)
    }
    ; 判断当前层数组元素, 是否包含下一层分隔符
    if((_level+1) <= _Delimiters.MaxIndex()){
        Loop % result.MaxIndex()
        {
            if(InStr(result[A_Index], _Delimiters[_level+1]))
            {
                result[A_Index]:= strSplitDeep(result[A_Index], _Delimiters, _OmitChars, _level+1)
            }
        }
    }
    return result
}

; ----------------------------------------------------------
; 返回重复字符串, nStr("a", 3), 返回"aaa"
; ----------------------------------------------------------
strN(_str, _numOfRepeats)
{
    _result := ""
    loop %_numOfRepeats%
        _result .= _str
    return _result
}

; ----------------------------------------------------------
; 修正日期字符串
; ----------------------------------------------------------
strFixDate(_dateStr)
{
    _fixDate := _dateStr
    if(RegExMatch(_dateStr, 正则表达式.模板("日期"), _date)>0)
    {
        _fixDate := strFill(_date1, 4, "19") . "-" . strFill(_date2, 2, "0") . "-" . strFill(_date3, 2, "0")
    }
    return _fixDate
}

; ----------------------------------------------------------
; 只要指定数量的字符串(源字符串, 起始位置, 选取长度, 后缀:=".....")
; 用于菜单, 只显示一部分内容
; ----------------------------------------------------------
strLimitLen(_string, _start, _length, _postfix:="")
{
    result:=""
    if(StrLen(_string) > _length)
        result:= SubStr(_string, _start, _length) . _postfix
    else
        result:= _string
    return result
}

; ----------------------------------------------------------
; 填充字符串(填充对象, 填充结果总长度, 填充字符)
; ----------------------------------------------------------
strFill(_inFillTarget, _inTotalLen, _inFillChar:="0", _inFillLeft:="left")
{
    _result         := ""
    _fillString     := ""
    _totalLen       := abs(_inTotalLen)
    _fillCharLen    := _totalLen - StrLen(_inFillTarget)
    ;--- 生成填充模版
    Loop %_fillCharLen% {
        _fillString .= _inFillChar
    }
    ;--- 对于填充字符大于一个时, 进行修正截取有效长度
    _fillString:= SubStr(_fillString, 1, _fillCharLen)
    ;--- 开始填充字符
    if(_inFillLeft=="left")           ; 左侧填充, 否则右侧填充
        _result := _fillString . _inFillTarget
    else
        _result := _inFillTarget . _fillString
    return _result
}

; ----------------------------------------------------------
; 加密/解密字符串 依赖lib_crypt.ahk
; ----------------------------------------------------------
加密字符串()
{
    result := ""
    test_str := Trim(Clipboarder.get("copy"), "`n`r")
    test_pwd := ""
    if(获取用户密码输入(test_pwd
        ,"请输入加密密码"
        ,"请输入加密密码"
        ,"^"""
        ,"""$"
        ,"\\$")=false)
        return
    ;----------------------------
    hash := Crypt.Encrypt.StrEncrypt(test_str,test_pwd,3,3)
    result := "; 加密结果`n"
            . "; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>`n"
            . hash
    ;----------------------------
    ;加密后的数据存入剪贴板
    Clipboarder.push(result)
    show_msg("`n加密后的数据结果已存入剪贴板`n")
}

; ----------------------------------------------------------
; 加密/解密字符串
; ----------------------------------------------------------
解密字符串()
{
    result := ""
    test_str := Trim(Clipboarder.get("copy"), "`n`r")
    test_pwd := ""
    if(获取用户输入(test_pwd
        ,"请输入解密密码"
        ,"请输入解密密码"
        ,
        ,"hide"
        ,"^"""
        ,"""$"
        ,"\\$")=false)
        return
    ;----------------------------
    hash := test_str
    decrypted_string := Crypt.Encrypt.StrDecrypt(hash,test_pwd,3,3)
    result := "; 解密结果`n"
            . "; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>`n"
            . decrypted_string
    ;----------------------------
    ;解密后的数据存入剪贴板
    Clipboarder.push(result)
    show_msg("`n解密后的数据结果已存入剪贴板`n")
}

;产生指定长度的随机数字字符串
;========================================================
strRandom(_min, _max, _length){
    Random, rand, _min, _max
    tmp_str := ""
    Loop, % _length - strlen(rand) {
        tmp_str .=  "0"
    }
    return tmp_str . rand
}

;产生14位短id -- "日期时分秒字符串"
;=========================================================
strTime(_format:="yyyy/MM/dd HH:mm:ss"){
    FormatTime, _result,, %_format%
    return _result
}

;输出17位id -- "14位时间字符串+3位随机数字"
;========================================================
strId(_format:="yyyyMMdd_HHmmss_"){
    return strTime(_format) . strRandom(0,999,3)
}


