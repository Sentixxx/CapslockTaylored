SendMode "Input"
SetWorkingDir A_ScriptDir


;=====================================================================o
;                      Punctuation Hook Registry

global PunctuationMode := false
; all dict comes from database
semicolonHookStr := getKeyStr(secretDictionary) "," getKeyStr(userDictionary) 
semicolonHook := InputHook("C", "{Space}{Esc}", semicolonHookStr)
semicolonHook.OnChar := onTypoChar
semicolonHook.OnEnd := onTypoEnd

+`;:: Send "{blind}:"
*`;::
{
    global semicolonHook, PunctuationMode
    thisHotkey := A_ThisHotkey
    disableOtherHotkey(thisHotkey)
    PunctuationMode := true
    KeyWait ";"
    PunctuationMode := false
    if (A_PriorKey == ";" && A_TimeSinceThisHotkey < 350)
    {
        enterSemicolonAbbr(semicolonHook)
    } 
    enableOtherHotkey(thisHotkey)
}

; 自定义输入法
; 优先: 无命令词典（纯文字）；优先打印自定义短语，支持跨平台导出，输入法通用
; 其次: 自定义脚本功能
;
; 官方文档说，switch 命中就返回，没有落下直通，所以不用 return
; 但一种观点认为，命中后返回，可以提前结束 hook 监听输入，防止垂直落下。
enterSemicolonAbbr(ih) {
    ToolTip "🙈"   
    ih.start()
    ih.wait()
    ih.stop()
    if (ih.Match)
    {
        try {
            value := "{text}" userDictionary[ih.Match]
            Send value
            moveCursorLeftIfEndWithBracket(value)
            return
        }
        ; 带命令词典: 功能比较重
        ToolTip "🙉 " secretDictionary[ih.Match] 
        execSemicolonAbbr(ih.Match)
    } else {
        ; 未收录词典，猴子跑了
        ToolTip "💨"
    }
    SetTimer () => Tooltip(), -500
}

moveCursorLeftIfEndWithBracket(value) {

    if isEndWithCommaBracket(value) {
        Send "{Left 2}"
        return
    }

    if isEndWithCoupleBracket(value) {
        Send "{Left}"
        return
    }

    ; 注解字符：如以括号和字符串结尾，光标向左偏移2位（Spring注解）
    isEndWithCommaBracket(value) {
        HayStack := '")'
        needle := SubStr(value, -2, 2)
        return InStr(HayStack, needle, false, -1)
    }

    ; 成对符号：如以成对符号(右)结尾，光标向左偏移1位
    isEndWithCoupleBracket(value) {
        HayStack := ")`]`}>）〉》】｝’”"
        needle := SubStr(value, -1, 1) 
        return InStr(HayStack, needle, false, -1)
    }

}

execSemicolonAbbr(typo) {

    switch typo 
    {
        case "no":
            path := "notepad"
            pasteInNotepad()
            ActivateOrRun("记事本", path, "", "")
            return
        case "rex":
            path := "tools\重启资源管理器.exe"
            ActivateOrRun("", path, "", "")
            return
        case "dm": Run A_ScriptDir
        case "dpc": Run "shell:my pictures"
        case "dw": Run "shell:Personal"
        case "dr": Run "shell:RecycleBinFolder"
        case "dx": Run "shell:downloads"
        case "db": Run "E:\backup"
        case "dpr": Run "E:\projects"
        case "quit": SmartCloseWindow()
        case "ee": ToggleTopMost()
        case "oo": IME.toggle() ; 如果第一次没切换成功，将就连按切换
        case "om": IME.inputChineseInDdoubleQuotes() ; 引号中输入中文
        case "gcam":
            gitStr := "git add -A`; git commit -a -m ''`; git push origin (git branch --show-current)`;"
            SendAndLeft(gitStr, 47)
        case "tm": Run "taskmgr"
        case "sleep": DllCall("PowrProf\SetSuspendState", "Int", 0, "Int", 0, "Int", 0)
        case "reboot": slideToReboot()
        case "shutdown": slideToShutdown()
        case "spy": openWinSpy()
        case "dotb": backupDotfiles()
        case "doto": 
            path := A_Programs "\Visual Studio Code\Visual Studio Code.lnk"
            activateOrRun("dotfiles ahk_exe Code.exe", path,  "E:\dotfiles")
        case "login": loginAdmin()
        case "dt": Send FormatTime(,"yyyy-MM-dd HH:mm:ss")
        case "hey": Sleep 500
        case "dh": Send "{Blind}^#{Left}"
        case "dl": Send "{Blind}^#{Right}"
        case "1": Send "{Blind}^+!1"
        case "2": Send "{Blind}^+!2"
        case "3": Send "{Blind}^+!3"
        case "4": Send "{Blind}^+!4"
        case "5": Send "{Blind}^+!5"
        case "cc": Vim.EditJavaCommentTitle()
        case "cil": Vim.changeCnCommentInDoubleQuotes()
        case "list": Vim.surroundWithList() 
        case "tt": Vim.paste2LastLineUp()
        case "gg": Vim.paste2LastLineReplace()
        case "bb": Vim.paste2LastLineDown()
        case "mm": Mouse.move()
        default: 
            return false
    }
    return true
}

