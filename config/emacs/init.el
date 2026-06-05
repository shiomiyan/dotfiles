(setq org-directory "~/org")
(setq org-default-notes-file "~/org/todo.org")

(setq org-todo-keywords
      '((sequence "TODO(t)" "DOING(i)" "|" "DONE(d)" "CANCEL(c)")))

(setq org-agenda-files '("~/org/todo.org"))

(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)

(setq org-capture-templates
      '(("t" "Todo" entry
         (file "~/org/todo.org")
         "* TODO %?\n  %U")))
