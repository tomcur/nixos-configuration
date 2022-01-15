(setq inhibit-splash-screen t)
(setq initial-buffer-choice nil)

(require 'org)
(setq default-directory "~/org")
(setq org-directory "~/org")
(setq org-agenda-files "~/org/agenda")
(setq org-log-done 'time)
(add-hook 'after-init-hook (lambda () (org-todo-list) (delete-other-windows)))

(require 'evil)
(evil-mode 1)
