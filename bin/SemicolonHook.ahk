SendMode "Input"
SetWorkingDir A_ScriptDir

;=====================================================================o
;                      Semicolon Hook Registry

global EnableSemicolonComfort := false
; all dict comes from database
semicolonHookStr := getKeyStr(secretDictionary) "," getKeyStr(userDictionary)
semicolonHook := InputHook("C", "{Space}{Esc}", semicolonHookStr)
semicolonHook.OnChar := onTypoChar
semicolonHook.OnEnd := onTypoEnd

+`;:: Send "{blind}:"
*`;::
{
    global semicolonHook, EnableSemicolonComfort
    thisHotkey := A_ThisHotkey
    GC.disableOtherHotkey(thisHotkey)
    EnableSemicolonComfort := true
    KeyWait ";"
    EnableSemicolonComfort := false
    if (A_PriorKey == ";" && A_TimeSinceThisHotkey < 350)
    {
        MonkeyIme.enterSemicolonAbbr(semicolonHook)
    }
    GC.enableOtherHotkey(thisHotkey)
}
; 分号短语命令
class SemicolonAbbr {

    static execute(typo)
    {
        switch typo
        {
            case "no": Launcher.notepad()
            case "rex": Launcher.explorerReload()
            case "os": Run A_ScriptDir
            case "opc": Run "shell:my pictures"
            case "ow": Run "shell:Personal"
            case "or": Run "shell:RecycleBinFolder"
            case "ox": Run "shell:downloads"
            case "ob": Run "E:\backup"
            case "opr": Run "E:\projects"
            case "quit": SmartCloseWindow()
            case "ee": ToggleTopMost()
            case "oo": IME.toggle()    ; 如果第一次没切换成功，将就连按切换
            case "tm": Run "taskmgr"
            case "sleep": DllCall("PowrProf\SetSuspendState", "Int", 0, "Int", 0, "Int", 0)
            case "reboot": slideToReboot()
            case "shutdown": slideToShutdown()
            case "dota": Dotfiles.apply()
            case "dotb": Dotfiles.backup()
            case "doto": Dotfiles.open()
            case "login": loginAdmin()
            case "dt": Send FormatTime(, "yyyy-MM-dd HH:mm:ss")
            case "hey": Sleep 500
            case "dh": Send "{Blind}^#{Left}"
            case "dl": Send "{Blind}^#{Right}"
            case "spy": Launcher.Ahk.winSpy()
            case "1": Launcher.dittoPaste(1)
            case "2": Launcher.dittoPaste(2)
            case "3": Launcher.dittoPaste(3)
            case "4": Launcher.dittoPaste(4)
            case "5": Launcher.dittoPaste(5)
            case "cc": Vim.EditJavaCommentTitle()
            case "il": Vim.inputChineseInDdoubleQuotes()    ; 引号中输入中文
            case "cil": Vim.changeCnCommentInDoubleQuotes()
            case "list": Vim.surroundWithList()
            case "tt": Vim.paste2LastLineUp()
            case "gg": Vim.paste2LastLineReplace()
            case "bb": Vim.paste2LastLineDown()
            case "vsa": Vim.swapArg()
            case "mm": Mouse.move()
            case "dbg": Debug.toggle()
            case "ln": IdeVim.markernext()
            case "lj": IdeVim.actionquickFix()
            case "lo": IdeVim.outlinefocus()
            case "lz": IdeVim.actiontoggleZenMode()
            case "lf": IdeVim.actionformatDocument()
            case "le": IdeVim.actionquickOpen()
            case "la": IdeVim.findInFiles()
            case "ls": IdeVim.viewexplorer()
            case "lgh": IdeVim.gitlensshowQuickFileHistory()
            case "lb": IdeVim.toggleBreakpoint()
            case "ldd": IdeVim.debugStart()
            case "lrr": IdeVim.rename()
            case "H": IdeVim.tabPreview()
            case "L": IdeVim.tabNext()
            case "ca": Idea.clearAll()
            case "docs": Website.docs()
            case "gen": Website.codeGen()
            case "json": Website.excel2json()
            case "gpt": Website.chatGpt()
            case "devst": BatchLauncher.devStart()
            case "devex": BatchLauncher.devExit()
            case "gmst": BatchLauncher.gameStart()
            case "gmex": BatchLauncher.gameExit()
            case "ww": WindowsDock.hidden()
            default:
                return false
        }
        return true
    }
}

