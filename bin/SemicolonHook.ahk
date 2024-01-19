;#Include MonkeyIME.ahk
;#Include SystemIME.ahk
#Include plugin\impl\GarbageCollector.ahk

#Hotif EnableSemicolonComfort
+A:: Send "{Blind}{text}●"          ; 分点论述的符号
*A:: Send "{blind}{+}"                ; 星号
*I:: Send "{blind}:"                ; 插入（Vim）
*V:: Send "{blind}|"                ; or
*Y:: Send "{blind}@"                ; at
*D:: Send "{blind}="                ; 逻辑判断
*S:: Send "{blind}<"                ; left
*F:: Send "{blind}>"                ; right
*R:: Send "{blind}&"                ; and
*G:: Send "{blind}{!}"              ; not
*X:: Send "{blind}*"                ; 下划线
*H:: Send "{Blind}{{}"               ; 匹配成对的括号
+H:: Send "{Blind}{}}"               ; 匹配成对的括号
*Q:: Send "{blind}("                ; 括号 (quote)
+Q:: Send "{blind})"                ; 括号 (quote)
*U:: Send "{blind}$"                ; 句子后
*E:: Send "{blind}{^}"              ; 句子前，上中左右, up
*J:: Send "{blind}{text};"          ; 英文分号，被自动补全替代
*C:: Send "{blind}."                ; 1键变2个键是否过度设计？.=, copy复用上次操作，保证输出英文（避免中文影响）
+B:: Send "{blind}`%"                ; %
*B:: Send "{blind}{%}"              ; 大括号放这里是迷惑的习惯，两个习惯会打架，集合在一个键不如[]左右直观
*K:: Send "{blind}``"               ; 精准定位时
*L:: Send "{blind}`""               ; 字符串, 寄存器
*W:: Send "{blind}{#}"              ; 挖井 [w]a jing
*N:: Send "{blind}_"                ; _
*M:: Send "{blind}{-}"              ; minus/减少
+M:: Send "{blind}{Space 4}"              ; plus/增加
*T:: Send "{blind}~"                ; 终端用户根目录
;*Z:: Vim.focusMethod()              ; 光标定位到函数名字（Vim）
; *,:: Send "{blind}{space}"          ; 因为空格键经常误触换行
*,:: Send "{blind}{text},"          ; 因为空格键经常误触换行
!Space:: send "{blind}{Alt}{enter}" ; 表格换行
*Space:: send "{blind}{enter}"      ; 回车，免位移
*O:: send "{blind}#{Space}"          ; switch language
;*1:: IME.commentCN("//")            ; java 注释
;*2:: IME.commentCN(";")             ; ahk 注释
#Hotif


;=====================================================================o
;                      Semicolon Hook Registry

global EnableSemicolonComfort := false
; ; 词典数据 /data/dict
; semicolonHookStr := getKeyStr(secretDict) "," getKeyStr(userDict)
; semicolonHook := InputHook("C", "{Space}{Esc}", semicolonHookStr)
; semicolonHook.OnChar := onTypoChar
; semicolonHook.OnEnd := onTypoEnd

+`;:: Send "{blind}:"
*`;::
{
    global semicolonHook, EnableSemicolonComfort
    thisHotkey := A_ThisHotkey
    GC.disableOtherHotkey(thisHotkey)
    EnableSemicolonComfort := true
    KeyWait ";"
    EnableSemicolonComfort := false
    if (A_PriorKey == ";" && A_TimeSinceThisHotkey < 200)
    {
        Send ";" 
    }
    GC.enableOtherHotkey(thisHotkey)
}

; ; 删除缓存拼写时，也不会更新
; onTypoChar(ih, char) {
;     Tooltip ih.Input
; }

; ; 清空缓存，可能遮蔽表现：有时新命令遗留错误上次错误信息
; onTypoEnd(ih) {
;     Tooltip
;     ; typoTip.show(ih.Input)
; }

; getKeyStr(dict) {
;     string := ""
;     for key, value in dict
;     {
;         string .= key ","
;     }
;     return RTrim(string, ",")
; }