(add-to-list 'default-frame-alist
             '(font . "Monaco-14"))

(ido-mode t)
(setq ido-enable-flex-matching t)
(set-face-attribute 'ido-subdir nil :foreground "green")

(column-number-mode t)
(set-scroll-bar-mode 'right)
(show-paren-mode 1)

(set-background-color "black")
(set-foreground-color "gray75")

(menu-bar-mode nil)

(tool-bar-mode 0)
(setq inhibit-startup-screen t)
