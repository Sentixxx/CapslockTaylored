﻿;#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode "Input"    ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir A_ScriptDir  ; Ensures a consistent starting directory.

;=====================================================================o
;               中文输入法特殊优待（默认中文状态使用英文字符）
;                   微软拼音让它进化了:在一个输入法中，中文和英文模式切换

; 在分号模式和数字模式中，保持英文标点
global chinesePunctuationHotkey := true

; 其他中文标点符号，已收录进分号模式的私有字典
#Hotif hasIME() and chinesePunctuationHotkey
,:: Send "{text}，"
.:: Send "{text}。"
+;:: Send "{blind}{text}："
+/:: Send "{blind}{text}？"
#Hotif


;=====================================================================o
;                    IME Status ToolTip

; 作者：知乎 @查理
; 时间：2021年9月
; 更新：https://www.zhihu.com/question/470805790/answer/2022570065

switchIME() {
    ; 优先完成切换任务，再报告状态（相反的状态，估计发送信号有延迟; 多线程先后问题，用原子操作）
    if (hasIME() = 1) {
        Send "^{Space}"
        ToolTip "EN" 
    } else {
        Send "^{Space}"
        ToolTip "中"
    }
    SetTimer () => ToolTip(), -1000
}

; @param EN / 中文
setIME(language)
{
    Sleep 50 ; 等一等是为了承接窗口切换的缓冲
    switch (language) {
        case "EN":
            if (hasIME() = 1) {
                Send "^{Space}"
                ToolTip "EN"
            }
        case "中文":
            if (hasIME() = 0) {
                Send "^{Space}"
                ToolTip "中"
            }
    }
    SetCapsLockState "AlwaysOff"  ; 热键切换一定概率出现大写 A
    SetTimer () => ToolTip(), -200
}

setIDEIME(language:="EN")
{
    MouseGetPos , , &ahkId
    title := WinGetProcessName(ahkId)
    if InStr(title, "idea64.exe") or InStr(title, "Code.exe") or InStr(title, "ahk_exe chrome.exe")
    {
        setIME(language)
    }
}

isNotTypingPinYin() {
    ; 策略模式：保持原接口不变，实现方式根据场景可选
    ; 系统有时会自动降级兼容，太诡异了
    return !(isTypingPinYinImg() or isTypingPinYinWin())
}

isTypingPinYinWin() {
    ; 适用蓝底白字老版本，Win11白皮肤接口失效，因为窗口常驻后台
    return WinExist("ahk_class Microsoft.IME.UIManager.CandidateWindow.Host")
}

isTypingPinYinImg() {
    ; 适用新版微软拼音，截图桃心
    CoordMode "Pixel"  ; 将下面的坐标解释为相对于屏幕而不是活动窗口.
    return ImageSearch(&FoundX, &FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, "bin\img\IMElogo.png")
}


; IMEの状態の取
;   対象： AHK v2.0.0以升
;   WinTitle : 対象Window (省略時:アクティブウィンドウ)
;   戻り値  1:ON 0:OFF
;   （但似乎找不到检测悬浮窗的接口，所以利用 AHK 搜图特性代替）
;   API: https://docs.microsoft.com/en-us/windows/win32/intl/wm-ime-control
;   API: https://docs.microsoft.com/en-us/previous-versions/windows/embedded/ms920833(v=msdn.10)
;   API: https://docs.microsoft.com/zh-cn/windows/win32/intl/input-method-manager-functions

hasIME(WinTitle:="A")
{
    try {
        hWnd := WinGetID(WinTitle)
    } catch Error {
        ; ^Esc 开始菜单弹窗，卡死在找不到当前窗口
        return
    }
    DetectHiddenWindows True
    result := SendMessage(
            0x283,  ; Message : WM_IME_CONTROL
            0x001,  ; wParam  : IMC_GETCONVERSIONMODE
            0,      ; lParam  ： (NoArgs)
            ,       ; Control ： (Window)
            ; 获取当前输入法的模式
            "ahk_id " DllCall("imm32\ImmGetDefaultIMEWnd", "Uint", hWnd, "Uint")
            )
    DetectHiddenWindows False
    ; 微软拼音（英-中，新/旧，新旧/新旧）0/1024-1/1025
    ; 搜狗五笔  0-1025
    ; 手心  1024-1025
    ; 搜狗拼音中英都是1025（无效）
    return (result == 1 or result == 1025)
    ; return result
}

; !1:: Tooltip hasime()