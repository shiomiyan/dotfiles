(setq system-time-locale "C")
(global-auto-revert-mode 1)
(recentf-mode 1)
(savehist-mode 1)
(save-place-mode 1)
(setq use-short-answers t)

;; Line number
(global-display-line-numbers-mode 1)

;; I'm Japanese
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)
(set-default 'buffer-file-coding-system 'utf-8)

;; fonts
(when (display-graphic-p)
  (set-face-attribute 'default nil :family "Recursive UD Mono" :height 100)
  )

;; enable mouse
(xterm-mouse-mode 1)

;; org-mode
(setq org-directory "~/org")
(setq org-default-notes-file "~/org/index.org")

(setq org-todo-keywords
      '((sequence "TODO(t)" "PROCESSING(p)" "|" "DONE(d)" "CANCEL(c)")))

(setq org-agenda-files '("~/org/todo.org"))

(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)

(setq org-capture-templates
      '(("t" "Todo" entry
         (file "~/org/todo.org")
         "* TODO %?\n  %U")))
