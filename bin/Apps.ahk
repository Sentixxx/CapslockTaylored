;=====================================================================o
;                      Application

; a = appearence | window | shot
; CapsLock & a::
; {
;     ; 魔鬼逻辑：当前{}大括号内，caps+a永远为按下，方法内无法修改此前提
;     ; 跳出问题，大括号之外释放热键
;     if GetKeyState("LAlt", "p") {
;         Window.move()
;     }
;     else if GetKeyState("LWin", "p") {
;         Mouse.move()
;     }
;     else if GetKeyState("LCtrl", "p") {
;         Window.zoom()
;     }
;     else {
;         return
;     }
;     GC.ModifyKey()
; }


; d = database | api docs
;

; f = find | search cabinet
; CapsLock & f::
; {
;     if GetKeyState("Ctrl") {
;         ;WinOS.Manager.explorer()
;     } else {
;         App.everything()
;     }
;     ;IME.set("EN")
; }

; g = google
CapsLock & g::
{
    if GetKeyState("Ctrl") or GetKeyState("Alt") {
        App.Chrome.searchSelected()
    } else {
        App.Chrome.run()
    }
}

; e = editor
CapsLock & e::
{
    if GetKeyState("Ctrl")
        {
            App.Mail.run()
        }
        else if GetKeyState("Alt")
        {
            activateOrRun("ahk_class CabinetWClass", "explorer",,,true)
            ;WinOS.Folder.personal()
        } else {
            App.Chrome.run()
        }
}

; r = run | develop | java | back-end
CapsLock & r::
{
    if GetKeyState("Ctrl")
    {
        ; App.Terminal.activate()
    }
    else if GetKeyState("Alt")
    {
        ;App.Todesk.run()
    } else {
        App.Terminal.run()
    }
}

; t = terminal | develop | front-end
CapsLock & t::
{
    if GetKeyState("Ctrl") {
        ;App.WxDevTools.activate()
    } else if getKeyState("Alt") {
        App.Typora.run()
    } else {
        App.Vscode.run()
    }
}



;=====================================================================o
;                    Copy & Paste Enhancement
; c = copy
; 强化复制粘贴，光标只在两处徘徊时
CapsLock & c::
{
    if !GetKeyState("Alt") {
        Send "^c"
        ClipWait 4
    } else {
        ; 正则去掉换行符号
        A_Clipboard := ""
        Send "^c"
        ClipWait 4
        A_Clipboard := RegExReplace(A_Clipboard, "`r`n")
    }
    Sleep 100
    Send "!{Tab}"
    Sleep 200
    Send "^v"
}

; v = paste | clipboard
CapsLock & v::
{
    App.ditto()
}

; x = ? dict
CapsLock & z::
{
    send "^!n"
    ;App.eaudic()
}

; 配合鼠标使用，因为删除键较远
CapsLock & x:: Send "{Blind}{Backspace}"



;=====================================================================o
;                    DevUtil
; 看电视
CapsLock & 8:: Send "{Media_Play_Pause}"