#Hotif EnableSemicolonComfort
+A:: Send "{Blind}{text}●"    ; 分点论述的符号
*A:: Send "{blind}*"
*I:: Send "{blind}:"
*Space:: send "{blind}{enter}"
*,:: Send "{blind}{space}"    ; 因为空格键经常误触换行
+V:: Send "{blind}{text}、"    ; 中文顿号
*V:: Send "{blind}|"    ; or
*Y:: Send "{blind}@"
*D:: Send "{blind}="    ; 逻辑判断
+S:: Send "{Blind}{text}○"    ; 分点论述二级符号
*S:: Send "{blind}<"
*F:: Send "{blind}>"
*R:: Send "{blind}&"    ; and
+G:: Send GC.ModifyKey()    ; 解除占用修饰键
*G:: Send "{blind}{!}"    ; not
*X:: Send "{blind}_"    ; 下划线
*H:: Send "{blind}`%"    ; 匹配成对的括号
+Q:: Send "{blind})"    ; 强迫症表示要放一起
*Q:: Send "{blind}("
*U:: Send "{blind}$"    ; 句子后
*E:: Send "{blind}{^}"    ; 句子前，上中左右
+J:: Send "{blind}{text}；"    ; 中文分号，大人什么都要
*J:: Send "{blind}{text};"    ; 英文分号，常用
*C:: Send "{blind}."    ; 存疑，一个身位可以到达，设置2个键，过度设计？.=, copy复用上次操作
+B:: Send "{blind}{}}"    ; 成对在一起
*B:: Send "{blind}{{}"    ; viB,viq配合很好
*K:: Send "{blind}``"    ; 精准定位时
*L:: Send "{blind}`""    ; 字符串, 寄存器
*W:: Send "{blind}{#}"
*N:: Send "{blind}-"    ; new/新增/增加
*M:: Send "{blind}{+}"    ; minus/减少
+T:: Send "{blind!+}{Space 4}"    ; 类似 tab
*T:: Send "{blind}~"    ; 终端用户根目录
*Z:: Send "{blind}^z"    ; 撤回，相当于删字
*O:: IME.toggle()    ; 终端可用 Esc 切换回英文，任意场合用 Rshift 切换，或再按一遍
*1:: chineseComment("//")
*2:: chineseComment(";")
*3:: chineseComment("###")
#Hotif


;=====================================================================o
;                     Hook Funtions

; 猴子输入法
; 优先: 无命令词典（纯文字）；优先打印自定义短语，支持跨平台导出，输入法通用
; 其次: 自定义脚本功能
;
; 官方文档说，switch 命中就返回，没有落下直通，所以不用 return
; 但一种观点认为，命中后返回，可以提前结束 hook 监听输入，防止垂直落下。
class MonkeyIme {

    static enterSemicolonAbbr(ih) {
        ToolTip "🙈"
        ih.start()
        ih.wait()
        ih.stop()
        if (ih.Match)
        {
            try {
                value := "{text}" userDictionary[ih.Match]
                Send value
                CursorUtil.moveLeftIfEndWithBracket(value)
                return
            }
            ; 带命令词典: 功能比较重
            ToolTip "🙉 " secretDictionary[ih.Match]
            SemicolonAbbr.execute(ih.Match)
        } else {
            ; 未收录词典，猴子跑了
            ToolTip "💨"
        }
        SetTimer () => Tooltip(), -500
    }


}

class CursorUtil {

    static moveLeftIfEndWithBracket(value) {

        if inSemicolon(value) {
            Send "{Left 3}"
            return
        }

        if inComma(value) {
            Send "{Left 2}"
            return
        }

        if inCouple(value) {
            Send "{Left}"
            return
        }

        ; Java
        inSemicolon(value) {
            HayStack := '");'
            needle := SubStr(value, -3, 3)
            return InStr(HayStack, needle, false, -1)

        }

        ; 注解字符：如以括号和字符串结尾，光标向左偏移2位（Spring注解）
        inComma(value) {
            HayStack := '")'
            needle := SubStr(value, -2, 2)
            return InStr(HayStack, needle, false, -1)
        }

        ; 成对符号：如以成对符号(右)结尾，光标向左偏移1位
        inCouple(value) {
            HayStack := ")`]`}>）〉》】｝’”"
            needle := SubStr(value, -1, 1)
            return InStr(HayStack, needle, false, -1)
        }

    }

}


chineseComment(startStr := "") {
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
    if (exStyle & 0x8)    ; 0x8 为 WS_EX_TOPMOST
    {
        exStyle := "  取消置顶  "
        WinSetAlwaysOnTop False, "A"
    } else {
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