#Hotif PunctuationMode
*A::
{
Send "{blind}*"
return
}
*I::
{
Send "{blind}:"
return
}
*Space::
{
send "{blind}{enter}"
return
}
*,::Send "{blind}{space}"    ; 因为空格键经常误触换行
+V::Send "{blind}{text}、"    ; 中文顿号
*V::Send "{blind}|"    ; or
*Y::Send "{blind}@"
*D::Send "{blind}="    ; 逻辑判断
*S::Send "{blind}<"
*F::Send "{blind}>"
*R::Send "{blind}&"    ; and
*G::Send "{blind}{!}"  ; not
*X::Send "{blind}_"    ; 下划线
*H::Send "{blind}`%"   ; 匹配成对的括号
+Q::Send "{blind})"    ; 强迫症表示要放一起
*Q::Send "{blind}("
*U::Send "{blind}$"    ; 句子后
*E::Send "{blind}{^}"  ; 句子前，上中左右
+J::Send "{blind}{text}；" ; 中文分号，大人什么都要
*J::Send "{blind}{text};" ; 英文分号，常用
*C::Send "{blind}."    ; 存疑，一个身位可以到达，设置2个键，过度设计？.=, copy复用上次操作
+B::Send "{blind}{}}"  ; 成对在一起
*B::Send "{blind}{{}"  ; viB,viq配合很好
*K::Send "{blind}``"   ; 精准定位时
*L::Send "{blind}`""   ; 字符串, 寄存器
*W::Send "{blind}{#}"
*N::Send "{blind}-"  ; new/新增/增加
*M::Send "{blind}{+}"    ; minus/减少
+T::Send "{blind!+}{Space 4}" ; 类似 tab 
*T::Send "{blind}~"   ; 终端用户根目录
*Z::Send "{blind}^z"         ; 撤回，相当于删字
*O::IME.toggle()  ; 终端可用 Esc 切换回英文，任意场合用 Rshift 切换，或再按一遍
*1::chineseComment("//")
*2::chineseComment(";")
*3::chineseComment("###")
#Hotif 

;=====================================================================o
;                     Hook Funtions

SendAndLeft(text, offset:=1)
{
    Send "{text}" text
    Send "{Left " offset "}"
}

chineseComment(startStr:="") {
    Send "{text}" startStr " "
    IME.set("中文")
}

onTypoChar(ih, char) {
    ; 删除缓存拼写时，也不会更新
    Tooltip ih.Input
}

onTypoEnd(ih) {
    ; 清空缓存，可能遮蔽表现：有时新命令遗留错误上次错误信息
    Tooltip 
    ; typoTip.show(ih.Input)
}

slideToShutdown()
{
    run "SlideToShutDown"
    sleep 1300
    MouseClick "Left", 100, 100
}

slideToReboot()
{
    ; run, SlideToShutDown
    ; sleep, 1300
    ; MouseClick, Left, 100, 100
    ; sleep, 250
    shutdown 2
}


ToggleTopMost()
{
    exStyle := WinGetExStyle("A")
    if (exStyle & 0x8)  ; 0x8 为 WS_EX_TOPMOST
    {
        exStyle := "  取消置顶  "
        WinSetAlwaysOnTop False, "A"
    }
    else {
        exStyle := "  窗口置顶  "
        WinSetAlwaysOnTop True, "A"
    }
    tip(exStyle, -500)
}

getKeyStr(dict) {
    string := ""
    for key, value in dict
    {
        string .= key ","
    }
    return RTrim(string, ",")
}