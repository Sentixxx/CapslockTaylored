; class WxDevTools extends App.WxDevTools {

;     static batch() {
;         this.restart()
;         Sleep 2000
;         this.login()
;     }

;     ; 清空全部缓存和普通编译
;     static restart()
;     {
;         Click "4034 57"
;         Click "4039 97"
;         Click "4023 170"
;         ; 普通编译
;         Send "^r"
;         ; 编译等待
;         Sleep 3000
;     }

;     static login()
;     {
;         ; 密码登录 > 登录 > 首页
;         Sleep 4000
;         Click "3819 626"
;         Sleep 2000
;         Click "3826 516"
;         Sleep 2000
;         Click "3674 858"
;     }

;     static testRegisterCreate() {

;     }
; }